import { ajax } from '../utils/ajax'
import apiRoutes from '../vue/routes/api-routes'

import { defineStore } from 'pinia'

export const useAssessmentsStore = defineStore('assessments', {
  state: () => ({
    isLoading: false,
    assessments: [],
  }),
  actions: {
    setAssessments(assessments) {
      this.assessments = assessments
    },
    async fetch(groupId) {
      this.isLoading = true
      const res = await ajax(apiRoutes.assessments.info(groupId))
      const data = await res.json()

      this.setAssessments(data)
      this.isLoading = false
    },
  },
})
