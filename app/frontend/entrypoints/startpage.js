// jQuery needs to be in a separate file, and must be imported before bootstrap
// Otherwise, JS's hoisting mechanism will import bootstrap before window.$ is set,
// which is needed by bootstrap.
import './add_jquery'
import * as bootstrap from 'bootstrap'

import BootstrapVue from 'bootstrap-vue'
import Vue from 'vue'

import StartpageApp from '../vue/startpage/startpage-app.vue'

import '../styles/application.scss'

window.bootstrap = bootstrap

const element = document.getElementById('levumi')

const init = async () => {
  Vue.use(BootstrapVue)
  console.log('yay, entrypoint')

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
      StartpageApp,
    },
  })
  $('[data-toggle="popover"]').popover()
}

if (element) {
  init()
}
