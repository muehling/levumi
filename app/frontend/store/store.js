import { ajax } from '../utils/ajax'
import { decryptStudentNames } from '../utils/encryption'
import apiRoutes from '../vue/routes/api-routes'

import { defineStore } from 'pinia'

export const useGlobalStore = defineStore('global', {
  state: () => ({
    errorMessage: '',
    genericMessages: { title: '', message: '' },
    generalModals: {
      isImprintOpen: false,
      isPrivacyOpen: false,
      isAboutOpen: false,
      isCookieHintOpen: false,
    },
    groupInfo: [],
    groups: [],
    isLoading: false,
    login: {},
    serverError: undefined,
    masquerade: false,
    shareKeys: {},
    staticData: {},
    studentsInGroups: {},
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
      this.studentsInGroup[groupId] = [...students]
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
    async fetchGroups() {
      const res = await ajax(apiRoutes.groups.groups)

      this.groups = res.data.groups
      this.shareKeys = res.data.share_keys
      const studentsInGroups = res.data.groups.reduce((acc, group) => {
        acc[group.id] = decryptStudentNames(group)

        return acc
      }, {})
      this.studentsInGroups = studentsInGroups
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
        this.staticData.testMetaData['tests'] = [...this.staticData.testMetaData.tests]
      }
    },

    async fetch(showLoader = false) {
      this.isLoading = showLoader
      const res = await ajax({ url: apiRoutes.users.coreData })
      const coreData = res.data
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
      this.isLoading = false
    },
  },
})
