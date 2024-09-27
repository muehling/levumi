<template>
  <loading-dots v-if="isLoading" :is-loading="isLoading" />
  <b-card v-else no-body class="mt-3 pb-0 mb-1">
    <div class="card-header">
      <b-nav pills>
        <b-nav-item class="cursor-default ms-0" link-class="ps-2">
          <span class="font-weight-bold">{{ currentArea?.name || '' }}</span>
        </b-nav-item>
        <i class="fas fa-arrow-right mt-2 meta-arrow"></i>
        <b-nav-item :id="group.id + '_test_type_' + currentTestType?.id" class="cursor-default">
          <span class="font-weight-bold">{{ currentTestType?.name || '' }}</span>
        </b-nav-item>
        <i class="fas fa-arrow-right mt-2 meta-arrow"></i>
        <b-nav-item :id="group.id + '_competence_' + currentCompetence?.id" class="cursor-default">
          <span class="font-weight-bold">{{ currentCompetence?.name || '' }}</span>
        </b-nav-item>
        <i class="fas fa-arrow-right mt-2 meta-arrow"></i>
        <b-nav-item :id="group.id + '_family_' + currentFamily?.id" class="cursor-default">
          <span class="font-weight-bold">{{ currentFamily?.name || '' }}</span>
        </b-nav-item>
        <i class="fas fa-arrow-right mt-2 meta-arrow"></i>
        <b-nav-item :id="group.id + '_test_' + currentTest?.id" active class="ms-3 cursor-default">
          <span class="font-weight-bold">{{ currentTest?.level || '' }}</span>
        </b-nav-item>
      </b-nav>
      <b-nav
        v-if="versions.length > 1 || (versions.length === 1 && versions[0].info.archive === true)"
        pills
        class="mt-1">
        <!-- Alle Versionen der gewählten Niveaustufe, falls vorhanden -->
        <b-nav-item
          v-for="version in versions"
          :id="group.id + '_version_' + version.info.id"
          :key="version.info.id"
          :active="version.info.id === versionSelected"
          lazy
          @click="handleClickVersion(version)">
          <span :class="version.used ? 'font-weight-bold' : ''">{{ version.info.label }}</span>
        </b-nav-item>
      </b-nav>
    </div>
    <b-tabs v-if="!isLoading" pills card nav-item-class="py-1">
      <b-tab :active="!hasResults" class="m-3">
        <template #title>
          <div>
            Messungen ({{ test.shorthand }})
            <span v-if="!isActive && test.student_test" class=" ">
              <i class="fas fa-pause ms-2 me-3"></i>
            </span>
            <span v-if="isActive && test.student_test" class="">
              <i class="fas fa-play ms-2 me-3"></i>
            </span>
          </div>
        </template>
        <!-- Neue Messungen -->
        <assessment-results
          :test="test"
          :group="group"
          :weeks="weeks"
          :results="results"
          :assessment="assessment" />
      </b-tab>

      <!-- Auswertungstab mit Graph -->
      <b-tab
        title="Auswertung"
        :active="hasResults"
        class="m-3"
        :disabled="weeks.length == 0 || assessmentData.configuration.views.length == 0">
        <analysis-view :key="test.id" :group="group" />
      </b-tab>

      <!-- Vorschläge für Fördermaterial -->
      <b-tab title="Fördern">
        <support-view :group="group" :test-id="test.id"></support-view>
      </b-tab>

      <!-- Testinfos darstellen -->
      <b-tab title="Testinfos">
        <div v-html="test.description.full"></div>
      </b-tab>
    </b-tabs>
  </b-card>
</template>

<script>
  import { isAdmin } from '../../utils/user'
  import { useAssessmentsStore } from '../../store/assessmentsStore'
  import { useGlobalStore } from '../../store/store'
  import AnalysisView from './analysis/analysis-view.vue'
  import AssessmentResults from './assessment-results.vue'
  import compact from 'lodash/compact'
  import LoadingDots from '../shared/loading-dots.vue'
  import SupportView from './supports/support-view.vue'
  import uniq from 'lodash/uniq'

  export default {
    name: 'AssessmentDetails',
    components: {
      AnalysisView,
      LoadingDots,
      SupportView,
      AssessmentResults,
    },

    props: {
      group: Object,
    },
    setup() {
      const globalStore = useGlobalStore()
      const assessmentsStore = useAssessmentsStore()
      return { globalStore, assessmentsStore }
    },

    computed: {
      assessmentData() {
        return this.assessmentsStore.getCurrentAssessment()
      },
      allAssessments() {
        return this.assessmentsStore.assessments[this.group.id]
      },
      currentArea() {
        return this.testMetaData.areas.find(area => area.id === this.assessmentData?.test?.area_id)
      },
      currentTestType() {
        return (
          this.testMetaData.test_types.find(
            testType => testType.id === this.assessmentData?.test?.test_type_id
          ) || this.testMetaData.test_types[0]
        )
      },
      currentCompetence() {
        return this.testMetaData.competences.find(
          competence => competence.id === this.assessmentData?.test?.competence_id
        )
      },
      currentFamily() {
        return this.testMetaData.test_families.find(
          family => family.id === this.assessmentData?.test?.test_family_id
        )
      },
      testMetaData: function () {
        return this.globalStore.staticData.testMetaData
      },
      currentTest() {
        return this.assessmentData?.test
      },
      versionSelected() {
        return this.currentTest?.id
      },

      hasResults() {
        return !!this.results?.length || false
      },
      isLoading() {
        return this.assessmentsStore.isLoading || !this.assessment
      },
      assessment() {
        return this.assessmentsStore.currentAssessment
      },
      test() {
        return this.assessmentsStore.currentAssessment?.test
      },
      results() {
        return this.assessmentsStore.currentAssessment?.series
      },

      weeks() {
        return compact(uniq(this.results?.map(w => w.test_week)))
      },
      isActive() {
        // const assessments = this.assessmentsStore.assessments[this.group.id]
        // return assessments?.find(a => a.test_id === this.test.id)?.active
        return this.assessmentsStore.currentAssessment.active
      },
      isAllowed() {
        return (
          this.globalStore.login.is_masquerading === null ||
          (!!this.globalStore.login.is_masquerading && !this.group.read_only) ||
          isAdmin()
        )
      },
      versions() {
        const test = this.testMetaData.tests.find(test => test.id === this.currentTest?.id)

        const tests = this.testMetaData.tests.filter(
          version => version.shorthand === test?.shorthand
        )
        const testIds = tests.map(version => version.id)
        const assessments = this.assessmentsStore
          .getAssessments(this.group.id)
          .filter(assessment => testIds.includes(assessment.test_id))
        const res = assessments.map(assessment => ({
          info: tests.find(test => test.id === assessment.test_id),
          used: true,
        }))

        return res.sort((a, b) => b?.info.id - a?.info.id)
      },
    },
    methods: {
      async handleClickVersion(version) {
        await this.assessmentsStore.fetchCurrentAssessment(this.group.id, version.info.id)
      },
    },
  }
</script>
<style scoped>
  .meta-arrow {
    color: #5a598c;
  }
</style>
