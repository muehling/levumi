<template>
  <div>
    <div v-if="!hasResults">
      <b-card
        v-if="globalStore.studentsInGroups[group.id].length === 0"
        bg-variant="white"
        class="col-lg-8 col-xl-6 mt-3"
      >
        <p class="text-center">
          Aktuell sind noch keine Schüler:innen für die Klasse angelegt. Bitte legen Sie diese
          zuerst im Klassenbuch an, damit Sie testen können!
        </p>
      </b-card>
      <b-card
        v-else-if="assessmentsStore.assessments[group.id]?.length == 0"
        bg-variant="white"
        class="col-lg-8 col-xl-6 mt-3"
      >
        <p class="text-center">
          Keine aktiven Tests mit Messungen vorhanden! <br />
          Legen Sie zunächst über den Button "Test hinzufügen/löschen" einen Test für diese Klasse
          an.
        </p>
      </b-card>
      <div v-else>
        <p v-if="assessmentsStore.assessments[group.id]?.length > 1" class="text-left">
          Bitte wählen Sie einen Test aus der Liste aus. Um später zu einem anderen Test zu
          wechseln, können Sie den Button <strong>Zurück zur Testübersicht</strong> verwenden.
          <span v-if="!group.read_only"
            >Weitere Tests können Sie über den Button
            <strong>Test hinzufügen/löschen</strong> aktivieren.</span
          >
        </p>
        <b-card>
          <group-assessments :group="group" />
        </b-card>
      </div>
    </div>

    <assessment-details
      v-else-if="hasResults && assessmentData.groupId === group.id"
      :key="assessmentData.id"
      :assessment-data="assessmentData"
      :group="group"
      @remove-entry="removeEntry"
    >
    </assessment-details>
  </div>
</template>
<script>
  import AssessmentDetails from './assessment-details.vue'
  import { useAssessmentsStore } from '../../store/assessmentsStore'
  import { useGlobalStore } from '../../store/store'
  import GroupAssessments from './group-assessments.vue'
  export default {
    name: 'AssessmentView',
    components: { AssessmentDetails, GroupAssessments },
    props: {
      group: Object,
    },
    setup() {
      const globalStore = useGlobalStore()
      const assessmentsStore = useAssessmentsStore()
      return { globalStore, assessmentsStore }
    },
    computed: {
      assessmentData() {
        return this.assessmentsStore.getCurrentAssessment()
      },
      hasResults() {
        return !!this.assessmentData
      },
    },
    methods: {
      removeEntry(index) {
        this.assessmentData.series.splice(index, 1) // todo Mutation von computed prop, sollte nicht erlaubt sein
      },
    },
  }
</script>
