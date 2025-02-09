import { createWebHistory, createRouter } from 'vue-router'
import AdministrationApp from '../administration/administration-app.vue'
import ClassBookApp from '../classbook/classbook-app.vue'
import HomeApp from '../home/home-app.vue'
import MaterialsAdmin from '../materials/materials-admin.vue'
import MaterialsApp from '../materials/materials-app.vue'
import NewsApp from '../news/news-app.vue'
import StatisticsApp from '../statistics/statistics-app.vue'
import SupportApp from '../support/support-app.vue'
import TestEditorApp from '../test-editor/test-editor-app.vue'
import TestsAdmin from '../tests/tests-admin.vue'
import TestsApp from '../tests/tests-app.vue'
import TestsExport from '../tests/tests-export.vue'
import UsersApp from '../users/users-app.vue'

const routes = [
  { path: '/', component: HomeApp },
  { path: '/start', component: HomeApp }, // legacy link, is now /diagnostik
  {
    path: '/diagnostik',
    component: HomeApp,
    name: 'Diagnostik',
    props: true,
    children: [
      {
        path: ':groupId',
        component: HomeApp,
        name: 'AssessmentList',
        children: [
          { path: 'testverwaltung', props: true, name: 'GroupTestAdmin', component: HomeApp },
          {
            path: 'testdetails/:testId',
            component: HomeApp,
            props: true,
            name: 'Assessment',
            children: [
              {
                path: 'einstellungen',
                component: HomeApp,
                props: true,
                name: 'AssessmentSettings',
              },
            ],
          },
        ],
      },
    ],
  },
  {
    path: '/klassenbuch',
    component: ClassBookApp,
    name: 'ClassBook',
    children: [
      {
        path: 'eigene_klassen',
        component: ClassBookApp,
        name: 'ClassbookOwn',
        children: [
          {
            path: ':groupId',
            component: ClassBookApp,
            name: 'ClassBookOwnGroup',
            children: [
              { path: 'liste', component: ClassBookApp, name: 'OwnList' },
              { path: 'aktionen', component: ClassBookApp, name: 'OwnActions' },
              { path: 'aktionen/allgemein', component: ClassBookApp, name: 'OwnActionsGeneral' },
              { path: 'aktionen/teilen', component: ClassBookApp, name: 'OwnActionsShare' },
              { path: 'aktionen/verschieben', component: ClassBookApp, name: 'OwnActionsMove' },
            ],
          },
        ],
      },
      {
        path: 'geteilte_klassen',
        component: ClassBookApp,
        name: 'ClassbookShared',
        children: [
          {
            path: ':groupId',
            component: ClassBookApp,
            name: 'ClassbookSharedGroup',
            children: [
              { path: 'liste', component: ClassBookApp },
              { path: 'aktionen', component: ClassBookApp },
              { path: 'aktionen/allgemein', component: ClassBookApp },
              { path: 'aktionen/teilen', component: ClassBookApp },
              { path: 'aktionen/verschieben', component: ClassBookApp },
            ],
          },
        ],
      },
    ],
  },
  { path: '/klassenbuch/archiv', component: ClassBookApp, name: 'ClassbookArchive' },
  { path: '/klassenbuch/neu', component: ClassBookApp, name: 'ClassbookNew' },
  { path: '/materialien', component: MaterialsApp, name: 'Materials' }, // Fördermaterialien
  { path: '/testuebersicht', component: TestsApp, name: 'Tests' }, // Tests
  { path: '/testverwaltung', component: TestsAdmin, name: 'TestsAdmin' },
  { path: '/testexport', component: TestsExport, name: 'TestsExport' },
  { path: '/nutzerverwaltung', component: UsersApp, name: 'Users' }, // Benutzerverwaltung
  { path: '/materialverwaltung', component: MaterialsAdmin, name: 'MaterialsAdmin' }, // Benutzerverwaltung
  { path: '/statistiken', component: StatisticsApp, name: 'Statistics' }, // Statistiken
  { path: '/administration', component: AdministrationApp, name: 'Administration' }, // Administration
  { path: '/groups/:groupId/assessments/:testId', component: HomeApp }, // Redirect route after user based tests // TODO might want to redirect to /diagnostik if the data can be kept
  { path: '/support', component: SupportApp },
  { path: '/test-editor', component: TestEditorApp },
  { path: '/neuigkeiten', component: NewsApp },
]

export default createRouter({ routes, linkActiveClass: 'active', history: createWebHistory() })
