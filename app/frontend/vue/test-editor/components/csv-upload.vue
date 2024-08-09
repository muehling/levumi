<template>
  <div>
    <div class="dataInfoText">
      Bitte laden Sie hier eine .CSV-Datei mit den einzelnen Fragen/Aufgaben hoch. Wie man eine
      solche Datei erstellt und in welcher Form Sie die Daten eintragen müssen finden Sie weiter
      unten auf dieser Seite. Es findet eine automatische Prüfung der hochgeladenen Datei statt,
      bitte beachten Sie, dass dies keine inhaltliche Prüfung ist, sondern nur nach unerlaubten
      Zeichen ( &lt; , > , " , ' ) und leeren Feldern sucht.
    </div>

    <b-form-file
      id="fileUploader"
      ref="fileUpload"
      v-model="file"
      class="dropArea"
      :class="{ dropAreaDropped: isValidFile }"
      :state="isValidFile"
      accept="text/csv"
      placeholder="Bitte eine Datei auswählen oder hier ablegen"
      drop-placeholder="Datei hier ablegen"
      size="lg"
      plain
      @change="fileToData()"></b-form-file>
    <b-form-invalid-feedback class="defaultFeedbackData" :state="isValidFile">
      {{ `Die Datei daf keines der folgenden Zeichen enthalten: <, >, " oder '` }}
      <br />
      Auch sind Felder, die ausschließlich Leerzeichen enthalten nicht erlaubt.
      <br />
    </b-form-invalid-feedback>
    <b-form-valid-feedback class="defaultFeedbackData" :state="isValidFile">
      Sieht gut aus!
    </b-form-valid-feedback>

    <b-button :disabled="!!file" class="deleteUploadButton" @click="clearFile">
      <i class="fa-solid fa-trash"></i>
      Datei entfernen
    </b-button>
    <b-button :disabled="!!file" @click="checkFile">
      <i class="fa-solid fa-magnifying-glass"></i>
      Datei überprüfen und fortfahren
    </b-button>
    <hr />

    <div v-if="isValidFile">
      <p>Laden Sie hier bitte die einzelnen Bilder hoch.</p>
      <b-form-file
        id="imageUploader"
        class="dropAreaDropped"
        :class="{ imageDropArea: isValidFile }"
        accept="image/*"
        placeholder="Hier bitte die Bilder hochladen"
        drop-placeholder="Datei hier ablegen"
        size="lg"
        plain
        multiple></b-form-file>
      <hr />
    </div>

    <csv-help :type="csvHelpType" />
  </div>
</template>
<script>
  import CsvHelp from './csv-help.vue'
  export default {
    name: 'CsvUpload',
    components: { CsvHelp },
    data() {
      return { file: undefined, csvHelpType: 'multipleChoice', dataArray: null }
    },
    computed: {
      isValidFile() {
        if (!this.dataArray) {
          return null
        } else {
          let result = this.checkFile()
          return result
        }
      },
    },

    methods: {
      clearFile() {
        this.$refs['fileUpload'].reset()
        this.dataArray = null
      },

      fileToData: function () {
        let vm = this //iek
        const [file] = document.getElementById('fileUploader').files
        const reader = new FileReader()
        reader.readAsText(file)
        reader.onload = function () {
          const dataAsString = reader.result
          vm.dataArray = stringToArray(dataAsString)
        }
        // Seperates the string at every line feed character (\r\n) and maps the split function to each resulting line then.
        function stringToArray(data) {
          let delimiter = null
          let comma = (data.match(/,/g) || []).length
          let semi = (data.match(/;/g) || []).length
          if (comma > semi) {
            delimiter = ','
          } else {
            delimiter = ';'
          }
          let refinedData = data.replace(/(\r\n|\r|\n)/g, '\r\n')
          let array = refinedData.split('\r\n').map(function (line) {
            return line.split(delimiter)
          })
          vm.deleteEmptyFields(array)
          if (array[array.length - 1] == '') {
            array.pop()
          }
          return array
        }
      },
      deleteEmptyFields: function (array) {
        array.forEach(line => {
          for (let i = line.length; i > 0; i--) {
            if (line[i] == '' && i != 1) {
              line.splice(i, 1)
            }
          }
        })
      },
      checkFile() {
        let copyOfDataArray = [...this.dataArray]
        const hasInvalidLines = copyOfDataArray.reduce((linesOkaySoFar, line) => {
          const lineHasInvalidFields = line.reduce((fieldsOkaySoFar, field, index) => {
            if (index != 0 && index != 1) {
              return fieldsOkaySoFar && this.stringIsValid(field)
            } else if (index == 1) {
              return fieldsOkaySoFar && this.isValidFileName(field)
            } else {
              return fieldsOkaySoFar && (!isNaN(field) || null || '') //If Group is mandatory: remove null and ""
            }
          }, true)
          if (this.isMultipleChoice || this.isGapText) {
            return linesOkaySoFar && lineHasInvalidFields && 3 < line.length && line.length < 10
          } else {
            return linesOkaySoFar && lineHasInvalidFields && line.length == 4
          }
        }, true)
        return hasInvalidLines
      },
      isValidFileName(name) {
        return (
          !name.includes(' ') &&
          !name.includes("'") &&
          !name.includes('"') &&
          !name.includes('<') &&
          !name.includes('>') &&
          !name.includes('ß') &&
          !name.includes('ü') &&
          !name.includes('ä') &&
          !name.includes('ö')
        )
      },
    },
  }
</script>
