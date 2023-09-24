import { ajax } from '../utils/ajax'
import apiRoutes from '../vue/routes/api-routes'

import { defineStore } from 'pinia'

export const useMaterialsStore = defineStore('materials', {
  state: () => ({
    isLoading: false,
    materials: [],
    materialsForTest: [],
  }),
  actions: {
    setMaterials(materials) {
      this.materials = materials
    },
    async fetch() {
      this.isLoading = true
      const res = await ajax({ url: apiRoutes.materials.info })
      const data = await res.json()
      this.setMaterials(data.materials)
      this.isLoading = false
    },
    async fetchMaterialsForTest(testId) {
      this.isLoading = true
      const res = await ajax({ url: apiRoutes.materials.materialsForTest(testId) })

      this.materialsForTest = await res.json()
      this.isLoading = false
    },
  },
})
