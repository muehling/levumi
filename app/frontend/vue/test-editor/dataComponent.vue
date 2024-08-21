<template>
  <div class="dataApp">
    <h2>Fragen erstellen</h2>
    <div class="dataInfoText">
      In diesem Abschnitt können Sie die Start- und Endseite des Tests, sowie die einzelnen Fragen
      und Antworten definieren. Klicken Sie auf die einzelnen Abschnitte, um diese zu bearbeiten.
      Sie können sich entscheiden, ob Sie die Fragen einzelnen eingeben, oder eine vorausgefüllte
      CSV-Datei hochladen. Wie dies geht erfahren Sie im Abschnitt "Datei hochladen".
    </div>
    <hr />
    <div class="my-4">
      <b-button class="mr-2" @click="load">Laden</b-button>
      <b-button @click="save">Speichern</b-button>
    </div>
    <b-tabs v-model="currentTab" content-class="mt-3" justified pills>
      <b-tab title="Startseite" active>
        <div :key="positionId + 'startpage'" class="editorArea">
          <content-input
            :key="`startPage-${startPage}`"
            :elements="startPage"
            @update-content="updateStartPage" />
        </div>
      </b-tab>

      <b-tab title="Fragen">
        <hr />

        <!--<b-tabs content-class="mt-3" align="center">
          <b-tab title="Datei hochladen" active> -->
        <csv-upload @submit-csv-data="addCsvData" @submit-csv-images="addCsvImages" />
        <!--  </b-tab>
          <b-tab title="Daten eingeben">
            <manual-item-input :dimensions="dimensions" @submit-items="addManualData" />
          </b-tab>
        </b-tabs> -->
      </b-tab>

      <b-tab title="Schlussseite">
        <div :key="positionId + 'endpage'" class="editorArea">
          <content-input
            :key="`endPage-${startPage}`"
            :elements="endPage"
            @update-content="updateEndPage" />
        </div>
      </b-tab>
    </b-tabs>

    <div v-if="dataWasUploaded">
      <hr />
      <b-button
        class="dataContinueButton continueButton"
        :disabled="!hasQuestions"
        @click="checkForValidData()">
        Weiter zur Zusammenfassung
        <b-icon icon="arrow-right"></b-icon>
      </b-button>
      <b-button class="ml-2" @click="prepareData">debug</b-button>
    </div>
  </div>
</template>

<script>
  import ContentInput from './components/content-input.vue'
  import CsvUpload from './components/csv-upload.vue'
  import difference from 'lodash/difference'
  import isObject from 'lodash/isObject'
  import { useGlobalStore } from 'src/store/store'

  export default {
    components: { CsvUpload, ContentInput },
    props: { questionType: String },
    setup() {
      const store = useGlobalStore()
      return { store }
    },
    data() {
      return {
        currentTab: 0,
        dataArray: null,
        currentMaxId: 0,
        startPage: [],
        endPage: [],
        previewContent: null,
        file: null,
        questions: [],
        currentQuestionId: 0,
        images: [],
        dimensions: [],
      }
    },
    computed: {
      positionId() {
        let a
        switch (this.currentTab) {
          case 0:
            a = this.startPage.reduce((acc, el) => acc + el.id + '/', 'start')
            return a
          case 2:
            return this.endPage.reduce((acc, el) => acc + el.id + '/', 'end')
          default:
            return undefined
        }
      },
      csvHelpType() {
        return this.questionType
      },

      isMultipleChoice() {
        return this.questionType === 'multipleChoice'
      },
      isTrueFalse() {
        return this.questionType === 'trueOrFalse'
      },
      isGapText() {
        return this.questionType === 'gapText'
      },
      dataWasUploaded() {
        return this.fileUploaded || !this.isEmptyManualQuestions
      },
      hasQuestions() {
        return this.questions.length !== 0
      },
    },

    methods: {
      parseSavedData() {
        const s = localStorage.getItem('test-editor-data')
        let settings
        try {
          settings = JSON.parse(s)
          return settings
        } catch (e) {
          console.error('Error parsing saved data', e)
          return undefined
        }
      },
      load() {
        const settings = this.parseSavedData()
        this.questions = settings.questions || []
        this.startPage = settings.startPage
        this.endPage = settings.endPage
      },
      save() {
        const settings = this.parseSavedData()

        const all = {
          ...settings,
          questions: this.questions,
          startPage: this.startPage,
          endPage: this.endPage,
        }
        localStorage.setItem('test-editor-data', JSON.stringify(all))
      },

      updateStartPage(elements) {
        this.startPage = elements
      },
      updateEndPage(elements) {
        this.endPage = elements
      },

      addManualData(data) {
        data.forEach(question => {
          if (question.image != null) {
            if (!this.checkIfImageIsStored(question.image.name)) {
              this.images.push(question.image)
            }
            question.image = question.image.name
          }
        })
        this.questions = data
      },

      addCsvData(data) {
        this.questions = data.questions
        this.dimensions = data.dimensions
      },

      addCsvImages(images) {
        images.forEach(image => {
          if (!this.checkIfImageIsStored(image.name)) {
            this.images.push(image)
          }
        })
      },

      stringIsValid: function (string) {
        return string !== ''
      },

      checkForValidData: function () {
        this.sendDataAndcontinueToSummary('csv')
      },

      checkElement(acc, element) {
        if (element.type == 'h1' || element.type == 'h3' || element.type == 'p') {
          return acc && this.stringIsValid(element.text)
        } else if (element.type === 'image') {
          return acc && element.image instanceof File
        } else {
          return false
        }
      },

      checkStaticPages: function () {
        const startIsOkay = this.startPage.reduce(this.checkElement, true)
        const endIsOkay = this.endPage.reduce(this.checkElement, true)
        return startIsOkay && endIsOkay
      },

      replaceUnsafeCharacters(elArray, prop) {
        const parsed = elArray.map(el => {
          if (el[prop]) {
            //TODO proper handling for " and '

            return {
              ...el,
              [prop]: el[prop]
                .replace(/&/g, '&amp;')
                .replace(/</g, '&lt;')
                .replace(/>/g, '&gt;')
                .replace(/"/g, '&quot;')
                .replace(/'/g, '&#039;'),
            }
          } else {
            return el
          }
        })
        return parsed
      },

      storeImages: function () {
        this.startPage.concat(this.endPage).forEach(el => {
          if (el.type === 'image' && !this.checkIfImageIsStored(el.image.name)) {
            this.images.push(el.image)
            const imgName = el.image.name
            el.image = imgName // replace the File object with just the name
          }
        })
      },

      prepareData() {
        const staticPagesAreValid = this.checkStaticPages()

        const imagesInQuestions = this.questions.reduce((acc, question) => {
          const images = question.image.split(',')
          return acc.concat(images)
        }, [])

        const imagesInStaticPages = this.startPage
          .filter(el => el.type === 'image')
          .concat(this.endPage.filter(el => el.type === 'image'))
          .map(el => el.image)

        const missingImagesInStaticPages = imagesInStaticPages.filter(img => !img)

        // remove duplicates via `...new Set(...)`
        const allImages = [...new Set(imagesInQuestions), ...new Set(imagesInStaticPages)]

        let uploadedImages = this.images.filter(file => file).map(file => file.name)

        const missingImages = difference(allImages, uploadedImages)
        const redundantImages = difference(uploadedImages, allImages)

        // remove redundant images
        if (redundantImages.length) {
          uploadedImages = uploadedImages.filter(
            image => redundantImages.findIndex(img => img === image?.name) !== -1
          )
        }

        return { missingImages, redundantImages, missingImagesInStaticPages }
      },

      sendDataAndcontinueToSummary: function () {
        this.storeImages()

        const { missingImages, redundantImages, missingImagesInStaticPages } = this.prepareData()

        if (missingImages.length) {
          this.store.setErrorMessage(
            `Folgende Bilder sind in den Eingabedaten definiert, wurden jedoch nicht hochgeladen: 
            \r\n${missingImages.join('\r\n')}
            \r\nBitte fügen Sie diese auf dem Tab 'Fragen' hinzu.`
          )
          return
        }
        if (missingImagesInStaticPages.length) {
          this.store.setErrorMessage(
            'Auf der Start- oder Endseite wurde Bild-Elemente definiert, jedoch keine Bilder hochgeladen.'
          )
          return
        }

        if (redundantImages.length) {
          this.store.setGenericMessage({
            message: `Folgende Bilder wurden hochgeladen, sind jedoch nicht in den Eingabedaten definiert: 
          \r\n${redundantImages.join('\r\n')}
          \r\nDiese wurden entfernt.`,
          })
        }

        this.addGroupIfMissing()

        const data = {
          questionType: this.questionType,
          questions: this.replaceUnsafeCharacters(this.questions, 'question'),
          startPage: this.replaceUnsafeCharacters(this.startPage, 'text'),
          endPage: this.replaceUnsafeCharacters(this.endPage, 'text'),
          dimensions: this.replaceUnsafeCharacters(this.dimensions, 'text'),
        }

        this.$emit('continueToSummary', [data, this.images])
      },

      addGroupIfMissing() {
        this.questions.forEach(item => {
          if (!item.group) {
            item.group = 1
          }
        })
      },

      checkIfImageIsStored(imageName) {
        this.images.forEach(image => {
          if (image.name === imageName) {
            return true
          }
        })
        return false
      },
    },
  }
</script>
