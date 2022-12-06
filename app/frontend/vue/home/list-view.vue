<template>
  <div v-if="assessmentsStore.assessments.length == 0">
    <p class="m-5 text-center text-muted">
      Keine aktiven Tests mit Messungen vorhanden! <br />
      Legen Sie zunächst über die Auswahl unten einen Test für diese Klasse an.
    </p>
  </div>
  <div v-else>
    <loading-dots :is-loading="isLoadingList"></loading-dots>
    <b-form-group>
      <b-form-checkbox-group
        v-model="selectedFilters"
        :options="availableFilters"
      ></b-form-checkbox-group>
    </b-form-group>
    <table class="table table-sm table-striped table-responsive-md text-small">
      <thead>
        <tr>
          <th>Test</th>
          <th>Anzahl Testungen</th>
          <th>Letzter Test am</th>
          <th>Wöchentliche Testung</th>
          <th></th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="test in sortedlist" :key="test.test + '/' + test.name">
          <td>{{ test.name }}</td>
          <td>{{ test.result_count }}</td>
          <td>{{ formatLastDate(test.last_test) }}</td>
          <td>
            <b-btn
              v-if="test.student_test"
              class="btn-sm"
              :variant="test.active ? 'outline-danger' : 'outline-success'"
              @click="toggleAssessment(test)"
            >
              <i :class="`fas fa-${test.active ? 'pause' : 'play'}`"></i>
              {{ test.active ? 'Pausieren' : 'Aktivieren' }}
            </b-btn>
            <b-btn v-else class="btn-sm" variant="outline-secondary" disabled>(Nutzer-Test)</b-btn>
          </td>
          <td>
            <b-btn
              :id="`delete-button-${test.test}`"
              class="btn-sm"
              :variant="test.result_count ? 'outline-secondary' : 'outline-danger'"
              @click="deleteAssessment(test)"
              ><i class="fas fa-trash"></i
            ></b-btn>
            <b-popover
              v-if="!!test.result_count"
              :target="`delete-button-${test.test}`"
              triggers="hover"
            >
              <p>
                Testungen mit Messungen können nicht gelöscht werden. Bitte löschen Sie zunächst die
                Messungen.
              </p>
            </b-popover>
          </td>
        </tr>
      </tbody>
    </table>
    <confirm-dialog ref="confirmDialog" />
  </div>
</template>

<script>
  import { ajax } from '../../utils/ajax'
  import { useAssessmentsStore } from '../../store/assessmentsStore'
  import apiRoutes from '../routes/api-routes'
  import ConfirmDialog from '../shared/confirm-dialog.vue'
  import LoadingDots from '../shared/loading-dots.vue'
  import { format } from 'date-fns'
  import intersection from 'lodash/intersection'

  const Filter = {
    WithResults: 1,
    WithoutResults: 2,
    StudentTests: 3,
    UserTests: 4,
    ActiveTests: 5,
    InactiveTests: 6,
  }

  export default {
    name: 'ListView',
    components: { ConfirmDialog, LoadingDots },
    props: {
      group: Object,
    },
    setup() {
      const assessmentsStore = useAssessmentsStore()
      return { assessmentsStore }
    },
    data() {
      return {
        selectedFilters: [Filter.WithResults, Filter.StudentTests, Filter.ActiveTests],
        availableFilters: [
          { text: 'Mit Messungen', value: Filter.WithResults },
          { text: 'Ohne Messungen', value: Filter.WithoutResults },
          { text: 'Schüler-Tests', value: Filter.StudentTests },
          { text: 'Nutzer-Tests', value: Filter.UserTests },
          { text: 'Aktiv', value: Filter.ActiveTests },
          { text: 'Inaktiv', value: Filter.InactiveTests },
        ],
      }
    },
    computed: {
      sortedlist() {
        const byResult = []
        const byType = []
        const byStatus = []

        if (this.selectedFilters.includes(Filter.WithResults)) {
          byResult.push(
            ...this.assessmentsStore.assessments.filter(assessment => assessment.result_count > 0)
          )
        }
        if (this.selectedFilters.includes(Filter.WithoutResults)) {
          byResult.push(
            ...this.assessmentsStore.assessments.filter(assessment => assessment.result_count === 0)
          )
        }
        if (this.selectedFilters.includes(Filter.StudentTests)) {
          byType.push(
            ...this.assessmentsStore.assessments.filter(assessment => assessment.student_test)
          )
        }
        if (this.selectedFilters.includes(Filter.UserTests)) {
          byType.push(
            ...this.assessmentsStore.assessments.filter(assessment => !assessment.student_test)
          )
        }
        if (this.selectedFilters.includes(Filter.ActiveTests)) {
          byStatus.push(
            ...this.assessmentsStore.assessments.filter(assessment => assessment.active)
          )
        }
        if (this.selectedFilters.includes(Filter.InactiveTests)) {
          byStatus.push(
            ...this.assessmentsStore.assessments.filter(assessment => !assessment.active)
          )
        }
        const intersected = intersection(byResult, byType, byStatus)
        return intersected.length ? intersected.sort((a, b) => a.name.localeCompare(b.name)) : []
      },
      isLoadingList() {
        return this.assessmentsStore.isLoading
      },
    },
    mounted() {
      this.updateList()
    },
    methods: {
      formatLastDate(date) {
        return date ? format(new Date(date), 'dd.MM.yyyy') : '-'
      },
      async toggleAssessment(test) {
        const res = await ajax({
          url: `/groups/${this.group.id}/assessments/${test.test}`,
          method: 'put',
          data: { assessment: { active: test.active ? 0 : 1 } },
        })
        if (res.status === 200) {
          this.updateList()
        }
      },
      async deleteAssessment(test) {
        if (test.result_count) {
          return
        }
        const ok = await this.$refs.confirmDialog.open({
          title: 'Testung löschen',
          message: 'Möchten Sie diesen Test von der Klasse entfernen?',
          okText: 'Testung löschen',
          okIntent: 'outline-danger',
        })

        if (ok) {
          const res = await ajax(apiRoutes.assessments.delete(this.group.id, test.test))
          if (res.status === 200) {
            this.updateList()
          }
        }
      },
      async updateList() {
        this.assessmentsStore.fetch(this.group.id)
      },
    },
  }
</script>
