<template>
  <div>
    <b-form class="mx-md-0 mw-100" @submit="login">
      <div class="form-group">
        <b-input
          id="login-email"
          v-model="email"
          type="email"
          name="email"
          :disabled="!!registeredEmail"
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
      <div v-if="passwordMismatch && !registeredEmail" class="mt-3">
        <div class="dropdown-divider"></div>
        <a href="/passwort">Passwort vergessen? Hier klicken!</a>
      </div>
    </b-form>
  </div>
</template>
<script>
  import { ajax } from '../../../utils/ajax'
  import apiRoutes from '../../routes/api-routes'

  export default {
    name: 'LoginForm',
    props: { registeredEmail: String },
    data() {
      return {
        password: '',
        email: '',
        passwordMismatch: false,
      }
    },
    mounted() {
      if (this.registeredEmail) {
        this.email = this.registeredEmail
      }
    },
    methods: {
      async login(e) {
        e.preventDefault()
        e.stopPropagation()
        const res = await ajax({
          ...apiRoutes.users.login,
          data: { email: this.email, password: this.password },
        })
        switch (res.status) {
          case 403:
            this.passwordMismatch = true
            break
          default:
            sessionStorage.setItem('login', this.password)
            this.$router.push('/diagnostik')
            window.location.reload() // necessary to load the full Levumi app
        }
      },
    },
  }
</script>
