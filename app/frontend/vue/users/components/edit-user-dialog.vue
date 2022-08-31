<template>
  <b-modal id="edit-user-dialog" ref="editUserDialog" hide-footer>
    <template #modal-title>
      {{ title }}
    </template>
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
              >Wenn Sie Ihre E-Mail Adresse oder Ihren Nutzertyp ändern möchten, wenden Sie sich
              bitte an uns.</small
            >
          </div>
        </div>

        <b-form-group>
          <b-button v-b-toggle.password-section variant="outline-secondary"
            >Passwort ändern</b-button
          >
          <b-collapse id="password-section" class="mt-2">
            <b-card>
              <b-form-group label="Passwort">
                <b-form-input
                  v-model="password"
                  type="password"
                  :class="hasPasswordErrors && 'is-invalid'"
                  :state="isPasswordValid"
                  placeholder="Neues Passwort"
                ></b-form-input>
                <small id="passwordHelp" class="form-text text-muted"
                  >Passwort bleibt unverändert, wenn nichts eingegeben wird.</small
                >
              </b-form-group>
              <b-form-group>
                <b-form-input
                  v-model="passwordConfirm"
                  type="password"
                  :class="hasPasswordErrors && 'is-invalid'"
                  :state="isPasswordValid"
                  placeholder="Neues Passwort bestätigen"
                ></b-form-input>
                <div v-if="hasPasswordErrors || !isPasswordValid" class="invalid-feedback">
                  Passwörter stimmen nicht überein!
                </div>
              </b-form-group>
              <b-form-group>
                <label>In welcher Stadt wurden Sie geboren?</label>
                <b-form-input
                  id=">security"
                  v-model="securityAnswer"
                  type="text"
                  class="form-control"
                  placeholder="Antwort"
                />
                <b-form-invalid-feedback
                  :state="!hasSecurityQuestionErrors && !isSecurityHintVisible"
                >
                  Bitte geben Sie die Antwort bei einer Passwortänderung erneut ein!
                </b-form-invalid-feedback>
                <b-form-valid-feedback :state="!hasSecurityQuestionErrors && password === ''">
                  <small id="securityHelp" class="form-text text-muted">
                    Wenn Sie Ihr Passwort vergessen, können Sie es mit Hilfe der Antwort auf die
                    Sicherheitsfrage wiederherstellen. Ihre Antwort wird nicht gespeichert, daher
                    muss sie bei einer Passwortänderung erneut eingegeben werden!
                  </small>
                </b-form-valid-feedback>
              </b-form-group>
            </b-card>
          </b-collapse>
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
    </b-container>
    <div class="d-flex justify-content-end">
      <b-button class="m-1" @click="_close">Schließen</b-button>
      <b-button class="m-1" :disabled="isSubmitDisabled" @click="_handleSubmit">{{
        buttonText
      }}</b-button>
    </div>
  </b-modal>
</template>

<script>
  import { ajax } from '../../../utils/ajax'
  import { hasCapability } from '../../../utils/user'
  import apiRoutes from '../../../utils/routes'
  export default {
    name: 'EditUserDialog',

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
        title: '',
        password: '',
        passwordConfirm: '',
        securityAnswer: '',

        // parent data
        states: this.$root.states,
        accountTypes: this.$root.accountTypes,
        stateOptions: this.$root.states.map(s => ({ value: s.id, text: s.label })),
        login: this.$root.login,
      }
    },
    computed: {
      canEditUser() {
        return hasCapability('user', this.$root.login?.capabilities)
      },
      accountTypeText() {
        return this.accountTypes.find(at => at.id === this.accountType)?.label
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
        return this.password !== '' || this.passwordConfirm !== ''
          ? this.password === this.passwordConfirm
          : null
      },
      isSecurityHintVisible() {
        return this.password !== '' && this.securityAnswer === ''
      },
      isSubmitDisabled() {
        return this.isPasswordValid && (this.isPasswordValid ? this.securityAnswer === '' : false)
      },
    },
    methods: {
      open(data = {}) {
        this.$refs.editUserDialog.show()
        this.user = data.user
        this.email = data.user.email || ''
        this.accountType = data.user.account_type
        this.state = data.user.state
        this.institution = data.user.institution
        this.isNew = data.isNew
        this.title = data.isNew ? 'Benutzer anlegen' : 'Benutzer bearbeiten'
        this.securityAnswer = ''
      },
      _close() {
        this.$refs.editUserDialog.hide()
        this.user = undefined
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

        const formData = data.user

        let res
        if (this.isNew) {
          res = await ajax({ ...apiRoutes.users.create, data })
        } else {
          if (this.password !== '' && this.securityAnswer !== '') {
            // Password and security question
            recode_keys(this.password)
            data.keys = JSON.stringify(keys)
            formData.password = this.password
            formData.password_confirmation = this.passwordConfirm
            formData.security_digest = sjcl.encrypt(this.securityAnswer, this.password)
          } else if (this.password === '' && this.securityAnswer !== '') {
            // only security question
            formData.security_digest = sjcl.encrypt(
              this.securityAnswer,
              sessionStorage.getItem('login')
            )
          }

          res = await ajax({
            ...apiRoutes.users.update(this.user.id),
            data: data,
          })
        }
        if (res.status === 200) {
          this.user = undefined
          this.$refs.editUserDialog.hide()
          this.$emit('refetch')
        } else {
          const data = await res.json()
          this.errors = data.errors
        }
      },
    },
  }
</script>
