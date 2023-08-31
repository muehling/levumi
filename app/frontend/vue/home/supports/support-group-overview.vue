<template>
  <div>
    <table class="table table-sm table-bordered">
      <thead>
        <th
          v-for="item in supportNeeds"
          :key="'header' + item.color"
          :style="`background-color: ${item.color};`"
        >
          {{ item.name }}
        </th>
      </thead>
      <tbody>
        <tr v-for="(row, rowIndex) in tableRows" :key="`support-row-${rowIndex}`">
          <td v-for="(student, index) in row" :key="'line' + index + '/' + rowIndex">
            {{ student?.name }}
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
          { name: 'Hoher Förderbedarf', color: 'red' },
          { name: 'Mittlerer Förderbedarf', color: 'yellow' },
          { name: 'Aktuell kein zusätzlicher Förderbedarf', color: 'lightblue' },
        ]
      },
      students() {
        return this.globalStore.studentsInGroups[this.group.id] || []
      },
      seriesByStudent() {
        const series = this.assessmentsStore.getSeriesByStudent()
        for (let s in series) {
          series[s] = takeRight(series[s], 3)
        }
        return series
      },
      highSupportStudents() {
        return this.getStudentsForTrend(-1)
      },
      mediumSupportStudents() {
        return this.getStudentsForTrend(0)
      },
      noSupportStudents() {
        return this.getStudentsForTrend(1)
      },
      tableRows() {
        const rows = zip(
          this.highSupportStudents.map(id => this.students.find(s => s?.id === id)),
          this.mediumSupportStudents.map(id => this.students.find(s => s?.id === id)),
          this.noSupportStudents.map(id => this.students.find(s => s?.id === id))
        )

        return rows
      },
    },
    methods: {
      getStudentsForTrend(trendValue) {
        const students = Object.entries(this.seriesByStudent).filter(
          s => s[1][s[1].length - 1].report.trend === trendValue
        )
        return students.map(s => parseInt(s[0], 10))
      },
    },
  }
</script>
