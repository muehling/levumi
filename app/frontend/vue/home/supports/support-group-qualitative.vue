<template>
  <div>
    Qualitative
    <b-card class="mt-2">
      <table class="table table-striped table-sm table-borderless">
        <thead>
          <th></th>
          <th v-for="(item, index) in itemDictionary" :key="item + index">{{ item }}</th>
        </thead>
        <tbody>
          <tr v-for="student in students" :key="student.id">
            <td>
              {{ student.name }}
            </td>
            <td>{{ getSeriesForStudent(student.id).length }}</td>
          </tr>
        </tbody>
      </table>
    </b-card>
  </div>
</template>

<script>
  import { useAssessmentsStore } from '../../../store/assessmentsStore'
  import { useGlobalStore } from '../../../store/store'
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
        console.log('arghg', this.assessmentsStore.getCurrentAssessment())
        return this.assessmentsStore.getCurrentAssessment()?.configuration.item_dimensions
      },
      series() {
        return this.assessmentsStore.getCurrentAssessment()?.series
      },
      students() {
        return this.globalStore.studentsInGroups[this.group.id] || []
      },
      seriesForStudents() {
        const a = this.series.reduce((acc, series) => {
          acc[series.student_id] = acc[series.student_id] || {}
          acc[series.student_id][series.data.group] =
            acc[series.student_id][series.data.group] || {}

          acc[series.student_id][series.data.group] += series.report.positive
          return acc
        }, {})
        return a
      },
    },
    methods: {
      getSeriesForStudent(studentId) {
        console.log('series', studentId, this.seriesForStudents[studentId])

        return this.series.filter(s => s.student_id === studentId)
      },
      getTrendPerStudentAndDimension(studentId, dimensionIndex) {},
    },
  }
</script>
