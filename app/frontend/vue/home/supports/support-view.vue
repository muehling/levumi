<template>
  <b-tabs pills card>
    <b-tab v-if="isGeneralSuggestionsVisible" title="Allgemeine Empfehlungen" lazy>
      <support-general-suggestions :group-id="group.id" :test="test" />
    </b-tab>
    <b-tab v-if="isSupportSuggestionsVisible" title="Förderung" lazy>
      <support-group-suggestions :group="group" :test="test" />
    </b-tab>
  </b-tabs>
</template>

<script>
  import { checkUserSettings } from '../../../utils/user'
  import { useAssessmentsStore } from '../../../store/assessmentsStore'
  import { useGlobalStore } from '../../../store/store'
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
      const globalStore = useGlobalStore()
      return { assessmentsStore, globalStore }
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
      isGeneralSuggestionsVisible() {
        return checkUserSettings(
          this.globalStore.login.settings,
          'visibilities.supportView.generalSuggestions'
        )
      },
      isSupportSuggestionsVisible() {
        return checkUserSettings(
          this.globalStore.login.settings,
          'visibilities.supportView.supportSuggestions'
        )
      },
    },
    methods: {},
  }
</script>
