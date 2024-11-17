<template>
  <div>
    <div>
      <b-button
        v-b-toggle.supportGroupQualitativeExplanation
        variant="outline-secondary"
        class="mb-3 btn-sm">
        Erläuterungen
      </b-button>
      <b-collapse id="supportGroupQualitativeExplanation">
        <p>
          Die Zahlen in den eckigen Klammern entsprechen der Anzahl der richtigen Antworten im
          Verhältnis zur Gesamtzahl der Antworten der letzten drei Testzeitpunkte.
        </p>
        <p v-for="item in supportNeeds" :key="item.color">
          <span :style="`background-color:${item.color}`">&nbsp;&nbsp;&nbsp;&nbsp;</span>
          <strong class="ms-2">{{ item.name + ': ' }}</strong>
          {{ item.explanation }}
        </p>
        <p>
          Ist eine Zelle leer, liegen weniger als drei Ergebnisse für die betreffende Dimension vor.
        </p>
      </b-collapse>
    </div>
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
            :style="`background-color: ${getBackgroundColor(student.id, index)};`">
            {{ getDisplayValue(getTrendForStudentAndDimension(student.id, index)?.answers) }}
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script>
  import { useAssessmentsStore } from '../../../store/assessmentsStore'
  import { useGlobalStore } from '../../../store/store'
  import takeRight from 'lodash/takeRight'
  import { getTrendFromResults } from '../../../utils/helpers'

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
      supportNeeds() {
        return [
          {
            name: 'Hoher Förderbedarf',
            explanation:
              'Es gibt keine Leistungssteigerung im Vergleich zum vorletzten Test,  z.B. [1/3, 1/1, 0/1].',
            color: '#F7A2A2',
          },
          {
            name: 'Mittlerer Förderbedarf',
            explanation:
              'Es gibt eine Leistungssteigerung im Vergleich zum vorletzten Test, jedoch war diese nicht kontinuierlich über die drei Tests hinweg,  z.B. [1/3, 1/1, 0/1].',
            color: '#FEEFAB',
          },
          {
            name: 'Aktuell kein zusätzlicher Förderbedarf',
            explanation:
              'Es gibt eine kontinuierliche Leistungssteigerung seit dem vorletzten Test, z.B. [1/3, 1/1, 0/1].',
            color: 'lightblue',
          },
        ]
      },
    },
    methods: {
      getDisplayValue(result) {
        if (!result) {
          return ''
        }

        return '[' + result.map(r => (r.r ? r.r : '0') + '/' + r.t).join(', ') + ']'
      },
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
          return { relation: relationCorrectToTotal, answers: answersByResult }
        } else {
          return undefined
        }
      },
      getBackgroundColor(studentId, dimIndex) {
        const data = this.getTrendForStudentAndDimension(studentId, dimIndex)

        if (!data) {
          return
        }

        const trend = getTrendFromResults(data.relation)
        switch (trend) {
          case 'NO_SUPPORT':
            return 'lightblue'
          case 'HIGH_SUPPORT':
            return '#F7A2A2'
          case 'MEDIUM_SUPPORT':
            return '#FEEFAB'
        }
      },
    },
  }
</script>
