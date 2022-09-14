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

      <b-form-group>
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
        <div v-if="hasStateErrors" class="invalid-feedback">
          Bitte wählen Sie ein Bundesland aus!
        </div>
      </b-form-group>
      <b-form-group label-cols="4" label="Institution">
        <b-form-input id="institution-input" v-model="institution" />
      </b-form-group>
    </b-form>
    <div class="d-flex justify-content-end">
      <b-button class="m-1" @click="_close">Schließen</b-button>
      <b-button class="m-1" :disabled="isSubmitDisabled" @click="_handleSubmit">{{
        buttonText
      }}</b-button>
    </div>
  </b-container>
</template>

<script>
  import { ajax } from '../../../utils/ajax'
  import { encryptWithKey, recodeKeys } from '../../../utils/encryption'
  import { hasCapability } from '../../../utils/user'
  import { useGlobalStore } from '../../../store/store'
  import apiRoutes from '../../routes/api-routes'
  import PasswordForm from './password-form.vue'

  export default {
    name: 'UserForm',
    components: { PasswordForm },
    props: {
      isNew: Boolean,
      user: Object,
    },

    setup() {
      const globalStore = useGlobalStore()
      return { globalStore }
    },
    data() {
      return {
        // local state
        email: this.user.email,
        accountType: this.user.account_type,
        state: this.user.state,
        institution: this.user.institution,
        errors: [],
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

      // validation
      isSubmitDisabled() {
        return (
          this.password === '' ||
          this.password !== this.passwordConfirm ||
          this.securityAnswer === ''
        )
      },
    },

    // todo user und krams müssen als props reingegeben werden. machen wir schön morgen, jetzt gehen wir bücher und minis kaufen.
    methods: {
      open(data = {}) {
        this.$refs.editUserDialog.show()
        this.email = data.user.email || ''
        this.accountType = data.user.account_type
        this.state = data.user.state
        this.institution = data.user.institution
        this.securityAnswer = ''
      },
      _close() {
        this.$refs.editUserDialog.hide()
      },
      async _handleSubmit() {
        const data = {
          user: {
            email: this.email,
            account_type: this.accountType,
            state: this.state,
            institution: this.institution,
          },
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
            data.user.security_digest = encryptWithKey(this.securityAnswer, this.password)
          } else if (this.password === '' && this.securityAnswer !== '') {
            // only security question
            data.user.security_digest = encryptWithKey(
              sessionStorage.getItem('login'),
              this.securityAnswer
            )
          }
          res = await ajax({
            ...apiRoutes.users.update(this.user.id),
            data: data,
          })
        }
        if (res.status === 200) {
          sessionStorage.setItem('login', this.password)
          this.$emit('submitSuccessful')
          this.globalStore.setShareKeys(newKeys)
        } else {
          const data = await res.json()
          this.errors = data.errors
        }
      },
    },
  }
</script>
