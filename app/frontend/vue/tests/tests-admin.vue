<template>
  <b-container v-cloak fluid>
    <b-row class="mt-3"> </b-row>
    <b-tabs card pills>
      <b-tab title="Testübersicht"> yay, liste </b-tab>
      <template #tabs-end>
        <b-nav-item role="presentation" @click="createTest"> Neuer Test </b-nav-item>
      </template>
    </b-tabs>
    <tests-list />
    <create-test-dialog ref="createTestDialog" />
  </b-container>
</template>

<script>
  import CreateTestDialog from './components/create-test-dialog.vue'
  import TestsList from './components/tests-list.vue'
  export default {
    name: 'TestsAdmin',
    components: { CreateTestDialog, TestsList },
    methods: {
      createTest() {
        this.$refs.createTestDialog.open()
      },
    },
  }
</script>
