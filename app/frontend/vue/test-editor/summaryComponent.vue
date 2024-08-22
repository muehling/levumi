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
      Test erstellen und herunterladen
      <b-icon icon="download"></b-icon>
    </b-button>
    <b-button class="ml-2" @click="printAll">debug</b-button>
  </b-card>
</template>

<script>
  import JSZip from 'jszip'
  export default {
    props: { allData: Object },

    data() {
      return {
        idAdded: false,
      }
    },

    computed: {
      isMultipleChoice() {
        return this.allData.questionType === 'multiple_choice'
      },
      isTrueOrFalse() {
        return this.allData.questionType === 'trueOrFalse'
      },
      isGapText() {
        return this.allData.questionType === 'gapText'
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
      printAll: function () {
        console.log(this.allData)
      },

      printQuestions: function () {
        console.log(this.allData.questions)
      },
      getProps: function () {
        return JSON.stringify(this.properties)
      },
      getConfiguration: function () {
        const a = {
          start_page: this.startPage,
          end_page: this.endPage,
          time_limit: this.properties.time_limit,
          dimensions: this.allData.dimensions,
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

        const [response1, response2, response3] = await Promise.all([
          fetch(`assets/${questionType}/test.js`),
          fetch(`assets/${questionType}/test.css`),
          fetch(`assets/${questionType}/test.html`),
        ])

        const items = this.questions.reduce((acc, item) => {
          delete item.type
          acc[`I${item.id}`] = { ...item, id: `I${item.id}` }
          return acc
        }, {})

        const scripts = await response1.text()
        const styles = await response2.text()
        const html = await response3.text()
        const json = JSON.stringify({
          ...this.properties,
          required_services: [
            `${this.allData.questionType}`,
            'timer',
            'content_page',
            'save_result',
            'start_page',
            'end_page',
          ],
          configuration: this.getConfiguration(),
          items: items,
        })

        zip.folder('scripts').file('test.js ', scripts)
        zip.folder('styles').file('test.css', styles)
        zip.file('test.html', html)
        zip.file('test.json', json)

        this.allData.images.forEach(image => {
          zip.folder('media').file(image.name, image)
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
