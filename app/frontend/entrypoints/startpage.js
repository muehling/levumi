// jQuery needs to be in a separate file, and must be imported before bootstrap
// Otherwise, JS's hoisting mechanism will import bootstrap before window.$ is set,
// which is needed by bootstrap.
import './add_jquery'
import * as bootstrap from 'bootstrap'

import { createPinia, PiniaVuePlugin } from 'pinia'
import BootstrapVue from 'bootstrap-vue-next'
import router from '../vue/routes/startpage-routes'
import StartpageApp from '../vue/startpage/startpage-app.vue'
import StartpageFaq from '../vue/startpage/components/startpage-faq.vue'
import StartpageResearchers from '../vue/startpage/components/startpage-researchers.vue'
import StartpageTeachers from '../vue/startpage/components/startpage-teachers.vue'
import StartpageTestimonials from '../vue/startpage/components/startpage-testimonials.vue'
import StartpageTests from '../vue/startpage/components/startpage-tests.vue'
import { createApp } from 'vue'
//import VueRouter from 'vue-router'
import { createBootstrap } from 'bootstrap-vue-next'

import '../styles/application.scss'

window.bootstrap = bootstrap

const element = document.getElementById('levumi')

const init = async () => {
  const data = JSON.parse(element.getAttribute('data')) || {}

  const pinia = createPinia()

  //new Vue({
  const app = createApp({
    //router,
    //pinia,
    el: '#levumi',
    components: {
      StartpageApp,
      StartpageFaq,
      StartpageResearchers,
      StartpageTeachers,
      StartpageTestimonials,
      StartpageTests,
    },
    data() {
      return data
    },
  })
  console.log('meh, app', app)

  app.use(router)
  app.use(pinia)
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

if (element) {
  init()
}

$('[data-toggle="popover"]').popover()
