<template>
  <div>
    <b-card>
      <b-input-group label="Email">
        <input
          v-model="email"
          type="email"
          name="email"
          class="form-control"
          placeholder="E-Mail-Adresse" 
          :disabled = "isEmailSend" />
      </b-input-group>
      <div v-if="txtForCorrectMail" id="email-invalid-feedback" d-block style="color: red">
        {{ txtForCorrectMail }}
        <b-button v-if="txtForCorrectMail" @click="newMailInput">E-Mail ändern</b-button>
      </div>
      
      <small class="form-text text-muted">
        Bitte geben Sie eine neue Mailadresse ein und fordern dann einen Einmalcode an.
      </small>
      <div>
        <b-button @click="sendCheckMail()">Einmalcode anfordern</b-button>
      </div>
        <div v-if="isEmailSend">
          <div class="mt-3">
            <input
              v-model="verification_key"
              name="verification_key"
              class="form-control"
              placeholder="Einmalcode" 
              :disabled="isKeyCorrect"/>
            <small id="confirmationHelp" class="form-text text-muted">
              Bitte geben Sie den Einmalcode ein.
            </small>
            <b-button :variant="isKeyCorrect ? 'success' : 'danger'" @click="validateVerificationKey()" >Einmalcode überprüfen</b-button>
            <div v-if="wrongKey" class="text-danger text-small mt-2">
              {{ wrongKey }}
            </div>
            <b-button v-if="isKeyCorrect" :variant="isMailNew ? 'success' : 'danger'" @click="changeMail()" >E-Mail-Adresse ändern</b-button>
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
        isEmailSend: false,
        verification_key: '',
        txtForCorrectMail: '',
        wrongKey: '',
        isKeyCorrect:false,
        isMailNew:false,
      }
    },
    computed: {},
    methods: {
      newMailInput(){
        this.isEmailSend = false
        this.txtForCorrectMail=''
      },
      async sendCheckMail() {
        this.isEmailSend = true
        const email = this.email
        if (!email || !email.includes('@')) {
          this.txtForCorrectMail = 'Bitte geben Sie eine gültige E-Mail-Adresse an'
          this.isEmailSend = false
          return
        } else {
          this.txtForCorrectMail = ''
        }
        const mail = await ajax({url:'/email_change_notification',
          method: 'POST',
          data:{ user: { email } }})
        if (mail.status === 200) {
          this.txtForCorrectMail = ''
        } else if (mail.status === 403) {
          this.txtForCorrectMail =
            'Diese Mail ist bereits in Benutzung, bitte wählen Sie eine andere oder kontaktieren Sie uns.'
            this.isEmailSend = false
        } else {
          this.txtForCorrectMail =
            'Da ist etwas schiefgelaufen, bitte versuchen Sie es erneut oder kontaktieren Sie uns.'
            this.isEmailSend = false
          return
        }
      },
      async validateVerificationKey() {
        const email = this.email
        const verification_key = this.verification_key
        const key = await ajax({url:'/email_verification_key_verification',
        method: 'POST',data:{user: { email, verification_key } }}) 
        if (key.status === 200) {
          this.isKeyCorrect = true
          this.wrongKey = ''
        } else {
          this.isKeyCorrect = false
          this.wrongKey =
            'Dies ist leider der falschen Code, bitte geben Sie ihn erneut ein oder kontaktieren Sie uns.'
        }
      },
      async changeMail(){
        const email = this.email
        const verification_key = this.verification_key
        const key = await ajax({url:'/email_verification_key_verification',
        method: 'POST',data:{user: { email, verification_key } }}) 
        if (key.status === 200) {
          this.isMailNew = true
          this.globalStore.login= key.data
          this.$emit("user-email-changed", email)
        } 
      }
    },
  }
</script>
