<template>
  <div>
    <div v-for="item in questions" :key="item.id" class="questionElement">
      <item-input
        :item="item"
        :dimensions="dimensions"
        @update-item="updateItem"
        @delete-item="deleteItem" />
    </div>
    <b-button @click="addItem">Item hinzufügen</b-button>
    <b-button @click="submitItems">Weiter zur Zusammenfassung</b-button>
  </div>
</template>
<script>
  import ItemInput from './item-input.vue'
  export default {
    name: 'ManualItemInput',
    components: { ItemInput },
    props: { dimensions: Array },
    data() {
      return { questions: [], currentQuestionId: 0, questionType: 'multipleChoice' }
    },
    methods: {
      addItem() {
        this.questions.push({ id: ++this.currentQuestionId, question: '', type: this.questionType })
      },
      updateItem(item) {
        this.questions = this.questions.map(q => (q.id === item.id ? item : q))
      },
      deleteItem(id) {
        this.questions = this.questions.filter(q => q.id !== id)
      },
      submitItems() {
        this.$emit('submit-items', this.questions)
      },
    },
  }
</script>
