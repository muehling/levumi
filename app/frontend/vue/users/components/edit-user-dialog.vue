<template>
  <div>
    <b-modal
      id="edit-user-dialog"
      ref="editDialog"
      title="Benutzerdaten ändern"
      v-if="isOpen"
      @hidden="isOpen = false"
      hide-footer>
      <user-form
        :is-new="isNew"
        :user="user"
        :show-delete-button="!isNew"
        @submitSuccessful="handleSuccess"
        @cancelEdit="cancelEdit" />
    </b-modal>
    <info-dialog ref="infoDialog" />
  </div>
</template>

<script>
  import UserForm from '../../shared/forms/user-form.vue'
  import InfoDialog from '../../shared/info-dialog.vue'

  export default {
    name: 'EditUserDialog',
    components: { UserForm, InfoDialog },

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
        isOpen: false,
      }
    },
    methods: {
      open(data = {}) {
        // this.$refs.editDialog.show()
        this.isOpen = true
        this.user = data.user
        this.isNew = data.isNew || false
      },
      handleSuccess(res) {
        const params = this.isNew ? { currentPage: 1 } : res
        this.$emit('refetch', params)
        this.$refs.infoDialog.open({
          message: !this.isNew
            ? 'Ihre Daten wurden erfolgreich geändert!'
            : 'Account wurde erfolgreich angelegt!',
          title: 'Speichern erfolgreich',
          okText: 'Schließen',
        })
        this._close()
      },
      cancelEdit() {
        this._close()
      },
      _close() {
        //  this.$refs.editDialog.hide()
        this.isOpen = false
        this.user = {}
      },
    },
  }
</script>
