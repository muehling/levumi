<template>
  <loading-dots v-if="isLoading" />
  <b-card v-else :title="`${questionTypeLabel}: Eigenschaften definieren`">
    <div class="m-4">
      <b-button class="mt-3" @click="load">Laden</b-button>
      <b-button class="mt-3 ms-2" @click="save">Speichern</b-button>
      <b-button class="continue mt-3 ms-2" @click="saveAndContinue">
        Speichern und weiter
        <i class="fa-solid fa-arrow-right"></i>
      </b-button>
    </div>

    <b-form :validated="wasSubmitted" class="mx-4" @submit.prevent="saveAndContinue">
      <context-help
        help-text="Lernbereich, Testtyp, Kompetenz und Testfamilie können aktuell nur aus den vorhandenen Stammdaten ausgewählt werden." />
      <b-form-group id="input-group-2" label="Lernbereich" label-for="inputArea" label-cols="3">
        <b-form-select id="inputArea" v-model="area" class="" required :options="areas" />
      </b-form-group>

      <b-form-group id="input-group-3" label="Testtyp" label-for="inputTestType" label-cols="3">
        <b-form-select
          id="inputTestType"
          v-model="test_type"
          class=""
          required
          :options="testTypes" />
      </b-form-group>

      <b-form-group
        id="input-group-4"
        label="Lernkompetenz"
        label-for="inputCompetence"
        label-cols="3">
        <b-form-select
          id="inputCompetence"
          v-model="competence"
          class=""
          required
          :disabled="!area"
          :options="competences" />
      </b-form-group>

      <b-form-group
        id="input-group-5"
        label="Testfamilie"
        label-for="inputTestFamily"
        label-cols="3">
        <b-form-select
          id="inputTestFamily"
          v-model="family"
          class=""
          required
          :disabled="!competence"
          :options="testFamilies" />
      </b-form-group>
      <hr />
      <b-form-group id="input-group-6" label="Kürzel" label-for="inputShorthand" label-cols="3">
        <b-form-input
          id="inputShorthand"
          v-model="shorthand"
          :formatter="setShorthand"
          required
          class="d-inline" />
        <context-help
          help-text="Kürzel des Tests. Muss eindeutig sein und darf keine Leerzeichen enthalten. Aktuell findet keine Überprüfung statt, ob das Kürzel bereits vergeben ist." />
      </b-form-group>

      <b-form-group
        id="input-group-7"
        label="Verantwortlich"
        label-for="inputResponsible"
        label-cols="3">
        <b-form-input id="inputResponsible" v-model="responsible" type="email" required class="" />
        <context-help
          help-text="Emailadresse der verantwortlichen Person. Verwenden Sie im Zweifelsfall Ihre eigene." />
      </b-form-group>

      <b-form-group id="input-group-8" label="Niveaustufe" label-for="inputLevel" label-cols="3">
        <b-form-input id="inputLevel" v-model="level" required class="" />
      </b-form-group>

      <b-form-group
        id="input-group-9"
        label="Durchführung durch"
        label-for="inputStudentTest"
        label-cols="3">
        <b-form-select
          id="inputStudentTest"
          v-model="student_test"
          class=""
          required
          :options="student_testOptions" />
      </b-form-group>

      <b-form-group id="input-group-10" label="Version" label-for="inputVersion" label-cols="3">
        <b-form-select
          id="inputVersion"
          v-model="version"
          class=""
          required
          :options="versionDropdownOptions" />
        <context-help
          help-text="Eine Versionsnummer > 1 sollte nur vergeben werden, wenn bereits ein Test mit diesem Kürzel vorhanden sind, dessen Ergebnisse aber nicht mehr vergleichbar sind." />
      </b-form-group>

      <b-form-group
        id="input-group-11"
        label="Zeitbegrenzung"
        label-for="inputTimeLimit"
        label-cols="3">
        <b-form-select
          id="inputTimeLimit"
          v-model="time_limit"
          class=""
          required
          :options="timeDropdownOptions" />
      </b-form-group>
      <b-form-group label="Demo-Aufgabe anzeigen" label-for="inputDemoTask" label-cols="3">
        <b-form-checkbox
          id="inputDemoTask"
          v-model="showDemoTask"
          :value="1"
          :unchecked-value="0" />
        <context-help
          help-text="Wenn aktiv, wird eine zufällige Aufgabe als Demo-Aufgabe angzeigt. Die gegebene Antwort fließt nicht in die Messung ein." />
      </b-form-group>
      <b-form-group
        label="Feedback nach jeder Aufgabe anzeigen"
        label-for="inputFeedback"
        label-cols="3">
        <b-form-checkbox
          id="inputFeedback"
          v-model="showFeedback"
          :value="1"
          :unchecked-value="0" />
        <context-help
          help-text="Wenn aktiv, wird nach jeder Frage eine Feedback-Seite angezeigt." />
      </b-form-group>
      <b-form-group
        v-if="showFeedback"
        label="Text für positives Feedback"
        label-for="inputPositiveFeedback"
        label-cols="3">
        <b-form-input id="inputPositiveFeedback" v-model="positiveFeedbackText" />
      </b-form-group>
      <b-form-group
        v-if="showFeedback"
        label="Text für negatives Feedback"
        label-for="inputNegativeFeedback"
        label-cols="3">
        <b-form-input id="inputNegativeFeedback" v-model="negativeFeedbackText" />
        <context-help
          help-text="Text, der als negatives Feedback dargestellt wird. ### kann als Platzhalter für die korrekte Antwort verwendet werden." />
      </b-form-group>
      <b-form-group
        v-if="showFeedback"
        label="Aufgabenstellung ausblenden"
        label-for="hideTaskInFeedback"
        label-cols="3">
        <b-form-checkbox
          id="inputDemoTask"
          v-model="hideTaskInFeedback"
          :value="1"
          :unchecked-value="0" />
        <context-help
          help-text="Wenn aktiv, wird die Aufgabenstellung (z. b. '3 + 6 = __' auf der Feedbackseite ausgeblendet." />
      </b-form-group>
      <b-form-group
        id="input-group-12"
        label="Beschreibung"
        label-for="inputDescription"
        label-cols="3">
        <b-form-textarea
          id="inputDescription"
          v-model="description"
          placeholder="Ausführliche Beschreibung des Tests"
          rows="3"
          max-rows="6"
          required />
      </b-form-group>

      <b-form-group
        id="input-group-13"
        label="Kurzbeschreibung"
        label-for="inputShortDescription"
        label-cols="3">
        <b-form-textarea
          id="inputShortDescription"
          v-model="short"
          placeholder="Kurzbeschreibung des Tests"
          rows="3"
          max-rows="6"
          required />
      </b-form-group>

      <b-form-group id="input-group-14" label="Verwendung" label-for="inputUsage" label-cols="3">
        <b-form-textarea
          id="inputUsage"
          v-model="usage"
          required
          placeholder="Hinweise zur Verwendung des Tests"
          rows="3"
          max-rows="6" />
      </b-form-group>
      <div v-if="options.length">
        <hr />
        <div v-for="o in options" :key="o.id">
          <b-form-group v-if="o.type === 'boolean'" :label="o.label" label-cols="3">
            <b-form-radio @click="setOption({ [o.id]: true })">Aktiv</b-form-radio>
            <b-form-radio @click="setOption({ [o.id]: false })">Inaktiv</b-form-radio>
            <context-help :help-text="o.description" />
          </b-form-group>
        </div>
      </div>
      <b-button class="continue mt-4" @click="saveAndContinue">
        Speichern und weiter
        <i class="fa-solid fa-arrow-right"></i>
      </b-button>
    </b-form>
  </b-card>
</template>

<script>
  import { testDefinitions } from './test-definitions.js'
  import { useGlobalStore } from 'src/store/store'
  import ContextHelp from 'src/vue/shared/context-help.vue'
  import isEmpty from 'lodash/isEmpty'
  import LoadingDots from '../shared/loading-dots.vue'

  export default {
    components: { ContextHelp, LoadingDots },
    props: { questionType: String },
    setup() {
      const store = useGlobalStore()
      return { store }
    },
    data() {
      return {
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
        showDemoTask: false,
        showFeedback: false,
        positiveFeedbackText: '',
        negativeFeedbackText: '',
        hideTaskInFeedback: false,
        selectedOptions: {},

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
      isLoading() {
        return isEmpty(this.store.staticData)
      },
      questionTypeLabel() {
        return testDefinitions[this.questionType]?.label
      },
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
      options() {
        return testDefinitions[this.questionType]?.options || []
      },

      compiledProps() {
        return {
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
          description: {
            full: this.description,
            short: this.short,
            time_limit: this.time_limit,
            usage: this.usage,
          },
          responsible: this.responsible,

          show_demo_task: this.showDemoTask,
          show_feedback: this.showFeedback,
          positive_feedback_text: this.positiveFeedbackText,
          negative_feedback_text: this.negativeFeedbackText,
          hide_task_in_feedback: this.hideTaskInFeedback,
          options: this.selectedOptions,
        }
      },
    },

    methods: {
      setShorthand(val) {
        const trimmed = val.replaceAll(/\s/g, '')
        return trimmed
      },
      setOption(val) {
        this.selectedOptions = { ...this.selectedOptions, ...val }
      },
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
          this.time_limit = props.description.time_limit
          this.description = props.description.full || ''
          this.short = props.description.short || ''
          this.usage = props.description.usage || ''
          this.responsible = props.responsible || ''
          this.test_type = this.store.staticData.testTypes.find(
            tt => tt.name === props.test_type
          )?.id

          this.showDemoTask = parseInt(props.show_demo_task, 10)
          this.showFeedback = parseInt(props.show_feedback, 10)
          this.positiveFeedbackText = props.positive_feedback_text.replaceAll('"', 'ʺ')
          this.negativeFeedbackText = props.negative_feedback_text.replaceAll('"', 'ʺ')
        } else {
          this.store.setErrorMessage('Keine Daten gefunden!')
        }
      },

      saveAndContinue() {
        this.wasSubmitted = true

        if (
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
          JSON.stringify({ ...data, properties: this.compiledProps })
        )
      },
    },
  }
</script>
