import { ajax } from '../utils/ajax'
import apiRoutes from '../vue/routes/api-routes'

import { defineStore } from 'pinia'

export const useAssessmentsStore = defineStore('assessments', {
  state: () => ({
    isLoading: false,
    assessments: {},
  }),
  actions: {
    setAssessments(groupId, assessments) {
      this.assessments[groupId] = assessments
    },
    getAssessments(groupId) {
      return this.assessments[groupId] || []
    },
    async fetch(groupId) {
      this.isLoading = true
      const res = await ajax(apiRoutes.assessments.info(groupId))
      const data = await res.json()

      this.setAssessments(groupId, data)
      this.isLoading = false
    },
  },
})
