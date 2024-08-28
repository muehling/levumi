<template>
  <div>
    <div>Testart auswählen</div>
    <hr />
    <div>
      <b-button
        v-for="questionType in questionTypes"
        :key="questionType.id"
        variant="outline-secondary"
        class="m-2"
        :disabled="questionType.disabled"
        @click="chooseType(questionType.click)">
        {{ questionType.title }}
      </b-button>
    </div>
  </div>
</template>

<script>
  export default {
    data() {
      return {
        questionTypes: [
          {
            id: 0,
            title: 'Multiple Choice',
            click: 'multiple_choice',
          },
          {
            id: 1,
            title: 'Arithmetik',
            //disabled: true,
            click: 'number_input',
          },
          {
            id: 2,
            title: 'Lückentext',
            disabled: true,
            click: 'gapText',
          },
        ],
      }
    },

    methods: {
      chooseType: function (questionType) {
        this.$emit('buttonClicked', questionType)
      },
    },
  }
</script>
