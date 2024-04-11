<template>
  <div class="d-flex flex-row justify-content-left logo-container py-4">
    <b-img
      class=""
      :src="require('../../../../assets/images/frontpage/cau-logo.png')"
      fluid
      alt="Logo der Christian-Albrechts-Universität Kiel" />
  </div>
</template>
<script>
  export default { name: 'StartPageUnis' }
</script>
<style>
  .logo-container {
    height: 6em;
    overflow: visible;
  }
</style>
