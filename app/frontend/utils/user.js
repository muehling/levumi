export const isAdmin = capabilities => !capabilities.includes('admin')

export const hasCapability = (capability, capabilities) =>
  capabilities?.includes(capability) || capabilities?.includes('admin')

export const isRegistered = user => user.intro_state > 2
