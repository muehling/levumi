// jQuery needs to be in a separate file, and must be imported before bootstrap
// Otherwise, JS's hoisting mechanism will import bootstrap before window.$ is set,
// which is needed by bootstrap.
import './add_jquery'
import * as bootstrap from 'bootstrap'
import * as sjcl from 'sjcl'

import BootstrapVue from 'bootstrap-vue'
import Vue from 'vue'
import VueRouter from 'vue-router'

import RootApp from '../vue/root-app.vue'
import ClassBookApp from '../vue/classbook/classbook-app.vue'
import HomeApp from '../vue/home/home-app.vue'
import MaterialsApp from '../vue/materials/materials-app.vue'
import StudentView from '../vue/testing/student-view.vue'
import UsersApp from '../vue/users/users-app.vue'
import VueApexCharts from 'vue-apexcharts'

import { createPinia, PiniaVuePlugin } from 'pinia' // used for global stores

import router from '../vue/routes/frontend-routes'

import '../styles/application.scss'

window.bootstrap = bootstrap

// TODO only needed for recover.html.erb
window.sjcl = sjcl

const element = document.getElementById('levumi')

const init = async () => {
  // TODO remove once all data is fetched from API
  const data = JSON.parse(element.getAttribute('data')) || {}

  Vue.use(BootstrapVue)

  Vue.use(VueApexCharts)
  Vue.component('apexchart', VueApexCharts)

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

  new Vue({
    router,
    pinia,
    el: '#levumi',
    components: {
      RootApp,
      ClassBookApp,
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
