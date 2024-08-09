<template>
  <!-- This is where the whole content is placed -->
  <div id="app">
    <div class="interactionBox shadow">
      <!-- 
          Displays step 1: The choice between different question types. Currently there are three available:
          Multiple Choice, True or False and Gap text. They are managed by the questionTypeComponent 
        -->
      <div v-if="view == 1">
        <questionTypeComponent @buttonClicked="setType($event)"></questionTypeComponent>
      </div>

      <!-- 
          Displays step 2: Lets the user set the general properties and descriptions of the question. v-show as cheap solution for restoring the input properties when returning here later. 
        -->
      <div v-show="view == 2">
        <propertyComponent @setProperties="setProperties($event)"></propertyComponent>
      </div>

      <!-- 
          Displays step 3: In this step, the user is prompted to either upload a csv file containing the questions or type them in manually in an interface.
          There is also an interface to create a welcome and an end page. 
        -->
      <div v-if="view == 3">
        <dataComponent
          :question-type="questionType"
          :dimensions="properties.dimensions"
          @continueToSummary="setData($event)"></dataComponent>
      </div>

      <!-- 
          Displays step 4: The summary of all inputs. The user can verify that all data is correct and then create and download the zip file.
        -->
      <div v-if="view == 4">
        <summaryComponent
          :all-data="allData"
          @continueToSummary="setData($event)"></summaryComponent>
      </div>
    </div>
  </div>
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
        // Schöner wäre es, wenn die Navigation mit dem vue-router gelöst wird. Dann könnte man auch
        // mit dem Browser navigieren. TODO @self: Learn how to work with routers :/
        view: 1,
        questionType: null,
        properties: null,
        questions: null,
        startPage: null,
        endPage: null,
      }
    },

    computed: {
      /**
       * Returns all the data necessary for the test. It is used for passing these properties to the summary component, where the test is generated.
       */
      allData() {
        // console.log("This is the allData object in the root app")
        // console.log({
        //         questionType: this.questionType,
        //         properties:   this.properties,
        //         questions:    this.questions,
        //         images:       this.images,
        //         welcome:      this.welcome,
        //         end:          this.end
        // })
        return {
          questionType: this.questionType,
          properties: this.properties,
          questions: this.questions,
          images: this.images,
          startPage: this.startPage,
          endPage: this.endPage,
        }
      },
    },
    methods: {
      /**
       * Is called when the user selects a type for the test.
       * It saves the type property and shows the property view.
       * @param {String} type Defines the type of the test.
       */
      setType: function (type) {
        this.questionType = type
        this.view = 2
      },

      /**
       * Is called when the user submits the properties.
       * It sets these to the property of vue and shows the upload view.
       * @param {Object} properties The different properties of the test. This includes name and descriptions.
       */
      setProperties: function (properties) {
        this.properties = properties
        this.view++
      },

      /**
       * Is called when the user submits the csv file.
       * It saves these to the property of vue and shows the summary view.
       * @param {Array} properties This Array contains the questions and answers for the test.
       */
      setData: function (data) {
        this.questions = data[0].questions
        this.startPage = data[0].startPage
        this.endPage = data[0].endPage
        this.images = data[1]
        // console.log("images in the app.vue", this.images)
        this.view++

        // this.questions = questions;
      },

      // only helper function for switching between the views. Not for the final version.
      setStep: function (number) {
        this.view = number
      },
    },
  }
</script>

<style>
  #app {
    min-height: 100vh;
  }

  .shadow {
    box-shadow: 5px 5px 10px 3px #9f9f9f;
    border: solid 1px #e1eae6;
  }

  b-navbar {
    position: sticky;
  }

  .navButtonDiv {
    margin: auto;
  }

  .navButton {
    margin-left: 0.5rem;
    margin-right: 0.5rem;
    width: 10rem;
  }

  .info {
    height: 1rem;
    transition-duration: 0.3s;
  }

  .info:hover {
    height: 1.4rem;
    transition-duration: 0.3s;
  }

  .interactionBox {
    border: solid 1px #e1eae6;
    width: 50%;
    /* TODO: Think about min width */
    min-width: 800px;
    min-height: 70%;
    padding: 1rem;
    border-radius: 0.5rem;
    margin: 3rem auto 3rem auto;
  }

  .defaultTooltip {
    font-size: 1rem;
    padding: 0.4rem;
  }

  button.downloadButton > .b-icon.bi {
    display: none;
  }

  button.downloadButton:hover > .b-icon.bi {
    display: inline-block;
  }

  button.deleteUploadButton > .b-icon.bi {
    display: none;
  }

  button.deleteUploadButton:hover > .b-icon.bi {
    display: inline-block;
  }

  .btn .b-icon.bi {
    font-size: 100%;
  }
</style>
