<template>
  <div>
    <nav-bar />
    <router-view />
  </div>
</template>
<script>
  import NavBar from './shared/nav-bar.vue'
  import { RouterView } from 'vue-router'
  import { getCoreData } from '../utils/store'
  export default {
    name: 'RootApp',
    components: {
      NavBar,
      RouterView,
    },
    async beforeCreate() {
      const path = window.location.pathname
      if (path !== '/testen' && path !== '/testen_login') {
        await getCoreData()
      }
    },
  }
</script>
