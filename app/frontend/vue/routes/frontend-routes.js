import ClassBookApp from '../classbook/classbook-app.vue'
import HomeApp from '../home/home-app.vue'
import MaterialsApp from '../materials/materials-app.vue'
import UsersApp from '../users/users-app.vue'
import TestsApp from '../tests/tests-app.vue'
import TestsAdmin from '../tests/tests-admin.vue'

import VueRouter from 'vue-router'

const routes = [
  { path: '/start', component: HomeApp }, // Diagnostik
  { path: '/klassenbuch', component: ClassBookApp }, // Klassenbuch
  { path: '/materialien', component: MaterialsApp }, // Fördermaterialien
  { path: '/testuebersicht', component: TestsApp }, // Tests
  { path: '/testverwaltung', component: TestsAdmin },
  { path: '/nutzerverwaltung', component: UsersApp }, // Benutzerverwaltung
]

export default new VueRouter({ routes, linkActiveClass: 'active', mode: 'history' })
