export default {
  classbook: {
    finishIntro: '/willkommen?classbook=true',
  },
  users: {
    update: id => ({ url: `/users/${id}`, method: 'PATCH' }),
    create: { url: '/users', method: 'post' },
    usersMail: id => ({ url: `/users/${id}/mail`, method: 'put' }),
  },
  home: {
    finishIntro: '/willkommen',
  },
  materials: {
    info: '/materials/info',
  },
}
