<template>
  <div>
    <b-form-group label="Passwort">
      <b-form-input
        v-model="passwordInput"
        autocomplete="new-password"
        type="password"
        :class="hasPasswordErrors && 'is-invalid'"
        :state="isPasswordValid"
        placeholder="Neues Passwort"
        @input="$emit('change-password', $event)"
      ></b-form-input>
      <small id="passwordHelp" class="form-text text-muted"
        >Passwort bleibt unverändert, wenn nichts eingegeben wird.</small
      >
    </b-form-group>
    <b-form-group>
      <b-form-input
        v-model="passwordConfirm"
        autocomplete="new-password"
        type="password"
        :class="hasPasswordErrors && 'is-invalid'"
        :state="isPasswordValid"
        placeholder="Neues Passwort bestätigen"
        @input="$emit('change-password-confirm', $event)"
      ></b-form-input>
      <div v-if="hasPasswordErrors || !isPasswordValid" class="invalid-feedback">
        Passwörter stimmen nicht überein!
      </div>
    </b-form-group>
    <b-form-group>
      <label>Sicherheitsfrage: In welcher Stadt wurden Sie geboren?</label>
      <b-form-input
        id=">security"
        v-model="securityAnswer"
        type="text"
        class="form-control"
        placeholder="Antwort"
        @input="$emit('change-security-answer', $event)"
      />
      <b-form-invalid-feedback :state="!hasSecurityQuestionErrors && !isSecurityHintVisible">
        Bitte geben Sie die Antwort bei einer Passwortänderung erneut ein!
      </b-form-invalid-feedback>
      <b-form-valid-feedback :state="!hasSecurityQuestionErrors && passwordInput === ''">
        <small id="securityHelp" class="form-text text-muted">
          Wenn Sie Ihr Passwort vergessen, können Sie es mit Hilfe der Antwort auf die
          Sicherheitsfrage wiederherstellen. Ihre Antwort wird nicht gespeichert, daher muss sie bei
          einer Passwortänderung erneut eingegeben werden!
        </small>
      </b-form-valid-feedback>
    </b-form-group>
  </div>
</template>

<script>
  export default {
    name: 'PasswordForm',
    props: {
      errors: Array,
    },
    data() {
      return {
        passwordInput: '',
        passwordConfirm: '',
        securityAnswer: '',
      }
    },
    computed: {
      hasPasswordErrors() {
        return Object.keys(this.errors).find(e => e === 'password') || false
      },
      isPasswordValid() {
        // returns null instead of boolean because this is expected for the bootstrap validation
        return this.passwordInput !== '' || this.passwordConfirm !== ''
          ? this.passwordInput === this.passwordConfirm
          : null
      },
      hasSecurityQuestionErrors() {
        return Object.keys(this.errors).find(e => e === 'security_digest')
      },
      isSecurityHintVisible() {
        return this.passwordInput !== '' && this.securityAnswer === ''
      },
    },
  }
</script>
