<template>
  <div>
    <b-modal id="create-test-dialog" ref="testImportDialog" title="Test importieren" hide-footer>
      <div v-if="isLoading" class="card card-body align-items-center">
        <div v-if="isLoading" class="spinner">
          <div class="bounce1"></div>
          <div class="bounce2"></div>
          <div class="bounce3"></div>
        </div>
        Hochladen...
      </div>
      <div v-else class="card card-body">
        <b-form-file
          v-model="file"
          class="mb-3"
          accept=".zip"
          :state="Boolean(file)"
          placeholder="Datei wählen oder hier ablegen..."
          drop-placeholder="Datei hier ablegen..."
        ></b-form-file>
        <b-form-checkbox v-model="updateOnly"
          >Nur Update (sonst Archivieren von existierendem Test)</b-form-checkbox
        >
        <b-form-checkbox v-model="keepMaterials"
          >Existierendes Fördermaterial beibehalten (nur bei Archivierung)</b-form-checkbox
        >
        <b-btn class="mt-3" variant="outline-primary" @click="importTest"
          ><i class="fas fa-file-upload mr-2"></i>Hochladen</b-btn
        >
      </div>
    </b-modal>
  </div>
</template>
<script>
  import { ajax } from '../../../utils/ajax'
  import apiRoutes from '../../routes/api-routes'
  import { useGlobalStore } from '../../../store/store'

  export default {
    name: 'CreateTestDialog',
    props: {
      users: Array,
    },
    setup() {
      const globalStore = useGlobalStore()
      return { globalStore }
    },
    data() {
      return { file: undefined, updateOnly: false, keepMaterials: false, isLoading: false }
    },
    methods: {
      open() {
        this.$refs.testImportDialog.show()
      },
      _close() {
        this.$refs.testImportDialog.hide()
      },
      async importTest() {
        const formData = new FormData()
        formData.append('test[file]', this.file)
        if (this.updateOnly) {
          formData.append('update_test', true)
        }
        if (this.keepMaterials) {
          formData.append('update_material', true)
        }

        this.isLoading = true
        const res = await ajax({
          ...apiRoutes.tests.import,
          data: formData,
        })
        this.isLoading = false
        switch (res.status) {
          case 200:
            this.globalStore.setGenericMessage({
              title: 'Import erfolgreich',
              message: 'Der Test wurde erfolgreich importiert!',
            })
            this.$emit('test-import:success')
            this.globalStore.fetch()
            break
          case 406:
            this.globalStore.setErrorMessage('Beim Import ist ein Fehler aufgetreten!')
            break
          default:
            this.globalStore.setErrorMessage('Ein unbekannter Fehler ist aufgetreten!')
        }
        this._reset()
        this._close()
      },
      _reset() {
        this.file = undefined
        this.updateOnly = false
        this.keepMaterials = false
        this.isLoading = false
      },
    },
  }
</script>
