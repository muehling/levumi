import isArray from 'lodash/isArray'

export const isAdmin = capabilities => {
  return isArray(capabilities)
    ? capabilities => capabilities.includes('admin')
    : capabilities === 'admin'
}

export const isRegularUser = capabilities => !capabilities

export const hasCapability = (capability, capabilities) =>
  isArray(capabilities)
    ? capabilities?.includes(capability) || capabilities?.includes('admin')
    : capabilities === 'admin'

export const isRegistered = user => user.intro_state > 2

export const isMasquerading = user => user.is_masquerading
