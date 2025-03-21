<template>
  <div>
    <div>
      <b-button
        v-b-toggle.supportGroupOverviewExplanation
        variant="outline-secondary"
        class="mb-3 btn-sm">
        Erläuterungen
      </b-button>
      <b-collapse id="supportGroupOverviewExplanation">
        <p>
          Die Zahlen in den eckigen Klammern entsprechen den Gesamtzahlen der richtigen Antworten
          der letzten drei Testzeitpunkte.
        </p>
        <p>
          Für nicht in der Tabelle enthaltene Schüler:innen liegen nicht genug Ergebnisse vor, um
          den Förderbedarf zu ermitteln.
        </p>
        <p v-for="item in supportNeeds" :key="item.color">
          <span :style="`background-color:${item.color}`">&nbsp;&nbsp;&nbsp;&nbsp;</span>
          <strong class="ms-2">{{ item.name + ': ' }}</strong>
          {{ item.explanation }}
        </p>
      </b-collapse>
    </div>
    <table class="table table-sm table-bordered support-table">
      <thead>
        <th
          v-for="item in supportNeeds"
          :key="'header' + item.color"
          width="33%"
          :style="`background-color: ${item.color};`">
          {{ item.name }}
        </th>
      </thead>
      <tbody>
        <tr v-for="(row, rowIndex) in tableRows" :key="`support-row-${rowIndex}`">
          <td v-for="(student, index) in row" :key="'line' + index + '/' + rowIndex" width="33%">
            {{ student }}
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script>
  import takeRight from 'lodash/takeRight'
  import { useAssessmentsStore } from '../../../store/assessmentsStore'
  import { useGlobalStore } from '../../../store/store'
  import zip from 'lodash/zip'
  import { getTrendFromResults } from '../../../utils/helpers'
  export default {
    name: 'SupportGroupOverview',
    components: {},
    props: {
      group: Object,
      test: Number,
    },
    setup() {
      const assessmentsStore = useAssessmentsStore()
      const globalStore = useGlobalStore()
      return { globalStore, assessmentsStore }
    },
    computed: {
      supportNeeds() {
        return [
          {
            name: 'Hoher Förderbedarf',
            explanation: 'Es gibt keine Leistungssteigerung im Vergleich zum vorletzten Test.',
            color: '#F7A2A2',
          },
          {
            name: 'Mittlerer Förderbedarf',
            explanation:
              'Es gibt eine Leistungssteigerung im Vergleich zum vorletzten Test, jedoch war diese nicht kontinuierlich über die drei Tests hinweg.',
            color: '#FEEFAB',
          },
          {
            name: 'Aktuell kein zusätzlicher Förderbedarf',
            explanation:
              'Es gibt eine kontinuierliche Leistungssteigerung seit dem vorletzten Test.',
            color: 'lightblue',
          },
        ]
      },
      students() {
        return this.globalStore.studentsInGroups[this.group.id] || []
      },
      seriesByStudent() {
        const series = this.assessmentsStore.getSeriesByStudent()
        for (let s in series) {
          const lastThree = takeRight(series[s], 3)
          series[s] = lastThree.map(result => {
            return result.report.positive.length
          })
        }
        return series
      },
      highSupportStudents() {
        const students = Object.entries(this.seriesByStudent).filter(s => {
          return getTrendFromResults(s[1]) === 'HIGH_SUPPORT'
        })

        return students
      },
      mediumSupportStudents() {
        const students = Object.entries(this.seriesByStudent).filter(s => {
          return getTrendFromResults(s[1]) === 'MEDIUM_SUPPORT'
        })
        return students
      },
      noSupportStudents() {
        const students = Object.entries(this.seriesByStudent).filter(s => {
          return getTrendFromResults(s[1]) === 'NO_SUPPORT'
        })
        return students
      },
      tableRows() {
        const rows = zip(
          this.highSupportStudents.map(
            id =>
              this.students.find(s => s.id === parseInt(id[0]))?.name +
              ' [' +
              id[1].join(', ') +
              ']'
          ),
          this.mediumSupportStudents.map(
            id =>
              this.students.find(s => s.id === parseInt(id[0]))?.name +
              ' [' +
              id[1].join(', ') +
              ']'
          ),
          this.noSupportStudents.map(
            id =>
              this.students.find(s => s.id === parseInt(id[0]))?.name +
              ' [' +
              id[1].join(', ') +
              ']'
          )
        )

        return rows
      },
    },
  }
</script>
<style>
  .support-table {
    table-layout: fixed;
  }
</style>
