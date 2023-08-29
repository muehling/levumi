<template>
  <div>
    <b-card class="mt-2">
      <table class="table table-sm table-bordered">
        <thead>
          <th>Name</th>
          <th v-for="(item, index) in itemDictionary" :key="'header' + item + index">{{ item }}</th>
        </thead>
        <tbody>
          <tr v-for="student in students" :key="student.id">
            <td>{{ student.name }}</td>
            <td
              v-for="(item, index) in itemDictionary"
              :key="'line' + item + index"
              :style="`background-color: ${getBackgroundColor(student.id, index)};`"
            >
              {{ getTrendForStudentAndDimension(student.id, index) }}
            </td>
          </tr>
        </tbody>
      </table>
    </b-card>
  </div>
</template>

<script>
  import { useAssessmentsStore } from '../../../store/assessmentsStore'
  import { useGlobalStore } from '../../../store/store'
  import takeRight from 'lodash/takeRight'

  export default {
    name: 'SupportGroupQualitative',
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
      itemDictionary() {
        return this.assessmentsStore.getCurrentAssessment()?.configuration.item_dimensions
      },
      seriesByStudent() {
        return this.assessmentsStore.getSeriesByStudent()
      },
      students() {
        return this.globalStore.studentsInGroups[this.group.id] || []
      },
    },
    methods: {
      // calculates the right/wrong answers per item dimension, as this information is not included in result.report
      getTrendForStudentAndDimension(studentId, dimIndex) {
        const series = takeRight(this.seriesByStudent[studentId], 3)
        // only get the data for the passed dimension index
        const dataForDim = series.map(s => ({
          ...s,
          data: s.data.filter(d => parseInt(d.group, 10) === parseInt(dimIndex, 10)),
        }))

        // one object per data point, with the numbers of right wrong and total answers
        // [{"r":2,"t":2},{"f":1,"t":2,"r":1},{"r":3,"t":3}]
        const answersByResult = dataForDim.map(d => {
          return d.data.reduce((acc, r) => {
            const key = r.result === 0 ? 'f' : 'r'
            acc[key] = acc[key] ? acc[key] + 1 : 1
            acc['t'] = acc['t'] ? acc['t'] + 1 : 1
            return acc
          }, {})
        })

        const relationCorrectToTotal = answersByResult.map(answer => {
          const a = (answer['r'] || 0) / answer['t']
          return Math.round(a * 100) / 100
        })

        //DEBUG STRING
        //if (
        //  relationCorrectToTotal.length > 2 &&
        //  !isNaN(relationCorrectToTotal.reduce((acc, r) => acc + r, 0))
        //) {
        //  return `${JSON.stringify(answersByResult)} ### ${relationCorrectToTotal}`
        //} else {
        //  return undefined
        //}

        if (
          relationCorrectToTotal.length > 2 &&
          !isNaN(relationCorrectToTotal.reduce((acc, r) => acc + r, 0))
        ) {
          return relationCorrectToTotal
        } else {
          return undefined
        }
      },
      getBackgroundColor(studentId, dimIndex) {
        const trendData = this.getTrendForStudentAndDimension(studentId, dimIndex)
        if (!trendData) {
          return
        }
        const lastTwoAverage = (trendData[0] + trendData[1]) / 2
        if (lastTwoAverage > trendData[2]) {
          return 'red'
        } else if (lastTwoAverage === trendData[2]) {
          return 'yellow'
        } else {
          return 'lightblue'
        }
      },
    },
  }
</script>
