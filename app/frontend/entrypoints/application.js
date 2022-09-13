//= require activestorage

// jQuery needs to be in a separate file, and must be imported before bootstrap
// Otherwise, JS's hoisting mechanism will import bootstrap before window.$ is set,
// which is needed by bootstrap.
import './add_jquery'
import * as bootstrap from 'bootstrap'

import BootstrapVue from 'bootstrap-vue'
import Vue from 'vue'
import VueQRCodeComponent from 'qrcode.vue'
import VueRouter from 'vue-router'

import RootApp from '../vue/root-app.vue'
import ClassBookApp from '../vue/classbook/classbook-app.vue'
import FrontendApp from '../vue/testing/frontend-app.vue'
import HomeApp from '../vue/home/home-app.vue'
import MaterialsApp from '../vue/materials/materials-app.vue'
import StudentView from '../vue/testing/student-view.vue'
import UsersApp from '../vue/users/users-app.vue'

import { createPinia, PiniaVuePlugin } from 'pinia'

import router from '../vue/routes/frontend-routes'

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

  const pinia = createPinia()

  Vue.use(VueRouter)
  Vue.use(PiniaVuePlugin)

  // TODO this is instantiated on every navigation event. Probably better use a single Vue app and Vue router instead.
  new Vue({
    router,
    pinia,
    el: '#levumi',
    components: {
      RootApp,
      ClassBookApp,
      FrontendApp,
      HomeApp,
      MaterialsApp,
      StudentView,
      UsersApp,
    },
    data: data,
  })
}

if (element) {
  init()
}
