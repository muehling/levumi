export default {
  users: {
    update: id => ({ url: `/users/${id}`, method: 'PATCH' }),
    create: { url: '/users', method: 'post' },
    usersMail: id => ({ url: `/users/${id}/mail`, method: 'put' }),
  },
  classbook: {
    finishIntro: '/willkommen?classbook=true',
  },
  home: {
    finishIntro: '/willkommen',
  },
}
