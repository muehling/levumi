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
        class="my-3"
        size="sm"
        variant="outline-secondary"
        @click="backToOverview">
        <i class="fas fa-backward-step me-1"></i>
        Zurück zur Testübersicht
      </b-button>
    </div>
    <group-test-admin v-if="isAllowed" :group="group" :is-open="isTestAdminOpen" />
    <assessment-view v-if="isTestListOpen" :selected-group-id="selectedGroupId" />
    <assessment-details v-if="isTestDetailsOpen" :group="group" @remove-entry="removeEntry" />
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

  export default {
    name: 'GroupView',
    components: { AssessmentDetails, AssessmentView, GroupTestAdmin },
    props: {
      selectedGroupId: Number,
    },
    setup() {
      const globalStore = useGlobalStore()
      const assessmentsStore = useAssessmentsStore()
      const testsStore = useTestsStore()
      return { globalStore, assessmentsStore, testsStore }
    },
    data: function () {
      return {
        testSelected:
          this.$root.pre_select && this.$root.pre_select.groupId === this.$route.params.groupId
            ? this.$root.pre_select.testId
            : 0,
        isTestAdminOpen: false,
        isTestDetailsOpen: false,
        isTestListOpen: true,
      }
    },
    computed: {
      assessmentData() {
        return this.assessmentsStore.currentAssessment
      },

      annotations: function () {
        return this.assessmentData?.annotations
      },
      displayClassBookButton() {
        return !this.isTestAdminOpen && !this.isTestDetailsOpen && this.group.students.length > 0
      },
      groups() {
        // the first element is only intended as a placeholder for new groups and is not needed here
        // TODO check if still necessary, globalStore.groups shouldn't contain a placeholder anymore
        return this.globalStore.groups.filter(group => group.id)
      },
      group() {
        return this.groups.find(group => group.id === this.selectedGroupId)
      },
      isAllowed() {
        const permissions = access(this.group).diagnostics
        return permissions?.createAssessments
      },
      readOnly() {
        return !!this.group?.read_only
      },
      displayTestAdminButton() {
        return (
          !!this.selectedGroupId &&
          !this.assessmentData &&
          this.isAllowed &&
          !this.isTestAdminOpen &&
          this.group.students.length > 0
        )
      },
    },
    watch: {
      '$route.params': {
        immediate: true,
        async handler(data) {
          switch (data.location) {
            case 'testverwaltung':
              this.isTestDetailsOpen = false
              this.isTestAdminOpen = true
              this.isTestListOpen = false
              break
            case 'testdetails':
              this.isTestDetailsOpen = true
              this.isTestAdminOpen = false
              this.isTestListOpen = false
              if (this.assessmentsStore.currentAssessment?.test?.id !== parseInt(data.testId, 10)) {
                await this.assessmentsStore.fetchCurrentAssessment(this.group.id, data.testId)
              }
              break
            default:
              this.isTestAdminOpen = false
              this.isTestDetailsOpen = false
              this.isTestListOpen = true
          }
        },
      },
    },

    async mounted() {
      const groupId = this.group.id

      this.$root.$on(`annotation-added-${groupId}`, this.addAnnotation)
      this.$root.$on(`annotation-removed-${groupId}`, this.removeAnnotation)

      await this.assessmentsStore.fetch(groupId)
      await this.testsStore.fetchUsedTestsForGroup(groupId)
    },
    methods: {
      gotoClassbook() {
        if (this.group.owner) {
          this.$router.push(`/klassenbuch/eigene_klassen/${this.group.id}`)
        } else {
          this.$router.push(`/klassenbuch/geteilte_klassen/${this.group.id}`)
        }
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
