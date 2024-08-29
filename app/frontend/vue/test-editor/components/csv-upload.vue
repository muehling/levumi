<template>
  <div>
    <div class="dataInfoText">
      Bitte laden Sie hier eine .CSV-Datei mit den einzelnen Fragen/Aufgaben hoch.
      <csv-help :type="questionType" />
    </div>

    <b-form-file
      id="fileUploader"
      ref="fileUpload"
      v-model="file"
      class="dropArea my-3"
      :class="{ dropAreaDropped: isFileChecked }"
      :state="isFileChecked"
      accept="text/csv"
      placeholder="Datei auswählen oder hier ablegen"
      drop-placeholder="Datei hier ablegen" />
    <b-form-invalid-feedback class="defaultFeedbackData" :state="isFileChecked">
      {{ `Die Datei daf keines der folgenden Zeichen enthalten: <, >, " oder '` }}
      <br />
      Auch sind Felder, die ausschließlich Leerzeichen enthalten nicht erlaubt.
      <br />
    </b-form-invalid-feedback>
    <b-button :disabled="!file" class="m-1" @click="checkFile">
      <i class="fa-solid fa-magnifying-glass"></i>
      Datei überprüfen und fortfahren
    </b-button>
    <b-button class="m-1 d-none" @click="debug">debug</b-button>
    <hr />

    <div v-if="isFileChecked">
      <p>Laden Sie hier bitte ggf. die benötigten Bilder hoch.</p>
      <b-form-file
        id="imageUploader"
        v-model="images"
        class="dropAreaDropped"
        :class="{ imageDropArea: isFileChecked }"
        accept="image/*"
        placeholder="Hier bitte die Bilder hochladen"
        drop-placeholder="Datei hier ablegen"
        multiple
        @input="uploadImages" />
      <hr />
    </div>
  </div>
</template>
<script>
  import CsvHelp from './csv-help.vue'
  export default {
    name: 'CsvUpload',
    components: { CsvHelp },
    props: { questionType: String },
    data() {
      return {
        file: undefined,
        data: null,
        isFileChecked: null,
        images: [],
      }
    },
    computed: {},

    methods: {
      debug() {
        console.log('debug', this.data, this.questions, this.images)
      },
      uploadImages() {
        this.$emit('submit-csv-images', this.images)
      },

      readCsvData() {
        return new Promise((resolve, reject) => {
          const reader = new FileReader()
          reader.readAsText(this.file)
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

        this.deleteEmptyFields(array) // das dürfte quatsch sein

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
      async checkFile() {
        const dataAsString = await this.readCsvData()
        const data = this.stringToArray(dataAsString)

        const checkResult = data.reduce((linesOkaySoFar, line) => {
          const lineHasInvalidFields = true //line.reduce((fieldsOkaySoFar, field, index) => {
          //  if (index !== 0 && index !== 1) {
          //    return fieldsOkaySoFar && this.stringIsValid(field)
          //  } else if (index === 1) {
          //    return fieldsOkaySoFar && this.isValidFileName(field)
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

        this.isFileChecked = checkResult
      },
      parseDimensions(data) {
        const rawDimensions = data.reduce((acc, d) => {
          acc[d[0]] = true
          return acc
        }, {})
        return Object.keys(rawDimensions).map((d, i) => ({ id: i + 1, text: d }))
      },
      parseMultipleChoice(data) {
        const dimensions = this.parseDimensions(data)
        const parsed = data.map((d, i) => {
          return {
            id: i + 1,
            correctAnswer: d[3],
            group: dimensions.find(dim => dim.text === d[0]).id,
            image: d[1],
            question: d[2],
            wrongAnswers: d.slice(4),
          }
        })
        return { questions: parsed, dimensions }
      },

      parseNumberInput(data) {
        const dimensions = this.parseDimensions(data)
        const parsed = data.map((d, i) => {
          return {
            id: i + 1,
            group: dimensions.find(dim => dim.text === d[0]).id,
            question: `${d[1]} ${d[2]} ${d[3]} = ${d[4]}`,
            firstNumber: d[1],
            operation: d[2],
            secondNumber: d[3],
            correctAnswer: d[4],
            inputPosition: d[5],
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
