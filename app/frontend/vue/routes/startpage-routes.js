//import StartpageFaq from '../startpage/components/startpage-faq.vue'
import StartpageResearchers from '../startpage/components/startpage-researchers.vue'
import StartpageTeachers from '../startpage/components/startpage-teachers.vue'
//import StartpageTestimonials from '../startpage/components/startpage-testimonials.vue'
import StartpageTests from '../startpage/components/startpage-tests.vue'
import StartpageStart from '../startpage/components/startpage-start.vue'

//import VueRouter from 'vue-router'
import { createMemoryHistory, createRouter } from 'vue-router'

const routes = [
  { path: '/', component: StartpageStart },
  { path: '/login', component: StartpageStart },
  { path: '/testinventar', component: StartpageTests },
  { path: '/lehrkraefte', component: StartpageTeachers },
  { path: '/forschung', component: StartpageResearchers },
  // { path: '/faq', component: StartpageFaq },
  // {path: "/testimonial", component: Startpage},
]

export default createRouter({ routes, linkActiveClass: 'active', history: createMemoryHistory() })
