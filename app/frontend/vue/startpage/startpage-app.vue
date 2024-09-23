<template>
  <div class="h-100 main-container">
    <nav
      class="startpage-navbar navbar sticky-top navbar-light bg-light justify-content-between d-block d-sm-flex">
      <div class="container-fluid m-3">
        <a v-if="isLoggedIn" href="/diagnostik">
          <img :src="levumiSmall" alt="Levumi - Startseite" width="48" height="48" />
          Levumi
        </a>
        <b-nav-item v-else class="navbar-brand d-block d-xs-inline" to="/">
          <img :src="levumiSmall" alt="Levumi - Startseite" width="48" height="48" />
          Levumi
          <b-alert v-if="!!systemMessage" class="ms-auto mb-0 d-inline" show variant="danger">
            {{ systemMessage }}
          </b-alert>
        </b-nav-item>
        <a href="/testen" class="btn btn-outline-secondary">Zugang für Schülerinnen und Schüler</a>
        <div class="mt-2 mt-md-0">
          <div v-if="isLoggedIn">
            <a class="btn btn-outline-secondary" href="/diagnostik">{{ user }}</a>
          </div>
          <div v-else>
            <b-dropdown
              id="login"
              auto-close="false"
              menu-class="login-dropdown"
              variant="outline-secondary"
              text="Einloggen"
              right>
              <div class="px-4 py-3 mx-3">
                <login-form />
              </div>
            </b-dropdown>
          </div>
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
  import FooterBar from '../shared/footer-bar.vue'
  import LoginForm from './components/login-form.vue'
  import levumiSmallSrc from '../../../assets/images/shared/Levumi-normal_small.png'

  export default {
    name: 'StartpageApp',
    components: { FooterBar, RouterView, LoginForm },
    provide() {
      return {
        passwordMismatch: this.passwordMismatch,
      }
    },
    props: { user: String, retry: String, initialTimeStamp: String },
    data() {
      return { showLogin: false }
    },
    computed: {
      isLoggedIn() {
        return this.user !== 'none'
      },
      passwordMismatch() {
        return this.retry === 'true'
      },
      systemMessage() {
        switch (this.$root.mode) {
          case 'staging':
            return 'TEST-SYSTEM'
          case 'development':
            return 'DEV'
          default:
            return ''
        }
      },
      levumiSmall() {
        return levumiSmallSrc
      },
    },
    mounted() {
      sessionStorage.setItem('ts', this.initialTimeStamp)
    },
  }
</script>
