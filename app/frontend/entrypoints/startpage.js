import { createPinia } from 'pinia'
import router from '../vue/routes/startpage-routes'
import StartpageApp from '../vue/startpage/startpage-app.vue'
import StartpageFaq from '../vue/startpage/components/startpage-faq.vue'
import StartpageResearchers from '../vue/startpage/components/startpage-researchers.vue'
import StartpageTeachers from '../vue/startpage/components/startpage-teachers.vue'
import StartpageTestimonials from '../vue/startpage/components/startpage-testimonials.vue'
import StartpageTests from '../vue/startpage/components/startpage-tests.vue'
import { createApp } from 'vue'
import { createBootstrap } from 'bootstrap-vue-next'

import '../styles/application.scss'

const element = document.getElementById('levumi')

const init = async () => {
  const data = JSON.parse(element.getAttribute('data')) || {}

  const pinia = createPinia()

  const app = createApp({
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

  app.use(router)
  app.use(pinia)
  app.use(createBootstrap())

  app.mount('#levumi')
}

if (element) {
  init()
}
