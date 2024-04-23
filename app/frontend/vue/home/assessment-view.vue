<template>
  <div>
    <div>
      <b-card
        v-if="globalStore.studentsInGroups[selectedGroupId].length === 0"
        bg-variant="white"
        class="col-lg-8 col-xl-6 mt-3">
        <p>
          Aktuell sind noch keine Schüler:innen für die Klasse angelegt. Bitte legen Sie diese
          zuerst im Klassenbuch an, damit Sie testen können!
        </p>
        <b-button variant="outline-secondary" @click="navigateToClassbook">
          <i class="fas fa-book-open mr-1"></i>
          Zum Klassenbuch
        </b-button>
      </b-card>
      <b-card
        v-else-if="assessmentsStore.assessments[selectedGroupId]?.length == 0"
        bg-variant="white"
        class="col-lg-8 col-xl-6 mt-3">
        <p class="text-center">
          Keine aktiven Tests mit Messungen vorhanden!
          <br />
          Legen Sie zunächst über den Button "Test hinzufügen/löschen" einen Test für diese Klasse
          an.
        </p>
      </b-card>
      <div v-else>
        <p v-if="assessmentsStore.assessments[selectedGroupId]?.length > 1" class="text-left">
          Bitte wählen Sie einen Test aus der Liste aus. Um später zu einem anderen Test zu
          wechseln, können Sie den Button
          <strong>Zurück zur Testübersicht</strong>
          verwenden.
          <span v-if="!group.read_only">
            Weitere Tests können Sie über den Button
            <strong>Test hinzufügen/löschen</strong>
            aktivieren.
          </span>
        </p>
        <b-card>
          <group-assessments :group="group" />
        </b-card>
      </div>
    </div>
  </div>
</template>
<script>
  import { useAssessmentsStore } from '../../store/assessmentsStore'
  import { useGlobalStore } from '../../store/store'
  import GroupAssessments from './group-assessments.vue'
  export default {
    name: 'AssessmentView',
    components: { GroupAssessments },
    props: {
      selectedGroupId: Number,
    },
    setup() {
      const globalStore = useGlobalStore()
      const assessmentsStore = useAssessmentsStore()
      return { globalStore, assessmentsStore }
    },
    computed: {
      group() {
        return this.globalStore.groups.find(group => group.id === this.selectedGroupId)
      },
    },
    methods: {
      navigateToClassbook() {
        const subClassbook = this.group.owner ? 'eigene_klassen' : 'geteilte_klassen'
        this.$router.push(`/klassenbuch/${subClassbook}/${this.group.id}`)
      },
    },
  }
</script>
