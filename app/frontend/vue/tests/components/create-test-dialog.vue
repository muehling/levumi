<template>
  <b-modal id="users-mail-dialog" ref="testImportDialog" title="Test importieren" hide-footer>
    <div class="card card-body">
      <b-form-file
        v-model="file"
        accept=".zip"
        :state="Boolean(file)"
        placeholder="Datei wählen oder hier ablegen..."
        drop-placeholder="Datei hier ablegen..."
      ></b-form-file>
      <b-btn variant="primary" @click="importTest">Hochladen</b-btn>
    </div>
  </b-modal>
</template>
<script>
  import { ajax } from '../../../utils/ajax'
  import apiRoutes from '../../routes/api-routes'

  export default {
    name: 'CreateTestDialog',
    props: {
      users: Array,
    },
    data() {
      return { file: undefined }
    },
    methods: {
      open() {
        this.$refs.testImportDialog.show()
      },
      _close() {
        this.$refs.testImportDialog.hide()
      },
      async importTest() {
        console.log('meh', this.file)
        const formData = new FormData()
        formData.append('file', this.file)

        const res = await ajax({ ...apiRoutes.tests.import, data: { test: formData } })
        if (res.status === 200) {
          console.log('yay, imported')
        }
      },
    },
  }
</script>
