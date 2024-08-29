<template>
  <div>
    {{ JSON.stringify(item) }}
    <p>
      <b-button class="btn-sm" @click="toggleCollapse">Frage {{ item.id }}</b-button>
      <b-button class="btn-sm ml-2 text-nowrap" variant="outline-danger" @click="deleteItem">
        <i class="fas fa-trash"></i>
        <span class="text-small d-none d-xl-inline pl-2">Löschen</span>
      </b-button>
    </p>

    <b-collapse :id="'collapse' + item.id" class="mt-2" visible appear>
      <div class="flexContainer">
        <b-form-group label="Frage" :label-for="'question' + item.id">
          <b-form-input :id="'question' + item.id" v-model="question" @input="updateItem" />
        </b-form-group>

        <b-form-group label="Dimension" :label-for="'group' + item.id">
          <b-form-select
            :id="'group' + item.id"
            v-model="group"
            :options="groupOptions"
            @change="updateItem" />
        </b-form-group>

        <b-form-group label="Bild (optional)" :label-for="'image' + item.id">
          <b-form-file
            :id="'image' + item.id"
            accept="image/*"
            placeholder="Bild"
            drop-placeholder="Hier ablegen"
            @input="addPicture" />
        </b-form-group>
        <b-form-group
          v-slot="{ ariaDescribedby }"
          label="Reihenfolge Bild/Text"
          :label-for="'image-order' + item.id">
          <b-form-radio
            :id="'it-order-0' + item.id"
            v-model="imageTextOrder"
            :aria-describedby="ariaDescribedby"
            :name="'imageTextOrder' + item.id"
            value="0"
            @change="updateItem">
            Bild, Text
          </b-form-radio>
          <b-form-radio
            :id="'it-order-1' + item.id"
            v-model="imageTextOrder"
            :aria-describedby="ariaDescribedby"
            :name="'imageTextOrder' + item.id"
            value="1"
            @change="updateItem">
            Text, Bild
          </b-form-radio>
        </b-form-group>
        <b-form-group v-if="item.type === 'trueOrFalse'">
          <b-form-radio-group
            :id="'correctAnswer' + index"
            v-model="correctAnswer"
            @input="updateItem">
            <b-form-radio value="true">Richtig</b-form-radio>
            <b-form-radio value="false">Falsch</b-form-radio>
          </b-form-radio-group>
        </b-form-group>

        <b-form-group
          v-if="displayMultipleAnswers"
          label="Richtige Antwort"
          :label-for="'correctAnswer' + item.id">
          <b-form-input
            :id="'correctAnswer' + item.id"
            v-model="correctAnswer"
            placeholder="Richtige Antwort"
            @input="updateItem" />
        </b-form-group>

        <div v-if="displayMultipleAnswers">
          <b-form-group
            v-for="(wrongAnswer, index) in wrongAnswers"
            :key="wrongAnswer.id"
            :label="`Falsche Antwort #${index}`"
            :label-for="'wrongAnswer1' + wrongAnswer.id">
            <b-form-input
              :id="'wrongAnswer1' + wrongAnswer.id"
              :placeholder="`Antwort ${index + 1}`"
              :value="wrongAnswer.text"
              @input="text => changeWrongAnswer(text, wrongAnswer.id)"></b-form-input>
          </b-form-group>
          <b-button @click="addWrongAnswer">Weitere falsche Antwort hinzufügen</b-button>
        </div>
      </div>
    </b-collapse>
  </div>
</template>
<script>
  export default {
    name: 'ItemInput',
    props: { item: Object, dimensions: Array },
    data() {
      return {
        question: this.item.question || '',
        group: this.item.group || undefined,
        correctAnswer: this.item.correctAnswer || '',
        image: undefined,
        wrongAnswers: this.item.wrongAnswers?.map((wa, i) => ({ id: i, text: wa })) || [
          { id: 0, text: '' },
        ],
        currentWrongAnswerId: this.item.wrongAnswers?.length || 1,
        imageTextOrder: this.item.imageTextOrder || 0,
      }
    },
    computed: {
      displayMultipleAnswers() {
        return this.item.type === 'multiple_choice' || this.item.type === 'trueOrFalse'
      },
      groupOptions() {
        return this.dimensions.map(dimension => ({ value: dimension.id, text: dimension.text }))
      },
    },
    methods: {
      addPicture() {
        const file = document.getElementById(`image${this.item.id}`).files[0]
        this.image = file
        this.updateItem()
      },
      toggleCollapse() {
        this.$root.$emit('bv::toggle::collapse', 'collapse' + this.item.id)
      },
      updateItem() {
        const it = {
          ...this.item,
          correctAnswer: this.correctAnswer,
          ...(this.wrongAnswers[0].text !== '' && {
            wrongAnswers: this.wrongAnswers.map(answer => answer.text),
          }),
          ...(this.question !== '' && { question: this.question }),
          ...(this.group && { group: this.group }),
          ...(this.image && { image: this.image }),
          ...(this.imageTextOrder && { imageTextOrder: this.imageTextOrder }),
        }
        this.$emit('update-item', it)
      },
      deleteItem() {
        this.$emit('delete-item', this.item.id)
      },
      addWrongAnswer() {
        this.wrongAnswers.push({ id: this.currentWrongAnswerId, text: '' })
        this.currentWrongAnswerId++
      },
      changeWrongAnswer(text, id) {
        this.wrongAnswers.find(wa => wa.id === id).text = text
        this.updateItem()
      },
    },
  }
</script>
