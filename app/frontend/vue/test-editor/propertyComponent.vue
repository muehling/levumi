<template>
  <div class="positionRelative">
    <div class="m-4">
      <h2>Eigenschaften definieren</h2>
      Hier können Sie weitere Eigenschaften und Beschreibungen des Tests festlegen. Eine Erklärung
      zu den jeweiligen Eigenschaften können Sie über das
      <b-icon icon="info-circle"></b-icon>
      erhalten. Bitte füllen Sie alle Felder aus und beschreiben Sie den Test möglichst genau.
      <br />
      <hr />
      <b-button class="mt-3" @click="load">Laden</b-button>
      <b-button class="mt-3 ml-2" @click="save">Speichern</b-button>
      <b-button class="continue mt-3 ml-2" @click="saveAndContinue">
        Speichern und weiter
        <b-icon icon="arrow-right"></b-icon>
      </b-button>
    </div>

    <b-form :validated="wasSubmitted" class="mx-4" @submit.prevent="saveAndContinue">
      <b-form-group id="input-group-1" label="Name" label-for="inputName">
        <b-form-input id="inputName" v-model="name" required min-length="5" />
      </b-form-group>

      <b-form-group id="input-group-2" label="Lernbereich" label-for="inputArea">
        <b-form-select id="inputArea" v-model="area" class="" required :options="areas" />
      </b-form-group>

      <b-form-group id="input-group-3" label="Testtyp" label-for="inputTestType">
        <b-form-select
          id="inputTestType"
          v-model="test_type"
          class=""
          required
          :options="testTypes" />
      </b-form-group>

      <b-form-group id="input-group-4" label="Lernkompetenz" label-for="inputCompetence">
        <b-form-select
          id="inputCompetence"
          v-model="competence"
          class=""
          required
          :disabled="!area"
          :options="competences" />
      </b-form-group>

      <b-form-group id="input-group-5" label="Testfamilie" label-for="inputTestFamily">
        <b-form-select
          id="inputTestFamily"
          v-model="family"
          class=""
          required
          :disabled="!competence"
          :options="testFamilies" />
      </b-form-group>

      <b-form-group id="input-group-6" label="Kürzel" label-for="inputShorthand">
        <b-form-input id="inputShorthand" v-model="shorthand" required class="" />
      </b-form-group>

      <b-form-group id="input-group-7" label="Verantwortlich" label-for="inputResponsible">
        <b-form-input id="inputResponsible" v-model="responsible" type="email" required class="" />
      </b-form-group>

      <b-form-group id="input-group-8" label="Niveaustufe" label-for="inputLevel">
        <b-form-input id="inputLevel" v-model="level" type="email" required class="" />
      </b-form-group>

      <b-form-group id="input-group-9" label="Durchführung durch" label-for="inputStudentTest">
        <b-form-select
          id="inputStudentTest"
          v-model="student_test"
          class=""
          required
          :options="student_testOptions" />
      </b-form-group>

      <b-form-group id="input-group-10" label="Version" label-for="inputVersion">
        <b-form-select
          id="inputVersion"
          v-model="version"
          class=""
          required
          :options="versionDropdownOptions" />
      </b-form-group>

      <b-form-group id="input-group-11" label="Zeitbegrenzung" label-for="inputTimeLimit">
        <b-form-select
          id="inputTimeLimit"
          v-model="time_limit"
          class=""
          required
          :options="timeDropdownOptions" />
      </b-form-group>

      <b-form-group id="input-group-12" label="Beschreibung" label-for="inputDescription">
        <b-form-textarea
          id="inputDescription"
          v-model="description"
          placeholder="Ausführliche Beschreibung des Tests"
          rows="3"
          max-rows="6"
          required />
      </b-form-group>

      <b-form-group id="input-group-13" label="Kurzbeschreibung" label-for="inputShortDescription">
        <b-form-textarea
          id="inputShortDescription"
          v-model="short"
          placeholder="Kurzbeschreibung des Tests"
          rows="3"
          max-rows="6"
          required />
      </b-form-group>

      <b-form-group id="input-group-14" label="Verwendung" label-for="inputUsage">
        <b-form-textarea
          id="inputUsage"
          v-model="usage"
          required
          placeholder="Hinweise zur Verwendung des Tests"
          rows="3"
          max-rows="6" />
      </b-form-group>
      <hr />
      <b-form-group
        v-for="(dimension, index) in dimensions"
        :key="dimension.id"
        :label="`Dimension #${index + 1}`"
        :label-for="'dimension' + dimension.id">
        <b-form-input
          :id="'dimension' + dimension.id"
          :placeholder="`Dimension ${index + 1}`"
          :value="dimension.text"
          @input="text => changeDimension(text, dimension.id)"></b-form-input>
      </b-form-group>
      <b-button @click="addDimension">Weitere Dimension hinzufügen</b-button>
      <hr />

      <b-button class="continue mt-4" @click="saveAndContinue">
        Speichern und weiter
        <b-icon icon="arrow-right"></b-icon>
      </b-button>
    </b-form>
  </div>
</template>

<script>
  import { useGlobalStore } from 'src/store/store'

  export default {
    setup() {
      const store = useGlobalStore()
      return { store }
    },
    data() {
      return {
        name: '',
        area: undefined,
        competence: undefined,
        family: undefined,
        shorthand: '',
        level: '',
        student_test: null,
        version: 1,
        time_limit: null,
        description: '',
        short: '',
        usage: '',
        responsible: '',
        test_type: undefined,
        wasSubmitted: false,
        dimensions: [{ id: 1, text: '' }],
        currentDimensionId: 1,

        timeDropdownOptions: [
          { value: null, text: 'Bitte auswählen' },
          { value: 1, text: '1 Minute' },
          { value: 2, text: '2 Minuten' },
          { value: 3, text: '3 Minuten' },
          { value: 4, text: '4 Minuten' },
          { value: 5, text: '5 Minuten' },
          { value: 6, text: '6 Minuten' },
          { value: 7, text: '7 Minuten' },
          { value: 8, text: '8 Minuten' },
          { value: 9, text: '9 Minuten' },
          { value: 10, text: '10 Minuten' },
          { value: 15, text: '15 Minuten' },
          { value: 20, text: '20 Minuten' },
          { value: 25, text: '25 Minuten' },
          { value: 30, text: '30 Minuten' },
          { value: 60, text: '60 Minuten' },
        ],
        student_testOptions: [
          { value: null, text: 'Bitte auswählen' },
          { value: 0, text: 'Zur Durchführung durch die Lehrkraft' },
          { value: 1, text: 'Selbständige Durchführung durch die Schüler:innen' },
        ],

        versionDropdownOptions: [
          { value: 1, text: 1 },
          { value: 2, text: 2 },
          { value: 3, text: 3 },
          { value: 4, text: 4 },
          { value: 5, text: 5 },
          { value: 6, text: 6 },
          { value: 7, text: 7 },
          { value: 8, text: 8 },
          { value: 9, text: 9 },
        ],
      }
    },

    computed: {
      areas() {
        return this.store.staticData.testMetaData.areas.map(area => ({
          value: area.id,
          text: area.name,
        }))
      },
      competences() {
        return this.store.staticData.testMetaData.competences
          .filter(competence => competence.area_id === this.area)
          .map(competence => ({
            value: competence.id,
            text: competence.name,
          }))
      },
      testFamilies() {
        return this.store.staticData.testMetaData.test_families
          .filter(testFamily => testFamily.competence_id === this.competence)
          .map(testFamily => ({
            value: testFamily.id,
            text: testFamily.name,
          }))
      },
      testTypes() {
        return this.store.staticData.testTypes.map(testType => ({
          value: testType.id,
          text: testType.name,
        }))
      },
      compiledProps() {
        return {
          name: this.name,
          area: this.store.staticData.testMetaData.areas.find(a => a.id === this.area)?.name,
          competence: this.store.staticData.testMetaData.competences.find(
            c => c.id === this.competence
          )?.name,
          family: this.store.staticData.testMetaData.test_families.find(tf => tf.id === this.family)
            ?.name,
          test_type: this.store.staticData.testTypes.find(tt => tt.id === this.test_type)?.name,
          shorthand: this.shorthand,
          level: this.level,
          student_test: this.student_test,
          version: this.version,
          time_limit: this.time_limit,
          description: this.description,
          short: this.short,
          usage: this.usage,
          responsible: this.responsible,
          dimensions: this.dimensions,
        }
      },
    },

    methods: {
      load() {
        const d = localStorage.getItem('test-editor-data')

        if (d) {
          let data
          try {
            data = JSON.parse(d)
          } catch {
            this.store.setErrorMessage('Geladene Daten sind fehlerhaft!')
          }

          const props = data.properties
          this.name = props.name || ''
          this.area = this.store.staticData.testMetaData.areas.find(a => a.name === props.area)?.id
          this.competence = this.store.staticData.testMetaData.competences.find(
            c => c.name === props.competence
          )?.id
          this.family = this.store.staticData.testMetaData.test_families.find(
            tf => tf.name === props.family
          )?.id
          this.shorthand = props.shorthand
          this.level = props.level
          this.student_test = props.student_test
          this.version = props.version
          this.time_limit = props.time_limit
          this.description = props.description || ''
          this.short = props.short || ''
          this.usage = props.usage || ''
          this.responsible = props.responsible || ''
          this.test_type = this.store.staticData.testTypes.find(
            tt => tt.name === props.test_type
          )?.id
          this.dimensions = data.dimensions
          this.currentDimensionId = data.dimensions.length
        } else {
          this.store.setErrorMessage('Keine Daten gefunden!')
        }
      },

      saveAndContinue() {
        this.wasSubmitted = true

        if (
          this.name &&
          this.area &&
          this.competence &&
          this.family &&
          this.level &&
          this.shorthand &&
          this.level &&
          this.student_test !== null &&
          this.version &&
          this.time_limit &&
          this.description &&
          this.short &&
          this.usage &&
          this.responsible &&
          this.test_type
        ) {
          this.save()
          this.$emit('setProperties', this.compiledProps)
        }
      },

      save() {
        const s = localStorage.getItem('test-editor-data')
        let data
        try {
          data = JSON.parse(s)
        } catch (e) {
          console.error('Error parsing saved data', e)
        }
        localStorage.setItem(
          'test-editor-data',
          JSON.stringify({ ...data, properties: this.compiledProps, dimensions: this.dimensions })
        )
      },
      addDimension() {
        this.dimensions.push({ id: ++this.currentDimensionId, text: '' })
      },
      changeDimension(text, id) {
        this.dimensions.find(wa => wa.id === id).text = text
      },
    },
  }
</script>
