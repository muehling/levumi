<template>
  <div classname="group-view my-3">
    <div class="mb-3">
      <div v-if="readOnly">
        <p>
          Diese Klasse ist mit Ihnen zur Ansicht geteilt, daher können Sie keine eigenen Messungen
          durchführen oder Einstellungen ändern.
        </p>
      </div>
      <b-button
        v-if="displayTestAdminButton"
        variant="outline-secondary"
        size="sm"
        class="me-2 my-3"
        @click="openTestAdmin">
        <i class="fas fa-gear me-2"></i>
        Test hinzufügen / löschen
      </b-button>
      <b-button
        v-if="displayClassBookButton"
        variant="outline-secondary"
        size="sm"
        class="my-3"
        @click="gotoClassbook">
        <i class="fas fa-book-open"></i>
        Zum Klassenbuch
      </b-button>
      <b-button
        v-if="isTestDetailsOpen || isTestAdminOpen"
        class="my-3 me-2"
        size="sm"
        variant="outline-secondary"
        @click="backToOverview">
        <i class="fas fa-backward-step me-2"></i>
        Zurück zur Testübersicht
      </b-button>
      <b-button
        v-if="!isTestListOpen && !isAssessmentSettingsOpen"
        class="my-3"
        size="sm"
        variant="outline-secondary"
        @click="openSettings">
        <i class="fas fa-gear me-2"></i>
        Aktionen und Einstellungen
      </b-button>
    </div>
    <div v-if="!!group">
      <assessment-settings v-if="isAssessmentSettingsOpen" :group="group" />

      <group-test-admin v-if="isAllowed" :group="group" :is-open="isTestAdminOpen" />
      <assessment-view v-if="isTestListOpen" :selected-group-id="selectedGroupId" />
      <assessment-details v-if="isTestDetailsOpen" :group="group" @remove-entry="removeEntry" />
    </div>
  </div>
</template>

<script>
  import { access } from 'src/utils/access'
  import { useAssessmentsStore } from 'src/store/assessmentsStore'
  import { useGlobalStore } from 'src/store/store'
  import { useTestsStore } from 'src/store/testsStore'
  import AssessmentDetails from './assessment-details.vue'
  import AssessmentView from './assessment-view.vue'
  import GroupTestAdmin from './group-test-admin.vue'
  import AssessmentSettings from './assessment-settings/assessment-settings.vue'
  import { useRoute } from 'vue-router'

  export default {
    name: 'GroupView',
    components: { AssessmentDetails, AssessmentView, GroupTestAdmin, AssessmentSettings },

    setup() {
      const route = useRoute()
      const globalStore = useGlobalStore()
      const assessmentsStore = useAssessmentsStore()
      const testsStore = useTestsStore()
      return { globalStore, assessmentsStore, testsStore, route }
    },
    data: function () {
      return {
        testSelected:
          this.$root.pre_select && this.$root.pre_select.groupId === this.$route.params.groupId
            ? this.$root.pre_select.testId
            : 0,
        isTestAdminOpen: false,
        isTestDetailsOpen: false,
        isTestListOpen: false,
        isAssessmentSettingsOpen: false,
      }
    },
    computed: {
      selectedGroupId() {
        return (
          parseInt(this.$route.params.groupId, 10) || this.groups.find(group => !group.archive).id
        )
      },
      assessmentData() {
        return this.assessmentsStore.currentAssessment
      },

      annotations: function () {
        return this.assessmentData?.annotations
      },
      displayClassBookButton() {
        return this.$route.name === 'AssessmentList'
      },
      groups() {
        // the first element is only intended as a placeholder for new groups and is not needed here
        // TODO check if still necessary, globalStore.groups shouldn't contain a placeholder anymore
        return this.globalStore.groups.filter(group => group.id)
      },
      group() {
        return this.globalStore.groups.find(
          group => group.id === parseInt(this.selectedGroupId, 10)
        )
      },
      isAllowed() {
        const permissions = access(this.group).diagnostics
        return permissions?.createAssessments
      },
      readOnly() {
        return !!this.group?.read_only
      },
      displayTestAdminButton() {
        return this.$route.name === 'AssessmentList'
      },
    },
    watch: {
      '$route.name': {
        immediate: true,
        async handler(name) {
          console.log('route change', name)

          switch (name) {
            case 'testverwaltung':
              console.log('Testverwaltung')

              this.isAssessmentSettingsOpen = false
              this.isTestDetailsOpen = false
              this.isTestAdminOpen = true
              this.isTestListOpen = false
              break
            case 'Assessment':
              console.log('Assessment')

              this.isAssessmentSettingsOpen = false
              this.isTestDetailsOpen = true
              this.isTestAdminOpen = false
              this.isTestListOpen = false

              break
            case 'AssessmentSettings':
              console.log('AssessmentSettings')

              this.isAssessmentSettingsOpen = true
              this.isTestDetailsOpen = false
              this.isTestAdminOpen = false
              this.isTestListOpen = false
              break
            default:
              console.log('Default')

              this.isAssessmentSettingsOpen = false
              this.isTestAdminOpen = false
              this.isTestDetailsOpen = false
              this.isTestListOpen = true
          }
        },
      },
    },

    async mounted() {
      //this.selectedGroupId = this.$route.params.groupId

      //this.$root.$on(`annotation-added-${groupId}`, this.addAnnotation)
      //this.$root.$on(`annotation-removed-${groupId}`, this.removeAnnotation)
      console.log('group view mounted', this.$route.params, this.group)

      await this.assessmentsStore.fetch(this.selectedGroupId)
      await this.testsStore.fetchUsedTestsForGroup(this.selectedGroupId)

      if (
        this.$route.params.testId &&
        this.assessmentsStore.currentAssessment?.test?.id !==
          parseInt(this.$route.params.testId, 10)
      ) {
        await this.assessmentsStore.fetchCurrentAssessment(
          this.selectedGroupId,
          this.$route.params.testId
        )
      }
    },
    methods: {
      gotoClassbook() {
        if (this.group.owner) {
          this.$router.push(`/klassenbuch/eigene_klassen/${this.selectedGroupId}`)
        } else {
          this.$router.push(`/klassenbuch/geteilte_klassen/${this.selectedGroupId}`)
        }
      },
      openSettings() {
        console.log('meh', this.assessmentData)
        this.$router.push(
          //TODO irgendwie gucken, wo der blöde Button hinsoll
          `/diagnostik/${this.selectedGroupId}/testdetails/${this.assessmentData.test.id}/einstellungen`
        )
      },
      openTestAdmin() {
        this.$router.push(`/diagnostik/${this.selectedGroupId}/testverwaltung`)
      },
      addAnnotation(annotation) {
        const annotations = this.assessmentData.annotations
        annotations.splice(0, 0, annotation)
        this.$set(this.assessmentData, 'annotations', annotations)
      },
      removeAnnotation(annotationId) {
        const annotations = this.assessmentData.annotations.filter(a => annotationId !== a.id)
        this.$set(this.assessmentData, 'annotations', annotations)
      },
      async setPreselect(data) {
        this.testSelected = data.testId
      },
      backToOverview() {
        this.assessmentsStore.setCurrentAssessment(undefined)
        this.$router.push(`/diagnostik/${this.selectedGroupId}`)
      },
      removeEntry(index) {
        this.assessmentData.series.splice(index, 1) // todo Mutation von computed prop, sollte nicht erlaubt sein
      },
    },
  }
</script>
<style>
  .group-view .card-body.card-body {
    padding: 1rem 0;
  }
  .group-view .card-body ul {
    padding: 0 1.25rem;
  }
  .group-view .card-body hr {
    margin: 0.5rem 0;
  }
</style>
