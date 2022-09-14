<template>
  <div>
    <b-modal id="edit-user-dialog" ref="editUserDialog" hide-footer>
      <template #modal-title> Benutzerdaten ändern </template>
      <user-form :is-new="isNew" :user="user" @submitSuccessful="handleSuccess" />
    </b-modal>
    <info-dialog ref="infoDialog" />
  </div>
</template>

<script>
  import { hasCapability } from '../../../utils/user'
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
        user: undefined,
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
    computed: {
      states() {
        return this.globalStore.staticData.states
      },
      accountTypes() {
        return this.globalStore.staticData.accountTypes
      },
      stateOptions() {
        return this.globalStore.staticData.states?.map(s => ({ value: s.id, text: s.label }))
      },
      login() {
        return this.globalStore.login
      },
      canEditUser() {
        return hasCapability('user', this.globalStore.login?.capabilities)
      },
      accountTypeText() {
        return this.accountTypes?.find(at => at.id === this.accountType)?.label
      },
      buttonText() {
        return this.isNew ? 'Anlegen' : 'Aktualisieren'
      },
      // error states come from the backend, e. g. when changing the email to an already existing one
      hasEmailErrors() {
        return Object.keys(this.errors).find(e => e === 'email')
      },
      hasAccountTypeErrors() {
        return Object.keys(this.errors).find(e => e === 'account_type')
      },
      hasStateErrors() {
        return Object.keys(this.errors).find(e => e === 'state')
      },
      hasPasswordErrors() {
        return Object.keys(this.errors).find(e => e === 'password')
      },
      hasSecurityQuestionErrors() {
        return Object.keys(this.errors).find(e => e === 'security_digest')
      },
      // validation
      isPasswordValid() {
        // returns null instead of boolean because this is expected for the bootstrap validation
        return this.password !== '' || this.passwordConfirm !== ''
          ? this.password === this.passwordConfirm
          : null
      },
      isSecurityHintVisible() {
        return this.password !== '' && this.securityAnswer === ''
      },
      isSubmitDisabled() {
        return (
          this.password === '' ||
          this.password !== this.passwordConfirm ||
          this.securityAnswer === ''
        )
      },
    },
    methods: {
      open(data = {}) {
        this.$refs.editUserDialog.show()
        this.user = data.user
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
      _close() {
        this.$refs.editUserDialog.hide()
        this.user = undefined
      },
    },
  }
</script>
