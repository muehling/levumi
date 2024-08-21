<template>
  <loading-dots v-if="isLoading" :is-loading="isLoading" />
  <b-card v-else no-body class="mt-3 pb-0 mb-1">
    <div class="card-header">
      <b-nav pills>
        <b-nav-item class="cursor-default">
          <span class="font-weight-bold">{{ currentArea?.name || '' }}</span>
        </b-nav-item>
        <i class="fas fa-arrow-right mt-2 text-primary"></i>
        <b-nav-item
          :id="group.id + '_test_type_' + currentTestType?.id"
          class="ml-3 cursor-default">
          <span class="font-weight-bold">{{ currentTestType?.name || '' }}</span>
        </b-nav-item>
        <i class="fas fa-arrow-right mt-2 text-primary"></i>
        <b-nav-item
          :id="group.id + '_competence_' + currentCompetence?.id"
          class="ml-3 cursor-default">
          <span class="font-weight-bold">{{ currentCompetence?.name || '' }}</span>
        </b-nav-item>
        <i class="fas fa-arrow-right mt-2 text-primary"></i>
        <b-nav-item :id="group.id + '_family_' + currentFamily?.id" class="ml-3 cursor-default">
          <span class="font-weight-bold">{{ currentFamily?.name || '' }}</span>
        </b-nav-item>
        <i class="fas fa-arrow-right mt-2 text-primary"></i>
        <b-nav-item :id="group.id + '_test_' + currentTest?.id" active class="ml-3 cursor-default">
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
    <b-tabs v-if="!isLoading" pills card>
      <b-tab :active="!hasResults" class="m-3">
        <div slot="title">
          Messungen ({{ test.shorthand }})
          <span v-if="!isActive && test.student_test" class="badge badge-danger">
            <i class="fas fa-pause"></i>
          </span>
          <span v-if="isActive && test.student_test" class="badge badge-success">
            <i class="fas fa-play"></i>
          </span>
        </div>
        <!-- Neue Messungen -->
        <div class="mb-3">
          <div v-if="test.archive">
            <p>
              Dieser Test wurde vom Levumi-Team überarbeitet (z.B. Korrektur einer Aufgabe, Änderung
              in der Ergebnisdarstellung). Unter dem Button "Aktuell" finden Sie die neuste
              Testversion, in der Sie ab jetzt die Testungen durchführen können.
            </p>
          </div>
          <div v-else-if="students.length == 0">
            <p>
              In dieser Klasse sind noch keine Schüler:innen angelegt. Um in dieser Klasse testen zu
              können, legen Sie bitte neue Schüler:innen im Klassenbuch an.
            </p>
          </div>
          <div v-else>
            <assessment-view-students
              :excludes="assessment.excludes"
              :group="group"
              :results="results"
              :test="test" />
          </div>
        </div>
        <!-- Liste der alten Messungen -->
        <div v-if="weeks.length > 0">
          <!-- Tabellen durch Rows nachbauen, wegen Collapse -->
          <!-- Header -->
          <b-row>
            <b-col><b>Woche ab dem</b></b-col>
            <b-col><b>Anzahl Ergebnisse</b></b-col>
            <b-col><b>Details</b></b-col>
          </b-row>
          <!-- Nach Wochen gruppierte Einträge -->
          <div v-for="(date, index) in weeks.slice().reverse()" :key="index" class="mt-2">
            <b-row>
              <b-col>{{ formatDate(date) }}</b-col>
              <b-col>{{ groupedResults[date].length }}</b-col>
              <b-col>
                <b-btn v-b-toggle="'collapse_' + index" size="sm" variant="outline-secondary">
                  <i class="when-closed fas fa-caret-down"></i>
                  <i class="when-opened fas fa-caret-up"></i>
                </b-btn>
              </b-col>
            </b-row>
            <!-- Aufklappbare Details -->
            <b-collapse :id="'collapse_' + index">
              <b-card class="mt-2">
                <table class="table table-striped table-sm table-borderless">
                  <thead>
                    <th>Datum</th>
                    <th>Schüler:in</th>
                    <th>Positiv</th>
                    <th>Negativ</th>
                    <th>Trend</th>
                    <th v-if="!readOnly">Aktionen</th>
                  </thead>
                  <tbody>
                    <tr
                      v-for="(result, resultIndex) in groupedResults[date]"
                      :key="`${result.id}/${resultIndex}`">
                      <td>{{ formatDate(result.data.test_date) }}</td>
                      <td>{{ studentName(result.data.student_id) }}</td>
                      <td>
                        <span v-html="getFormattedItems(result.data.report.positive)"></span>
                      </td>
                      <td>
                        <span v-html="getFormattedItems(result.data.report.negative)"></span>
                      </td>
                      <td>
                        <i
                          v-if="result.data.report.trend > 0"
                          class="fas fa-arrow-up"
                          style="color: var(--success-color)"></i>
                        <i
                          v-else-if="result.data.report.trend == 0"
                          class="fas fa-arrow-right"
                          style="color: var(--secondary-color)"></i>
                        <i v-else class="fas fa-arrow-down" style="color: var(--danger-color)"></i>
                      </td>
                      <td v-if="!readOnly">
                        <b-btn
                          small
                          variant="outline-danger"
                          title="Diese Messung löschen"
                          @click="deleteResult(result, resultIndex)">
                          <i class="fas fa-trash"></i>
                        </b-btn>
                      </td>
                    </tr>
                  </tbody>
                </table>
              </b-card>
            </b-collapse>
          </div>
          <confirm-dialog ref="confirmDialog" />
        </div>
        <div v-else>Für diesen Test liegen noch keine Messungen vor.</div>
      </b-tab>

      <!-- Auswertungstab mit Graph -->
      <b-tab
        title="Auswertung"
        :active="hasResults"
        class="m-3"
        :disabled="weeks.length == 0 || assessmentData.configuration.views.length == 0">
        <analysis-view
          :key="test.id"
          :annotations="assessmentData.annotations"
          :configuration="assessmentData.configuration"
          :group="group"
          :results="assessmentData.series"
          :students="students"
          :test="test"
          :is-loading-update="isLoading"></analysis-view>
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
  import { ajax } from '../../utils/ajax'
  import { getStudent } from '../../utils/helpers'
  import { isAdmin } from '../../utils/user'
  import { printDate } from '../../utils/date'
  import { useAssessmentsStore } from '../../store/assessmentsStore'
  import { useGlobalStore } from '../../store/store'
  import AnalysisView from './analysis/analysis-view.vue'
  import apiRoutes from '../routes/api-routes'
  import AssessmentViewStudents from './assessment-view-students.vue'
  import compact from 'lodash/compact'
  import ConfirmDialog from '../shared/confirm-dialog.vue'
  import isObject from 'lodash/isObject'
  import LoadingDots from '../shared/loading-dots.vue'
  import SupportView from './supports/support-view.vue'
  import uniq from 'lodash/uniq'

  export default {
    name: 'AssessmentDetails',
    components: {
      AnalysisView,
      AssessmentViewStudents,
      ConfirmDialog,
      LoadingDots,
      SupportView,
    },
    provide: function () {
      return {
        printDate: printDate,
        readOnly: this.readOnly,
        studentName: this.studentName,
        weeks: this.weeks,
      }
    },
    props: {
      group: Object,
    },
    setup() {
      const globalStore = useGlobalStore()
      const assessmentsStore = useAssessmentsStore()
      return { globalStore, assessmentsStore }
    },
    data: function () {
      return {
        excludeList: this.excludes || [],
        isUpdating: false,
      }
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
      testTypeSelected() {
        return this.currentTest?.test_type_id
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
      readOnly() {
        return !!this.group.read_only
      },
      students() {
        return this.globalStore.studentsInGroups[this.group.id] || []
      },
      groupedResults() {
        //Results nach Wochen gruppieren, für die Ergebnisliste
        const result = this.results.reduce((acc, res, i) => {
          acc[res.test_week] = acc[res.test_week] || []
          acc[res.test_week].push({ index: i, data: res })
          return acc
        }, {})

        return result
      },
      includedStudents() {
        return this.students.filter(student => !this.excludeList.includes(student.id))
      },
      excludedStudents() {
        return this.students.filter(student => this.excludeList.includes(student.id))
      },
      weeks() {
        return compact(uniq(this.results?.map(w => w.test_week)))
      },
      isActive() {
        const assessments = this.assessmentsStore.assessments[this.group.id]

        return assessments?.find(a => a.test_id === this.test.id)?.active
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
      async exclude(studentId) {
        const res = await ajax(
          apiRoutes.assessments.excludeStudent(this.group.id, this.test.id, studentId)
        )
        if (res.status === 200) {
          this.excludeList.push(studentId)
        }
      },
      formatDate(date) {
        return printDate(date)
      },

      async deleteResult(result, index) {
        const ok = await this.$refs.confirmDialog.open({
          title: 'Messung löschen',
          message: `Diese Messung unwiderruflich löschen! Sind Sie sicher?`,
          okText: 'Ja, löschen',
        })
        if (ok) {
          const res = await ajax(
            apiRoutes.assessments.deleteResult(result.data.student_id, result.data.id)
          )
          if (res.status === 200) {
            this.remove(result.index, index)
          }
        }
      },
      remove(index, collapseIndex) {
        //Löscht einen Eintrag aus der Ergebnisliste
        let last = true
        for (let i = 0; i < this.results.length; ++i) {
          if (i != index && this.results[i].test_week == this.results[index].test_week) {
            last = false
            break
          }
        }
        if (last) {
          //Letzter Eintrag der Woche wird gelöscht => Collapse erst schließen
          this.$root.$emit('bv::toggle::collapse', 'collapse_' + collapseIndex)
        }
        this.$emit('remove-entry', index)
      },
      studentName(id) {
        //Student-Objekt aus globaler Variable holen
        return getStudent(this.group.id, id)?.name
      },
      getFormattedItems(items) {
        const it = Object.values(items).map(item => {
          const a = this.test.items[item] || { question: '<unknown item>' }

          return typeof a === 'string' ? a : a.question
        })
        return it.join(', ')
      },
    },
  }
</script>

<style scoped>
  /* Darstellung des Collapse durch CSS toggeln*/
  .collapsed > .when-opened,
  :not(.collapsed) > .when-closed {
    display: none;
  }
  .cursor-default > a {
    cursor: default;
  }
  .cursor-default > a.nav-link:not(.active):hover {
    color: #5a598c !important;
  }
</style>
