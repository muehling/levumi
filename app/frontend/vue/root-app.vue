<template>
  <div v-if="isLoading" class="spinner">
    <div class="bounce1"></div>
    <div class="bounce2"></div>
    <div class="bounce3"></div>
  </div>

  <div v-else-if="isRegistrationComplete">
    <nav-bar />
    <router-view />
    <error-dialog />
    <input-dialog ref="renewLoginDialog">
      <div slot="extraContent" class="d-flex justify-content-between mb-4">
        <div class="d-inline-block">Sie sind nicht {{ globalStore.login.email }}?</div>
        <b-btn variant="outline-secondary" @click="logout">Logout</b-btn>
      </div>
    </input-dialog>
    <generic-message />
    <confirm-dialog ref="confirmDialog" />
  </div>
  <div v-else>
    <accept-terms v-if="!areTermsAccepted" />
    <complete-registration v-else :account-type="accountType" />
  </div>
</template>
<script>
  import { ajax } from '../utils/ajax'
  import { RouterView } from 'vue-router'
  import { useGlobalStore } from '../store/store'
  import AcceptTerms from './registration/accept-terms.vue'
  import apiRoutes from './routes/api-routes'
  import CompleteRegistration from './registration/complete-registration.vue'
  import ConfirmDialog from './shared/confirm-dialog.vue'
  import ErrorDialog from './shared/error-dialog.vue'
  import GenericMessage from './shared/generic-message.vue'
  import InputDialog from './shared/input-dialog.vue'
  import NavBar from './shared/nav-bar.vue'
  import router from './routes/frontend-routes'

  export default {
    name: 'RootApp',
    components: {
      AcceptTerms,
      CompleteRegistration,
      ConfirmDialog,
      ErrorDialog,
      GenericMessage,
      InputDialog,
      NavBar,
      RouterView,
    },
    setup() {
      const globalStore = useGlobalStore()
      return { globalStore }
    },
    computed: {
      isLoading() {
        return this.globalStore.isLoading
      },
      isRegistrationComplete() {
        return (
          !!this.globalStore.login &&
          this.globalStore.login.tc_accepted &&
          this.globalStore.login.intro_state > 2
        )
      },
      areTermsAccepted() {
        return this.globalStore.login && this.globalStore.login.tc_accepted
      },
      accountType() {
        return this.globalStore.login.account_type
      },
    },
    async created() {
      const path = window.location.pathname
      if (path !== '/testen' && path !== '/testen_login') {
        await this.globalStore.fetch(true)
        // Check if login information is present. This may get lost in restored browser sessions,
        // or when a link is opened in a new tab. In this case, we need to log in again
        const login = sessionStorage.getItem('login')
        if (!login) {
          if (!this.globalStore.masquerade) {
            this.sendLogin('')
          } else {
            // if a masqueraded session was active, tell the user and terminate the session.
            // TBD really tell the user?
            await this.$refs.confirmDialog.open({
              title: 'Sitzung beendet',
              message: 'Ihre letzte Sitzung als maskierter Nutzer wurde unerwartet beendet.',
              okText: 'Ok',
              hideCancelButton: true,
            })

            await ajax({ url: apiRoutes.users.logout, method: 'GET' })

            // page reload is necessary to flush the store and force the user the re-enter his password
            window.location.reload()
          }
        }
      }
    },
    methods: {
      async logout() {
        await ajax({ url: apiRoutes.users.logout, method: 'POST' })
        router.push('/')
        window.location.reload()
      },
      async sendLogin(text) {
        const pw = await this.$refs.renewLoginDialog.open({
          message: `${text}Bitten geben Sie Ihr Passwort erneut ein, um fortzufahren:`,
          okText: 'Ok',
          placeHolder: 'Passwort',
          title: 'Passwort erneut eingeben',
          type: 'password',
          disableClose: true,
        })
        const res = await ajax(
          apiRoutes.users.renewLogin({ email: this.globalStore.login.email, password: pw })
        )
        switch (res.status) {
          case 200:
            sessionStorage.setItem('login', pw)
            await this.globalStore.fetch()
            break
          case 404:
            this.sendLogin('Das hat leider nicht geklappt. ')
        }
      },
    },
  }
</script>
