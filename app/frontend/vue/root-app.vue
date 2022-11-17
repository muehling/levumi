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
    <input-dialog ref="inputDialog" />
    <generic-message />
  </div>
  <div v-else>
    <accept-terms v-if="!areTermsAccepted" />
    <complete-registration v-else :account-type="accountType" />
  </div>
</template>
<script>
  import { RouterView } from 'vue-router'
  import { useGlobalStore } from '../store/store'
  import AcceptTerms from './registration/accept-terms.vue'
  import NavBar from './shared/nav-bar.vue'
  import CompleteRegistration from './registration/complete-registration.vue'
  import ErrorDialog from './shared/error-dialog.vue'
  import GenericMessage from './shared/generic-message.vue'
  import InputDialog from './shared/input-dialog.vue'
  import { ajax } from '../utils/ajax'
  import apiRoutes from './routes/api-routes'
  export default {
    name: 'RootApp',
    components: {
      NavBar,
      RouterView,
      AcceptTerms,
      CompleteRegistration,
      ErrorDialog,
      GenericMessage,
      InputDialog,
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
        await this.globalStore.fetch()
        // Check if login information is present. This may get lost in restored browser sessions,
        // or when a link is opened in a new tab. In this case, we need to log in again
        const login = sessionStorage.getItem('login')
        if (!login) {
          this.sendLogin('')
        }
      }
    },
    methods: {
      async sendLogin(text) {
        const pw = await this.$refs.inputDialog.open({
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
