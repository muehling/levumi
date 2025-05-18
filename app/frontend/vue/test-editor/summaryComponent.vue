<template>
  <b-card title="Zusammenfassung">
    <div class="mb-4">
      <p>Testkürzel: {{ allData.properties.shorthand }}</p>
      <p>Kompetenz: {{ allData.properties.competence }}</p>
      <p>Niveaustufe: {{ allData.properties.level }}</p>
      <p>Zeitbegrenzung: {{ allData.properties.description.time_limit }} Minute(n)</p>
      <p>Anzahl der Items: {{ allData.questions.length }}</p>
    </div>

    <b-button variant="success" @click="downloadZIP()">
      <i class="fas fa-download me-2"></i>
      Test erstellen und herunterladen
    </b-button>
    <b-button v-if="admin" class="ms-2" @click="printAll">debug</b-button>
  </b-card>
</template>

<script>
  import JSZip from 'jszip'
  import { testDefinitions } from './test-definitions.js'
  import { isAdmin } from 'src/utils/user.js'
  export default {
    props: { allData: Object, questionType: String },

    data() {
      return {
        idAdded: false,
      }
    },

    computed: {
      admin() {
        return isAdmin()
      },
      questionTypeLabel() {
        return testDefinitions[this.questionType]?.label
      },
      properties() {
        return this.allData.properties
      },
      questions() {
        return this.allData.questions
      },
      startPage() {
        return this.allData.startPage
      },
      endPage() {
        return this.allData.endPage
      },
    },

    methods: {
      printAll() {
        console.log(this.allData)
        console.log(this.properties)
        console.log(this.getConfiguration())
      },

      printQuestions() {
        console.log(this.allData.questions)
      },
      getProperties() {
        return {
          area: this.properties.area,
          competence: this.properties.competence,
          family: this.properties.family,
          test_type: this.properties.test_type,
          shorthand: this.properties.shorthand,
          level: this.properties.level,
          student_test: this.properties.student_test,
          version: this.properties.version,
          time_limit: this.properties.time_limit,
          description: { ...this.properties.description },
          responsible: this.properties.responsible,
        }
      },
      getConfiguration() {
        const a = {
          start_page: this.startPage,
          end_page: this.endPage,
          time_limit: this.properties.time_limit,
          dimensions: this.allData.dimensions,
          item_type: this.allData.questionType,
          options: {
            show_demo_task: this.properties.show_demo_task,
            show_feedback: this.properties.show_feedback,
            feedback: {
              positive: this.properties.positive_feedback_text,
              negative: this.properties.negative_feedback_text,
              show_task: this.properties.hide_task_in_feedback,
            },
            ...this.properties.test_options,
          },
          views: [
            {
              key: 'V1',
              label: 'Übersicht',
              student: true,
              group: true,
              type: 'graph',
              options: {
                chart: {
                  type: 'line',
                },
                yaxis: {
                  title: {
                    text: 'Anzahl richtig gelöster Items',
                  },
                  min: 0,
                },
              },
            },
            {
              key: 'V2',
              label: 'Qualitative Auswertung',
              student: true,
              group: false,
              type: 'table',
              column_keys: ['RGI', 'FGI', 'LG', 'LGM'],
              columns: [
                'Richtig gelöste Items',
                'Falsch gelöste Items',
                'Bearbeitungsgenauigkeit (in %)',
                'Bearbeitungsgeschwindigkeit pro Minute',
              ],
            },
            {
              key: 'V3',
              label: 'Gesamtauswertung',
              student: true,
              group: false,
              type: 'graph_table',
              column_keys: ['RGI', 'FGI', 'LG', 'LGM'],
              columns: [
                'Richtig gelöste Items',
                'Falsch gelöste Items',
                'Bearbeitungsgenauigkeit (in %)',
                'Bearbeitungsgeschwindigkeit pro Minute',
              ],
              series_keys: ['SUM'],
              series: ['Anzahl'],
              options: {
                chart: {
                  type: 'line',
                },
              },
              yaxis: {
                title: {
                  text: 'Anzahl richtig gelöster Items',
                },
                min: 0,
              },
            },
          ],
        }

        return a
      },

      downloadZIP: async function () {
        const zip = new JSZip()

        const questionType = this.allData.questionType
        const fileName = this.allData.properties.shorthand

        let scripts, styles, html
        try {
          fetch(`assets/${questionType}/test.js`).then(res => (scripts = res.text()))
          fetch(`assets/${questionType}/test.css`).then(res => (styles = res.text()))
          fetch(`assets/${questionType}/test.html`).then(res => (html = res.text()))

          if (scripts) {
            zip.folder('scripts').file('test.js ', scripts)
          }
          if (styles) {
            zip.folder('styles').file('test.css', styles)
          }
          if (html) {
            zip.file('test.html', html)
          }
        } catch (e) {
          console.warn('Error getting test specific files. Probably none are needed.')
        }

        const items = this.questions.reduce((acc, item) => {
          delete item.type
          acc[`I${item.id}`] = { ...item, id: `I${item.id}` }
          return acc
        }, {})

        const renderer = testDefinitions[this.allData.questionType].renderer

        const requiredServices = [
          `${renderer}`,
          'timer',
          'v2/content_page',
          'v2/save_result',
          'v2/start_page',
          'v2/end_page',
          'v2/test_controller',
        ]
        if (this.properties.show_feedback) {
          requiredServices.push('v2/feedback')
        }
        if (this.properties.show_demo_task) {
          requiredServices.push('v2/demo_item')
        }

        const json = JSON.stringify({
          ...this.getProperties(),
          required_services: requiredServices,
          configuration: this.getConfiguration(),
          items: items,
        })

        zip.file('test.json', json)

        this.allData.assets.forEach(asset => {
          zip.folder('media').file(asset.name, asset)
        })

        zip.generateAsync({ type: 'blob' }).then(function (content) {
          const url = URL.createObjectURL(content)

          const link = document.createElement('a')
          link.href = url
          link.download = fileName + '.zip'
          link.click()
        })
      },
    },
  }
</script>
