<template>
  <div>
    <div class="mb-3">
      <div v-if="test.archive">
        <p>
          Dieser Test wurde vom Levumi-Team überarbeitet (z.B. Korrektur einer Aufgabe, Änderung in
          der Ergebnisdarstellung). Unter dem Button "Aktuell" finden Sie die neuste Testversion, in
          der Sie ab jetzt die Testungen durchführen können.
        </p>
      </div>
      <div v-else-if="students.length == 0">
        <p>
          In dieser Klasse sind noch keine Schüler:innen angelegt. Um in dieser Klasse testen zu
          können, legen Sie bitte neue Schüler:innen im Klassenbuch an.
        </p>
      </div>
      <div v-else-if="!!assessment">
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
            <b-button v-b-toggle="'collapse_' + index" size="sm" variant="outline-secondary">
              <i class="when-closed fas fa-caret-down"></i>
              <i class="when-opened fas fa-caret-up"></i>
            </b-button>
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
                      class="fas fa-arrow-up improvement-arrow"></i>
                    <i
                      v-else-if="result.data.report.trend == 0"
                      class="fas fa-arrow-right neutral-arrrow"></i>
                    <i v-else class="fas fa-arrow-down degradation-arrow"></i>
                  </td>
                  <td v-if="!readOnly">
                    <b-button
                      small
                      variant="outline-danger"
                      title="Diese Messung löschen"
                      @click="deleteResult(result, resultIndex)">
                      <i class="fas fa-trash"></i>
                    </b-button>
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
  </div>
</template>
<script setup>
  import AssessmentViewStudents from './assessment-view-students.vue'
  import ConfirmDialog from '../shared/confirm-dialog.vue'
  import { printDate } from '../../utils/date'
  import { ajax } from '../../utils/ajax'
  import apiRoutes from '../routes/api-routes'
  import { computed } from 'vue'

  const { test, group, weeks, results, assessment } = defineProps({
    test: Object,
    group: Object,
    weeks: Array,
    results: Array,
    assessment: Object,
  })

  const students = computed(() => group.students)
  const readOnly = computed(() => !!group.read_only)
  const groupedResults = computed(() => {
    const result = results.reduce((acc, res, i) => {
      acc[res.test_week] = acc[res.test_week] || []
      acc[res.test_week].push({ index: i, data: res })
      return acc
    }, {})

    return result
  })

  const getFormattedItems = items => {
    const it = Object.values(items).map(item => {
      const a = test.items[item] || { question: '<unknown item>' }

      return typeof a === 'string' ? a : a.question
    })
    return it.join(', ')
  }
  const formatDate = date => {
    return printDate(date)
  }

  const deleteResult = async (result, index) => {
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
  }
  const studentName = id => group.students.find(student => student.id === id).name
</script>
