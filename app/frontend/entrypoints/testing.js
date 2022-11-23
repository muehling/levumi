// jQuery needs to be in a separate file, and must be imported before bootstrap
// Otherwise, JS's hoisting mechanism will import bootstrap before window.$ is set,
// which is needed by bootstrap.
import './add_jquery'
import * as bootstrap from 'bootstrap'

import BootstrapVue from 'bootstrap-vue'
import Vue from 'vue'
import VueQRCodeComponent from 'qrcode.vue'

import FrontendApp from '../vue/testing/frontend-app.vue'

import '../styles/application.scss'

window.bootstrap = bootstrap

const element = document.getElementById('levumi')

const init = async () => {
  // TODO remove once all data is fetched from API
  const data = JSON.parse(element.getAttribute('data')) || {}

  Vue.component('QrCode', VueQRCodeComponent)
  Vue.use(BootstrapVue)

  Vue.mixin({
    data: function () {
      return {
        get jQuery() {
          return window.$
        },
      }
    },
  })

  new Vue({
    el: '#levumi',
    components: {
      FrontendApp,
    },
    data: data,
  })
}

if (element) {
  init()
}
