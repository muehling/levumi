import ClassBookApp from '../classbook/classbook-app.vue'
import HomeApp from '../home/home-app.vue'
import MaterialsApp from '../materials/materials-app.vue'
import UsersApp from '../users/users-app.vue'
import TestsApp from '../tests/tests-app.vue'
import VueRouter from 'vue-router'

const routes = [
  { path: '/start', component: HomeApp }, // Diagnostik
  { path: '/willkommen', component: ClassBookApp }, // Klassenbuch
  { path: '/materials', component: MaterialsApp }, // Fördermaterialien
  { path: '/tests', component: TestsApp }, // Tests, still rendered by Rails
  { path: '/users', component: UsersApp }, // Benutzerverwaltung
]

export default new VueRouter({ routes })
