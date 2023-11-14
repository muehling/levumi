<template>
  <div>
    <div>
      <b-button
        v-b-toggle.supportGroupQualitativeExplanation
        variant="outline-secondary"
        class="mb-3 btn-sm d-none"
        >Erläuterungen</b-button
      >
      <b-collapse id="supportGroupQualitativeExplanation">
        <p>
          Die Zahlen in den eckigen Klammern entsprechen der Anzahl der richtigen Antworten im
          Verhältnis zur Gesamtzahl der Antworten der letzten drei Testzeitpunkte.
        </p>
        <p v-for="item in supportNeeds" :key="item.color">
          <span :style="`background-color:${item.color}`">&nbsp;&nbsp;&nbsp;&nbsp;</span>
          <strong class="ml-2">{{ item.name + ': ' }}</strong
          >{{ item.explanation }}
        </p>
      </b-collapse>
    </div>
    <table class="table table-sm table-bordered table-striped table-hover group-suggestions">
      <thead>
        <th>Name</th>
        <th
          v-for="(item, index) in itemDictionary"
          :key="'header' + item + index"
          class="text-small"
        >
          {{ item }}
        </th>
      </thead>
      <tbody>
        <tr v-for="(student, studentIndex) in students" :key="student.id">
          <td class="text-small">{{ student.name }}</td>
          <td
            v-for="(item, index) in itemDictionary"
            :key="'line' + item + index"
            class="text-small"
          >
            <b-dropdown
              v-if="materialsPerStudentAndDimension[studentIndex][index]?.suggestions?.length"
              text="Fördermaterial"
              variant="outline-secondary"
              size="sm"
              :toggle-class="materialsPerStudentAndDimension[studentIndex][index].intent"
            >
              <b-dropdown-item
                v-for="material in materialsPerStudentAndDimension[studentIndex][index].suggestions"
                :key="material.label"
                class="mb-0 text-small"
                :href="material.link"
                target="_blank"
              >
                {{ material.label }}
              </b-dropdown-item>
            </b-dropdown>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script>
  import { getTrendFromResults } from '@/utils/helpers'
  import { useAssessmentsStore } from '@/store/assessmentsStore'
  import { useGlobalStore } from '@/store/store'
  import { useMaterialsStore } from '@/store/materialsStore'
  import flatten from 'lodash/flatten'
  import takeRight from 'lodash/takeRight'

  export default {
    name: 'SupportGroupSuggestions',
    components: {},
    props: {
      group: Object,
      testId: Number,
    },
    setup() {
      const assessmentsStore = useAssessmentsStore()
      const globalStore = useGlobalStore()
      const materialsStore = useMaterialsStore()
      return { globalStore, assessmentsStore, materialsStore }
    },
    computed: {
      supportNeeds() {
        return [
          {
            name: 'Hoher Förderbedarf',
            explanation:
              'Es gibt keine Leistungssteigerung im Vergleich zum vorletzten Test, z.B. [1/3, 1/1, 0/1].',
            color: '#F7A2A2',
          },
          {
            name: 'Mittlerer Förderbedarf',
            explanation:
              'Es gibt eine Leistungssteigerung im Vergleich zum vorletzten Test, jedoch war diese nicht kontinuierlich über die drei Tests hinweg, z.B. [1/3, 1/1, 0/1].',
            color: '#FEEFAB',
          },
          {
            name: 'Aktuell kein zusätzlicher Förderbedarf',
            explanation:
              'Es gibt eine kontinuierliche Leistungssteigerung seit dem vorletzten Test, z.B. [2/3, 3/4, 4/4].',
            color: 'lightblue',
          },
        ]
      },
      itemDictionary() {
        return this.assessmentsStore.getCurrentAssessment()?.configuration.item_dimensions
      },
      seriesByStudent() {
        return this.assessmentsStore.getSeriesByStudent()
      },
      students() {
        return this.globalStore.studentsInGroups[this.group.id] || []
      },
      materialsPerStudentAndDimension() {
        const materials = []
        this.students.forEach((student, index) => {
          materials[index] = []
          for (let item in this.itemDictionary) {
            const suggestions = this.getMaterialSuggestions(student.id, item)

            materials[index][parseInt(item, 10)] = {
              intent: suggestions?.intent,
              suggestions: suggestions?.materials,
            }
          }
        })

        return materials
      },
    },
    async created() {
      await this.materialsStore.fetchMaterialsForTest(this.testId)
      await this.materialsStore.fetch()
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

        if (
          relationCorrectToTotal.length > 2 &&
          !isNaN(relationCorrectToTotal.reduce((acc, r) => acc + r, 0))
        ) {
          return { relation: relationCorrectToTotal, answers: answersByResult }
        } else {
          return undefined
        }
      },

      getMaterialSuggestions(studentId, dimIndex) {
        const data = this.getTrendForStudentAndDimension(studentId, dimIndex)

        if (!data) {
          return
        }
        if (!this.materialsStore.materials.materials) {
          return
        }

        const trend = getTrendFromResults(data.relation)
        let materials
        let supports
        let intent
        switch (trend) {
          case 'NO_SUPPORT':
            return undefined
          case 'HIGH_SUPPORT':
            intent = 'outline-danger'
          case 'MEDIUM_SUPPORT': //eslint-disable-line no-fallthrough
            intent = intent || 'outline-warning'
            supports = this.materialsStore.materialsForTest.filter(
              material => material.group === parseInt(dimIndex, 10)
            )
            materials = supports.map(support =>
              this.materialsStore.materials.materials.find(
                material => material.id === support.material_id
              )
            )

            return {
              intent,
              materials: flatten(
                materials.map(material =>
                  material.files.map(file => ({ label: file.name, link: file.path }))
                )
              ),
            }
        }
        return undefined
      },
    },
  }
</script>

<style>
  .group-suggestions .b-dropdown {
    width: 100%;
  }
  .group-suggestions .btn.dropdown-toggle {
    color: black;
  }
  .group-suggestions .btn.dropdown-toggle.outline-warning {
    border-color: #feefab !important;
    background-color: #feefab !important;
  }

  .group-suggestions .btn.dropdown-toggle.outline-danger {
    border-color: #f7a2a2 !important;
    background-color: #f7a2a2 !important;
  }
</style>
