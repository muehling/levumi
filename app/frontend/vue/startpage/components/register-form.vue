<template>
  <b-card class="shadow" body-class="info-card">
    <div v-if="registrationSuccessful">
      <h4>Vielen Dank für Ihre Registrierung!</h4>
      <hr />
      <p>Wir haben Ihnen Ihre Zugangsdaten per E-Mail geschickt.</p>
      <p>Bitte loggen Sie sich ein, um die Registrierung abzuschließen.</p>
      <div class="p-0 m-0">
        <login-form :registered-email="email" />
      </div>
    </div>
    <div v-else>
      <p class="text-bold text-left">
        Interessiert? Dann einfach einen
        <strong>kostenfreien Zugang anlegen!</strong>
      </p>
      <hr />
      <b-form @submit="handleRegister">
        <BFormGroup label-class="text-small mb-0" label="Email-Adresse" label-for="register-email">
          <BFormInput
            id="register-email"
            v-model="email"
            placeholder="E-Mail-Adresse"
            type="email" />
          <div v-if="errorMessage" class="invalid-feedback d-block">{{ errorMessage }}</div>
        </BFormGroup>
        <hr class="mt-0 d-none" />
        <BFormGroup label-class="text-small mt-3 mb-0" label="Ich bin...">
          <b-form-radio v-model="accountType" inline name="user[account_type]" value="0">
            Lehrkraft
          </b-form-radio>
          <b-form-radio v-model="accountType" inline name="user[account_type]" value="1">
            Forscher:in
          </b-form-radio>
          <b-form-radio v-model="accountType" inline name="user[account_type]" value="2">
            Privatperson
          </b-form-radio>
        </BFormGroup>
        <hr class="mt-0 d-none" />
        <BFormGroup label-class="text-small mt-3 mb-0" label="Aus...">
          <b-form-select
            v-model="state"
            class="mb-3"
            variant="outline-secondary"
            :options="states" />
        </BFormGroup>
        <hr class="m-0 d-none" />
        <b-form-checkbox
          v-model="acceptTerms"
          class=""
          name="accept-terms"
          value="accepted"
          unchecked-value="not_accepted">
          Ich bin mit den
          <a href="#" data-toggle="modal" data-focus="false" data-target="#t_and_c">
            Nutzungsbedingungen
          </a>
          einverstanden
        </b-form-checkbox>
        <hr />
        <div class="d-flex justify-content-right mt-3">
          <b-button
            id="main-register"
            type="submit"
            :disabled="isSubmitDisabled"
            variant="success"
            @click="handleRegister">
            Registrieren
          </b-button>
        </div>
      </b-form>
    </div>
  </b-card>
</template>
<script>
  import { ajax } from '../../../utils/ajax'
  import LoginForm from './login-form.vue'
  export default {
    name: 'RegisterForm',
    components: { LoginForm },
    props: { openModal: Boolean },

    data() {
      return {
        acceptTerms: false,
        email: '',
        state: null,
        accountType: undefined,
        comment: '',
        errorMessage: '',
        registrationSuccessful: undefined,
        states: [
          { text: 'Bundesland auswählen', value: null, disabled: true },
          { text: 'Baden-Württemberg', value: 1 },
          { text: 'Bayern', value: 2 },
          { text: 'Berlin', value: 3 },
          { text: 'Brandenburg', value: 4 },
          { text: 'Bremen', value: 5 },
          { text: 'Hamburg', value: 6 },
          { text: 'Hessen', value: 7 },
          { text: 'Mecklenburg-Vorpommern', value: 8 },
          { text: 'Niedersachsen', value: 9 },
          { text: 'Nordrhein-Westfalen', value: 10 },
          { text: 'Rheinland-Pfalz', value: 11 },
          { text: 'Saarland', value: 12 },
          { text: 'Sachsen', value: 13 },
          { text: 'Sachsen-Anhalt', value: 14 },
          { text: 'Schleswig-Holstein', value: 15 },
          { text: 'Thüringen', value: 16 },
          { text: 'Österreich', value: 17 },
          { text: 'Schweiz', value: 18 },
          { text: 'Anderes Land', value: 19 },
        ],
      }
    },
    computed: {
      isSubmitDisabled() {
        return (
          !this.acceptTerms ||
          this.acceptTerms !== 'accepted' ||
          this.email === '' ||
          !this.state ||
          this.accountType === undefined
        )
      },
      timestamp() {
        return sessionStorage.getItem('ts')
      },
    },
    methods: {
      handleClose() {
        this.$root.$emit('bv::hide::modal', 'register-modal')
      },
      async handleRegister(e) {
        e.preventDefault()
        e.stopPropagation()
        const data = {
          user: {
            email: this.email.trim(),
            state: this.state,
            account_type: this.accountType,
            timestamp: new Date().toISOString(),
            render_timestamp: this.timestamp,
            comment: this.comment,
          },
        }

        const res = await ajax({ url: '/users', method: 'POST', data: data })

        switch (res.status) {
          case 200:
            this.registrationSuccessful = true
            this.state = null
            this.accountType = undefined
            this.acceptTerms = false
            break
          default:
            this.errorMessage = res.data.errors.join('\n\n')
        }
      },
    },
  }
</script>
