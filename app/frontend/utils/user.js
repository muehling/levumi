import isArray from 'lodash/isArray'
import { useGlobalStore } from '../store/store'

export const isAdmin = () => {
  const gs = useGlobalStore()
  const capabilities = gs.login.capabilities
  return hasCapability('admin', capabilities)
}

export const isRegularUser = capabilities => !capabilities

export const hasCapability = (capability, capabilities) => {
  let capabilitiesArray = capabilities || ''

  if (!isArray(capabilitiesArray)) {
    capabilitiesArray = capabilitiesArray.split(',')
  }

  return capabilitiesArray?.includes(capability) || capabilitiesArray?.includes('admin')
}

export const isRegistered = user => user.intro_state > 2

export const isMasquerading = () => {
  const gs = useGlobalStore()
  return !!gs.login.is_masquerading
}

// checks the user config for the passed key. keyPath needs to be the full path
// separated with dots, e. g. "visibilities.supportView.generalSuggestions"
// returns false if the path is not found, or the setting value.
export const checkUserSettings = (config, keyPath) => {
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
