<template>
  <b-container>
    <b-form @submit="_handleSubmit">
      <b-form-group label-cols="4" label="E-Mail-Adresse*">
        <b-form-input
          v-model="email"
          :class="hasEmailErrors && 'is-invalid'"
          :readonly="!canEditUser"
        />
        <div v-if="hasEmailErrors" class="invalid-feedback">{{ errors['email'].join('\n') }}</div>
      </b-form-group>
      <b-form-group v-if="canEditUser" label-cols="4" label="Typ" class="mt-3">
        <b-form-radio
          v-for="at in accountTypes"
          :key="at.id"
          v-model="accountType"
          :value="at.id"
          >{{ at.label }}</b-form-radio
        >
        <div v-if="hasAccountTypeErrors" class="invalid-feedback">
          Bitte wählen Sie einen Account-Typen aus!
        </div>
      </b-form-group>
      <b-form-group v-if="!canEditUser" label-cols="4" label="Typ">
        <b-form-input :value="accountTypeText" :readonly="true" />
      </b-form-group>
      <div v-if="!canEditUser" class="form-group row">
        <div class="col-sm-12">
          <small class="form-text text-muted"
            >Wenn Sie Ihre E-Mail Adresse oder Ihren Nutzertyp ändern möchten, wenden Sie sich bitte
            an uns.</small
          >
        </div>
      </div>

      <b-form-group v-if="isOwnProfile">
        <b-button v-b-toggle.password-section variant="outline-secondary">Passwort ändern</b-button>
        <b-collapse id="password-section" class="mt-2">
          <password-form
            :errors="errors"
            @change-password="pw => (password = pw)"
            @change-password-confirm="pw => (passwordConfirm = pw)"
            @change-security-answer="a => (securityAnswer = a)"
        /></b-collapse>
      </b-form-group>
      <b-form-group label-cols="4" label="Bundesland*">
        <b-form-select
          id="state-input"
          v-model="state"
          :class="hasStateErrors && 'is-invalid'"
          :options="stateOptions"
        />
      </b-form-group>
      <extra-data-form
        :account-type="accountType"
        :town="town"
        :school-type="schoolType"
        :focus-type="focusType"
        :institution="institution"
        @change-institution="inst => (institution = inst)"
        @change-town="t => (town = t)"
        @change-school-type="st => (schoolType = st)"
        @change-focus-type="ft => (focusType = ft)"
      >
      </extra-data-form>
      <div v-if="canEditSettingsJson">
        <b-button v-b-toggle.json-edit variant="outline-secondary">User-Config ändern</b-button>
        <b-collapse id="json-edit" class="mt-2">
          <b-form-textarea
            v-model="settings"
            placeholder="Enter something..."
            rows="3"
            max-rows="6"
          ></b-form-textarea>
        </b-collapse>
      </div>
    </b-form>
    <div class="d-flex justify-content-end">
      <b-button
        v-if="showDeleteButton && isOwnProfile"
        variant="danger"
        class="m-1"
        @click="deleteSelf"
        >Profil löschen</b-button
      >
      <b-button variant="outline-secondary" class="m-1" @click="_close">Schließen</b-button>
      <b-button
        variant="outline-success"
        class="m-1"
        :disabled="isSubmitDisabled"
        @click="_handleSubmit"
        >{{ buttonText }}</b-button
      >
    </div>
    <confirm-dialog ref="confirmDeleteDialog" />
    <confirm-dialog ref="doneConfirmation" />
  </b-container>
</template>

<script>
  import { ajax } from '../../../utils/ajax'
  import { encryptWithKey, recodeKeys } from '../../../utils/encryption'
  import { hasCapability, isAdmin } from '../../../utils/user'
  import { useGlobalStore } from '../../../store/store'
  import apiRoutes from '../../routes/api-routes'
  import ConfirmDialog from '../confirm-dialog.vue'
  import ExtraDataForm from './extra-data-form.vue'
  import isEmpty from 'lodash/isEmpty'
  import PasswordForm from './password-form.vue'

  export default {
    name: 'UserForm',
    components: { PasswordForm, ExtraDataForm, ConfirmDialog },
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
        settings: this.user.settings,
        state: this.user.state,
        town: this.user.town,
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
        return isAdmin(this.globalStore.login?.capabilities)
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

        let res
        let newKeys
        if (this.isNew) {
          res = await ajax({ ...apiRoutes.users.create, data })
        } else {
          if (this.password !== '' && this.securityAnswer !== '') {
            // Password and security question
            newKeys = recodeKeys(this.password)
            data.keys = JSON.stringify(newKeys)
            data.user.password = this.password
            data.user.password_confirmation = this.passwordConfirm
            data.user.security_digest = encryptWithKey(this.password, this.securityAnswer)
          }
          res = await ajax({
            ...apiRoutes.users.update(this.user.id),
            data: data,
          })
        }

        if (res.status === 200) {
          this.$emit('submitSuccessful', res)
          if (newKeys) {
            sessionStorage.setItem('login', this.password)
            this.globalStore.setShareKeys(newKeys)
          }
        } else {
          const data = await res.json()
          this.errors = data.errors
        }
      },
      async deleteSelf() {
        const answer = await this.$refs.confirmDeleteDialog.open({
          title: 'Profil löschen',
          message: `Mit dieser Aktion werden alle Daten des angemeldeten Benutzers gelöscht.
            Dies betrifft sowohl das Benutzerprofil wie auch alle bisher erfassten Schüler,
            Klassen und Messungen. Dieser Vorgang kann nicht rückgängig gemacht werden.`,
          okText: 'Ja, löschen',
          cancelText: 'Nein, abbrechen',
        })

        if (answer) {
          const res = await ajax({ ...apiRoutes.users.delete() })
          if (res.status === 200) {
            this.$root.$on('bv::modal::hide', () => {
              location.replace('/')
              sessionStorage.clear('login')
            })

            this.$refs.doneConfirmation.open({
              title: 'Profil erfolgreich gelöscht',
              message:
                'Ihr Profil wurde vollständig gelöscht. Nach dem Schließen dieses Dialoges werden Sie zur Startseite weitergeleitet.',
              hideCancelButton: true,
              okText: 'Ok',
              okIntent: 'outline-success',
            })
          }
        }
      },
    },
  }
</script>
