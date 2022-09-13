import { ajax } from '../utils/ajax'
import apiRoutes from '../vue/routes/api-routes'

import { defineStore } from 'pinia'

export const useTestsStore = defineStore('tests', {
  state: () => ({
    isLoading: false,
    tests: [],
  }),
  actions: {
    setTests(tests) {
      this.tests = tests
    },
    async fetch() {
      this.isLoading = true
      const res = await ajax({ url: apiRoutes.tests.info })
      const data = await res.json()
      this.setTests(data.tests)
      this.isLoading = false
    },
  },
})
