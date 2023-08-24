import ClassBookApp from '../classbook/classbook-app.vue'
import HomeApp from '../home/home-app.vue'
import MaterialsApp from '../materials/materials-app.vue'
import UsersApp from '../users/users-app.vue'
import TestsApp from '../tests/tests-app.vue'
import TestsAdmin from '../tests/tests-admin.vue'
import TestsExport from '../tests/tests-export.vue'
import MaterialsAdmin from '../materials/materials-admin.vue'
import StatisticsApp from '../statistics/statistics-app.vue'
import AdministrationApp from '../administration/administration-app.vue'

import VueRouter from 'vue-router'

const routes = [
  { path: '/start', component: HomeApp, name: 'Diagnostik' }, // Diagnostik
  { path: '/klassenbuch', component: ClassBookApp, name: 'ClassBook' }, // Klassenbuch
  { path: '/materialien', component: MaterialsApp, name: 'Materials' }, // Fördermaterialien
  { path: '/testuebersicht', component: TestsApp, name: 'Tests' }, // Tests
  { path: '/testverwaltung', component: TestsAdmin, name: 'TestsAdmin' },
  { path: '/testexport', component: TestsExport, name: 'TestsExport' },
  { path: '/nutzerverwaltung', component: UsersApp, name: 'Users' }, // Benutzerverwaltung
  { path: '/materialverwaltung', component: MaterialsAdmin, name: 'MaterialsAdmin' }, // Benutzerverwaltung
  { path: '/statistiken', component: StatisticsApp, name: 'Statistics' }, // Statistiken
  { path: '/administration', component: AdministrationApp, name: 'Administration' }, // Administration
  { path: '/groups/:groupId/assessments/:assessmentId', component: HomeApp }, // Redirect route after user based tests // TODO might want to redirect to /start if the data can be kept
]

export default new VueRouter({ routes, linkActiveClass: 'active', mode: 'history' })
