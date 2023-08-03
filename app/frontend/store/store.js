import { ajax } from '../utils/ajax'
import { decryptStudentNames } from '../utils/encryption'
import apiRoutes from '../vue/routes/api-routes'

import { defineStore } from 'pinia'

export const useGlobalStore = defineStore('global', {
  state: () => ({
    isLoading: false,
    login: {},
    studentsInGroups: {},
    groups: [],
    groupInfo: [],
    masquerade: false,
    shareKeys: {},
    staticData: {},
    errorMessage: '',
    genericMessage: { title: '', message: '' },
  }),

  actions: {
    setGroups(groups) {
      this.groups = groups
    },
    setShareKeys(keys) {
      this.shareKeys = keys || {}
    },
    setShareKey({ key, value }) {
      this.shareKeys = { ...this.shareKeys, [key]: value }
    },
    setStudentsInGroup({ groupId, students }) {
      this.studentsInGroups[groupId] = students
    },
    setErrorMessage(msg) {
      this.errorMessage = msg
    },
    setGenericMessage(msg) {
      this.genericMessage = msg
    },
    resetGenericMessage() {
      this.genericMessage = { title: '', message: '' }
    },
    setLogin(data) {
      let settings = {}
      try {
        settings = JSON.parse(data.settings)
      } catch (e) {
        // nothing to do
      }
      const d = { ...data, settings }
      this.login = d
    },

    async fetchAnnotationCategories() {
      const res = await ajax({ url: apiRoutes.annotationCategories.index })
      const data = await res.json()
      this.staticData.annotationCategories = data
    },
    async fetchTestTypes() {
      const res = await ajax({ url: apiRoutes.testTypes.index })
      const data = await res.json()
      this.staticData.testTypes = data
    },

    async fetchTestMetaData() {
      const res = await ajax({ ...apiRoutes.tests.testMetaData })
      const data = await res.json()
      this.staticData.testMetaData = data
    },

    async fetch(showLoader = false) {
      this.isLoading = showLoader
      const res = await ajax({ url: apiRoutes.users.coreData })
      const coreData = await res.json()
      this.shareKeys = coreData.share_keys
      this.groups = coreData.groups
      this.groupInfo = coreData.groupInfo
      this.masquerade = coreData.masquerade
      this.login = coreData.login
      this.staticData = {
        states: coreData.states,
        schoolTypes: coreData.schoolTypes,
        focusTypes: coreData.focusTypes,
        accountTypes: coreData.accountTypes,
        annotationCategories: coreData.annotationCategories,
        testTypes: coreData.testTypes,
        testMetaData: coreData.testMetaData,
      }

      // decrypt student names
      if (coreData.groups) {
        const studentsInGroups = coreData.groups.reduce((acc, group) => {
          acc[group.id] = decryptStudentNames(group)

          return acc
        }, {})

        this.studentsInGroups = studentsInGroups
      }
      this.isLoading = false
    },
  },
})
