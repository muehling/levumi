import isArray from 'lodash/isArray'

export const isAdmin = capabilities => {
  return hasCapability('admin', capabilities)
}

export const isRegularUser = capabilities => !capabilities

export const hasCapability = (capability, capabilities) => {
  let capabilitiesArray = capabilities
  if (!isArray(capabilitiesArray)) {
    capabilitiesArray = capabilities.split(',')
  }

  return capabilitiesArray?.includes(capability) || capabilitiesArray?.includes('admin')
}

export const isRegistered = user => user.intro_state > 2

export const isMasquerading = user => user.is_masquerading
