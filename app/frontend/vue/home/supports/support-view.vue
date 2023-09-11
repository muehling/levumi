<template>
  <b-tabs pills card>
    <b-tab v-if="canSeeGeneral" title="Allgemeine Empfehlungen" lazy>
      <support-general-suggestions :group-id="group.id" :test="test" />
    </b-tab>
    <b-tab v-if="canSeeSuggestions" title="Förderung" lazy>
      <support-group-suggestions :group="group" :test="test" />
    </b-tab>
  </b-tabs>
</template>

<script>
  import { useAssessmentsStore } from '../../../store/assessmentsStore'
  import SupportGeneralSuggestions from './support-general-suggestions.vue'
  import SupportGroupSuggestions from './support-group-suggestions.vue'
  export default {
    name: 'SupportView',
    components: {
      SupportGeneralSuggestions,
      SupportGroupSuggestions,
    },
    props: {
      group: Object,
      test: Number,
    },
    setup() {
      const assessmentsStore = useAssessmentsStore()
      return { assessmentsStore }
    },
    data: function () {
      return {
        loading: true,
      }
    },
    computed: {
      hasItemDictionary() {
        return this.assessmentsStore.getCurrentAssessment()?.configuration.item_dimensions
      },
      canSeeGeneral() {
        return true
      },
      canSeeSuggestions() {
        return true
      },
    },
    methods: {},
  }
</script>
