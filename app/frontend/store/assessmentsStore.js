import { ajax } from '../utils/ajax'
import { defineStore } from 'pinia'
import apiRoutes from '../vue/routes/api-routes'
import groupBy from 'lodash/groupBy'
//import Vue from 'vue'

export const useAssessmentsStore = defineStore('assessments', {
  state: () => ({
    isLoading: false,
    assessments: {},
    currentAssessment: undefined,
  }),
  actions: {
    setAssessments(groupId, assessments) {
      //Vue.set(this.assessments, groupId, assessments) // need to set this way to preserve reactivity
      this.assessments[groupId] = assessments
    },
    getAssessments(groupId) {
      return this.assessments[groupId] || []
    },
    setCurrentAssessment(assessment) {
      this.currentAssessment = assessment
    },
    getCurrentAssessment() {
      return this.currentAssessment
    },
    getSeriesByStudent() {
      if (!this.currentAssessment) {
        console.error('assessmentsStore: currentAssessment not set')
        return
      }
      return groupBy(this.currentAssessment.series, 'student_id')
    },

    async fetchCurrentAssessment(groupId, testId) {
      this.isLoading = true
      const res = await ajax(apiRoutes.assessments.currentAssessment(groupId, testId))
      if (res.status === 200) {
        const data = res.data
        this.currentAssessment = { ...data, groupId }
      } else {
        this.currentAssessment = undefined
      }
      this.isLoading = false
      return this.currentAssessment
    },
    async fetch(groupId) {
      if (!groupId) {
        return
      }
      this.isLoading = true
      const res = await ajax(apiRoutes.assessments.info(groupId))

      if (res.status === 200) {
        const data = res.data
        this.setAssessments(groupId, data)
      } else {
        this.setAssessments(groupId, [])
      }
      this.isLoading = false
    },
    reset() {
      this.isLoading = false
      this.assessments = {}
      this.currentAssessment = undefined
    },
  },
})
