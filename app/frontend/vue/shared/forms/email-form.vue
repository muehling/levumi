<template>
  <div>
    <b-card>
      <b-form-group>
        <p>
          Vor dem Ändern Ihrer E-Mail-Adresse senden wir Ihnen einen Einmalcode an die neue
          E-Mail-Adresse, um sicherzustellen, dass Sie Zugriff darauf haben.
        </p>
        <b-form-input
          v-model="email"
          type="email"
          name="email"
          class="form-control"
          :disabled="isEmailSent"
          placeholder="Neue E-Mail-Adresse eingeben"
          @focus="errorMessage = ''" />
        <span v-if="!!errorMessage" class="text-small text-danger">{{ errorMessage }}</span>

        <div>
          <b-button
            v-if="isCodeRequestButtonVisible"
            variant="outline-secondary"
            class="mt-3"
            @click="sendCheckMail">
            Einmalcode anfordern
          </b-button>
        </div>
      </b-form-group>
      <div v-if="isEmailSent">
        <div class="mt-3">
          <b-form-input
            v-model="verificationKey"
            name="verificationKey"
            class="form-control"
            placeholder="Einmalcode eingeben" />
          <small id="confirmationHelp" class="form-text text-muted">
            Bitte geben Sie den Einmalcode ein.
          </small>
          <div class="d-flex gap-2 w-100">
            <b-button
              class="mt-3 flex-grow-1"
              variant="outline-success"
              @click="changeEmailAddress">
              E-Mail-Adresse ändern
            </b-button>
            <b-button variant="outline-danger" class="mt-3 flex-grow-1" @click="resetEmailInput">
              Eingabe zurücksetzen
            </b-button>
          </div>
        </div>
      </div>
    </b-card>
  </div>
</template>

<script>
  import { useGlobalStore } from '../../../store/store'
  import { ajax } from '../../../utils/ajax'
  export default {
    name: 'EmailForm',
    setup() {
      const globalStore = useGlobalStore()
      return { globalStore }
    },
    data() {
      return {
        email: '',
        isEmailSent: false,
        verificationKey: '',
        errorMessage: '',
      }
    },
    computed: {
      isCodeRequestButtonVisible() {
        return !this.isEmailSent
      },
      isResetButtonVisible() {
        return this.isEmailSent
      },
    },
    methods: {
      async sendCheckMail() {
        this.isEmailSent = true
        if (!this.email || !this.email.includes('@') || this.email.includes(' ')) {
          this.errorMessage = 'Bitte geben Sie eine gültige E-Mail-Adresse an.'
          this.isEmailSent = false
          return
        } else {
          this.errorMessage = ''
        }
        const res = await ajax({
          url: '/users/email_change_notification',
          method: 'POST',
          data: { user: { email: this.email } },
        })
        if (res.status === 200) {
          this.errorMessage = ''
        } else if (res.status === 403) {
          this.errorMessage =
            'Diese E-Mail-Adresse wird bereits von einem anderen Nutzer verwendet!'
          this.isEmailSent = false
        } else {
          this.errorMessage =
            'Da ist etwas schiefgelaufen. Bitte versuchen Sie es erneut oder kontaktieren Sie uns.'
          this.isEmailSent = false
        }
      },
      resetEmailInput() {
        this.errorMessage = ''
        this.email = ''
        this.isEmailSent = false
      },
      async changeEmailAddress() {
        const email = this.email
        const res = await ajax({
          url: '/users/change_user_email',
          method: 'POST',
          data: { user: { email, verification_key: this.verificationKey } },
        })

        if (res.status === 200) {
          this.errorMessage = ''
          this.verificationKey = ''
          this.email = ''
          this.globalStore.login = res.data
          this.$emit('user-email-changed', email)
        } else {
          this.errorMessage =
            'Der eingegebene Code ist nicht korrekt. Bitte probieren Sie es erneut und achten auch auf Leerzeichen am Anfang oder Ende des Codes.'
        }
      },
    },
  }
</script>
