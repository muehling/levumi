<template>
  <b-container v-cloak fluid>
    <b-row class="mt-3"> </b-row>
    <b-tabs card pills>
      <b-tab title="Testübersicht"></b-tab>
      <template #tabs-end>
        <b-nav-item role="presentation" @click="createTest"> Neuer Test </b-nav-item>
        <b-nav-item role="presentation" @click="createAnnotationCategory">
          Neuer Anmerkungstyp
        </b-nav-item>
      </template>
    </b-tabs>
    <tests-list :fetch-trigger="fetchTrigger" />
    <create-test-dialog ref="createTestDialog" @test-import:success="propagateFetch()" />
    <annotation-categories-dialog ref="annotationCategoriesDialog" />
  </b-container>
</template>

<script>
  import CreateTestDialog from './components/create-test-dialog.vue'
  import AnnotationCategoriesDialog from './components/annotation-categories-dialog.vue'
  import TestsList from './components/tests-list.vue'
  export default {
    name: 'TestsAdmin',
    components: { CreateTestDialog, TestsList, AnnotationCategoriesDialog },
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
