<template>
  <div v-if="assessmentsStore.assessments[group.id]?.length == 0">
    <p class="m-5 text-center text-muted">
      Keine aktiven Tests mit Messungen vorhanden! <br />
      Legen Sie zunächst über die Auswahl unten einen Test für diese Klasse an.
    </p>
  </div>
  <div v-else class="assessment-list">
    <b-form-group>
      <b-form-checkbox-group
        v-model="selectedFilters"
        :options="availableFilters"
      ></b-form-checkbox-group>
      <b-btn size="sm" :variant="toggleButtonVariant" @click="handleToggleActive">
        <i :class="`fas fa-${!allTestsActive ? 'pause' : 'play'}`"></i>
        {{ toggleButtonText }}</b-btn
      >
    </b-form-group>
    <table class="table table-sm table-striped table-hover table-responsive-md text-small">
      <thead>
        <tr>
          <th>Test</th>
          <th>Anzahl Testungen</th>
          <th>Wöchentliche Testung</th>
          <th></th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="test in sortedList" :key="test.test + '/' + test.name" class="assessment-line">
          <td @click="setPreselect(test)">{{ test.name }}</td>
          <td>{{ test.result_count }}</td>
          <!--<td>{{ formatLastDate(test.last_test) }}</td>-->
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
            <b-btn v-else class="btn-sm" variant="outline-secondary" disabled
              >(Lehrkräfte-Übung)</b-btn
            >
          </td>
          <td>
            <b-btn
              :id="`delete-button-${test.test}`"
              class="btn-sm"
              :variant="test.result_count ? 'outline-danger' : 'outline-secondary'"
              @click="deleteAssessment(test)"
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
  import { useAssessmentsStore } from '../../store/assessmentsStore'
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
    name: 'ListView',
    components: { ConfirmDialog },
    props: {
      group: Object,
    },
    setup() {
      const assessmentsStore = useAssessmentsStore()
      return { assessmentsStore }
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
      }
    },
    computed: {
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

        return intersected.length ? intersected.sort((a, b) => a.name.localeCompare(b.name)) : []
      },
    },
    async created() {
      await this.updateList()
    },
    methods: {
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
        const res = await ajax({
          ...apiRoutes.assessments.updateAll(this.group.id),
          data: { active: !this.allTestsActive },
        })
        if (res.status === 200) {
          this.assessmentsStore.fetch(this.group.id)
        }
      },
      setPreselect(test) {
        this.$emit('set-preselect', {
          group: this.group.id,
          area: test.area_id,
          competence: test.competence_id,
          family: test.test_family_id,
          test: test.test_id,
        })
      },
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
        await this.assessmentsStore.fetch(this.group.id)
      },
    },
  }
</script>

<style>
  .assessment-list .assessment-line:hover {
    cursor: pointer;
  }

  .assessment-list fieldset.form-group > div {
    display: flex;
    align-items: center;
  }
</style>
