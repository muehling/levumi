<template>
  <div>
    <b-card>
      <b-form-group label="Neue E-Mail-Adresse">
        <b-form-input
          v-model="email"
          type="email"
          name="email"
          class="form-control"
          :disabled="isEmailSent"
          placeholder="E-Mail-Adresse"
          @focus="errorMessage = ''" />
        <span v-if="!!errorMessage" class="text-small text-danger">{{ errorMessage }}</span>
        <div>
          <b-button :disabled="isVerificationRequestDisabled" @click="sendCheckMail" class="mt-3">
            Einmalcode anfordern
          </b-button>
        </div>
      </b-form-group>
      <div v-if="isEmailSent">
        <div class="mt-3">
          <b-form-input
            v-model="verification_key"
            name="verification_key"
            class="form-control"
            placeholder="Einmalcode" />
          <small id="confirmationHelp" class="form-text text-muted">
            Bitte geben Sie den Einmalcode ein.
          </small>
          <b-button class="mt-3" variant="outline-success" @click="changeEmailAddress">
            E-Mail-Adresse ändern
          </b-button>
          <div v-if="wrongKey" class="text-danger text-small mt-2">
            {{ wrongKey }}
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
        verification_key: '',
        errorMessage: '',
        wrongKey: '',
      }
    },
    computed: {
      isVerificationRequestDisabled() {
        return !!this.errorMessage || this.isEmailSent
      },
    },
    methods: {
      async sendCheckMail() {
        this.isEmailSent = true
        const email = this.email
        if (!email || !email.includes('@')) {
          this.errorMessage = 'Bitte geben Sie eine gültige E-Mail-Adresse an'
          this.isEmailSent = false
          return
        } else {
          this.errorMessage = ''
        }
        const mail = await ajax({
          url: '/users/email_change_notification',
          method: 'POST',
          data: { user: { email } },
        })
        if (mail.status === 200) {
          this.errorMessage = ''
        } else if (mail.status === 403) {
          this.errorMessage =
            'Diese Mail ist bereits in Benutzung, bitte wählen Sie eine andere oder kontaktieren Sie uns.'
          this.isEmailSent = false
        } else {
          this.errorMessage =
            'Da ist etwas schiefgelaufen, bitte versuchen Sie es erneut oder kontaktieren Sie uns.'
          this.isEmailSent = false
        }
      },
      async changeEmailAddress() {
        const email = this.email
        const verification_key = this.verification_key
        const res = await ajax({
          url: '/users/change_user_email',
          method: 'POST',
          data: { user: { email, verification_key } },
        })

        if (res.status === 200) {
          this.wrongKey = ''
          this.globalStore.login = res.data
          this.$emit('user-email-changed', email)
        } else {
          this.wrongKey =
            'Dies ist leider der falschen Code, bitte geben Sie ihn erneut ein oder kontaktieren Sie uns.'
        }
      },
    },
  }
</script>
