<template>
  <div>
    <nav-bar />
    <router-view />
  </div>
</template>
<script>
  import NavBar from './shared/nav-bar.vue'
  import { RouterView } from 'vue-router'
  import { store } from '../utils/store'
  import { decryptStudentName } from '../utils/encryption'
  import { ajax } from '../utils/ajax'
  export default {
    name: 'RootApp',
    components: {
      NavBar,
      RouterView,
    },
    async beforeCreate() {
      const path = window.location.pathname
      if (path !== '/testen' && path !== '/testen_login') {
        // get core data
        const res = await ajax({ url: `/users/core_data` })
        const coreData = await res.json()

        store.setShareKeys(coreData.share_keys)
        store.setGroups(coreData.groups)
        store.setMasquerade(coreData.masquerade)
        store.setLogin(coreData.login)
        store.setStaticData({
          states: coreData.states,
          schoolTypes: coreData.schoolTypes,
          focusTypes: coreData.focusTypes,
          accountTypes: coreData.accountTypes,
        })

        // decrypt student names
        if (coreData.groups) {
          const studentsInGroups = coreData.groups.reduce((acc, group) => {
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
      }
    },
  }
</script>
