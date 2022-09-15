export default {
  classbook: {
    finishIntro: '/willkommen?classbook=true',
  },
  users: {
    update: id => ({ url: `/users/${id}`, method: 'PATCH' }),
    create: { url: '/users', method: 'POST' },
    usersMail: id => ({ url: `/users/${id}/mail`, method: 'PUT' }),
    coreData: '/users/core_data',
    logout: '/logout',
  },
  home: {
    finishIntro: '/willkommen',
  },
  materials: {
    info: '/materials/info',
  },
  tests: {
    info: 'tests/info',
  },
}
