<template>
  <div>
    <div class="dataInfoText">
      Bitte laden Sie hier eine .CSV-Datei mit den einzelnen Fragen/Aufgaben hoch.
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
    <b-form-invalid-feedback class="defaultFeedbackData" :state="isCsvChecked">
      {{ `Die Datei daf keines der folgenden Zeichen enthalten: <, >, " oder '` }}
      <br />
      Auch sind Felder, die ausschließlich Leerzeichen enthalten nicht erlaubt.
      <br />
    </b-form-invalid-feedback>
    <b-button :disabled="!csv" class="m-1" @click="checkCsv">
      <i class="fa-solid fa-magnifying-glass"></i>
      Datei überprüfen und fortfahren
    </b-button>
    <!--<b-button class="m-1 d-none" @click="debug">debug</b-button>-->
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
  export default {
    name: 'CsvUpload',
    components: { CsvHelp },
    props: { questionType: String, showDemoTask: Boolean },
    data() {
      return {
        csv: undefined,
        data: null,
        isCsvChecked: null,
        assets: [],
      }
    },
    computed: {},

    methods: {
      debug() {
        console.log('debug', this.data, this.questions, this.assets)
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
      async checkCsv() {
        const dataAsString = await this.readCsvData()
        const data = this.stringToArray(dataAsString)

        const checkResult = data.reduce((linesOkaySoFar, line) => {
          const lineHasInvalidFields = true //line.reduce((fieldsOkaySoFar, field, index) => {
          //  if (index !== 0 && index !== 1) {
          //    return fieldsOkaySoFar && this.stringIsValid(field)
          //  } else if (index === 1) {
          //    return fieldsOkaySoFar && this.isValidCsvName(field)
          //  } else {
          //    return fieldsOkaySoFar
          //  }
          //}, true)
          return linesOkaySoFar && lineHasInvalidFields
        }, true)

        if (checkResult) {
          this.data = data
          this.$emit('submit-csv-data', this.parseData(data))
        }

        this.isCsvChecked = checkResult
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
          return {
            id: i + 1,
            group: dimensions.find(dim => dim.text === d[0].trim())?.id || 0,
            assets: d[1],
            question: d[2],
            correctAnswer: d[3],
            wrongAnswers: d[4].split(','),
          }
        })
        return { questions: parsed, dimensions }
      },

      parseNumberInput(data) {
        const dimensions = this.parseDimensions(data)
        const parsed = data.map((d, i) => {
          let firstNumber, secondNumber, correctAnswer
          switch (d[5]) {
            case '1':
              firstNumber = `${d[3]}`
              secondNumber = `${d[4]}`
              correctAnswer = `${d[1]}`
              break
            case '2':
              firstNumber = `${d[1]}`
              secondNumber = `${d[4]}`
              correctAnswer = `${d[3]}`
              break
            case '3':
              firstNumber = `${d[1]}`
              secondNumber = `${d[3]}`
              correctAnswer = `${d[4]}`
              break
          }
          return {
            id: i + 1,
            group: dimensions.find(dim => dim.text === d[0].trim())?.id || 0,
            question: `${d[1]} ${d[2]} ${d[3]} = ${d[4]}`,
            firstNumber,
            operation: d[2],
            secondNumber,
            correctAnswer,
            inputPosition: d[5],
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
          default:
            console.log('Unbekannte Testart :-(')
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
