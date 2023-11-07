<template>
  <div class="d-inline">
    <b-btn v-b-modal.create-assessment-modal variant="outline-secondary" size="sm" class="ml-2">
      <i class="fas fa-list"></i>Test hinzufügen
    </b-btn>
    <b-modal
      id="create-assessment-modal"
      ref="createAssessmentModal"
      size="xl"
      scrollable
      title="Test hinzufügen"
      hide-footer
    >
      <div class="row">
        <div class="col-6">
          <div class="accordion" role="tablist">
            <b-card v-for="area in areas" :key="area.id" no-body class="mb-0 border-0">
              <b-card-header header-tag="header" class="px-1 pb-1 pt-0 border-0" role="tab">
                <b-button
                  v-b-toggle="`area-select-accordion${area.id}`"
                  block
                  :variant="`${selectedAreaId === area.id ? 'primary' : 'outline-primary'}`"
                  @click.stop.prevent="expandArea(area.id)"
                  ><span
                    :class="`${assessmentExists('area', area.id) ? 'font-weight-bold' : ''}`"
                    >{{ area.name }}</span
                  ></b-button
                >
              </b-card-header>
              <b-collapse
                :id="`area-select-accordion${area.id}`"
                accordion="area-select-accordion"
                role="tabpanel"
              >
                <b-card-body class="pr-0 py-0">
                  <div class="accordion" role="tablist">
                    <b-card
                      v-for="competence in area.competences"
                      :key="competence.id"
                      no-body
                      class="mb-0 border-0"
                    >
                      <b-card-header header-tag="header" class="px-1 pb-1 pt-0 border-0" role="tab">
                        <b-button
                          v-b-toggle="`competence-select-accordion${competence.id}`"
                          block
                          :variant="`${
                            selectedCompetenceId === competence.id ? 'primary' : 'outline-primary'
                          }`"
                          @click.stop.prevent="expandCompetence(competence.id)"
                          ><span
                            :class="`${
                              assessmentExists('competence', competence.id)
                                ? 'font-weight-bold'
                                : ''
                            }`"
                            >{{ competence.name }}</span
                          ></b-button
                        >
                      </b-card-header>
                      <b-collapse
                        :id="`competence-select-accordion${competence.id}`"
                        accordion="competence-select-accordion"
                        role="tabpanel"
                      >
                        <b-card-body class="pr-0 py-0">
                          <div class="accordion" role="tablist">
                            <b-card
                              v-for="testFamily in competence.test_families"
                              :key="testFamily.id"
                              no-body
                              class="mb-0 border-0"
                            >
                              <b-card-header
                                header-tag="header"
                                class="px-1 pb-1 pt-0 border-0"
                                role="tab"
                              >
                                <b-button
                                  v-b-toggle="`testFamily-select-accordion${testFamily.id}`"
                                  block
                                  :variant="`${
                                    selectedTestFamilyId === testFamily.id
                                      ? 'primary'
                                      : 'outline-primary'
                                  }`"
                                  @click.stop.prevent="expandTestFamily(testFamily.id)"
                                  ><span
                                    :class="`${
                                      assessmentExists('testFamily', testFamily.id)
                                        ? 'font-weight-bold'
                                        : ''
                                    }`"
                                    >{{ testFamily.name }}</span
                                  ></b-button
                                >
                              </b-card-header>
                              <b-collapse
                                :id="`testFamily-select-accordion${testFamily.id}`"
                                accordion="testFamily-select-accordion"
                                role="tabpanel"
                              >
                                <b-card-body class="pr-0 py-0">
                                  <div class="accordion" role="tablist">
                                    <b-card
                                      v-for="test in testFamily.tests"
                                      :key="test.id"
                                      no-body
                                      class="mb-0 border-0"
                                      ><b-card-header
                                        header-tag="header"
                                        class="px-1 pb-1 pt-0 border-0"
                                        role="tab"
                                      >
                                        <b-button
                                          block
                                          :variant="`${getTestButtonVariant(test.id)}`"
                                          @click.stop.prevent="displayTestDetail(test.id)"
                                          ><span
                                            :class="`${
                                              assessmentExists('test', test.id)
                                                ? 'font-weight-bold'
                                                : ''
                                            }`"
                                            >{{ test.name + getTestButtonSuffix(test.id) }}</span
                                          ></b-button
                                        >
                                      </b-card-header>
                                    </b-card>
                                  </div>
                                </b-card-body>
                              </b-collapse>
                            </b-card>
                          </div>
                        </b-card-body>
                      </b-collapse>
                    </b-card>
                  </div>
                </b-card-body>
              </b-collapse>
            </b-card>
          </div>
        </div>
        <div class="col-6 d-flex flex-column">
          Area: {{ selectedAreaId }} <br />Competence: {{ selectedCompetenceId }}<br />
          Family:
          {{ selectedTestFamilyId }}
          <div v-if="!selectedTest">
            {{ helpText }}
          </div>
          <div v-else class="flex-grow-1 d-flex flex-column">
            <div class="flex-grow-1 test-details overflow-auto">
              {{ selectedTest?.shorthand }}
              <div class="text-left text-small">
                <p v-if="selectedTest.short" class="text-light bg-secondary pl-1">
                  Kurzbeschreibung
                </p>
                <p v-if="selectedTest.short" v-html="selectedTest.short"></p>
                <p class="text-light bg-secondary pl-1">Ausführliche Beschreibung</p>
                <table class="table table-striped table-sm text-left">
                  <tbody>
                    <tr>
                      <td>Anzahl Items</td>
                      <td>{{ Object.keys(selectedTest.items).length }}</td>
                    </tr>
                    <tr>
                      <td>Durchführung</td>
                      <td>
                        {{
                          selectedTest.student_test
                            ? 'Selbstständig durch die Schüler:innen'
                            : 'Durch die Lehrkraft'
                        }}
                      </td>
                    </tr>
                    <tr>
                      <td>Zeitbeschränkung</td>
                      <td>{{ selectedTest.time_limit }}</td>
                    </tr>
                    <tr>
                      <td>Durchführung</td>
                      <td>{{ selectedTest.usage }}</td>
                    </tr>
                    <tr>
                      <td colspan="2">
                        <b-button v-b-toggle="'test-items'" variant="outline-secondary"
                          >Items</b-button
                        >
                        <b-collapse id="test-items">{{
                          Object.values(selectedTest.items).join(', ')
                        }}</b-collapse>
                      </td>
                    </tr>
                  </tbody>
                </table>
                <p v-if="selectedTest.description" class="text-light bg-secondary pl-1">
                  Beschreibung
                </p>
                <p v-if="selectedTest.description" v-html="selectedTest.description"></p>
              </div>
            </div>
            <div class="d-flex flex-grow-0 justify-content-end">
              <b-button
                v-if="!assessmentForSelectedTest"
                class="mt-3"
                variant="success"
                @click="createAssessment"
                >Test für die Klasse aktivieren</b-button
              >
              <b-button
                v-if="assessmentForSelectedTest?.student_test && !isAssessmentActive"
                class="mt-3"
                variant="outline-success"
                @click="toggleAssessment"
                ><i class="fas fa-play mr-2"></i>Test aktivieren</b-button
              >
              <b-button
                v-if="assessmentForSelectedTest?.student_test && isAssessmentActive"
                class="ml-2 mt-3"
                variant="outline-danger"
                @click="toggleAssessment"
                ><i class="fas fa-pause mr-2"></i>Test pausieren</b-button
              >
              <b-button
                v-if="assessmentForSelectedTest"
                class="ml-2 mt-3"
                variant="success"
                @click="jumpToAssessment()"
                ><i class="fas fa-check mr-2"></i>Zur Diagnostik</b-button
              >
            </div>
          </div>
        </div>
      </div>
    </b-modal>
  </div>
</template>
<script>
  import { ajax } from '../../utils/ajax'
  import { useTestsStore } from '../../store/testsStore'
  import { useGlobalStore } from '../../store/store'
  import { useAssessmentsStore } from '../../store/assessmentsStore'
  import isEmpty from 'lodash/isEmpty'
  export default {
    name: 'CreateAssessmentView',
    props: {
      group: Object,
      groupInfo: Object,
    },
    setup() {
      const globalStore = useGlobalStore() // evtl raus
      const assessmentsStore = useAssessmentsStore()
      const testsStore = useTestsStore()

      return { globalStore, testsStore, assessmentsStore }
    },
    data: function () {
      return {
        selectedAreaId: undefined,
        selectedCompetenceId: undefined,
        selectedTestFamilyId: undefined,
        selectedTestId: undefined,
        assessments: [],
        //assessmentForSelectedTest: undefined,
      }
    },
    computed: {
      testMetaData: function () {
        return this.globalStore.staticData.testMetaData
      },
      areas() {
        return this.testsStore.tests
      },
      competences() {
        return this.areas?.find(area => area.id === this.selectedAreaId)?.competences
      },
      testFamilies() {
        return this.competences?.find(competence => competence.id === this.selectedCompetenceId)
          ?.test_families
      },
      tests() {
        return this.testFamilies?.find(testFamily => testFamily.id === this.selectedTestFamilyId)
          ?.tests
      },
      selectedTest() {
        return this.tests?.find(test => test.id === this.selectedTestId)
      },
      usedTests: function () {
        return this.testMetaData.tests.reduce((acc, test) => {
          const isTestUsed = this.groupInfo.used_test_ids.find(testId => testId === test.id)
          const versions = this.testMetaData.tests.filter(
            version =>
              version.level === test.level && version.test_family_id === this.familySelected
          )
          acc.push({ info: test, used: isTestUsed, versions })

          return acc
        }, [])
      },
      usedAreas() {
        return this.testMetaData.areas.reduce((acc, area) => {
          const used = !!this.groupInfo.used_test_ids.some(usedId =>
            area.test_ids.find(testId => testId === usedId)
          )
          if (used) {
            acc.push(area.id)
          }
          return acc
        }, [])
      },
      usedCompetences() {
        return this.testMetaData?.competences.reduce((acc, competence) => {
          const used = !!this.groupInfo.used_test_ids.some(usedId =>
            competence.test_ids.find(testId => testId === usedId)
          )

          if (used) {
            acc.push(competence.id)
          }
          return acc
        }, [])
      },
      usedTestFamilies() {
        return this.testMetaData?.test_families.reduce((acc, family) => {
          const used = !!this.groupInfo.used_test_ids.some(usedId =>
            family.test_ids.find(testId => testId === usedId)
          )
          if (used) {
            acc.push(family.id)
          }
          return acc
        }, [])
      },

      usedTestTypes() {
        const currentArea = this.testMetaData.areas.find(area => area.id === this.areaSelected)

        const typeLabels = this.testMetaData.test_types.filter(testType => {
          return currentArea.used_test_types.find(testTypeId => testTypeId === testType.id)
        })
        if (isEmpty(typeLabels)) {
          typeLabels.unshift(this.testMetaData.test_types[0])
        }

        return typeLabels.map(typeLabel => {
          typeLabel.used = !!this.groupInfo.used_test_ids.some(usedId =>
            typeLabel.test_ids.find(id => id === usedId)
          )
          return typeLabel
        })
      },
      helpText() {
        if (this.selectedTestFamilyId) {
          return 'Bitte wählen Sie links in der Navigation einen Test aus. Grün umrandete Tests sind für die Klasse bereits aktiviert.'
        } else if (this.selectedCompetenceId) {
          return 'Bitte wählen Sie links in der Navigation eine Testfamilie aus.'
        } else if (this.selectedAreaId) {
          return 'Bitte wählen Sie links in der Navigation eine Lernkompetenz aus.'
        } else if (!this.selectedAreaId) {
          return 'Bitte wählen Sie links in der Navigation einen Lernbereich aus.'
        }
        return ''
      },
      assessmentForSelectedTest() {
        return this.assessments.find(assessment => assessment.test_id === this.selectedTestId)
      },
      isAssessmentActive() {
        return this.assessmentForSelectedTest?.active
      },
    },
    async created() {
      await this.testsStore.fetch()
    },
    methods: {
      assessmentExists(type, id) {
        switch (type) {
          case 'area':
            return this.usedAreas.find(areaId => areaId === id)
          case 'competence':
            return this.usedCompetences.find(competenceId => competenceId === id)
          case 'testFamily':
            return this.usedTestFamilies.find(testFamilyId => testFamilyId === id)
          case 'test':
            return !!this.assessments.find(assessment => assessment.test_id === id)
        }
      },
      getTestButtonVariant(testId) {
        const assessment = this.assessments.find(assessment => assessment.test_id === testId)
        if (assessment && testId === this.selectedTestId) {
          return 'success'
        } else if (assessment) {
          return 'outline-success'
        } else if (this.selectedTestId === testId) {
          return 'primary'
        } else {
          return 'outline-primary'
        }
      },
      getTestButtonSuffix(testId) {
        const assessment = this.assessments.find(assessment => assessment.test_id === testId)
        if (assessment && !assessment.active) {
          return ' (pausiert)'
        } else if (assessment && !assessment.student_test) {
          return ' (Lehrkräfte-Übung)'
        }
        return ''
      },
      async refetch() {
        await this.assessmentsStore.fetch(this.group.id)
        this.assessments = this.assessmentsStore.getAssessments(this.group.id)
      },
      reset(level) {
        switch (level) {
          case 'area':
            this.selectedAreaId = undefined
          case 'competence': // eslint-disable-line no-fallthrough
            this.selectedCompetenceId = undefined
          case 'testFamily': // eslint-disable-line no-fallthrough
            this.selectedTestFamilyId = undefined
          case 'test': // eslint-disable-line no-fallthrough
            this.testId = undefined
        }
      },
      expandArea(areaId) {
        this.selectedAreaId = this.selectedAreaId === areaId ? undefined : areaId
        this.reset('competence')
      },
      expandCompetence(competenceId) {
        this.selectedCompetenceId =
          this.selectedCompetenceId === competenceId ? undefined : competenceId
        this.reset('testFamily')
      },
      expandTestFamily(testFamilyId) {
        this.selectedTestFamilyId =
          this.selectedTestFamilyId === testFamilyId ? undefined : testFamilyId

        this.reset('test')
      },
      displayTestDetail(testId) {
        this.selectedTestId = testId
      },
      async toggleAssessment() {
        const res = await ajax({
          url: `/groups/${this.group.id}/assessments/${this.selectedTestId}`,
          method: 'put',
          data: { assessment: { active: this.assessmentForSelectedTest?.active ? 0 : 1 } },
        })
        if (res.status === 200) {
          await this.refetch()
        }
      },
      async jumpToAssessment() {
        this.$refs.createAssessmentModal.hide()
        await this.assessmentsStore.fetchCurrentAssessment(this.group.id, this.selectedTestId)
        //    this.$emit(
        //      'select-test',
        //      {
        //        groupId: this.group.id,
        //        areaId: this.selectedAreaId,
        //        competenceId: this.selectedCompetenceId,
        //        familyId: this.selectedTestFamilyId,
        //        testId: this.selectedTestId,
        //        versionId: this.selectedTestId,
        //        typeId: this.selectedTest.test_type_id,
        //      },
        //      false
        //    )
        this.reset('area')
      },
      async createAssessment() {
        const test = this.globalStore.staticData.testMetaData.tests.find(
          test => test.id === this.selectedTestId
        )
        if (test.archive) {
          return
        }

        const res = await ajax({
          contentType: 'application/x-www-form-urlencoded',
          data: `test_id=${test.id}, active=true`,
          method: 'post',
          url: `/groups/${this.group.id}/assessments/`,
        })
        if (res.status === 200) {
          await this.refetch()
        }
      },
    },
  }
</script>
<style scoped>
  .card-header {
    background-color: transparent;
  }
  .test-details {
    max-height: 80vh;
    overflow: auto;
  }
</style>
