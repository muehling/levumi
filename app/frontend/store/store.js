import { ajax } from '../utils/ajax'
import { decryptStudentNames } from '../utils/encryption'
import apiRoutes from '../vue/routes/api-routes'

import { defineStore } from 'pinia'
import Vue from 'vue'

export const useGlobalStore = defineStore('global', {
  state: () => ({
    errorMessage: '',
    genericMessage: { title: '', message: '' },
    groupInfo: [],
    groups: [],
    isLoading: false,
    login: {},
    serverError: undefined,
    masquerade: false,
    shareKeys: {},
    staticData: {},
    studentsInGroups: {},
    isLoginOpen: false,
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
      const data = res.data
      this.staticData.annotationCategories = data
    },
    async fetchTestTypes() {
      const res = await ajax({ url: apiRoutes.testTypes.index })
      const data = res.data
      this.staticData.testTypes = data
    },

    async fetchTestMetaData() {
      const res = await ajax({ ...apiRoutes.tests.testMetaData })
      const data = res.data
      this.staticData.testMetaData = data
    },

    async getItemsForTest(testId) {
      const test = this.staticData.testMetaData.tests.find(test => test.id === testId)
      if (!test) {
        console.error('globalStore::getItemsForTest: test with given id not found!')
      }
      if (test?.items) {
        return test.items
      } else {
        const data = await ajax({ ...apiRoutes.tests.items(testId) })
        const items = data.data
        test.items = items
        Vue.set(this.staticData.testMetaData, 'tests', [...this.staticData.testMetaData.tests])
      }
    },

    async fetch(showLoader = false) {
      this.isLoading = showLoader
      const res = await ajax({ url: apiRoutes.users.coreData })
      const coreData = res.data
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
