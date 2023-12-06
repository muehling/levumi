<template>
  <div class="assessment-list">
    <div class="assessment-filter mb-4">
      <b-form-checkbox-group
        v-model="selectedFilters"
        :options="availableFilters"
      ></b-form-checkbox-group>
      <b-btn v-if="isAllowed" size="sm" :variant="toggleButtonVariant" @click="handleToggleActive">
        <i :class="`fas fa-${!allTestsActive ? 'play' : 'pause'}`"></i>
        {{ toggleButtonText }}</b-btn
      >
    </div>
    <table class="table table-sm table-striped table-hover table-responsive-md text-small">
      <thead>
        <tr>
          <th>Id</th>
          <th>Kürzel</th>
          <th>Test</th>
          <th>Anzahl Testungen</th>
          <th>Letzter Test</th>
          <th>Test-Typ</th>
          <th v-if="isAllowed">Wöchentliche Testung</th>
          <th v-if="isAllowed"></th>
        </tr>
      </thead>
      <tbody>
        <tr
          v-for="assessment in sortedList"
          :key="`${assessment.test_id}/${assessment.name}`"
          class="assessment-line"
        >
          <td>{{ assessment.test_id }}</td>
          <td>{{ assessment.shorthand }}</td>
          <td class="assessment-link" @click="setPreselect(assessment)">
            {{ assessment.name }}
            <i
              v-if="loadingAssessmentId === assessment.test_id"
              class="ml-2 fas fa-spinner fa-spin"
            ></i>
          </td>

          <td>{{ assessment.result_count }}</td>
          <td>{{ formatLastDate(assessment.last_test) }}</td>
          <td>{{ getTestTypeLabel(assessment.test_type_id) }}</td>
          <td v-if="isAllowed">
            <b-btn
              v-if="assessment.student_test"
              class="btn-sm"
              :variant="assessment.active ? 'outline-danger' : 'outline-success'"
              @click="toggleAssessment(assessment)"
            >
              <i
                v-if="!checkIsUpdating(assessment.test_id)"
                :class="`fas fa-${assessment.active ? 'pause' : 'play'}`"
              ></i>
              <i v-else class="fas fa-spinner fa-spin"></i>
              {{ assessment.active ? 'Pausieren' : 'Aktivieren' }}
            </b-btn>
            <b-btn v-else class="btn-sm" variant="outline-secondary" disabled
              >(Lehrkräfte-Übung)</b-btn
            >
          </td>
          <td v-if="isAllowed">
            <b-btn
              :id="`delete-button-${assessment.test}`"
              class="btn-sm"
              :variant="assessment.result_count ? 'danger' : 'outline-danger'"
              @click="deleteAssessment(assessment)"
              ><i class="fas fa-trash"></i
            ></b-btn>
          </td>
        </tr>
      </tbody>
    </table>
    <confirm-dialog ref="confirmDialog" />
  </div>
</template>
<script>
  import { ajax } from '../../utils/ajax'
  import { format } from 'date-fns'
  import { isAdmin } from '../../utils/user'
  import { useAssessmentsStore } from '../../store/assessmentsStore'
  import { useTestsStore } from '../../store/testsStore'
  import { useGlobalStore } from '../../store/store'
  import apiRoutes from '../routes/api-routes'
  import ConfirmDialog from '../shared/confirm-dialog.vue'
  import intersection from 'lodash/intersection'
  import isEmpty from 'lodash/isEmpty'

  const Filter = {
    WithResults: 1,
    WithoutResults: 2,
    StudentTests: 3,
    UserTests: 4,
    ActiveTests: 5,
    InactiveTests: 6,
  }

  export default {
    name: 'GroupAssessments',
    components: { ConfirmDialog },
    props: {
      group: Object,
    },
    setup() {
      const assessmentsStore = useAssessmentsStore()
      const globalStore = useGlobalStore()
      const testsStore = useTestsStore()
      return { assessmentsStore, globalStore, testsStore }
    },
    data() {
      return {
        selectedFilters: [
          Filter.WithResults,
          Filter.WithoutResults,
          Filter.StudentTests,
          Filter.UserTests,
          Filter.ActiveTests,
          Filter.InactiveTests,
        ],
        availableFilters: [
          { text: 'Mit Messungen', value: Filter.WithResults },
          { text: 'Ohne Messungen', value: Filter.WithoutResults },
          { text: 'Schüler:innen-Tests', value: Filter.StudentTests },
          { text: 'Lehrkräfte-Übungen', value: Filter.UserTests },
          { text: 'Aktivierte Testungen', value: Filter.ActiveTests },
          { text: 'Pausierte Testungen', value: Filter.InactiveTests },
        ],
        isUpdating: [],
        loadingAssessmentId: undefined,
      }
    },
    computed: {
      isAllowed() {
        return !this.group.read_only || isAdmin(this.globalStore.login.capabilities)
      },
      defaultTestType() {
        return this.globalStore.staticData.testMetaData.test_types[0]
      },
      toggleButtonVariant() {
        return !this.allTestsActive ? 'outline-success' : 'outline-danger'
      },
      toggleButtonText() {
        return !this.allTestsActive ? 'Alle Tests aktivieren' : 'Alle Tests pausieren'
      },
      allTestsActive() {
        return this.assessmentsStore
          .getAssessments(this.group.id)
          .filter(assessment => assessment.student_test)
          .reduce((acc, assessment) => acc && assessment.active, true)
      },

      sortedList() {
        const byResult = []
        const byType = []
        const byStatus = []
        const assessments = this.assessmentsStore.getAssessments(this.group.id)

        // not accepted shared groups will return
        if (isEmpty(assessments)) {
          return []
        }

        if (this.selectedFilters.includes(Filter.WithResults)) {
          byResult.push(...assessments.filter(assessment => assessment.result_count > 0))
        }
        if (this.selectedFilters.includes(Filter.WithoutResults)) {
          byResult.push(...assessments.filter(assessment => assessment.result_count === 0))
        }
        if (this.selectedFilters.includes(Filter.StudentTests)) {
          byType.push(...assessments.filter(assessment => assessment.student_test))
        }
        if (this.selectedFilters.includes(Filter.UserTests)) {
          byType.push(...assessments.filter(assessment => !assessment.student_test))
        }
        if (this.selectedFilters.includes(Filter.ActiveTests)) {
          byStatus.push(...assessments.filter(assessment => assessment.active))
        }
        if (this.selectedFilters.includes(Filter.InactiveTests)) {
          byStatus.push(...assessments.filter(assessment => !assessment.active))
        }
        const intersected = intersection(byResult, byType, byStatus)

        return intersected.length
          ? intersected.sort(
              (a, b) => a.shorthand.localeCompare(b.shorthand) || a.name.localeCompare(b.name)
            )
          : []
      },
    },
    methods: {
      getTestTypeLabel(testTypeId) {
        return (
          this.globalStore.staticData.testMetaData.test_types.find(
            testType => testType.id === testTypeId
          )?.name || this.defaultTestType.name
        )
      },
      checkIsUpdating(testId) {
        return this.isUpdating.find(id => id === testId)
      },
      async handleToggleActive() {
        let ok = true
        if (this.assessmentsStore.getAssessments(this.group.id).length !== this.sortedList.length) {
          ok = await this.$refs.confirmDialog.open({
            title: `Alle Tests ${this.allTestsActive ? 'pausieren' : 'aktivieren'}`,
            message:
              'Diese Aktion wechselt den Status all Ihrer Test, auch der derzeit durch die Filterung nicht sichtbaren. Möchten Sie fortfahren?',
            okText: 'Ja, fortfahren',
            okIntent: 'outline-success',
          })
        }
        if (!ok) {
          return
        }
        this.isUpdating = this.sortedList.map(assessment => assessment.test_id)
        const res = await ajax({
          ...apiRoutes.assessments.updateAll(this.group.id),
          data: { active: !this.allTestsActive },
        })
        if (res.status === 200) {
          await this.assessmentsStore.fetch(this.group.id)
        }
        this.isUpdating = []
      },
      async setPreselect(assessment) {
        this.loadingAssessmentId = assessment.test_id
        this.assessmentData = await this.assessmentsStore.fetchCurrentAssessment(
          this.group.id,
          assessment.test_id
        )
        this.loadingAssessmentId = undefined
      },
      formatLastDate(date) {
        return date ? format(new Date(date), 'dd.MM.yyyy') : '-'
      },
      async toggleAssessment(assessment) {
        this.isUpdating.push(assessment.test_id)
        const res = await ajax({
          url: `/groups/${this.group.id}/assessments/${assessment.test_id}`,
          method: 'put',
          data: { assessment: { active: assessment.active ? 0 : 1 } },
        })
        if (res.status === 200) {
          await this.updateList()
        }
      },
      async deleteAssessment(assessment) {
        const ok = await this.$refs.confirmDialog.open({
          title: 'Testung löschen',
          message: 'Möchten Sie diesen Test von der Klasse entfernen?',
          okText: 'Testung löschen',
          okIntent: 'outline-danger',
        })
        this.isUpdating.push(assessment.test_id)

        if (ok) {
          const res = await ajax(apiRoutes.assessments.delete(this.group.id, assessment.test_id))
          if (res.status === 200) {
            await this.updateList()
          }
        }
      },
      async updateList() {
        await this.assessmentsStore.fetch(this.group.id)
        await this.testsStore.fetchUsedTestsForGroup(this.group.id)
        this.isUpdating = []
      },
    },
  }
</script>
<style scoped>
  .assessment-link {
    cursor: pointer;
  }
  .assessment-filter {
    display: flex;
    justify-content: space-between;
  }
</style>
