<template>
  <div v-if="!isOpen"></div>
  <b-card v-else class="mt-3">
    <div class="row">
      <div class="col-12 col-xl-3 col-lg-4 col-md-5 col-sm-6">
        <div class="accordion" role="tablist">
          <b-card v-for="area in areas" :key="'area' + area.id" no-body class="mb-0 border-0">
            <b-card-header header-tag="header" class="px-1 pb-1 pt-0 border-0" role="tab">
              <b-button
                :aria-expanded="selectedAreaId === area.id ? 'true' : 'false'"
                :aria-controls="`area-select-accordion${area.id}`"
                class="test-admin-button"
                block
                :variant="`${selectedAreaId === area.id ? 'primary' : 'outline-primary'}`"
                @click.stop.prevent="expandArea(area.id)">
                <span :class="`${assessmentExists('area', area.id) ? 'font-weight-bold' : ''}`">
                  {{ area.name }}
                </span>
              </b-button>
            </b-card-header>
            <b-collapse
              :id="`area-select-accordion${area.id}`"
              :visible="selectedAreaId === area.id"
              role="tabpanel">
              <b-card-body class="pr-0 py-0">
                <div class="accordion" role="tablist">
                  <b-card
                    v-for="testTypeId in area.test_type_ids"
                    :key="'testtype' + testTypeId + '/' + area.id"
                    no-body
                    class="mb-0 border-0">
                    <b-card-header header-tag="header" class="px-1 pb-1 pt-0 border-0" role="tab">
                      <b-button
                        :aria-expanded="selectedTestTypeId === testTypeId ? 'true' : 'false'"
                        :aria-controls="`testType-select-accordion${testTypeId + '/' + area.id}`"
                        class="test-admin-button"
                        block
                        :variant="`${
                          selectedTestTypeId === testTypeId ? 'primary' : 'outline-primary'
                        }`"
                        @click.stop.prevent="expandTestType(testTypeId)">
                        <span
                          :class="`${
                            assessmentExists('testType', testTypeId) ? 'font-weight-bold' : ''
                          }`">
                          {{ testTypes.find(testType => testType.id === testTypeId).name }}
                        </span>
                      </b-button>
                    </b-card-header>
                    <b-collapse
                      :id="`testType-select-accordion${testTypeId + '/' + area.id}`"
                      :visible="selectedTestTypeId === testTypeId && selectedAreaId === area.id"
                      role="tabpanel">
                      <b-card-body class="pr-0 py-0">
                        <div class="accordion" role="tablist">
                          <b-card
                            v-for="competence in competencesForTestType(area.id, testTypeId)"
                            :key="competence.id"
                            no-body
                            class="mb-0 border-0">
                            <b-card-header
                              header-tag="header"
                              class="px-1 pb-1 pt-0 border-0"
                              role="tab">
                              <b-button
                                :aria-expanded="
                                  selectedCompetenceId === competence.id ? 'true' : 'false'
                                "
                                :aria-controls="`competence-select-accordion${
                                  testTypeId + '/' + competence.id
                                }`"
                                class="test-admin-button"
                                block
                                :variant="`${
                                  selectedCompetenceId === competence.id
                                    ? 'primary'
                                    : 'outline-primary'
                                }`"
                                @click.stop.prevent="expandCompetence(competence.id)">
                                <span
                                  :class="`${
                                    assessmentExists('competence', competence.id)
                                      ? 'font-weight-bold'
                                      : ''
                                  }`">
                                  {{ competence.name }}
                                </span>
                              </b-button>
                            </b-card-header>
                            <b-collapse
                              :id="`competence-select-accordion${testTypeId + '/' + competence.id}`"
                              :visible="selectedCompetenceId === competence.id"
                              role="tabpanel">
                              <b-card-body class="pr-0 py-0">
                                <div class="accordion" role="tablist">
                                  <b-card
                                    v-for="testFamily in testFamiliesForCompetence(
                                      competence.id,
                                      testTypeId
                                    )"
                                    :key="testFamily.id"
                                    no-body
                                    class="mb-0 border-0">
                                    <b-card-header
                                      header-tag="header"
                                      class="px-1 pb-1 pt-0 border-0"
                                      role="tab">
                                      <b-button
                                        :aria-expanded="
                                          selectedTestFamilyId === testFamily.id ? 'true' : 'false'
                                        "
                                        :aria-controls="`testFamily-select-accordion${
                                          testTypeId + '/' + testFamily.id
                                        }`"
                                        class="test-admin-button"
                                        block
                                        :variant="`${
                                          selectedTestFamilyId === testFamily.id
                                            ? 'primary'
                                            : 'outline-primary'
                                        }`"
                                        @click.stop.prevent="expandTestFamily(testFamily.id)">
                                        <span
                                          :class="`${
                                            assessmentExists('testFamily', testFamily.id)
                                              ? 'font-weight-bold'
                                              : ''
                                          }`">
                                          {{ testFamily.name }}
                                        </span>
                                      </b-button>
                                    </b-card-header>
                                    <b-collapse
                                      :id="`testFamily-select-accordion${
                                        testTypeId + '/' + testFamily.id
                                      }`"
                                      :visible="testFamily.id === selectedTestFamilyId"
                                      role="tabpanel">
                                      <b-card-body class="pr-0 py-0">
                                        <div class="accordion" role="tablist">
                                          <b-card
                                            v-for="test in testsForTestFamily(
                                              testFamily.id,
                                              testTypeId
                                            )"
                                            :key="test.id"
                                            no-body
                                            class="mb-0 border-0">
                                            <b-card-header
                                              header-tag="header"
                                              class="px-1 pb-1 pt-0 border-0"
                                              role="tab">
                                              <b-button
                                                class="test-admin-button"
                                                block
                                                :variant="`${getTestButtonVariant(test.id)}`"
                                                @click.stop.prevent="displayTestDetail(test.id)">
                                                <span
                                                  :class="`${
                                                    assessmentExists('test', test.id)
                                                      ? 'font-weight-bold'
                                                      : ''
                                                  }`">
                                                  {{ test.level + getTestButtonSuffix(test.id) }}
                                                </span>
                                              </b-button>
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
              </b-card-body>
            </b-collapse>
          </b-card>
        </div>
      </div>
      <div class="col-12 col-xl-9 col-lg-8 col-md-7 col-sm-6 d-flex flex-column">
        <div v-if="!selectedTest" class="col-lg-6 ml-0 pl-0">
          <p>
            Die Tests sind hierarchisch in Lernbereiche, Lernkompetenzen und Testfamilien
            eingeordnet. Sie können sich durch die Baumstruktur links navigieren, um selbst Tests
            kennenzulernen und für die Klassen freischalten zu können.
          </p>
          <p>
            Ist eine Zeile fett gedruckt, befindet sich in dieser Kategorie bereits ein aktivierter
            Test.
          </p>
          {{ helpText }}
        </div>
        <div v-else class="d-flex flex-column">
          <div class="test-details overflow-auto">
            <p>
              Kürzel:
              <strong>{{ selectedTest?.shorthand }}</strong>
            </p>
            <p v-if="assessmentForSelectedTest?.result_count">
              {{ assessmentForSelectedTest?.result_count }} Messungen für diese Klasse vorhanden
            </p>
            <div class="text-left text-small">
              <p v-if="selectedTest.description.short" class="text-light bg-secondary pl-1">
                Kurzbeschreibung
              </p>
              <p v-if="selectedTest.description.short" v-html="selectedTest.description.short"></p>
              <p v-if="selectedTest.description.full" class="text-light bg-secondary pl-1">
                Beschreibung
              </p>
              <p v-if="selectedTest.description" v-html="selectedTest.description.full"></p>
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
                      <b-button v-b-toggle="'test-items'" variant="outline-secondary">
                        Items
                      </b-button>
                      <b-collapse id="test-items">
                        {{ Object.values(selectedTest.items).join(', ') }}
                      </b-collapse>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>
        <div class="d-flex flex-grow-0 justify-content-start align-items-end flex-wrap">
          <b-button
            v-if="!!selectedTestId"
            class="mr-2 mt-3"
            :href="`/results/start_demo/${selectedTestId}`"
            target="_blank"
            variant="outline-secondary">
            Ausprobieren
          </b-button>
          <b-button
            v-if="!assessmentForSelectedTest && selectedTestId"
            class="mr-2 mt-3"
            variant="success"
            @click="createAssessment">
            Test für die Klasse aktivieren
          </b-button>
          <b-button
            v-if="assessmentForSelectedTest"
            class="mr-2 mt-3"
            variant="outline-success"
            @click="jumpToAssessment()">
            <i class="fas fa-check mr-2"></i>
            Zur Diagnostik
          </b-button>
          <b-button
            v-if="assessmentForSelectedTest"
            class="mr-2 mt-3"
            :variant="assessmentForSelectedTest?.result_count ? 'danger' : 'outline-danger'"
            @click="deleteAssessment">
            <i class="fas fa-trash mr-2"></i>
            Test löschen
          </b-button>
          <b-btn class="mr-2 mt-3" variant="danger" @click="handleClose">Abbrechen</b-btn>
        </div>
      </div>
    </div>
    <confirm-dialog ref="confirmDialog" />
  </b-card>
</template>
<script>
  import { ajax } from '../../utils/ajax'
  import { useAssessmentsStore } from '../../store/assessmentsStore'
  import { useGlobalStore } from '../../store/store'
  import { useTestsStore } from '../../store/testsStore'
  import apiRoutes from '../routes/api-routes'
  import ConfirmDialog from '../shared/confirm-dialog.vue'
  export default {
    name: 'GroupTestAdmin',
    components: { ConfirmDialog },
    props: {
      group: Object,
      isOpen: Boolean,
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
        selectedTestTypeId: undefined,
        selectedCompetenceId: undefined,
        selectedTestFamilyId: undefined,
        selectedTestId: undefined,
        accordionData: {},
      }
    },
    computed: {
      defaultTestType: function () {
        return this.globalStore.staticData.testMetaData.test_types[0]
      },
      testMetaData: function () {
        return {
          ...this.globalStore.staticData.testMetaData,
          tests: this.globalStore.staticData.testMetaData.tests.map(test => ({
            ...test,
            is_used: this.testData.used_test_ids?.includes(test.id),
          })),
        }
      },
      assessments() {
        return this.assessmentsStore.getAssessments(this.group.id)
      },
      areas() {
        const areas = [...this.testMetaData.areas]
        return areas.sort((a, b) => (a.name > b.name ? 1 : -1))
      },
      testTypes() {
        return this.testMetaData.test_types
      },
      competences() {
        return this.testMetaData.competences
      },
      testFamilies() {
        return this.testMetaData.test_families
      },
      tests() {
        return this.testMetaData.tests
      },
      selectedTest() {
        const test = this.tests?.find(test => test.id === this.selectedTestId)
        if (test && !test.items) {
          test.items = {}
        }
        return test
      },
      testData() {
        return this.testsStore.getTestsForGroup(this.group.id) || {}
      },
      usedAreas() {
        return this.testMetaData.areas.reduce((acc, area) => {
          const used = !!this.testData.used_test_ids.some(usedId =>
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
          const used = !!this.testData.used_test_ids.some(usedId =>
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
          const used = !!this.testData.used_test_ids.some(usedId =>
            family.test_ids.find(testId => testId === usedId)
          )
          if (used) {
            acc.push(family.id)
          }
          return acc
        }, [])
      },

      usedTestTypes() {
        return this.testMetaData?.test_types.reduce((acc, testType) => {
          const used = !!this.testData.used_test_ids.some(usedId =>
            testType.test_ids.find(testId => testId === usedId)
          )
          if (used) {
            acc.push(testType.id)
          }
          return acc
        }, [])
      },
      helpText() {
        if (this.selectedTestFamilyId) {
          return 'Bitte wählen Sie in der Navigation einen Test aus. Grün umrandete Tests sind für die Klasse bereits aktiviert.'
        } else if (this.selectedCompetenceId) {
          return 'Bitte wählen Sie in der Navigation eine Testfamilie aus.'
        } else if (this.selectedTestTypeId) {
          return 'Bitte wählen Sie in der Navigation eine Lernkompetenz aus.'
        } else if (this.selectedAreaId) {
          return 'Bitte wählen Sie in der Navigation einen Test-Typen aus.'
        } else if (!this.selectedAreaId) {
          return 'Bitte wählen Sie in der Navigation einen Lernbereich aus.'
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
    watch: {
      isOpen() {
        this.reset('area')
      },
    },

    methods: {
      handleClose() {
        this.reset('area')
        this.$router.push(`/diagnostik/${this.group.id}`)
      },
      competencesForTestType(areaId, testTypeId) {
        const competences = this.competences
          .filter(
            competence =>
              competence.test_type_ids.includes(testTypeId) && competence.area_id === areaId
          )
          .sort((a, b) => (a.name > b.name ? 1 : -1))
        return competences
      },
      testFamiliesForCompetence(competenceId, testTypeId) {
        const testFamilies = this.testFamilies
          .filter(
            testFamily =>
              testFamily.test_type_ids.includes(testTypeId) &&
              testFamily.competence_id === competenceId
          )
          .sort((a, b) => (a.name > b.name ? 1 : -1))
        return testFamilies
      },
      testsForTestFamily(testFamilyId, testTypeId) {
        const tests = this.tests
          .filter(
            test =>
              test.test_family_id === testFamilyId &&
              !test.archive &&
              (test.test_type_id === testTypeId ||
                (!test.test_type_id && testTypeId === this.defaultTestType.id))
          )
          .sort((a, b) => (a.level > b.level ? 1 : -1))
        return tests
      },
      assessmentExists(type, id) {
        switch (type) {
          case 'area':
            return this.tests?.reduce(
              (acc, test) => (test.area_id === id ? acc || test.is_used : acc),
              false
            )
          case 'testType':
            return this.tests?.reduce(
              (acc, test) =>
                test.test_type_id === id && test.area_id === this.selectedAreaId && !test.archive
                  ? acc || test.is_used
                  : acc,
              false
            )
          case 'competence':
            return this.tests?.reduce(
              (acc, test) =>
                test.test_type_id === this.selectedTestTypeId &&
                test.competence_id === id &&
                !test.archive
                  ? acc || test.is_used
                  : acc,
              false
            )

          case 'testFamily':
            return this.tests?.reduce(
              (acc, test) =>
                test.test_type_id === this.selectedTestTypeId &&
                test.test_family_id === id &&
                !test.archive
                  ? acc || test.is_used
                  : acc,
              false
            )
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
        await this.testsStore.fetchUsedTestsForGroup(this.group.id)
      },

      reset(level) {
        switch (level) {
          case 'area':
            this.selectedAreaId = undefined
          case 'testType': //eslint-disable-line no-fallthrough
            this.selectedTestTypeId = undefined
          case 'competence': // eslint-disable-line no-fallthrough
            this.selectedCompetenceId = undefined
          case 'testFamily': // eslint-disable-line no-fallthrough
            this.selectedTestFamilyId = undefined
          case 'test': // eslint-disable-line no-fallthrough
            this.selectedTestId = undefined
        }
      },
      expandArea(areaId) {
        this.reset('testType')
        this.selectedAreaId = this.selectedAreaId === areaId ? undefined : areaId
      },
      expandTestType(testTypeId) {
        this.selectedTestTypeId = this.selectedTestTypeId === testTypeId ? undefined : testTypeId
        this.reset('competence')
      },
      expandCompetence(competenceId) {
        this.reset('testFamily')
        this.selectedCompetenceId =
          this.selectedCompetenceId === competenceId ? undefined : competenceId
      },
      expandTestFamily(testFamilyId) {
        this.reset('test')
        this.selectedTestFamilyId =
          this.selectedTestFamilyId === testFamilyId ? undefined : testFamilyId
      },
      async displayTestDetail(testId) {
        await this.globalStore.getItemsForTest(testId)
        this.selectedTestId = testId
      },
      async jumpToAssessment() {
        await this.assessmentsStore.fetchCurrentAssessment(this.group.id, this.selectedTestId)
        this.$router.push(`/diagnostik/${this.group.id}/testdetails/${this.selectedTestId}`)
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
      async deleteAssessment() {
        const ok = await this.$refs.confirmDialog.open({
          title: 'Testung löschen',
          message: `Möchten Sie diesen Test von der Klasse entfernen?${
            this.assessmentForSelectedTest.result_count
              ? ' Damit werden auch alle bestehenden Messungen gelöscht. Dieser Vorgang kann nicht rückgängig gemacht werden!'
              : ''
          }`,
          disableCloseOnBackdrop: true,
          okText: 'Testung löschen',
          okIntent: 'danger',
          cancelText: 'Abbrechen',
        })

        if (ok) {
          const res = await ajax(
            apiRoutes.assessments.delete(this.group.id, this.assessmentForSelectedTest.test_id)
          )
          if (res.status === 200) {
            await this.refetch()
          }
        }
      },
    },
  }
</script>
<style>
  .card-header {
    background-color: transparent !important;
  }
  .test-details {
    max-height: 80vh;
    overflow: auto;
  }
</style>
