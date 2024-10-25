// jQuery needs to be in a separate file, and must be imported before bootstrap
// Otherwise, JS's hoisting mechanism will import bootstrap before window.$ is set,
// which is needed by bootstrap.
import './add_jquery'
import * as bootstrap from 'bootstrap'

import { createBootstrap } from 'bootstrap-vue-next'
import { createApp } from 'vue'

import FrontendApp from '../vue/testing/frontend-app.vue'

import '../styles/application.scss'

window.bootstrap = bootstrap

const element = document.getElementById('levumi')

const init = async () => {
  // TODO remove once all data is fetched from API
  const data = JSON.parse(element.getAttribute('data')) || {}

  // new Vue({
  const app = createApp({
    el: '#levumi',
    components: {
      FrontendApp,
    },
    data() {
      return data
    },
  })
  app.use(createBootstrap())

  app.mixin({
    data: function () {
      return {
        get jQuery() {
          return window.$
        },
      }
    },
  })
  app.mount('#levumi')
}

$('[data-toggle="popover"]').popover()

if (element) {
  init()
}
