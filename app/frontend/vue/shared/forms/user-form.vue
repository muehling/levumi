<template>
  <b-container>
    <b-form @submit="_handleSubmit">
      <b-form-group label-cols="4" label="E-Mail-Adresse*">
        <b-form-input
          v-model="email"
          :class="hasEmailErrors && 'is-invalid'"
          :readonly="!canEditUser" />
        <div v-if="hasEmailErrors" class="invalid-feedback">{{ errors['email'].join('\n') }}</div>
      </b-form-group>
      <b-form-group v-if="canEditUser" label-cols="4" label="Typ" class="mt-3">
        <b-form-radio v-for="at in accountTypes" :key="at.id" v-model="accountType" :value="at.id">
          {{ at.label }}
        </b-form-radio>
        <div v-if="hasAccountTypeErrors" class="invalid-feedback">
          Bitte wählen Sie einen Account-Typen aus!
        </div>
      </b-form-group>
      <b-form-group v-if="!canEditUser" label-cols="4" label="Typ" class="mt-3">
        <b-form-input :model-value="accountTypeText" :readonly="true" />
      </b-form-group>
      <div v-if="!canEditUser" class="form-group row">
        <div class="col-sm-12">
          <small class="form-text text-muted">
            Wenn Sie Ihre E-Mail Adresse oder Ihren Nutzertyp ändern möchten, wenden Sie sich bitte
            an uns.
          </small>
        </div>
      </div>

      <b-form-group v-if="isOwnProfile">
        <b-button v-b-toggle.password-section variant="outline-secondary">Passwort ändern</b-button>
        <b-collapse id="password-section" class="mt-2">
          <password-form
            :errors="errors"
            @change-password="pw => (password = pw)"
            @change-password-confirm="pw => (passwordConfirm = pw)"
            @change-security-answer="a => (securityAnswer = a)" />
        </b-collapse>
      </b-form-group>
      <div class="mt-3 mb-2">
        <b-form-group label-cols="4" label="Bundesland*">
          <b-form-select
            id="state-input"
            v-model="state"
            :class="hasStateErrors && 'is-invalid'"
            :options="stateOptions" />
        </b-form-group>
      </div>
      <extra-data-form
        :account-type="accountType"
        :town="town"
        :school-type="schoolType"
        :focus-type="focusType"
        :institution="institution"
        @change-institution="inst => (institution = inst)"
        @change-town="t => (town = t)"
        @change-school-type="st => (schoolType = st)"
        @change-focus-type="ft => (focusType = ft)"></extra-data-form>
      <div v-if="canEditSettingsJson" class="mb-3">
        <b-button variant="outline-secondary" @click="settingsOpen = !settingsOpen">
          User-Config ändern
        </b-button>
        <b-collapse v-model="settingsOpen" class="mt-2">
          <b-form-textarea
            v-model="settings"
            placeholder="Enter something..."
            rows="3"
            max-rows="6"></b-form-textarea>
        </b-collapse>
      </div>
    </b-form>
    <div class="d-flex justify-content-end">
      <b-button
        v-if="showDeleteButton && isOwnProfile"
        variant="danger"
        class="m-1"
        @click="deleteSelf">
        Profil löschen
      </b-button>
      <b-button variant="outline-secondary" class="m-1" @click="_close">Schließen</b-button>
      <b-button
        variant="outline-success"
        class="m-1"
        :disabled="isSubmitDisabled"
        @click="_handleSubmit">
        {{ buttonText }}
      </b-button>
    </div>
    <feedback-on-user-deletion ref="confirmDeleteDialog" />
    <confirm-dialog ref="doneConfirmation" />
  </b-container>
</template>

<script>
  import { ajax } from '../../../utils/ajax'
  import { encryptWithKey } from '../../../utils/encryption'
  import { hasCapability } from '../../../utils/user'
  import { useGlobalStore } from '../../../store/store'
  import apiRoutes from '../../routes/api-routes'
  import ConfirmDialog from '../confirm-dialog.vue'
  import ExtraDataForm from './extra-data-form.vue'
  import isEmpty from 'lodash/isEmpty'
  import PasswordForm from './password-form.vue'
  import FeedbackOnUserDeletion from '../feedback-on-user-deletion.vue'

  export default {
    name: 'UserForm',
    components: { PasswordForm, ExtraDataForm, ConfirmDialog, FeedbackOnUserDeletion },
    props: {
      isNew: Boolean,
      user: Object,
      showDeleteButton: Boolean,
    },

    setup() {
      const globalStore = useGlobalStore()
      return { globalStore }
    },
    data() {
      return {
        // local state
        accountType: this.user.account_type,
        email: this.user.email,
        errors: [],
        focusType: this.user.focus,
        institution: this.user.institution,
        password: '',
        passwordConfirm: '',
        schoolType: this.user.school_type,
        securityAnswer: '',
        settings:
          typeof this.user.settings === 'string'
            ? this.user.settings
            : JSON.stringify(this.user.settings),
        state: this.user.state,
        town: this.user.town,
        settingsOpen: false,
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
      isOwnProfile() {
        return this.globalStore.login.id === this.user.id
      },
      canEditUser() {
        return hasCapability('user', this.globalStore.login?.capabilities)
      },
      canEditSettingsJson() {
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
      hasSettingsErrors() {
        if (isEmpty(this.settings)) {
          return false
        }
        try {
          JSON.parse(this.settings)
        } catch (e) {
          console.log('user settings json cannot be parsed')
          return true
        }
        return false
      },

      /********************************
       * checks whether the submit button needs to be disabled
       ********************************/
      isSubmitDisabled() {
        const hasPasswordRelatedChange =
          this.password !== '' || this.passwordConfirm !== '' || this.securityAnswer !== ''

        const isIncomplete =
          this.email === '' ||
          !this.state ||
          this.accountType === undefined ||
          this.hasSettingsErrors

        const isPasswordInvalid =
          this.password === '' ||
          this.password !== this.passwordConfirm ||
          this.securityAnswer === ''

        return hasPasswordRelatedChange ? isPasswordInvalid || isIncomplete : isIncomplete
      },
    },

    methods: {
      _close() {
        this.$emit('cancelEdit')
      },
      async _handleSubmit() {
        const data = {
          user: {
            email: this.email,
            account_type: this.accountType,
            state: this.state,
          },
        }

        if (this.accountType === 1) {
          data.user.institution = this.institution
        } else if (this.accountType === 0) {
          data.user.town = this.town
          data.user.school_type = this.schoolType
          data.user.focus = this.focusType
        }

        if (this.settings && this.settings !== this.user.settings) {
          data.user.settings = this.settings
        }

        let res
        let newKeys
        if (this.isNew) {
          res = await ajax({ ...apiRoutes.users.create, data })
        } else {
          if (this.password !== '' && this.securityAnswer !== '') {
            data.user.password = this.password
            data.user.password_confirmation = this.passwordConfirm
            data.user.security_digest = encryptWithKey(this.password, this.securityAnswer)
            data.user.masterkey = encryptWithKey(sessionStorage.getItem('mk'), this.password)
          }
          res = await ajax({
            ...apiRoutes.users.update(this.user.id),
            data: data,
          })
        }

        if (res.status === 200) {
          this.$emit('submitSuccessful', res)
          if (newKeys) {
            this.globalStore.setShareKeys(newKeys)
          }
        } else {
          const data = res.data
          this.errors = data.errors
        }
      },
      async deleteSelf() {
        const answer = await this.$refs.confirmDeleteDialog.open()

        if (answer) {
          const res = await ajax({ ...apiRoutes.users.delete(answer) })
          if (res.status === 200) {
            await this.$refs.doneConfirmation.open({
              title: 'Profil erfolgreich gelöscht',
              message:
                'Ihr Profil wurde vollständig gelöscht. Nach dem Schließen dieses Dialoges werden Sie zur Startseite weitergeleitet.',
              hideCancelButton: true,
              okText: 'Ok',
              okIntent: 'outline-success',
            })
            location.replace('/')
            sessionStorage.clear()
          }
        }
      },
    },
  }
</script>
