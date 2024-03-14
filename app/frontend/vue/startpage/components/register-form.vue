<template>
  <b-form @submit="handleRegister">
    <input type="hidden" name="authenticity_token" :value="csrfToken" autocomplete="off" />
    <b-form-group label-cols="4" label="Email-Adresse" label-for="register-email">
      <b-form-input
        id="register-email"
        v-model="email"
        name="user[email]"
        @focus="errorMessage = ''" />
      <div v-if="errorMessage" class="invalid-feedback d-block">{{ errorMessage }}</div>
    </b-form-group>
    <b-form-group v-slot="{ ariaDescribedby }" label-cols="4" label="Ich bin...">
      <b-form-radio
        v-model="accountType"
        :aria-describedby="ariaDescribedby"
        name="user[account_type]"
        value="0">
        Lehrkraft
      </b-form-radio>
      <b-form-radio
        v-model="accountType"
        :aria-describedby="ariaDescribedby"
        name="user[account_type]"
        value="1">
        Forscher:in
      </b-form-radio>
      <b-form-radio
        v-model="accountType"
        :aria-describedby="ariaDescribedby"
        name="user[account_type]"
        value="2">
        Privatperson
      </b-form-radio>
    </b-form-group>
    <b-form-group label-cols="4" label="Aus...">
      <b-form-select v-model="state" variant="outline-secondary" :options="states" />
    </b-form-group>
    <b-form-checkbox
      v-model="acceptTerms"
      name="accept-terms"
      value="accepted"
      unchecked-value="not_accepted">
      Ich bin mit den
      <a href="#" data-toggle="modal" data-focus="false" data-target="#t_and_c">
        Nutzungsbedingungen
      </a>
      einverstanden
    </b-form-checkbox>
    <div class="d-flex justify-content-right mt-3">
      <b-button id="main-cancel" variant="outline-secondary" class="mr-2" @click="handleClose">
        Abbrechen
      </b-button>
      <b-button
        id="main-register"
        type="submit"
        :disabled="!acceptTerms || acceptTerms !== 'accepted'"
        variant="outline-success"
        @click="handleRegister">
        Registrieren
      </b-button>
    </div>
  </b-form>
</template>
<script>
  import { ajax } from '../../../utils/ajax'
  export default {
    name: 'RegisterForm',

    data() {
      return {
        acceptTerms: false,
        email: '',
        state: undefined,
        accountType: undefined,
        comment: '',
        errorMessage: '',
      }
    },
    computed: {
      csrfToken() {
        return document.getElementsByName('csrf-token')[0].getAttribute('content')
      },
      timestamp() {
        return sessionStorage.getItem('ts')
      },
      states() {
        return [
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
        ]
      },
    },
    methods: {
      handleClose() {
        this.$root.$emit('bv::hide::modal', 'register-modal')
      },
      async handleRegister(e) {
        console.log('meh', this.timestamp)

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
        console.log('maiu', res)

        switch (res.status) {
          case 200:
            break
          default:
            this.errorMessage = res.data.errors.join('\n\n')
        }
        //todo res auswerten und Feedback anzeigen
      },
    },
  }
</script>
