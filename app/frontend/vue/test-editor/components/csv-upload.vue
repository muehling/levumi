<template>
  <div>
    <div>
      Bitte lade hier eine .csv-Datei mit den einzelnen Fragen/Aufgaben hoch.
      <csv-help :type="questionType" />
    </div>

    <b-form-file
      id="fileUploader"
      ref="fileUpload"
      v-model="csv"
      class="dropArea my-3"
      :class="{ dropAreaDropped: isCsvChecked }"
      :state="isCsvChecked"
      accept="text/csv"
      placeholder="Datei auswählen oder hier ablegen"
      drop-placeholder="Datei hier ablegen" />
    <div v-if="checkedLines !== undefined">
      <b-card>
        <span>
          Es scheint, als gäbe es Fehler in der csv-Datei. Bitte überprüfe die Tabelle: Zellen mit
          <i class="fas fa-x text-danger"></i>
          sind falsch definiert (siehe Hinweise zur CSV-Struktur). Leere oder zuvielene Zellen sind
          wahrscheinlich auf zuviele oder zuwenige Zeilenumbrüche in der CSV zurückzuführen.
        </span>
        <table>
          <thead>
            <tr>
              <td></td>
              <td v-for="(header, index) in checkedLines[0]" :key="index" class="px-2">
                Spalte {{ index + 1 }}
              </td>
            </tr>
          </thead>
          <tr v-for="(row, rowIndex) in checkedLines" :key="rowIndex">
            <td>Zeile {{ rowIndex + 1 }}</td>
            <td
              v-for="(cell, colIndex) in row"
              :key="colIndex"
              :class="`${cell ? 'true' : 'false'} px-2 text-center`">
              <i v-if="cell === true" class="fas fa-check text-success"></i>
              <i v-if="cell === false" class="fas fa-x text-danger"></i>
            </td>
          </tr>
        </table>
      </b-card>
    </div>
    <b-button :disabled="!csv" class="m-1 mt-3" @click="checkCsv">
      <i class="fa-solid fa-magnifying-glass"></i>
      Datei überprüfen und fortfahren
    </b-button>

    <b-button class="m-1" @click="debug">debug</b-button>
    <hr />

    <div v-if="isCsvChecked">
      <p>Laden Sie hier bitte ggf. die benötigten Assets (Bilder, mp3s, etc.) hoch.</p>
      <b-form-file
        id="assetUploader"
        v-model="assets"
        class="dropAreaDropped"
        placeholder="Hier bitte die Dateien hochladen"
        drop-placeholder="Datei hier ablegen"
        multiple
        @change="uploadAssets" />
      <hr />
    </div>
  </div>
</template>
<script>
  import CsvHelp from './csv-help.vue'
  import { testDefinitions } from '../test-definitions'
  import { checkLine } from './line-checker'
  export default {
    name: 'CsvUpload',
    components: { CsvHelp },
    props: { questionType: String, showDemoTask: Boolean },
    data() {
      return {
        csv: undefined,
        data: null,
        isCsvChecked: undefined,
        assets: [],
        checkedLines: undefined,
      }
    },
    computed: {
      fieldConstraints() {
        return testDefinitions[this.questionType]?.fieldConstraints
      },
    },

    methods: {
      async debug() {
        const t = await this.checkCsv(true)
        console.log('debug', this.data, this.questions, this.assets, t)
      },
      async uploadAssets() {
        //todo without the timeout, this.assets is empty at @change. b-form-file is still subject to change, so this might change in the future
        // https://bootstrap-vue-next.github.io/bootstrap-vue-next/docs/components/form-file.html
        setTimeout(() => {
          this.$emit('submit-csv-assets', this.assets)
        }, 200)
      },

      readCsvData() {
        return new Promise((resolve, reject) => {
          const reader = new FileReader()
          reader.readAsText(this.csv)
          reader.onload = () => {
            resolve(reader.result)
            reject(reader.error)
          }
        })
      },

      stringToArray(data) {
        data = data.replace(/(\r\n|\r|\n)/g, '\r\n')
        let array = data.split('\r\n').map(function (line) {
          return line.split(';')
        })

        this.deleteEmptyFields(array)

        if (array[array.length - 1].length === 1) {
          array.pop()
        }
        return array
      },
      deleteEmptyFields(array) {
        array.forEach(line => {
          for (let i = line.length; i > 0; i--) {
            if (line[i] == '' && i != 1) {
              line.splice(i, 1)
            }
          }
        })
      },
      async checkCsv(debug) {
        const dataAsString = await this.readCsvData()
        const data = this.stringToArray(dataAsString)

        const checkResult = data.map(line => {
          const checked = checkLine(line, this.fieldConstraints)

          return checked
        })
        const allClear = checkResult.reduce((acc, line) => {
          return (
            acc &&
            line.reduce((innerAcc, field) => {
              return innerAcc && field
            }, true)
          )
        }, true)

        if (allClear && debug !== true) {
          this.data = data
          this.$emit('submit-csv-data', this.parseData(data))
        } else if (!allClear) {
          //todo wird irgendwo oben für irgendne validierung gebraucht

          this.checkedLines = checkResult
        } else {
          this.checkedLines = checkResult
        }
        this.isCsvChecked = allClear
      },
      parseDimensions(data) {
        const rawDimensions = data.reduce((acc, d) => {
          const dimName = d[0].trim()
          if (dimName) {
            acc[dimName] = true
          }
          return acc
        }, {})
        return Object.keys(rawDimensions).map((d, i) => ({ id: i + 1, text: d }))
      },
      parseMultipleChoice(data) {
        const dimensions = this.parseDimensions(data)

        const parsed = data.map((d, i) => {
          if (d.length === 1) {
            return null
          }
          let correctAnswer
          try {
            correctAnswer = JSON.parse(d[3])
          } catch (e) {
            correctAnswer = d[3]
          }

          const parseAnswer = a => {
            let f
            try {
              f = JSON.parse(a) //needed for answers with custom styles
              return f
            } catch (e) {
              return a
            }
          }
          let wrongAnswers
          if (d[4].includes('|')) {
            wrongAnswers = d[4].split('|').map(g => {
              return parseAnswer(g)
            })
          } else {
            wrongAnswers = [parseAnswer(d[4])]
          }

          return {
            id: i + 1,
            group: dimensions.find(dim => dim.text === d[0].trim())?.id || 0,
            assets: d[1],
            question: d[2],
            correctAnswer,
            wrongAnswers,
          }
        })

        return { questions: parsed.filter(p => !!p), dimensions }
      },
      parseBlitzReading(data) {
        const mcPart = this.parseMultipleChoice(data)
        const test = mcPart.questions.map((line, index) => {
          return { ...line, timeout: data[index][5] }
        })
        return { ...mcPart, questions: test }
      },

      parseNumberInput(data) {
        const dimensions = this.parseDimensions(data)
        const parsed = data.map((d, i) => {
          let firstNumber, secondNumber, correctAnswer, question
          switch (d[5]) {
            case '1':
              firstNumber = `${d[3]}`
              secondNumber = `${d[4]}`
              correctAnswer = `${d[1]}`
              question = `(${d[1]}) ${d[2]} ${d[3]} = ${d[4]}`
              break
            case '2':
              firstNumber = `${d[1]}`
              secondNumber = `${d[4]}`
              correctAnswer = `${d[3]}`
              question = `${d[1]} ${d[2]} (${d[3]}) = ${d[4]}`
              break
            case '3':
              firstNumber = `${d[1]}`
              secondNumber = `${d[3]}`
              correctAnswer = `${d[4]}`
              question = `${d[1]} ${d[2]} ${d[3]} = (${d[4]})`
              break
          }
          return {
            id: i + 1,
            group: dimensions.find(dim => dim.text === d[0].trim())?.id || 0,
            question,
            firstNumber,
            operation: d[2],
            secondNumber,
            correctAnswer,
            inputPosition: d[5],
          }
        })

        return { questions: parsed, dimensions }
      },
      parseMathTextProblem(data) {
        const dimensions = this.parseDimensions(data)
        const parsed = data.map((d, i) => {
          return {
            id: i + 1,
            group: dimensions.find(dim => dim.text === d[0].trim())?.id || 0,
            question: d[1],
            shortQuestion: d[2],
            correctAnswer: d[3],
          }
        })
        return { questions: parsed, dimensions }
      },
      parseAudioImageMultipleChoice(data) {
        const dimensions = this.parseDimensions(data)
        const parsed = data.map((d, i) => {
          return {
            id: i + 1,
            group: dimensions.find(dim => dim.text === d[0].trim())?.id || 0,
            question: d[1],
            audio: d[2],
            correctAnswer: d[3],
            wrongAnswers: d[4],
            assets: `${d[2]},${d[3]},${d[4]}`,
          }
        })
        return { questions: parsed, dimensions }
      },

      parseData(data) {
        switch (this.questionType) {
          case 'multiple_choice':
            return this.parseMultipleChoice(data)
          case 'number_input':
            return this.parseNumberInput(data)
          case 'audio_images_multiple_choice':
            return this.parseAudioImageMultipleChoice(data)
          case 'math_text_problem':
            return this.parseMathTextProblem(data)
          case 'blitz_reading':
            return this.parseBlitzReading(data)
          default:
            console.warn('Unbekannte Testart :-(')
        }
      },
      isValidFileName(name) {
        return (
          !name.includes(' ') &&
          !name.includes("'") &&
          !name.includes('"') &&
          !name.includes('<') &&
          !name.includes('>') &&
          !name.includes('(') &&
          !name.includes(')') &&
          !name.includes('ß') &&
          !name.includes('ü') &&
          !name.includes('ä') &&
          !name.includes('ö')
        )
      },
      stringIsValid: function (string) {
        return string !== ''
      },
    },
  }
</script>
