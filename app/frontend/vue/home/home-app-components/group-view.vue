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
        <i class="fas fa-book-open me-2"></i>
        Zum Klassenbuch
      </b-button>
      <b-button
        v-if="isTestDetailsOpen || isTestAdminOpen"
        class="my-3 me-2"
        size="sm"
        variant="outline-secondary"
        @click="backToOverview">
        <i class="fas fa-arrow-left me-2"></i>
        Zurück zur Testübersicht
      </b-button>
    </div>
    <div v-if="!!group">
      <group-test-admin v-if="isAllowed" :group="group" :is-open="isTestAdminOpen" />
      <assessment-list v-if="isTestListOpen" :selected-group-id="selectedGroupId" />
      <assessment-details v-if="isTestDetailsOpen" :group="group" />
    </div>
  </div>
</template>

<script>
  import { access } from 'src/utils/access'
  import { useAssessmentsStore } from 'src/store/assessmentsStore'
  import { useGlobalStore } from 'src/store/store'
  import { useTestsStore } from 'src/store/testsStore'
  import AssessmentDetails from './group-view-components/assessment-details.vue'
  import AssessmentList from './group-view-components/assessment-list.vue'
  import GroupTestAdmin from './group-view-components/group-test-admin.vue'
  import { useRoute } from 'vue-router'

  export default {
    name: 'GroupView',
    components: { AssessmentDetails, AssessmentList, GroupTestAdmin },
    props: { selectedGroupId: Number },

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
      assessmentData() {
        return this.assessmentsStore.currentAssessment
      },

      annotations: function () {
        return this.assessmentData?.annotations
      },
      displayClassBookButton() {
        return this.$route.name === 'AssessmentList' || this.$route.name === 'Diagnostik'
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
        return (
          this.isAllowed &&
          (this.$route.name === 'AssessmentList' ||
            (this.$route.name === 'Diagnostik' && !this.group.read_only))
        )
      },
    },
    watch: {
      '$route.name': {
        immediate: true,
        async handler(name) {
          switch (name) {
            case 'GroupTestAdmin':
              this.isAssessmentSettingsOpen = false
              this.isTestDetailsOpen = false
              this.isTestAdminOpen = true
              this.isTestListOpen = false
              break
            case 'Assessment':
              this.isAssessmentSettingsOpen = false
              this.isTestDetailsOpen = true
              this.isTestAdminOpen = false
              this.isTestListOpen = false

              break
            case 'AssessmentSettings':
              this.isAssessmentSettingsOpen = true
              this.isTestDetailsOpen = false
              this.isTestAdminOpen = false
              this.isTestListOpen = false
              break
            default:
              this.isAssessmentSettingsOpen = false
              this.isTestAdminOpen = false
              this.isTestDetailsOpen = false
              this.isTestListOpen = true
          }
        },
      },
    },

    async mounted() {
      this.getAssessmentData()
    },
    methods: {
      async getAssessmentData() {
        if (
          this.$route.params.testId &&
          parseInt(this.$route.params.groupId, 10) === this.selectedGroupId &&
          this.assessmentsStore.currentAssessment?.test?.id !==
            parseInt(this.$route.params.testId, 10)
        ) {
          await this.assessmentsStore.fetchCurrentAssessment(
            this.selectedGroupId,
            this.$route.params.testId
          )
        }
      },
      gotoClassbook() {
        if (this.group.owner) {
          this.$router.push(`/klassenbuch/eigene_klassen/${this.selectedGroupId}`)
        } else {
          this.$router.push(`/klassenbuch/geteilte_klassen/${this.selectedGroupId}`)
        }
      },

      openTestAdmin() {
        this.$router.push(`/diagnostik/${this.selectedGroupId}/testverwaltung`)
      },

      async setPreselect(data) {
        this.testSelected = data.testId
      },
      backToOverview() {
        this.assessmentsStore.setCurrentAssessment(undefined)
        this.$router.push(`/diagnostik/${this.selectedGroupId}`)
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
