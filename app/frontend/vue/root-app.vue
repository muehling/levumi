<template>
  <div>
    <nav-bar />
    <router-view />
  </div>
</template>
<script>
  import NavBar from './shared/nav-bar.vue'
  import { RouterView } from 'vue-router'
  import { useGlobalStore } from '../store/store'
  export default {
    name: 'RootApp',
    components: {
      NavBar,
      RouterView,
    },
    setup() {
      const globalStore = useGlobalStore()
      return { globalStore }
    },
    async created() {
      const path = window.location.pathname
      if (path !== '/testen' && path !== '/testen_login') {
        await this.globalStore.fetch()
      }
    },
  }
</script>
