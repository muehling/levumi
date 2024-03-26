<template>
  <div class="h-100 main-container">
    <nav
      class="startpage-navbar navbar sticky-top navbar-light bg-light justify-content-between d-block d-sm-flex">
      <a v-if="isLoggedIn" href="/diagnostik">
        <img
          src="/images/shared/Levumi-normal_small.png"
          alt="Levumi - Startseite"
          width="48"
          height="48" />
        Levumi
      </a>
      <b-nav-item v-else class="navbar-brand d-block d-xs-inline" to="/">
        <img
          src="/images/shared/Levumi-normal_small.png"
          alt="Levumi - Startseite"
          width="48"
          height="48" />
        Levumi
      </b-nav-item>
      <a href="/testen" class="btn btn-outline-secondary">Zugang für Schülerinnen und Schüler</a>
      <div class="mt-2 mt-md-0">
        <div v-if="isLoggedIn">
          <a class="btn btn-outline-secondary" href="/diagnostik">{{ user }}</a>
        </div>
        <div v-else>
          <b-dropdown
            id="login"
            :menu-class="`login-dropdown${passwordMismatch ? ' show' : ''}`"
            :class="passwordMismatch ? 'show' : ''"
            variant="outline-secondary"
            text="Einloggen"
            right>
            <div>
              <b-form
                class="px-4 py-3 mx-3 mx-md-0 mw-100"
                action="/login"
                method="POST"
                @submit="login">
                <div class="form-group">
                  <input
                    type="hidden"
                    name="authenticity_token"
                    :value="csrfToken"
                    autocomplete="off" />
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
                <b-button type="submit" @click="login">Einloggen</b-button>
                <div v-if="passwordMismatch" class="mt-3">
                  <div class="dropdown-divider"></div>
                  <a href="/passwort">Passwort vergessen? Hier klicken!</a>
                </div>
              </b-form>
            </div>
          </b-dropdown>
        </div>
      </div>
    </nav>
    <div class="main-container startpage-container">
      <router-view :is-logged-in="isLoggedIn" />
    </div>
    <footer-bar />
  </div>
</template>

<script>
  import { RouterView } from 'vue-router'
  import RegisterModal from './components/register-modal.vue'
  import FooterBar from '../shared/footer-bar.vue'
  export default {
    name: 'StartpageApp',
    components: { RegisterModal, FooterBar, RouterView },
    props: { user: String, retry: String, initialTimeStamp: String },

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
      isLoggedIn() {
        return this.user !== 'none'
      },
      passwordMismatch() {
        return this.retry === 'true'
      },
    },
    watch: {},
    mounted() {
      sessionStorage.setItem('ts', this.initialTimeStamp)
    },
    methods: {
      login() {
        sessionStorage.setItem('login', this.password)
      },
    },
  }
</script>
