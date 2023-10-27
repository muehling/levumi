<template>
  <b-tabs pills card>
    <b-tab v-if="isGeneralSuggestionsVisible" title="Allgemeine Empfehlungen" lazy>
      <support-general-suggestions :group-id="group.id" :test-id="testId" />
    </b-tab>
    <b-tab v-if="isAllSuggestionsVisible" title="Allgemeine Empfehlungen" lazy>
      <all-suggestions-for-test :group-id="group.id" :test-id="testId" />
    </b-tab>
    <b-tab v-if="isSupportSuggestionsVisible" title="Fördermaterialien" lazy>
      <support-group-suggestions :group="group" :test-id="testId" />
    </b-tab>
  </b-tabs>
</template>

<script>
  import { checkUserSettings } from '../../../utils/user'
  import { useAssessmentsStore } from '../../../store/assessmentsStore'
  import { useGlobalStore } from '../../../store/store'
  import SupportGeneralSuggestions from './support-general-suggestions.vue'
  import AllSuggestionsForTest from './all-suggestions-for-test.vue' //TODO rename 2 AllMaterialsForTest
  import SupportGroupSuggestions from './support-group-suggestions.vue'
  export default {
    name: 'SupportView',
    components: {
      SupportGeneralSuggestions,
      SupportGroupSuggestions,
      AllSuggestionsForTest,
    },
    props: {
      group: Object,
      testId: Number,
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
        // if there is no visibilities.supportView setting, display the standard tab
        if (!checkUserSettings(this.globalStore.login.settings, 'visibilities.supportView')) {
          return true
        } else {
          // otherwise use the setting
          return checkUserSettings(
            this.globalStore.login.settings,
            'visibilities.supportView.generalSuggestions'
          )
        }
      },
      isSupportSuggestionsVisible() {
        return (
          checkUserSettings(
            this.globalStore.login.settings,
            'visibilities.supportView.supportSuggestions'
          ) && this.hasItemDictionary
        )
      },
      isAllSuggestionsVisible() {
        return checkUserSettings(
          this.globalStore.login.settings,
          'visibilities.supportView.allSuggestionsForTest'
        )
      },
    },
    methods: {},
  }
</script>
