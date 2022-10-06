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
  export default {
    name: 'RootApp',
    components: {
      NavBar,
      RouterView,
      AcceptTerms,
      CompleteRegistration,
      ErrorDialog,
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
      }
    },
  }
</script>
