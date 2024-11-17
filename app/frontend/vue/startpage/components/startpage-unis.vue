<template>
  <div class="d-flex flex-row justify-content-left logo-container py-4">
    <img class="" :src="cauLogo" fluid alt="Logo der Christian-Albrechts-Universität Kiel" />
  </div>
</template>
<script>
  import cauLogoSrc from '../../../../assets/images/frontpage/cau-logo.png'
  export default {
    name: 'StartPageUnis',
    computed: {
      cauLogo() {
        return cauLogoSrc
      },
    },
  }
</script>
<style>
  .logo-container {
    height: 6em;
    overflow: visible;
  }
</style>
