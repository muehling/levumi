<template>
  <b-container>
    <b-row class="mt-3"></b-row>
    <b-tabs card pills>
      <b-tab title="Test-Metadaten" lazy>
        <tests-meta />
      </b-tab>
      <b-tab title="Anmerkungstypen" lazy>
        <annotation-categories ref="annotationCategoriesDialog" />
      </b-tab>
      <b-tab title="Testtypen" lazy>
        <test-types ref="testTypes" />
      </b-tab>
    </b-tabs>
  </b-container>
</template>
<script>
  import { useGlobalStore } from '../../store/store'
  import AnnotationCategories from './components/annotation-categories.vue'
  import TestTypes from './components/test-types.vue'
  import TestsMeta from './components/tests-meta.vue'
  export default {
    name: 'AdministrationApp',
    components: { AnnotationCategories, TestsMeta, TestTypes },
    setup() {
      const globalStore = useGlobalStore()
      return { globalStore }
    },
  }
</script>
