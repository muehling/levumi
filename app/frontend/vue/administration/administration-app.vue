<template>
  <b-container v-cloak fluid>
    <b-row class="mt-3"> </b-row>
    <b-tabs card pills>
      <b-tab title="Testübersicht">
        <p>hallo welt</p>
      </b-tab>
      <b-tab title="Anmerkungstypen">
        <annotation-categories-dialog ref="annotationCategoriesDialog" />
      </b-tab>
    </b-tabs>
  </b-container>
</template>
<script>
  import { useGlobalStore } from '../../store/store'
  import AnnotationCategoriesDialog from './components/annotation-categories-dialog.vue'
  export default {
    name: 'AdministrationApp',
    components: { AnnotationCategoriesDialog },
    setup() {
      const globalStore = useGlobalStore()
      return { globalStore }
    },
  }
</script>
