//= require activestorage

// jQuery needs to be in a separate file, and must be imported before bootstrap
// Otherwise, JS's hoisting mechanism will import bootstrap before window.$ is set,
// which is needed by bootstrap.
import './add_jquery'
import * as bootstrap from 'bootstrap'

import Vue from 'vue'
import BootstrapVue from 'bootstrap-vue'
import VueQRCodeComponent from 'qrcode.vue'

import ClassBookApp from '../vue/classbook/classbook-app.vue'
import FrontendApp from '../vue/testing/frontend-app.vue'
import HomeApp from '../vue/home/home-app.vue'
import MaterialsApp from '../vue/materials/materials-app.vue'
import StudentView from '../vue/testing/student-view.vue'
import UsersApp from '../vue/users/users-app.vue'

import '../styles/application.scss'
import { decryptStudentName } from '../utils/encryption'
import { store } from '../utils/store'
import { ajax } from '../utils/ajax'

window.bootstrap = bootstrap

const element = document.getElementById('levumi')

const init = async () => {
  // TODO remove once all data is fetched from API
  const data = JSON.parse(element.getAttribute('data')) || {}

  // get core data
  const res = await ajax({ url: `/users/core_data` })
  const studentsData = await res.json()

  store.setShareKeys(studentsData.share_keys)
  store.setGroups(studentsData.groups)

  // decrypt student names
  if (studentsData.groups) {
    const studentsInGroups = studentsData.groups.reduce((acc, group) => {
      acc[group.id] = group.students?.map(student => {
        return {
          ...student,
          name: decryptStudentName(student.name, `Kind_${student.id}`, group.id),
        }
      })
      return acc
    }, {})

    store.setStudentsInGroups(studentsInGroups)
  }

  Vue.component('QrCode', VueQRCodeComponent)
  Vue.use(BootstrapVue)

  Vue.mixin({
    data: function () {
      return {
        get jQuery() {
          return window.$
        },
        store,
      }
    },
  })

  // TODO this is instantiated on every navigation event. Probably better use a single Vue app and Vue router instead.
  new Vue({
    el: '#levumi',
    components: {
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

window.highlightNavItem = item => {
  //Klasse 'active' von allen nav-items entfernen und dann bei übergebenem Element hinzufügen
  let btns = document.getElementById('navbarContent').getElementsByClassName('active')
  for (let i = 0; i < btns.length; i++) {
    btns[i].className = btns[i].className.replace(' active', '')
  }
  document.getElementById(item).className += ' active'
}
