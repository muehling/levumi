<template>
  <b-container v-cloak fluid>
    <b-row class="mt-3"> </b-row>
    <b-tabs card pills>
      <b-tab v-if="false" title="Test-Metadaten">
        <p>todo</p>
      </b-tab>
      <b-tab title="Anmerkungstypen">
        <annotation-categories ref="annotationCategoriesDialog" />
      </b-tab>
    </b-tabs>
  </b-container>
</template>
<script>
  import { useGlobalStore } from '../../store/store'
  import AnnotationCategories from './components/annotation-categories.vue'
  export default {
    name: 'AdministrationApp',
    components: { AnnotationCategories },
    setup() {
      const globalStore = useGlobalStore()
      return { globalStore }
    },
  }
</script>
