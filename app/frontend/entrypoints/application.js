import * as sjcl from 'sjcl'

import BootstrapVue from 'bootstrap-vue-next'
import ClassBookApp from '../vue/classbook/classbook-app.vue'
import HomeApp from '../vue/home/home-app.vue'
import MaterialsApp from '../vue/materials/materials-app.vue'
import RootApp from '../vue/root-app.vue'
import StudentView from '../vue/testing/student-view.vue'
import UsersApp from '../vue/users/users-app.vue'

import { createApp } from 'vue'
import VueApexCharts from 'vue-apexcharts'
//import VueRouter from 'vue-router'

import { createPinia, PiniaVuePlugin } from 'pinia' // used for global stores

import router from '../vue/routes/frontend-routes'

import '../styles/application.scss'

// TODO only needed for recover.html.erb
window.sjcl = sjcl

const element = document.getElementById('levumi')

const init = async () => {
  const data = JSON.parse(element.getAttribute('data')) || {}
  const pinia = createPinia()

  //new Vue({
  const app = createApp({
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
    data() {
      return data
    },
  })

  app.use(BootstrapVue)
  app.use(VueApexCharts)
  //app.component('apexchart', VueApexCharts)
  app.mixin({
    data: function () {
      return {
        get jQuery() {
          return window.$
        },
      }
    },
  })

  //app.use(VueRouter)
  app.use(PiniaVuePlugin)
}

if (element) {
  init()
}
