<template>
  <div>
    <div>Testart auswählen</div>
    <hr />

    <b-card v-for="def in testTypes" :key="def.id" class="mb-4">
      <b-card-header>
        <strong>{{ def.label }}</strong>
      </b-card-header>
      <b-card-body>
        <p v-html="def.description"></p>
        <b-button variant="outline-secondary" @click="chooseType(def.id)">Auswählen</b-button>
      </b-card-body>
    </b-card>
  </div>
</template>

<script>
  import { testDefinitions } from './test-definitions.js'
  export default {
    computed: {
      testTypes() {
        return Object.entries(testDefinitions).map(def => ({
          label: def[1].label,
          description: def[1].description,
          id: def[0],
        }))
      },
    },
    methods: {
      chooseType: function (questionType) {
        this.$emit('test-selected', questionType)
      },
    },
  }
</script>
