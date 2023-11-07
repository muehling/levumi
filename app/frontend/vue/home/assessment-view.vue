<template>
  <div>
    <b-card bg-variant="light" class="mt-3">
      <b-nav v-if="currentTestId" pills>
        <b-nav-item class=""
          ><span class="font-weight-bold">{{ currentArea?.name || '' }}</span></b-nav-item
        >
        <i v-if="enableTestTypes" class="fas fa-arrow-right mt-2 text-primary"></i>
        <b-nav-item
          v-if="enableTestTypes"
          :id="group.id + '_test_type_' + currentTestType?.id"
          class="ml-3"
          ><span class="font-weight-bold">{{ currentTestType?.name || '' }}</span>
        </b-nav-item>
        <i class="fas fa-arrow-right mt-2 text-primary"></i>
        <b-nav-item :id="group.id + '_competence_' + currentCompetence?.id" class="ml-3"
          ><span class="font-weight-bold">{{ currentCompetence?.name || '' }}</span>
        </b-nav-item>
        <i class="fas fa-arrow-right mt-2 text-primary"></i>
        <b-nav-item :id="group.id + '_family_' + currentFamily?.id" class="ml-3"
          ><span class="font-weight-bold">{{ currentFamily?.name || '' }}</span>
        </b-nav-item>
        <i class="fas fa-arrow-right mt-2 text-primary"></i>
        <b-nav-item :id="group.id + '_test_' + currentTest?.id" active class="ml-3"
          ><span class="font-weight-bold">{{ currentTest?.level || '' }}</span>
        </b-nav-item>
      </b-nav>
      <b-nav
        v-if="versions.length > 1 || (versions.length === 1 && versions[0].info.archive === true)"
        pills
        class="mt-1"
      >
        <!-- Alle Versionen der gewählten Niveaustufe, falls vorhanden -->
        <b-nav-item
          v-for="version in versions"
          :id="group.id + '_version_' + version.info.id"
          :key="version.info.id"
          :active="version.info.id === versionSelected"
          lazy
          @click="handleClickVersion(version)"
        >
          <span :class="version.used ? 'font-weight-bold' : ''">{{ version.info.label }}</span>
        </b-nav-item>
      </b-nav>
    </b-card>
    <b-row :id="'assessment-jump' + group.id">
      <b-col>
        <div v-if="isLoadingUpdate" class="spinner" style="padding-bottom: 75px">
          <div class="bounce1"></div>
          <div class="bounce2"></div>
          <div class="bounce3"></div>
        </div>
        <div v-else-if="!isLoadingUpdate && !hasResults">
          <p class="m-5 text-center text-muted">
            <span v-if="globalStore.studentsInGroups[group.id].length == 0">
              Aktuell sind noch keine Schüler:innen für die Klasse angelegt. Bitte legen Sie diese
              zuerst im Klassenbuch an, damit Sie testen können!
            </span>
            <span v-else>
              Kehren Sie zu Ihren vorherigen Tests zurück (fett gedruckt) oder wählen Sie einen
              neuen Test aus der Liste.
            </span>
          </p>
        </div>
        <assessment-details
          v-else-if="assessmentData && currentTest"
          :key="assessmentData.id"
          :assessment-data="assessmentData"
          :group="group"
          @update="loadAssessment(testSelected)"
          @remove-entry="removeEntry"
        >
        </assessment-details>
      </b-col>
    </b-row>
  </div>
</template>
<script>
  import AssessmentDetails from './assessment-details.vue'
  import { useAssessmentsStore } from '../../store/assessmentsStore'
  import { useGlobalStore } from '../../store/store'
  export default {
    name: 'AssessmentView',
    components: { AssessmentDetails },
    props: {
      group: Object,
      groupInfo: Object,
      index: Number,
      currentTestId: Number,
    },
    setup() {
      const globalStore = useGlobalStore()
      const assessmentsStore = useAssessmentsStore()
      return { globalStore, assessmentsStore }
    },
    data() {
      return { enableTestTypes: true }
    },
    computed: {
      assessmentData() {
        return this.assessmentsStore.currentAssessment
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
      hasResults() {
        return !!this.assessmentData
      },
      results() {
        return this.assessmentData
      },
      testSelected() {
        return this.currentTest?.id
      },
      versionSelected() {
        return this.currentTest?.id
      },
      testTypeSelected() {
        return this.currentTest?.test_type_id
      },
      isLoadingUpdate() {
        return this.assessmentsStore.isLoading
      },
      versions() {
        const test = this.testMetaData.tests.find(test => test.id === this.testSelected)

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
    watch: {
      currentTestId: {
        immediate: true,
        handler(data) {
          console.log('data', data)
        },
      },
    },
    methods: {
      removeEntry(index) {
        this.assessmentData.series.splice(index, 1)
      },
      async handleClickVersion(version) {
        await this.assessmentsStore.fetchCurrentAssessment(this.group.id, version.info.id)
      },
      async loadAssessment(testId, isVersion) {
        this.assessmentData = this.assessmentsStore.getCurrentAssessment()
      },
    },
  }
</script>
