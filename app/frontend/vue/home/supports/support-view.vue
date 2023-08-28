<template>
  <b-tabs pills card>
    <b-tab title="Allgemeine Empfehlungen" lazy>
      <support-general-suggestions :group-id="group.id" :test="test" />
    </b-tab>
    <b-tab title="Übersicht" lazy>
      <support-group-overview :group="group" :test="test" />
    </b-tab>
    <b-tab v-if="hasItemDictionary" title="Qualitative Auswertung" lazy>
      <support-group-qualitative :group="group" :test="test" />
    </b-tab>
    <b-tab title="Förderung" lazy>
      <support-group-suggestions :group="group" :test="test" />
    </b-tab>
  </b-tabs>
</template>

<script>
  import { useAssessmentsStore } from '../../../store/assessmentsStore'
  import SupportGeneralSuggestions from './support-general-suggestions.vue'
  import SupportGroupOverview from './support-group-overview.vue'
  import SupportGroupQualitative from './support-group-qualitative.vue'
  import SupportGroupSuggestions from './support-group-suggestions.vue'
  export default {
    name: 'SupportView',
    components: {
      SupportGeneralSuggestions,
      SupportGroupOverview,
      SupportGroupQualitative,
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
        console.log(this.assessmentsStore.getCurrentAssessment()?.configuration.item_dimensions)
        return this.assessmentsStore.getCurrentAssessment()?.configuration.item_dimensions
      },
    },
    methods: {},
  }
</script>
