export const isAdmin = capabilities => !capabilities.includes('admin')

export const isRegularUser = capabilities => !capabilities

export const hasCapability = (capability, capabilities) =>
  capabilities?.includes(capability) || capabilities?.includes('admin') || capabilities === 'admin'

export const isRegistered = user => user.intro_state > 2
