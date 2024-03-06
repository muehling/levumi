<template>
  <div class="h-100 main-container">
    <nav class="navbar sticky-top navbar-light bg-light justify-content-between d-block d-sm-flex">
      <a class="navbar-brand d-block d-xs-inline" href="/">
        <img
          src="/images/shared/Levumi-normal_small.png"
          alt="Levumi - Startseite"
          width="48"
          height="48" />
        Levumi
      </a>
      <a href="/testen" class="btn btn-outline-secondary">Zugang für Schülerinnen und Schüler</a>
      <div class="mt-2 mt-md-0">
        <div v-if="isLoggedIn">
          <a class="btn btn-outline-secondary" href="/diagnostik">{{ user }}</a>
        </div>
        <div v-else>
          <register-modal :timestamp="initialTimeStamp" />

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
    <startpage-nav />
    <b-container class="main-container">
      <router-view />
    </b-container>
    <footer-bar />
  </div>
</template>

<script>
  import { RouterView } from 'vue-router'
  import RegisterModal from './components/register-modal.vue'
  import FooterBar from '../shared/footer-bar.vue'
  import StartpageNav from './components/startpage-nav.vue'
  export default {
    name: 'StartpageApp',
    components: { RegisterModal, FooterBar, StartpageNav, RouterView },
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
    mounted() {},
    methods: {
      login() {
        sessionStorage.setItem('login', this.password)
      },
    },
  }
</script>
<style>
  .login-dropdown {
    width: 26em;
  }
  .register-dropdown {
    width: 36em;
  }
  .main-container {
    margin-bottom: 4em;
  }
</style>
