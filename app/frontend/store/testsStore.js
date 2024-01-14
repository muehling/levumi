import { ajax } from '../utils/ajax'
import { defineStore } from 'pinia'
import apiRoutes from '../vue/routes/api-routes'
import Vue from 'vue'

export const useTestsStore = defineStore('tests', {
  state: () => ({
    isLoading: false,
    tests: [],
    testsForGroup: {},
  }),
  actions: {
    setTests(tests) {
      this.tests = tests
    },
    getTestsForGroup(groupId) {
      return this.testsForGroup[groupId]
    },
    async fetch() {
      this.isLoading = true
      const res = await ajax({ url: apiRoutes.tests.info })
      const data = await res.json()
      this.setTests(data.tests)
      this.isLoading = false
    },
    async fetchUsedTestsForGroup(groupId) {
      if (!groupId) {
        return
      }
      const res = await ajax(apiRoutes.groups.getTestData(groupId))
      const testData = await res.json()
      Vue.set(this.testsForGroup, groupId, testData)
    },
  },
})
