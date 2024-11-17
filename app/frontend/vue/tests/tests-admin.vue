<template>
  <b-container fluid>
    <b-card title="Testverwaltung">
      <b-button @click="createTest" variant="primary">Test hochladen</b-button>
      <tests-list :fetch-trigger="fetchTrigger" />
      <create-test-dialog ref="createTestDialog" @test-import:success="propagateFetch()" />
    </b-card>
  </b-container>
</template>

<script>
  import CreateTestDialog from './components/create-test-dialog.vue'

  import TestsList from './components/tests-list.vue'
  export default {
    name: 'TestsAdmin',
    components: { CreateTestDialog, TestsList },
    data() {
      return { fetchTrigger: Symbol() }
    },
    methods: {
      createTest() {
        this.$refs.createTestDialog.open()
      },
      createAnnotationCategory() {
        this.$refs.annotationCategoriesDialog.open()
      },
      propagateFetch() {
        this.fetchTrigger = Symbol()
      },
    },
  }
</script>
