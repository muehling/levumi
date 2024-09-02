<template>
  <div class="accordion instructionAccordion" role="tablist">
    <div no-body class="mb-1">
      <b-button v-b-toggle.accordion-2 variant="outline-secondary" class="mt-3">
        Hinweise zu Dateien, Daten und CSV-Struktur
      </b-button>

      <b-collapse id="accordion-2" accordion="my-accordion" role="tabpanel">
        <b-card class="mt-3">
          <ul>
            <li>Die Dateinamen dürfen keine Sonder- und Leerzeichen enthalten.</li>
            <li>Bilddateien sollten nach Möglichkeit nicht größer als 50kb sein.</li>
            <li>Audiodateien sollten nach Möglichkeit nicht größer als 15kb/s sein.</li>
            <li>
              Als Format für Bilddateien eignet sich webp, für Audio ist mp3 am Besten geeignet.
            </li>
          </ul>
        </b-card>
        <b-card class="mt-3">
          <p class="pt-3">
            Als Feldtrennzeichen muss das Semikolon verwendet werden. Jede Zeile der CSV-Datei
            definiert ein Test-Item und besteht aus folgenden Einträgen:
          </p>
          <ul>
            <li v-for="(field, index) in fields" :key="index">
              <b>{{ `Spalte ${index + 1}` }}</b>
              {{ field }}
            </li>
          </ul>
        </b-card>
      </b-collapse>
    </div>
  </div>
</template>
<script>
  import { testDefinitions } from '../test-definitions.js'
  export default {
    name: 'CsvHelp',
    props: { type: String },
    computed: {
      fields() {
        return testDefinitions[this.type].csvFieldHelp
      },
    },
  }
</script>
