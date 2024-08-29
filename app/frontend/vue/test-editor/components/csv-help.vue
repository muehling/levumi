<template>
  <div class="accordion instructionAccordion" role="tablist">
    <div no-body class="mb-1">
      <b-button v-b-toggle.accordion-2 variant="outline-secondary" class="mt-3">
        Hinweise zur CSV-Struktur
      </b-button>

      <b-collapse id="accordion-2" accordion="my-accordion" role="tabpanel">
        <b-card>
          <p class="pt-3">
            Jede Zeile der CSV-Datei definiert ein Test-Item und besteht aus folgenden Einträgen:
          </p>
          <p v-for="(field, index) in fields" :key="index">
            <b>{{ getTitle(index) }}</b>
            {{ field }}
          </p>
        </b-card>
      </b-collapse>
    </div>
  </div>
</template>
<script>
  import { fieldDefinitions } from './csv-field-definitions.js'
  export default {
    name: 'CsvHelp',
    props: { type: String },
    computed: {
      fields() {
        return fieldDefinitions[this.type]
      },
    },
    methods: {
      getTitle(index) {
        if (index === this.fields.length - 1 && this.fields[this.fields.length - 1] === '') {
          return ''
        }
        return index === this.fields.length - 1 ? 'Alle weiteren Spalten' : `Spalte ${index + 1}`
      },
    },
  }
</script>
