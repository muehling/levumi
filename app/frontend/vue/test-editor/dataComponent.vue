<template>
  <b-card class="dataApp" :title="`${questionTypeLabel}: Start-/Endseite/Daten definieren`">
    <div class="dataInfoText">
      In diesem Abschnitt können Sie die Start- und Endseite des Tests sowie die einzelnen Fragen
      und Antworten definieren. Klicken Sie auf die einzelnen Abschnitte, um diese zu bearbeiten.
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
        <csv-upload
          :question-type="questionType"
          @submit-csv-data="addCsvData"
          @submit-csv-assets="addCsvAssets" />
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
      <b-button class="ml-2 d-none" @click="prepareData">debug</b-button>
    </div>
  </b-card>
</template>

<script>
  import ContentInput from './components/content-input.vue'
  import CsvUpload from './components/csv-upload.vue'
  import difference from 'lodash/difference'
  import { useGlobalStore } from 'src/store/store'
  import { testDefinitions } from './test-definitions.js'

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
        assets: [],
        dimensions: [],
      }
    },
    computed: {
      questionTypeLabel() {
        return testDefinitions[this.questionType]?.label
      },
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
          if (question.asset != null) {
            if (!this.checkIfAssetIsStored(question.asset.name)) {
              this.assets.push(question.asset)
            }
            question.asset = question.asset.name
          }
        })
        this.questions = data
      },

      addCsvData(data) {
        this.questions = data.questions
        this.dimensions = data.dimensions
      },

      addCsvAssets(assets) {
        assets.forEach(asset => {
          if (!this.checkIfAssetIsStored(asset.name)) {
            this.assets.push(asset)
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
        } else if (element.type === 'asset') {
          return acc && element.asset instanceof File
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

      storeAssets: function () {
        this.startPage.concat(this.endPage).forEach(el => {
          if (el.type === 'asset' && !this.checkIfAssetIsStored(el.asset.name)) {
            this.assets.push(el.asset)
            const imgName = el.asset.name
            el.asset = imgName // replace the File object with just the name
          }
        })
      },

      prepareData() {
        const staticPagesAreValid = this.checkStaticPages()

        const assetsInQuestions = this.questions.reduce((acc, question) => {
          let assets
          if (question.assets) {
            assets = question.assets.split(',')
          }
          return acc.concat(assets)
        }, [])

        const assetsInStaticPages = this.startPage
          .filter(el => el.type === 'asset')
          .concat(this.endPage.filter(el => el.type === 'asset'))
          .map(el => el.asset)

        const missingAssetsInStaticPages = assetsInStaticPages.filter(img => !img)

        // remove duplicates via `...new Set(...)`
        const allAssets = [...new Set(assetsInQuestions), ...new Set(assetsInStaticPages)].filter(
          asset => asset !== undefined
        )

        let uploadedAssets = this.assets.filter(file => file).map(file => file.name)

        const missingAssets = difference(allAssets, uploadedAssets)
        const redundantAssets = difference(uploadedAssets, allAssets)

        // remove redundant assets
        if (redundantAssets.length) {
          uploadedAssets = uploadedAssets.filter(
            asset => redundantAssets.findIndex(img => img === asset?.name) !== -1
          )
        }

        return { missingAssets, redundantAssets, missingAssetsInStaticPages }
      },

      sendDataAndcontinueToSummary: function () {
        this.storeAssets()

        const { missingAssets, redundantAssets, missingAssetsInStaticPages } = this.prepareData()

        if (missingAssets.length) {
          this.store.setErrorMessage(
            `Folgende Dateien sind in den Eingabedaten definiert, wurden jedoch nicht hochgeladen: 
            \r\n${missingAssets.join('\r\n')}
            \r\nBitte fügen Sie diese auf dem Tab 'Fragen' hinzu.`
          )
          return
        }
        if (missingAssetsInStaticPages.length) {
          this.store.setErrorMessage(
            'Auf der Start- oder Endseite wurde Bild-Elemente definiert, jedoch keine Bilder hochgeladen.'
          )
          return
        }

        if (redundantAssets.length) {
          this.store.setGenericMessage({
            message: `Folgende Dateien wurden hochgeladen, sind jedoch nicht in den Eingabedaten definiert: 
          \r\n${redundantAssets.join('\r\n')}
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

        this.$emit('continueToSummary', [data, this.assets])
      },

      addGroupIfMissing() {
        this.questions.forEach(item => {
          if (!item.group) {
            item.group = 1
          }
        })
      },

      checkIfAssetIsStored(assetName) {
        this.assets.forEach(asset => {
          if (asset.name === assetName) {
            return true
          }
        })
        return false
      },
    },
  }
</script>
