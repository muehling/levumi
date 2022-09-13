import { ajax } from '../utils/ajax'
import { decryptStudentName } from '../utils/encryption'
import apiRoutes from '../vue/routes/api-routes'

import { defineStore } from 'pinia'

export const useGlobalStore = defineStore('global', {
  state: () => ({
    isLoading: false,
    login: {},
    studentsInGroups: {},
    groups: [],
    masquerade: false,
    shareKeys: {},
    staticData: {},
  }),

  actions: {
    setGroups(groups) {
      this.groups = groups
    },
    async fetch() {
      this.isLoading = true
      const res = await ajax({ url: apiRoutes.users.coreData })
      const coreData = await res.json()

      this.shareKeys = coreData.share_keys
      this.groups = coreData.groups
      this.masquerade = coreData.masquerade
      this.login = coreData.login
      this.staticData = {
        states: coreData.states,
        schoolTypes: coreData.schoolTypes,
        focusTypes: coreData.focusTypes,
        accountTypes: coreData.accountTypes,
      }

      // decrypt student names
      if (coreData.groups) {
        const studentsInGroups = coreData.groups.reduce((acc, group) => {
          acc[group.id] = group.students?.map(student => {
            return {
              ...student,
              name: decryptStudentName(
                student.name,
                `Kind_${student.id}`,
                group.id,
                coreData.share_keys
              ),
            }
          })
          return acc
        }, {})

        this.studentsInGroups = studentsInGroups
      }
      this.isLoading = false
    },
  },
})

/*export const getMaterialsData = async () => {
  const res = await ajax({ url: apiRoutes.materials.info })
  const data = await res.json()
  store.setMaterialsData(data.materials)
}

export const getTestsData = async () => {
  const res = await ajax({ url: apiRoutes.tests.info })
  const data = await res.json()
  store.setTestsData(data.tests)
}
*/
