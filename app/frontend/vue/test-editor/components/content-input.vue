<template>
  <div class="d-flex flex-column w-100 mt-3">
    <div v-for="(item, i) in items" :key="item.id">
      <div class="d-flex flex-row mb-3">
        <b-button-group vertical>
          <b-button
            :disabled="canMoveUp(i)"
            variant="outline-secondary"
            @click="moveElement(item.id, -1)">
            <i class="fa-solid fa-arrow-up" aria-hidden="true"></i>
          </b-button>
          <b-button
            :disabled="canMoveDown(i)"
            variant="outline-secondary"
            @click="moveElement(item.id, 1)">
            <i class="fa-solid fa-arrow-down" aria-hidden="true"></i>
          </b-button>
        </b-button-group>
        <div class="flex-grow-1 border mx-4">
          <p class="d-flex m-0">{{ typeDescription(item) }}:</p>
          <b-form-textarea
            v-if="item.type == 'h1'"
            id="input-large"
            rows="2"
            max-rows="4"
            :value="item.text"
            placeholder="Hier bitte den Text eingeben"
            @input="val => updateElement(item, val)" />

          <b-form-textarea
            v-if="item.type == 'h3'"
            placeholder="Hier bitte den Text eingeben"
            rows="2"
            max-rows="4"
            @input="val => updateElement(item, val)" />

          <b-form-textarea
            v-if="item.type == 'p'"
            placeholder="Hier bitte den Text eingeben"
            rows="2"
            max-rows="4"
            :value="item.text"
            @input="val => updateElement(item, val)" />

          <b-form-file
            v-if="item.type == 'asset'"
            :id="`imageUpload${item.id}`"
            accept="image/*"
            class="inputImage"
            size="md"
            :placeholder="item.asset ? item.asset.name : 'Bild hochladen'"
            @input="addPicture(item)" />
        </div>
        <b-button-group vertical>
          <b-button variant="outline-secondary" @click="deleteElement(item.id)">
            <i class="fa-solid fa-xmark" aria-hidden="true" ></i>
          </b-button>
        </b-button-group>
      </div>
    </div>

    <div class="mt-3">
      <b-button class="mr-3" variant="outline-primary" @click="showModal">
        Element hinzufügen
      </b-button>
      <b-button
        v-if="hasInput"
        variant="outline-primary"
        class="previewButton"
        @click="previewPage('start')">
        Vorschau zeigen
      </b-button>
    </div>
    <b-modal ref="addElementModal" size="sm" centered hide-footer title="Element auswählen">
      <div class="d-block text-center">
        <!-- Adds h1 tags for headings -->
        <b-button variant="outline-secondary" class="w-100 mb-3" @click="addElement('h1')">
          <h1>Überschrift</h1>
        </b-button>
        <br />
        <!-- Adds h3 tags for normal text -->
        <b-button variant="outline-secondary" class="w-100 mb-3" @click="addElement('h3')">
          <h3>Unterüberschrift</h3>
        </b-button>
        <br />
        <!-- Adds p tags for long text -->
        <b-button variant="outline-secondary" class="w-100 mb-3" @click="addElement('p')">
          Fließtext
        </b-button>
        <br />
        <!-- Adds an img tag -->
        <b-button variant="outline-secondary" class="w-100 mb-3" @click="addElement('asset')">
          Bild
        </b-button>
      </div>
    </b-modal>
    <b-modal ref="previewModal" size="xl" centered hide-footer title="So wird die Seite aussehen">
      <div ref="previewModalContent" class="d-block text-center" v-html="previewContent"></div>
    </b-modal>
  </div>
</template>
<script>
  import { useGlobalStore } from 'src/store/store'
  export default {
    name: 'ContentInput',
    props: { elements: Array },
    setup() {
      const store = useGlobalStore()
      return { store }
    },
    data() {
      return {
        items: this.elements || [],
        currentMaxId: this.elements.length || 0,
        previewContent: undefined,
      }
    },
    computed: {
      hasInput() {
        return this.items.length > 0
      },
    },
    methods: {
      canMoveUp(index) {
        return index >= 1
      },
      canMoveDown(index) {
        return index < this.items.length - 1
      },
      typeDescription(item) {
        switch (item.type) {
          case 'h1':
            return 'Überschrift 1'
          case 'h3':
            return 'Überschrift 2'
          case 'p':
            return 'Fließtext'
          case 'asset':
            return 'Bild'
          default:
            return '<unbekannter Typ>'
        }
      },
      showModal() {
        this.$refs['addElementModal'].show()
      },
      addElement(type) {
        this.items.push({
          type: type,
          text: '',
          id: this.currentMaxId++,
        })

        this.$refs['addElementModal'].hide()
      },
      addPicture(item) {
        const file = document.getElementById(`imageUpload${item.id}`).files[0]
        item.asset = file
        this.updateElement(item)
      },
      moveElement(itemId, direction) {
        let sourcePosition, targetElement, temp
        const tempItems = [...this.items]
        sourcePosition = tempItems.findIndex(el => el.id === itemId)

        targetElement = tempItems[sourcePosition + direction]
        temp = tempItems[sourcePosition]
        tempItems[sourcePosition + direction] = temp
        tempItems[sourcePosition] = targetElement

        this.items = tempItems
      },
      updateElement(item, val) {
        if (val) {
          item.text = val.target.value.replaceAll('"', 'ʺ')
        }
        this.items = this.items.map(el => (el.id === item.id ? item : el))
        this.$emit('update-content', this.items)
      },
      deleteElement(itemId) {
        this.items = this.items.filter(item => item.id !== itemId)
      },
      previewPage() {
        this.previewContent = '<div class = "previewContainer">' + this.generateHTMLforPreview()

        this.$refs['previewModal'].show()
        this.addImagesToPreview()
      },

      generateHTMLforPreview: function () {
        return this.items.reduce((string, currentLine, index) => {
          if (currentLine.type == 'asset') {
            return (string +=
              '<div id="imageContainer' + index + '" class = "imageContainer"></div>')
          } else {
            return (string +=
              '<' + currentLine.type + '>' + currentLine.text + '</' + currentLine.type + '><br>')
          }
        }, '<div>')
      },

      addImagesToPreview: function () {
        let imageIsMissing = false
        this.items.forEach((element, index) => {
          if (element.type == 'asset') {
            let reader = new FileReader()
            reader.onload = function (e) {
              let img = new Image()
              img.src = e.target.result
              document.getElementById('imageContainer' + index).appendChild(img)
            }
            if (element.asset) {
              reader.readAsDataURL(element.asset)
            } else {
              imageIsMissing = true
            }
          }
        })
        if (imageIsMissing) {
          this.store.setErrorMessage(
            'Für mindestens ein Bildelement wurde keine Grafik hochgeladen!'
          )
        }
      },
    },
  }
</script>
