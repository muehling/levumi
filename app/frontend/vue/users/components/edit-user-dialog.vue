<template>
  <div>
    <b-modal id="edit-user-dialog" ref="editUserDialog" hide-footer>
      <template #modal-title> Benutzerdaten ändern </template>
      <user-form
        :is-new="isNew"
        :user="user"
        @submitSuccessful="handleSuccess"
        @cancelEdit="cancelEdit"
      />
    </b-modal>
    <info-dialog ref="infoDialog" />
  </div>
</template>

<script>
  import { useGlobalStore } from '../../../store/store'
  import UserForm from '../../shared/forms/user-form.vue'
  import InfoDialog from '../../shared/info-dialog.vue'

  export default {
    name: 'EditUserDialog',
    components: { UserForm, InfoDialog },
    setup() {
      const globalStore = useGlobalStore()
      return { globalStore }
    },
    data() {
      return {
        // local state
        user: {},
        email: '',
        accountType: '',
        state: '',
        institution: '',
        errors: [],
        isNew: false,
        password: '',
        passwordConfirm: '',
        securityAnswer: '',
      }
    },
    methods: {
      open(data = {}) {
        this.$refs.editUserDialog.show()
        this.user = data.user
        this.isNew = data.isNew || false
      },
      handleSuccess() {
        this.$emit('refetch')
        this.$refs.infoDialog.open({
          message: 'Ihre Daten wurden erfolgreich geändert!',
          title: 'Speichern erfolgreich',
          okText: 'Schließen',
        })
        this._close()
      },
      cancelEdit() {
        this._close()
      },
      _close() {
        this.$refs.editUserDialog.hide()
        this.user = {}
      },
    },
  }
</script>
