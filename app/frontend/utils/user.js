import { ajax } from './ajax'
import { encryptWithKey, recodeKeys, decryptWithKey } from 'src/utils/encryption'
import { isEmpty } from 'lodash'
import { useGlobalStore } from '../store/store'
import apiRoutes from 'src/vue/routes/api-routes'
import isArray from 'lodash/isArray'

export const isAdmin = () => {
  const gs = useGlobalStore()
  const capabilities = gs.login.capabilities
  return hasCapability('admin', capabilities)
}

// any user without capabilities
export const isRegularUser = capabilities => !capabilities

// users of type "Privatperson"
export const isSingleUser = () => {
  const gs = useGlobalStore()
  return gs.login.account_type === 2
}

export const hasCapability = (capability, capabilities) => {
  let capabilitiesArray = capabilities || ''
  if (!isArray(capabilitiesArray)) {
    capabilitiesArray = capabilitiesArray.split(',')
  }
  return capabilitiesArray?.includes(capability) || capabilitiesArray?.includes('admin')
}

// checks if the user has completed the "set password and security question" step
export const isRegistrationComplete = user => user.intro_state > 2

export const isMasquerading = () => {
  const gs = useGlobalStore()
  return !!gs.login.is_masquerading
}

// checks the user config for the passed key. keyPath needs to be the full path
// separated with dots, e. g. "visibilities.supportView.generalSuggestions"
// returns false if the path is not found, or the setting value.
export const checkUserSettings = (config, keyPath) => {
  if (!config || isEmpty(config)) {
    return {}
  }
  const keys = keyPath.split('.')
  let currentObj = config
  for (const key of keys) {
    if (!(key in currentObj)) {
      return false
    }
    currentObj = currentObj[key]
  }

  return currentObj
}

export const decryptOrAddMasterkey = async (res, password) => {
  let masterkey = res.data.masterkey
  if (!masterkey) {
    masterkey = Math.random()
      .toString(36)
      .replace(/[^a-z]+/g, '')
      .substring(0, 6)

    sessionStorage.setItem('mk', masterkey)
    await recodeGroupKeysWithMasterkey(res.data.id, masterkey, password, res.data.shares)
    sessionStorage.removeItem('login')
  } else {
    const decryptedKey = decryptWithKey(masterkey, password)
    sessionStorage.setItem('mk', decryptedKey)
  }
}

export const recodeGroupKeysWithMasterkey = async (id, key, pw, shares) => {
  // this needs to be a promise. otherwise the redirect to /diagnostik after login
  // can occur too early, resulting in improperly recoded keys.
  const p = new Promise(resolve => {
    const encodedKey = encryptWithKey(key, pw)
    const recodedShares = recodeKeys(key, pw, shares)

    resolve({ encodedKey, recodedShares })
  })
  const { encodedKey, recodedShares } = await p
  if (recodedShares.error) {
    console.log('error.', recodedShares)

    return
  }

  const data = { user: { masterkey: encodedKey }, keys: JSON.stringify(recodedShares) }
  const res = await ajax({
    ...apiRoutes.users.update(id),
    data,
  })

  if (res.status !== 200) {
    console.warn('error recoding share keys')
  }
}
