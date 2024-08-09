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
      <b-button @click="load">Laden</b-button>
      <b-button @click="save">Speichern</b-button>
    </div>
    <b-tabs v-model="currentTab" content-class="mt-3" justified pills>
      <b-tab title="Startseite" active>
        <hr />
        <div class="dataInfoText">
          Hier können Sie die Startseite Ihres Tests konfigurieren. Klicken Sie einfach auf das mit
          <b>+</b>
          gekennzeichnete Feld, um Überschriften, Texte oder Bilder hinzuzufügen. Sie können bereits
          hinzugefügte Inhalte mit Hilfe der Pfeile neu anordnen. Über die Schaltfläche "Vorschau
          zeigen" können Sie sich eine Vorschau ausgeben lassen, die die grundlegende Startseite des
          Tests darstellt. Jede Startseite enthält eine Schlatfläche am Ende, über die der Test
          gestartet werden kann. Sollten der Startseite keine Inhalte hinzugefügt werden, bekommt
          der Test eine generische Startseite.
        </div>
        <hr />
        <div :key="positionId" class="editorArea">
          <div v-for="(item, index) in startPage" :key="index" class="d-flex">
            <content-input
              :key="item.id"
              :item="item"
              :dimensions="dimensions"
              @update-element="updateElement"
              @move-element="moveElement"
              @delete-element="deleteElement" />
          </div>
          <hr />
          <div class="text-center">
            <b-button class="mr-3" @click="showModal('start')">Element hinzufügen</b-button>
            <b-button
              v-if="welcomeArrayHasInput"
              class="previewButton"
              @click="previewPage('start')">
              Vorschau zeigen
            </b-button>
          </div>
        </div>
      </b-tab>

      <b-tab title="Fragen">
        <hr />

        <b-tabs content-class="mt-3" align="center">
          <b-tab title="Daten eingeben" active>
            <div v-for="item in questions" :key="item.id" class="questionElement">
              <item-input
                :item="item"
                :dimensions="dimensions"
                @update-item="updateItem"
                @delete-item="deleteItem" />
            </div>
            <b-button @click="addItem">Item hinzufügen</b-button>
          </b-tab>
          <b-tab title="Datei hochladen">
            <csv-upload />
          </b-tab>
        </b-tabs>
      </b-tab>

      <b-tab title="Schlussseite">
        <hr />
        <div class="dataInfoText">
          Hier können Sie die Endseite Ihres Tests konfigurieren. Klicken Sie einfach auf das mit
          <b>+</b>
          gekennzeichnete Feld, um Überschriften, Texte oder Bilder hinzuzufügen. Sie können bereits
          hinzugefügte Inhalte mit Hilfe der Pfeile neu anordnen. Über die Schaltfläche "Vorschau
          zeigen" können Sie sich eine Vorschau ausgeben lassen, die die grundlegende Endseite des
          Tests darstellt. Jede Endseite enthält eine Schlatfläche am Ende, über die der Test
          beendet werden kann. Sollten der Endseite keine Inhalte hinzugefügt werden, bekommt der
          Test eine generische Endseite.
        </div>

        <div :key="positionId" class="editorArea">
          <div v-for="(item, index) in endPage" :key="index" class="d-flex">
            <content-input
              :key="item.id"
              :item="item"
              :index="index"
              @update-element="updateElement"
              @move-element="moveElement"
              @delete-element="deleteElement" />
          </div>
          <hr />
          <div class="text-center">
            <b-button class="mr-3" @click="showModal('end')">Element hinzufügen</b-button>
            <b-button v-if="welcomeArrayHasInput" class="previewButton" @click="previewPage('end')">
              Vorschau zeigen
            </b-button>
          </div>
        </div>
      </b-tab>
    </b-tabs>

    <b-modal ref="previewModal" size="xl" centered hide-footer title="So wird die Seite aussehen">
      <div ref="previewModalContent" class="d-block text-center" v-html="previewContent"></div>
    </b-modal>

    <b-modal
      ref="chooseDataOriginModal"
      size="xl"
      centered
      hide-footer
      title="Sie haben sowohl eine CSV-Datei hochgeladen, als auch manuell Fragen eingefügt, wie möchten Sie fortfahren?">
      <div class="dataOriginGrid">
        <button
          class="chooseDataOriginButton manual"
          @click="sendDataAndcontinueToSummary('manual')">
          Die manuellen Daten verwenden
        </button>
        <button class="chooseDataOriginButton csv" @click="sendDataAndcontinueToSummary('csv')">
          Die CSV-Daten verwenden
        </button>
      </div>
    </b-modal>

    <!-- This modal is shown if there is any issue with the input or not input content. It also gives further information where the issue was found and what might be the cause -->
    <b-modal ref="falsyDataOrPageModal" size="xl" hide-footer title="Fehler">
      <div v-if="!isValidPagesForContinue()" class="falseDataText">
        <p class="text-center">Es wurden Fehler auf der Start- oder Endseite gefunden.</p>
      </div>
      <div v-if="!isValidInputForContinue()" class="falseDataText">
        <p class="text-center">Es wurden Fehler in den zusammengeklickten Items gefunden.</p>
      </div>
      <div v-if="!isValidFileForContinue()" class="falseDataText">
        <p class="text-center">Es wurden Fehler in der hochgeladenen CSV-Datei gefunden-</p>
      </div>
    </b-modal>

    <!-- This modal shows all available elements to add to the welcome and end page. New elements like audio or video need to be added here. -->
    <b-modal ref="addElementModal" size="sm" centered hide-footer title="Element auswählen">
      <div class="d-block text-center">
        <!-- Adds h1 tags for headings -->
        <b-button variant="outline-secondary" class="w-100 mb-3" @click="addElementToPage('h1')">
          <h1>Überschrift</h1>
        </b-button>
        <br />
        <!-- Adds h3 tags for normal text -->
        <b-button variant="outline-secondary" class="w-100 mb-3" @click="addElementToPage('h3')">
          <h3>Unterüberschrift</h3>
        </b-button>
        <br />
        <!-- Adds p tags for long text -->
        <b-button variant="outline-secondary" class="w-100 mb-3" @click="addElementToPage('p')">
          Fließtext
        </b-button>
        <br />
        <!-- Adds an img tag -->
        <b-button variant="outline-secondary" class="w-100 mb-3" @click="addElementToPage('image')">
          Bild
        </b-button>
      </div>
    </b-modal>

    <div v-if="dataWasUploaded">
      <hr />
      <b-button class="dataContinueButton continueButton" @click="checkForValidData()">
        Weiter zur Zusammenfassung
        <b-icon icon="arrow-right"></b-icon>
      </b-button>
    </div>
  </div>
</template>

<script>
  import ContentInput from './components/content-input.vue'
  import ItemInput from './components/item-input.vue'
  import CsvUpload from './components/csv-upload.vue'
  export default {
    components: { CsvUpload, ContentInput, ItemInput },
    props: { questionType: String, dimensions: Array },
    data() {
      return {
        currentTab: 0,
        dataArray: null,
        currentMaxId: 0,
        startPage: [],
        endPage: [],
        previewContent: null,
        file: null,
        questions: [{ id: -1, type: this.questionType, question: '' }],
        currentQuestionId: 0,
        images: [],
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

      welcomeArrayHasInput() {
        return this.startPage.length != 0
      },
      endArrayHasInput() {
        return this.endPage.length != 0
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
        this.questions = settings.questions
        this.startPage = settings.startPage
        this.endPage = settings.endPage
        this.currentQuestionId = settings.questions.length - 1
        this.currentMaxId = settings.startPage?.length + settings.endPage?.length
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
      addItem() {
        this.questions.push({ id: ++this.currentQuestionId, question: '', type: this.questionType })
      },
      updateItem(item) {
        this.questions = this.questions.map(q => (q.id === item.id ? item : q))
      },
      deleteItem(id) {
        this.questions = this.questions.filter(q => q.id !== id)
      },
      updateElement(item) {
        switch (this.currentTab) {
          case 0:
            this.startPage = this.startPage.map(el => (el.id === item.id ? item : el))
            break
          case 2:
            this.endPage = this.endPage.map(el => (el.id === item.id ? item : el))
        }
      },

      showModal() {
        this.$refs['addElementModal'].show()
      },

      addElementToPage(contentType) {
        if (this.currentTab === 0) {
          this.startPage.push({
            type: contentType,
            text: '',
            id: this.currentMaxId++,
            position: this.startPage.length,
          })
        } else if (this.currentTab === 2) {
          this.endPage.push({
            type: contentType,
            text: '',
            id: this.currentMaxId++,
            position: this.endPage.length,
          })
        }
        this.$refs['addElementModal'].hide()
      },

      moveElement(itemId, direction) {
        let source, target, temp
        switch (this.currentTab) {
          case 0:
            source = this.startPage.find(el => el.id === itemId)
            target = this.startPage.find(el => el.position === source.position + direction)
            temp = source.position
            source.position = source.position + direction
            target.position = temp
            this.startPage.sort((a, b) => (a.position < b.position ? -1 : 1))
        }
      },

      deleteElement(itemId) {
        if (this.currentTab === 0) {
          this.startPage = this.startPage
            .filter(el => el.id !== itemId)
            .map((el, index) => {
              el.position = index
              return el
            })
        } else {
          this.endPage = this.endPage
            .filter(el => el.id !== itemId)
            .map((el, index) => {
              el.position = index
              return el
            })
        }
      },

      previewPage() {
        let buttonContent = 'Test starten'
        if (this.currentTab === 2) {
          buttonContent = 'Test beenden'
        }
        this.previewContent =
          '<div class = "previewContainer">' +
          this.generateHTMLforPreview() +
          '<button style = "margin: 2rem">' +
          buttonContent +
          '</button></div>'
        this.$refs['previewModal'].show()
        this.addImagesToPreview()
      },

      generateHTMLforPreview: function () {
        let data
        if (this.currentTab === 0) {
          data = this.startPage
        } else {
          data = this.endPage
        }
        return data.reduce((string, currentLine, index) => {
          if (currentLine.type == 'image') {
            return (string +=
              '<div id="imageContainer' + index + '" class = "imageContainer"></div><br>')
          } else {
            return (string +=
              '<' + currentLine.type + '>' + currentLine.text + '</' + currentLine.type + '><br>')
          }
        }, '<div>')
      },

      addImagesToPreview: function () {
        let arrayToWorkWith
        if (this.currentTab === 0) {
          arrayToWorkWith = this.startPage
        } else {
          arrayToWorkWith = this.endPage
        }
        arrayToWorkWith.forEach((element, index) => {
          if (element.type == 'image') {
            let reader = new FileReader()
            reader.onload = function (e) {
              let img = new Image()
              img.src = e.target.result
              document.getElementById('imageContainer' + index).appendChild(img)
            }
            reader.readAsDataURL(element.image)
          }
        })
      },

      //////////////
      // Data Tab //
      //////////////

      /**
       * Checks whether the given string is empty or containes unallowed characters.
       * @param {*} string The string that is to be examined for unallowed content.
       * @returns Returns whether the string is valid or not.
       */
      stringIsValid: function (string) {
        if (
          !(
            !string == '' &&
            !string.includes("'") &&
            !string.includes('"') &&
            !string.includes('<') &&
            !string.includes('>')
          )
        ) {
          return false
        } else {
          return true
        }
      },

      /**
       * Checks if there is data in the input interface or the upload interface or both. Depending on the constellation it also checks the validity of the data.
       * If there are errors in the data, it shows a modal with further information.
       * If there is input both in the manual interface and the file upload it asks the user what data to choose or to merge them.
       * If everything is okay or the user chose what data to use, the summaryComponetn is shown where the user can download the file.
       */
      checkForValidData: function () {
        switch (this.stateOfData()) {
          case 'onlyOneDataSubmitted':
            if (
              this.isValidFileForContinue() &&
              this.isValidInputForContinue() &&
              this.isValidPagesForContinue()
            ) {
              if (this.file != null) {
                this.sendDataAndcontinueToSummary('csv')
              } else {
                this.sendDataAndcontinueToSummary('manual')
              }
            } else {
              this.$refs['falsyDataOrPageModal'].show()
            }
            break
          case 'bothDataSubmitted':
            if (
              this.isValidFileForContinue() &&
              this.isValidInputForContinue() &&
              this.isValidPagesForContinue()
            ) {
              this.$refs['chooseDataOriginModal'].show()
            } else {
              this.$refs['falsyDataOrPageModal'].show()
            }
            break
        }
      },

      /**
       * Checks if there is an uploaded file and/or input data in the question interface.
       * @returns In which state the data is: Only manual data, only CSV file or both.
       */
      stateOfData: function () {
        if (this.isEmptyManualQuestions && this.file == null) {
          return 'noDataSubmitted'
        } else if (!this.isEmptyManualQuestions && this.file != null) {
          return 'bothDataSubmitted'
        } else {
          return 'onlyOneDataSubmitted'
        }
      },

      /**
       * Checks if the data that was input in the question interface is valid. It also returns true if there is no input for simplicity reasons in the @checkForValidData method and a modal where it is used with a v-if.
       * @returns Returns whether the questions that were input via the interface are valid.
       */
      isValidInputForContinue: function () {
        if (this.isEmptyManualQuestions) {
          return true
        } else {
          // Naive approach, not efficient but works for the moment: TODO implement reduce
          let isValid = true
          /*  this.inputDataArray.forEach(question => {
            if (isValid && (this.isMultipleChoice || this.isGapText)) {
              isValid =
                (question[1] == null || this.isValidFileName(question[1].name)) &&
                question[2] != null &&
                question[2] != '' &&
                question[3] != null &&
                question[3] != '' &&
                question[4] != null &&
                question[4] != ''
            } else {
              isValid =
                (question[1] == null || this.isValidFileName(question[1].name)) &&
                question[2] != null &&
                question[2] != '' &&
                question.length == 4
            }
          })*/
          return isValid
        }
      },

      /**
       * Checks if there is a file and if so if it has valid content. If there is no file it still returns true in order to continue with the manually input data. So it only returns false if thre is invalid data.
       * @returns Returns if there is no invalid data.
       */
      isValidFileForContinue: function () {
        if (this.file == null) {
          return true
        } else {
          // If was needed because it would throw a "TypeError: this.dataArray is not iterable" because at the moment of computing the dataArray is not computed yet. Called because this is used in a v-if in the falsyDataOrPageModal.
          if (this.dataArray != null) {
            return this.fileHasValidContent()
          } else {
            return true
          }
        }
      },

      /**
       * Checks if the welcome and end pages are valid. It does so by reducing the element to a boolean value if all previous elements were valid. Could have been implemented with a combined reduce function but has two seperate for readability reasons.
       * @returns Returns whether both the welcome and the end page have valid content. I. e. no empty text fields or unallowed characters.
       */
      isValidPagesForContinue: function () {
        const welcomeIsOkay = this.startPage.reduce((okaySoFar, element) => {
          if (element.type == 'h1' || element.type == 'h3' || element.type == 'p') {
            return okaySoFar && this.stringIsValid(element.text)
          } else {
            return okaySoFar && true
          }
        }, true)

        const endIsOkay = this.endPage.reduce((okaySoFar, element) => {
          if (element.type == 'h1' || element.type == 'h3' || element.type == 'p') {
            return okaySoFar && this.stringIsValid(element.text)
          } else {
            return okaySoFar && true
          }
        }, true)

        return welcomeIsOkay && endIsOkay
      },

      /**
       * If there is input in both the interface and the file upload, the user chooses one of them.
       * The function also adds the images of the questions to the image property,
       * This method then emits an event that triggers the page to continue to the summary view.
       * @param {} data
       */
      sendDataAndcontinueToSummary: function (d) {
        this.storeImages()
        let data

        if (d == 'manual') {
          this.addGroupIfMissing('manual')

          for (let i = 0; i < this.questions.length; i++) {
            if (this.questions[i].image != null) {
              if (!this.checkIfImageIsStored(this.questions[i].image.name)) {
                this.images.push(this.questions[i].image)
              }
              this.questions[i].image = this.questions[i].image.name
            }
          }
          data = {
            questions: this.questions,
            startPage: this.startPage,
            endPage: this.endPage,
          }
          this.$emit('continueToSummary', [data, this.images])
        } else {
          this.addGroupIfMissing('csv')

          var fileInput = document.getElementById('imageUploader')
          for (let i = 0; i < fileInput.files.length; i++) {
            if (!this.checkIfImageIsStored(fileInput.files[i].name)) {
              this.images.push(fileInput.files[i])
            }
          }
          data = {
            questionType: this.questionType,
            questions: this.dataArray,
            startPage: this.startPage,
            endPage: this.endPage,
          }
          this.$emit('continueToSummary', [data, this.images])
        }
      },

      storeImages: function () {
        this.startPage.concat(this.endPage).forEach(el => {
          if (el.type === 'image' && !this.checkIfImageIsStored(el.image.name)) {
            this.images.push(el.image)
          }
        })
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
