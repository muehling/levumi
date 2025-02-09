<template>
  <div id="test-types" class="container">
    <p class="mt-4">Folgende Test-Typen stehen aktuell zur Verfügung:</p>
    <div>
      <table class="table table-striped table-sm w-100 border">
        <thead>
          <tr class="text-bold">
            <td>ID</td>
            <td>Bezeichnung</td>
            <td>Beschreibung</td>
            <td></td>
          </tr>
        </thead>
        <tbody>
          <tr v-for="testType in testTypes" :key="testType.id">
            <td>{{ testType.id }}</td>
            <td>{{ testType.name }}</td>
            <td>{{ testType.description }}</td>
            <td>
              <b-button
                class="btn btn-sm text-light"
                variant="danger"
                @click="deleteTestType(testType.id)">
                <i class="fas fa-trash"></i>
              </b-button>
            </td>
          </tr>
        </tbody>
      </table>

      <div class="mt-4 flex-row d-flex">
        <b-form-input
          id="category"
          v-model="testTypeName"
          placeholder="Neuen Typ eingeben"
          class="me-4"></b-form-input>
        <b-form-input
          id="category"
          v-model="testTypeDescription"
          placeholder="Beschreibung eingeben"></b-form-input>
        <b-button class="ms-3" @click="createTestType">Speichern</b-button>
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
    name: 'TestTypes',
    components: { ConfirmDialog },
    setup() {
      const globalStore = useGlobalStore()
      return { globalStore }
    },
    data() {
      return {
        testTypeName: '',
        testTypeDescription: '',
        testTypes: this.globalStore.staticData.testTypes,
      }
    },

    methods: {
      async createTestType() {
        this.isLoading = true

        const res = await ajax({
          data: { name: this.testTypeName, description: this.testTypeDescription },
          ...apiRoutes.testTypes.create,
        })

        if (res.status === 200) {
          const data = res.data
          this.testTypes = [...this.testTypes, data]
          this.globalStore.fetchTestTypes()
        }

        this.isLoading = false

        this._reset()
      },
      async deleteTestType(id) {
        const ok = await this.$refs.confirmDialog.open({
          message: `Testtyp wird gelöscht. Fortfahren?`,
          okText: 'Ja, löschen',
          title: 'Testtyp löschen',
        })
        if (ok) {
          const res = await ajax({
            ...apiRoutes.testTypes.delete(id),
          })
          if (res.status === 200) {
            this.testTypes = this.testTypes.filter(category => category.id !== id)
            this.globalStore.fetchTestTypes()
          } else {
            this.globalStore.setErrorMessage(
              'Dieser Testtyp wird aktuell verwendet und kann nicht gelöscht werden.'
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
