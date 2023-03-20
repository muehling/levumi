<template>
  <div id="annotation-categories">
    <p>Folgende Anmerkungstypen stehen aktuell zur Verfügung:</p>
    <div>
      <div
        v-for="annotationCategory in annotationCategories"
        :key="annotationCategory.id"
        class="category-line w-100 justify-content-between align-items-center d-flex my-1 p-2"
      >
        <span>{{ parseDisplayName(annotationCategory.name) }}</span>
        <b-btn
          class="btn btn-sm"
          variant="outline-danger"
          @click="deleteCategory(annotationCategory.id)"
        >
          <i class="fas fa-trash"></i>
        </b-btn>
      </div>
      <div class="mt-4 flex-row d-flex">
        <label class="pt-2 mr-4" for="category">Typ: </label
        ><b-form-input
          id="category"
          v-model="category"
          placeholder="Neuen Typ eingeben"
        ></b-form-input>
        <label class="pt-2 ml-4 mr-2" for="group">Gruppe: </label
        ><b-form-input id="group" v-model="group" placeholder="Gruppe"></b-form-input>
        <label class="pt-2 ml-4 mr-2" for="index">Index: </label
        ><b-form-input id="index" v-model="index" placeholder="Index"></b-form-input>
        <b-button class="ml-3" @click="createAnnotationCategory">Speichern</b-button>
      </div>
    </div>

    <confirm-dialog ref="confirmDialog" />
  </div>
</template>
<script>
  import { ajax } from '../../../utils/ajax'
  import apiRoutes from '../../routes/api-routes'
  import { useGlobalStore } from '../../../store/store'
  import ConfirmDialog from '../../shared/confirm-dialog.vue'

  export default {
    name: 'AnnotationCategoriesDialog',
    components: { ConfirmDialog },
    props: {
      users: Array,
    },
    setup() {
      const globalStore = useGlobalStore()
      return { globalStore }
    },
    data() {
      return {
        category: '',
        group: 1,
        index: 1,
        annotationCategories: this.globalStore.staticData.annotationCategories,
      }
    },

    methods: {
      parseDisplayName(completeName) {
        const [name, group, index] = completeName.split('#')
        return `${name}${group ? ', Gruppe' + group : ''}${index ? ', Index: ' + index : ''}`
      },
      async createAnnotationCategory() {
        this.isLoading = true

        const res = await ajax({
          data: { name: `${this.category}#${this.group}#${this.index}` },
          ...apiRoutes.annotationCategories.create,
        })

        if (res.status === 200) {
          const data = await res.json()
          this.annotationCategories = [...this.annotationCategories, data]
          this.globalStore.fetchAnnotationCategories()
        }

        this.isLoading = false

        this._reset()
      },
      async deleteCategory(id) {
        const ok = await this.$refs.confirmDialog.open({
          message: `Anmerkungstyp wird gelöscht. Fortfahren`,
          okText: 'Ja, löschen',
          title: 'Anmerkungstyp löschen',
        })
        if (ok) {
          const res = await ajax({
            ...apiRoutes.annotationCategories.delete(id),
          })
          if (res.status === 200) {
            this.annotationCategories = this.annotationCategories.filter(
              category => category.id !== id
            )
            this.globalStore.fetchAnnotationCategories()
          } else {
            this.globalStore.setErrorMessage(
              'Dieser Anmerkungstyp wird aktuell verwendet und kann nicht gelöscht werden.'
            )
          }
        }
      },

      _reset() {
        this.newCategory = ''
        this.isLoading = false
      },
    },
  }
</script>
<style>
  #annotation-categories .category-line:nth-child(odd) {
    background-color: rgba(0, 0, 0, 0.05);
  }
</style>
