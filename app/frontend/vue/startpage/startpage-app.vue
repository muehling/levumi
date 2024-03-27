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
            ref="loginDropdown"
            menu-class="login-dropdown"
            variant="outline-secondary"
            text="Einloggen"
            right>
            <login-form />
          </b-dropdown>
        </div>
      </div>
    </nav>
    <div class="main-container startpage-container" @click="handleCloseLogin">
      <router-view :is-logged-in="isLoggedIn" />
    </div>
    <footer-bar />
  </div>
</template>

<script>
  import { RouterView } from 'vue-router'
  import FooterBar from '../shared/footer-bar.vue'
  import LoginForm from './components/login-form.vue'
  import { useGlobalStore } from '../../store/store'
  export default {
    name: 'StartpageApp',
    components: { FooterBar, RouterView, LoginForm },
    provide() {
      return {
        passwordMismatch: this.passwordMismatch,
      }
    },
    props: { user: String, retry: String, initialTimeStamp: String },
    setup() {
      const globalStore = useGlobalStore()
      return { globalStore }
    },
    computed: {
      isLoggedIn() {
        return this.user !== 'none'
      },
      passwordMismatch() {
        return this.retry === 'true'
      },
      isLoginOpen() {
        return this.globalStore.isLoginOpen
      },
    },
    watch: {
      isLoginOpen() {
        if (this.$refs.loginDropdown && this.isLoginOpen === true) {
          this.$refs.loginDropdown.show()
        }
      },
    },
    mounted() {
      sessionStorage.setItem('ts', this.initialTimeStamp)
      if (this.$refs.loginDropdown && this.passwordMismatch === true) {
        this.$refs.loginDropdown.show()
      }
    },
    methods: {
      handleCloseLogin() {
        this.globalStore.isLoginOpen = false
      },
    },
  }
</script>
