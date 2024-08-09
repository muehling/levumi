<template>
  <div class="d-flex w-100 mt-3">
    <b-button-group vertical>
      <b-button v-if="canMoveUp" @click="moveElement(-1)">
        <b-icon icon="arrow-up" aria-hidden="true" />
      </b-button>
      <b-button v-if="canMoveDown" @click="moveElement(1)">
        <b-icon icon="arrow-down" aria-hidden="true" />
      </b-button>
    </b-button-group>
    <div class="flex-grow-1 border">
      <p class="d-flex m-0">{{ typeDescription }}:</p>
      <b-form-textarea
        v-if="item.type == 'h1'"
        id="input-large"
        v-model="text"
        rows="2"
        max-rows="4"
        placeholder="Hier bitte den Text eingeben"
        @input="updateElement" />

      <b-form-textarea
        v-if="item.type == 'h3'"
        v-model="text"
        placeholder="Hier bitte den Text eingeben"
        rows="2"
        max-rows="4"
        @input="updateElement" />

      <b-form-textarea
        v-if="item.type == 'p'"
        v-model="text"
        placeholder="Hier bitte den Text eingeben"
        rows="2"
        max-rows="4"
        @input="updateElement" />

      <b-form-file
        v-if="item.type == 'image'"
        :id="`imageUpload${item.id}`"
        v-model="image"
        accept="image/*"
        class="inputImage"
        size="md"
        :placeholder="image ? image.name : 'Bild hochladen'"
        @input="addPicture" />
    </div>
    <b-button-group vertical>
      <b-button @click="deleteElement">
        <b-icon icon="x-lg" aria-hidden="true" />
      </b-button>
    </b-button-group>
  </div>
</template>
<script>
  export default {
    name: 'ContentInput',
    props: { item: Object, index: Number },
    data() {
      return {
        text: this.item.text || '',
        image: this.item.image || undefined,
      }
    },
    computed: {
      canMoveUp() {
        return true
      },
      canMoveDown() {
        return true
      },
      typeDescription() {
        switch (this.item.type) {
          case 'h1':
            return 'Überschrift 1'
          case 'h3':
            return 'Überschrift 2'
          case 'p':
            return 'Fließtext'
          case 'image':
            return 'Bild'
          default:
            return '<unbekannter Typ>'
        }
      },
    },
    methods: {
      addPicture() {
        const file = document.getElementById(`imageUpload${this.item.id}`).files[0]
        this.image = file
        this.updateElement()
      },
      moveElement(direction) {
        this.$emit('move-element', this.item.id, direction)
      },
      updateElement() {
        this.$emit('update-element', { ...this.item, text: this.text, image: this.image })
      },
      deleteElement() {
        this.$emit('delete-element', this.item.id)
      },
    },
  }
</script>
