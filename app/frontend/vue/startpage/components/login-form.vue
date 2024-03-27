<template>
  <div>
    <b-form class="px-4 py-3 mx-3 mx-md-0 mw-100" action="/login" method="POST" @submit="login">
      <div class="form-group">
        <input type="hidden" name="authenticity_token" :value="csrfToken" autocomplete="off" />
        <b-input
          id="login-email"
          type="email"
          name="email"
          aria-label="Email-Adresse eingeben"
          placeholder="E-Mail Adresse"
          :class="`form-control${passwordMismatch ? ' is-invalid' : ''}`" />
      </div>
      <div class="form-group">
        <b-input
          id="password"
          v-model="password"
          type="password"
          name="password"
          aria-label="Passwort eingeben"
          placeholder="Passwort"
          :class="`form-control${passwordMismatch ? ' is-invalid' : ''}`" />
        <div class="invalid-feedback">Benutzername oder Passwort ist falsch!</div>
      </div>
      <b-button type="submit" variant="success" @click="login">Einloggen</b-button>
      <div v-if="passwordMismatch" class="mt-3">
        <div class="dropdown-divider"></div>
        <a href="/passwort">Passwort vergessen? Hier klicken!</a>
      </div>
    </b-form>
  </div>
</template>
<script>
  export default {
    name: 'LoginForm',
    inject: ['passwordMismatch'],
    data() {
      return {
        password: '',
        userName: '',
      }
    },
    computed: {
      csrfToken() {
        return document.getElementsByName('csrf-token')[0].getAttribute('content')
      },
    },
    methods: {
      login() {
        sessionStorage.setItem('login', this.password)
      },
    },
  }
</script>
