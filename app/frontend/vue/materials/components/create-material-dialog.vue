<template>
  <div>
    <b-modal
      id="users-mail-dialog"
      ref="materialImportDialog"
      title="Material importieren"
      hide-footer
      ><div v-if="isLoading" class="card card-body align-items-center">
        <b-spinner></b-spinner>Hochladen...
      </div>
      <div v-else class="card card-body">
        <b-form-file
          v-model="file"
          accept=".zip"
          :state="Boolean(file)"
          placeholder="Datei wählen oder hier ablegen..."
          drop-placeholder="Datei hier ablegen..."
        ></b-form-file>
        <b-btn class="mt-3" variant="primary" @click="importMaterial">Hochladen</b-btn>
      </div>
    </b-modal>
  </div>
</template>
<script>
  import { ajax } from '../../../utils/ajax'
  import apiRoutes from '../../routes/api-routes'
  import { useGlobalStore } from '../../../store/store'

  export default {
    name: 'CreateMaterialDialog',
    props: {
      users: Array,
    },
    setup() {
      const globalStore = useGlobalStore()
      return { globalStore }
    },
    data() {
      return { file: undefined, isLoading: false }
    },
    methods: {
      open() {
        this.$refs.materialImportDialog.show()
      },
      _close() {
        this.$refs.materialImportDialog.hide()
      },
      async importMaterial() {
        const formData = new FormData()
        formData.append('material[file]', this.file)
        this.isLoading = true
        const res = await ajax({
          ...apiRoutes.materials.import,
          contentType: 'omit',
          data: formData,
        })
        this.isLoading = false
        switch (res.status) {
          case 200:
            this.globalStore.setGenericMessage({
              title: 'Import erfolgreich',
              message: 'Das Übungsmaterial wurde erfolgreich importiert!',
            })
            this.$emit('material-import:success')
            break
          case 406:
            this.globalStore.setErrorMessage('Beim Import ist ein Fehler aufgetreten!')
            break
          default:
            this.globalStore.setErrorMessage('Ein unbekannter Fehler ist aufgetreten!')
        }
        this.file = undefined
        this._close()
      },
    },
  }
</script>
