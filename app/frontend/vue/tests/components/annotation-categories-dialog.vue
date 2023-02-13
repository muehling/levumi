<template>
  <div>
    <b-modal
      id="annotation-categories-dialog"
      ref="annotationCategoriesDialog"
      title="Anmerkungstypen definieren"
      hide-footer
    >
      Folgende Anmerkungstypen stehen aktuell zur Verfügung:
      <div>
        <div v-for="annotationCategory in annotationCategories" :key="annotationCategory.id">
          {{ annotationCategory.name }}
        </div>
        <b-form-input v-model="newCategory" placeholder="Neuen Typ eingeben"></b-form-input>
        <b-button @click="createAnnotationCategory">Speichern</b-button>
      </div>
    </b-modal>
  </div>
</template>
<script>
  import { ajax } from '../../../utils/ajax'
  import apiRoutes from '../../routes/api-routes'
  import { useGlobalStore } from '../../../store/store'

  export default {
    name: 'AnnotationCategoriesDialog',
    props: {
      users: Array,
    },
    setup() {
      const globalStore = useGlobalStore()
      return { globalStore }
    },
    data() {
      return {
        newCategory: '',
        annotationCategories: this.globalStore.staticData.annotationCategories,
      }
    },
    methods: {
      async open() {
        this.$refs.annotationCategoriesDialog.show()
      },
      _close() {
        this.$refs.annotationCategoriesDialog.hide()
      },
      async createAnnotationCategory() {
        this.isLoading = true

        const res = await ajax({
          data: { name: this.newCategory },
          ...apiRoutes.annotationCategories.create,
        })

        if (res.status === 200) {
          const data = await res.json()
          this.annotationCategories = [...this.annotationCategories, data]
        }

        this.isLoading = false

        this._reset()
      },
      _reset() {
        this.newCategory = ''
        this.isLoading = false
      },
    },
  }
</script>
