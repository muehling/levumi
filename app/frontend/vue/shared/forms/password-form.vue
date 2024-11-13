<template>
  <div>
    <b-card>
      <b-input-group label="Passwort">
        <b-form-input
          v-model="passwordInput"
          :class="hasPasswordErrors && 'is-invalid'"
          :state="isPasswordValid"
          :type="inputType"
          autocomplete="new-password"
          placeholder="Neues Passwort"
          @input="$emit('change-password', $event.target.value)" />
        <template #append>
          <BInputGroupText>
            <i :class="passwordIcon" @click="showPassword = !showPassword"></i>
          </BInputGroupText>
        </template>
      </b-input-group>
      <small id="passwordHelp" class="form-text text-muted">
        Bitte geben Sie ein neues Passwort ein.
      </small>
      <div class="mt-3">
        <b-input-group>
          <b-form-input
            v-model="passwordConfirm"
            autocomplete="new-password"
            :type="inputType"
            :class="hasPasswordErrors && 'is-invalid'"
            :state="isPasswordValid"
            placeholder="Neues Passwort bestätigen"
            @input="$emit('change-password-confirm', $event.target.value)" />
          <template #append>
            <BInputGroupText>
              <i :class="passwordIcon" @click="showPassword = !showPassword"></i>
            </BInputGroupText>
          </template>
        </b-input-group>
        <small id="confirmationHelp" class="form-text text-muted">
          Bitte geben Sie das neue Passwort erneut ein.
        </small>

        <div v-if="hasPasswordErrors || !isPasswordValid" class="text-danger text-small mt-2">
          Passwörter stimmen nicht überein!
        </div>
      </div>
      <div class="mt-3">
        <b-form-group>
          <label>Sicherheitsfrage: In welcher Stadt wurden Sie geboren?</label>
          <b-form-input
            id=">security"
            v-model="securityAnswer"
            type="text"
            class="form-control"
            placeholder="Antwort"
            @input="$emit('change-security-answer', $event.target.value)" />
          <b-form-invalid-feedback :state="!hasSecurityQuestionErrors && !isSecurityHintVisible">
            Bitte geben Sie die Antwort bei einer Passwortänderung erneut ein!
          </b-form-invalid-feedback>
          <b-form-valid-feedback :state="!hasSecurityQuestionErrors && passwordInput === ''">
            <small id="securityHelp" class="form-text text-muted">
              Wenn Sie Ihr Passwort vergessen, können Sie es mit Hilfe der Antwort auf die
              Sicherheitsfrage wiederherstellen. Ihre Antwort wird nicht gespeichert, daher muss sie
              bei einer Passwortänderung erneut eingegeben werden!
            </small>
          </b-form-valid-feedback>
        </b-form-group>
      </div>
    </b-card>
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
        showPassword: false,
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
      passwordIcon() {
        return this.showPassword ? 'fa fa-eye-slash' : 'fa fa-eye'
      },
      inputType() {
        return this.showPassword ? 'text' : 'password'
      },
    },
  }
</script>
