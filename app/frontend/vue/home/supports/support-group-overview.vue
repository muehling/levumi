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
          const lastThree = takeRight(series[s], 3)
          series[s] = lastThree.map(result => {
            return result.report.positive.length
          })
        }
        return series
      },
      highSupportStudents() {
        const students = Object.entries(this.seriesByStudent).filter(s => {
          const [x1, x2, x3] = s[1]
          return x1 >= x3
        })

        return students
      },
      mediumSupportStudents() {
        const students = Object.entries(this.seriesByStudent).filter(s => {
          const [x1, x2, x3] = s[1]
          return x1 < x3 && (x1 > x2 || x2 > x3)
        })
        return students
      },
      noSupportStudents() {
        const students = Object.entries(this.seriesByStudent).filter(s => {
          const [x1, x2, x3] = s[1]
          return x1 < x3 && x1 <= x2 && x2 <= x3
        })
        return students
      },
      tableRows() {
        const rows = zip(
          this.highSupportStudents.map(
            id => this.students.find(s => s.id === parseInt(id[0]))?.name + ' ' + id[1]
          ),
          this.mediumSupportStudents.map(
            id => this.students.find(s => s.id === parseInt(id[0]))?.name + ' ' + id[1]
          ),
          this.noSupportStudents.map(
            id => this.students.find(s => s.id === parseInt(id[0]))?.name + ' ' + id[1]
          )
        )

        return rows
      },
    },
  }
</script>
