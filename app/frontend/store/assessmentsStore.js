import { ajax } from '../utils/ajax'
import { defineStore } from 'pinia'
import apiRoutes from '../vue/routes/api-routes'
import Vue from 'vue'

export const useAssessmentsStore = defineStore('assessments', {
  state: () => ({
    isLoading: false,
    assessments: {},
  }),
  actions: {
    setAssessments(groupId, assessments) {
      Vue.set(this.assessments, groupId, assessments) // need to set this way to preserve reactivity
    },
    getAssessments(groupId) {
      return this.assessments[groupId] || []
    },
    async fetch(groupId) {
      this.isLoading = true
      const res = await ajax(apiRoutes.assessments.info(groupId))

      if (res.status === 200) {
        const data = await res.json()
        this.setAssessments(groupId, data)
      } else {
        this.setAssessments(groupId, [])
      }
      this.isLoading = false
    },
  },
})
