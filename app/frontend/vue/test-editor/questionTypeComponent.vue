<template>
  <div>
    <h1>Willkommen</h1>
    <div class="infoText">
      Auf dieser Seite können Sie einen Test zur Lernverlaufsdiagnostik in Levumi erstellen. Dieser
      wird in mehreren Schritten zusammengestellt und kann anschließend heruntergeladen werden.
      <br />
      <br />
      <hr />
      Bitte wählen Sie zunächst welche Art von Test Sie erstellen möchten.
    </div>
    <hr />
    <div class="flexBox">
      <b-card
        v-for="questionType in questionTypes"
        :key="questionType.id"
        :question-type="questionType"
        :title="questionType.title"
        :img-src="questionType.image"
        img-top
        class="mb-2 questionTypeButton"
        @click="chooseType(questionType.click)"></b-card>
    </div>
  </div>
</template>

<script>
  export default {
    data() {
      return {
        // This variable contains the available question types. If new ones are to be added, they need to be
        // added here and will be displayed dynamically.
        questionTypes: [
          {
            id: 0,
            title: 'Multiple Choice',
            image: '/images/test-editor/multipleChoice.jpg',
            click: 'multipleChoice',
          },
          {
            id: 1,
            title: 'Wahr oder Falsch',
            image: '/images/test-editor/yesNo.jpg',
            click: 'trueOrFalse',
          },
          {
            id: 2,
            title: 'Lückentext',
            image: '/images/test-editor/lueckenText.png',
            click: 'gapText',
          },
        ],
      }
    },

    methods: {
      /**
       * Emits the chosen question type to the root vue.
       */
      chooseType: function (questionType) {
        this.$emit('buttonClicked', questionType)
      },
    },
  }
</script>

<style>
  .questionTypeButton {
    flex-basis: auto;
    flex-grow: 1;
    max-width: 25%;
    min-width: 20%;
    background-color: rgb(232, 232, 232);
    border-radius: 0.5rem;
    border: solid 1px lightgrey;
    box-shadow: 10px 10px 12px 3px #9f9f9f;
    transition-duration: 0.5s;
    transition-timing-function: ease;
    filter: grayscale(1);
    cursor: pointer;
  }

  .questionTypeButton:hover {
    filter: grayscale(0);
    box-shadow: 12px 12px 15px 5px #9f9f9f;
    transition-duration: 0.5s;
    transition-timing-function: ease;
  }

  .flexBox {
    display: flex;
    flex-direction: row;
    flex-wrap: wrap;
    justify-content: center;
    gap: 5% 5%;
    margin-top: 5%;
    margin-bottom: 5%;
  }

  .card-img-top {
    border-radius: 0.5rem 0.5rem 0 0;
  }

  .infoText {
    font-size: 1.3rem;
    padding: 3% 10% 3% 10%;
  }
</style>
