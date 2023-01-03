<template>
  <b-container v-cloak fluid>
    <b-row class="mt-3"> </b-row>
    <b-tabs card pills>
      <b-tab title="Test-Export"></b-tab>
    </b-tabs>
    <tests-list :show-export="true" />
  </b-container>
</template>

<script>
  import TestsList from './components/tests-list.vue'
  export default {
    name: 'TestsExport',
    components: { TestsList },
  }
</script>
