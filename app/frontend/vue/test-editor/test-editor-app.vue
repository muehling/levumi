<template>
  <b-container>
    <b-card title="Test-Editor">
      <div v-if="view == 1">
        <questionTypeComponent @test-selected="setType($event)"></questionTypeComponent>
      </div>

      <div v-show="view == 2">
        <propertyComponent
          :question-type="questionType"
          @setProperties="setProperties($event)"></propertyComponent>
      </div>
      <div v-if="view == 3">
        <dataComponent
          :question-type="questionType"
          :show-demo-task="!!properties.show_demo_task"
          @continueToSummary="setData($event)"></dataComponent>
      </div>
      <div v-if="view == 4">
        <summaryComponent :all-data="allData" :question-type="questionType"></summaryComponent>
      </div>
    </b-card>
  </b-container>
</template>

<script>
  import questionType from './questionTypeComponent.vue'
  import properties from './propertyComponent.vue'
  import dataFiles from './dataComponent.vue'
  import summary from './summaryComponent.vue'

  export default {
    name: 'App',
    components: {
      questionTypeComponent: questionType,
      propertyComponent: properties,
      dataComponent: dataFiles,
      summaryComponent: summary,
    },
    data() {
      return {
        view: 1,
        questionType: undefined,
        properties: undefined,
        questions: undefined,
        startPage: undefined,
        endPage: undefined,
        dimensions: undefined,
      }
    },

    computed: {
      allData() {
        return {
          questionType: this.questionType,
          properties: this.properties,
          questions: this.questions,
          assets: this.assets,
          startPage: this.startPage,
          endPage: this.endPage,
          dimensions: this.dimensions,
        }
      },
    },
    methods: {
      setType: function (type) {
        this.questionType = type
        this.view = 2
      },

      setProperties: function (properties) {
        this.properties = properties
        this.view++
      },

      setData: function (data) {
        this.questions = data[0].questions
        this.startPage = data[0].startPage
        this.endPage = data[0].endPage
        this.dimensions = data[0].dimensions
        this.assets = data[1]
        this.view++
      },

      setStep: function (number) {
        this.view = number
      },
    },
  }
</script>
