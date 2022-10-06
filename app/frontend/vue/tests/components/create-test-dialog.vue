<template>
  <b-modal id="users-mail-dialog" ref="testImportDialog" title="Test importieren" hide-footer>
    <div class="card card-body">
      <b-form>
        <b-btn variant="primary" @click="importTest">Hochladen</b-btn>
      </b-form>
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
        const res = await ajax({ ...apiRoutes.tests.import })
        if (res.status === 200) {
          console.log('yay, imported')
        }
      },
    },
  }
</script>
