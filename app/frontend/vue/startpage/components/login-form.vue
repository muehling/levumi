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
          :class="`my-3 form-control${passwordMismatch ? ' is-invalid' : ''}`" />
        <div class="invalid-feedback">Benutzername oder Passwort ist falsch!</div>
      </div>
      <div class="d-flex submit-section">
        <b-button type="submit" variant="success" :disabled="isLoading" @click="login">
          Einloggen
        </b-button>
        <div v-if="isLoading" class="spinner ms-3 mt-2">
          <div class="bounce1 pt-2"></div>
          <div class="bounce2 pt-2"></div>
          <div class="bounce3 pt-2"></div>
        </div>
      </div>
      <div v-if="passwordMismatch && !registeredEmail" class="mt-3">
        <div class="dropdown-divider"></div>
        <a href="/passwort">Passwort vergessen? Hier klicken!</a>
      </div>
    </b-form>
  </div>
</template>
<script>
  import { decryptOrAddMasterkey } from 'src/utils/user'
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
        isLoading: false,
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
        this.isLoading = true

        const res = await ajax({
          ...apiRoutes.users.login,
          data: { email: this.email, password: this.password },
        })
        this.isLoading = false

        switch (res.status) {
          case 403:
            this.passwordMismatch = true
            break
          case 200:
            if (res.data.is_registered) {
              await decryptOrAddMasterkey(res, this.password)
            }
            window.location.replace('/diagnostik')
            break
          default:
            console.warn('unknown login response')
        }
      },
    },
  }
</script>
<style>
  .submit-section .spinner > div {
    background-color: #fff;
    border: 2px solid #5a598c;
  }
</style>
