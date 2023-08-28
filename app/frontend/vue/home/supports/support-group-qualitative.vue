<template>
  <div>
    <b-card class="mt-2">
      <table class="table table-striped table-sm table-borderless">
        <thead>
          <th>Name</th>
          <th v-for="(item, index) in itemDictionary" :key="'header' + item + index">{{ item }}</th>
        </thead>
        <tbody>
          <tr v-for="student in students" :key="student.id">
            <td>{{ student.name }}</td>
            <td v-for="(item, index) in itemDictionary" :key="'line' + item + index">
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
  import groupBy from 'lodash/groupBy'
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
    data: function () {
      return {
        isLoading: true,
      }
    },
    computed: {
      itemDictionary() {
        return this.assessmentsStore.getCurrentAssessment()?.configuration.item_dimensions
      },
      series() {
        return this.assessmentsStore.getCurrentAssessment()?.series
      },
      students() {
        return this.globalStore.studentsInGroups[this.group.id] || []
      },
      seriesByStudent() {
        return groupBy(this.series, 'student_id')
      },
    },
    methods: {
      getSeriesForStudent(studentId) {
        return takeRight(this.seriesByStudent[studentId], 3)
      },
      getTrendForStudentAndDimension(studentId, dimIndex) {
        const series = this.getSeriesForStudent(studentId)
        const dataForDim = series.map(s => ({
          ...s,
          data: s.data.filter(d => parseInt(d.group, 10) === parseInt(dimIndex, 10)),
        }))

        // one object per data point, with the numbers of right wrong and total answers
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
      },
    },
  }
</script>
