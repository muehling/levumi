<template>
  <div classname="group-view">
    <div v-if="readOnly">
      <p>
        Diese Klasse ist mit Ihnen zur Ansicht geteilt, daher können Sie keine eigenen Messungen
        durchführen oder Einstellungen ändern.
      </p>
    </div>
    <div v-if="!!group.id && !assessmentData && isAllowed && !isTestAdminOpen" class="mb-2 mt-2">
      <b-btn variant="outline-secondary" size="sm" class="mb-3" @click="openTestAdmin">
        <i class="fas fa-gear mr-1"></i>Test hinzufügen / löschen
      </b-btn>
    </div>
    <b-button
      v-if="!!assessmentData || isTestAdminOpen"
      class="mb-2 mt-2"
      size="sm"
      variant="outline-secondary"
      @click="backToOverview"
    >
      <i class="fas fa-backward-step mr-1"></i> Zurück zur Testübersicht
    </b-button>
    <group-test-admin
      v-if="isAllowed"
      :group="group"
      :is-open="isTestAdminOpen"
      @close-test-admin="closeTestAdmin"
    />
    <assessment-view v-if="!isTestAdminOpen" :group="group" />
  </div>
</template>

<script>
  import { isAdmin } from '../../utils/user'
  import { useAssessmentsStore } from '../../store/assessmentsStore'
  import { useTestsStore } from '../../store/testsStore'
  import { useGlobalStore } from '../../store/store'
  import AssessmentView from './assessment-view.vue'
  import GroupTestAdmin from './group-test-admin.vue'

  export default {
    name: 'GroupView',
    components: { AssessmentView, GroupTestAdmin },

    props: {
      group: Object,
      isActive: Boolean,
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
          this.$root.pre_select && this.$root.pre_select.groupId === this.group.id
            ? this.$root.pre_select.testId
            : 0,
        isTestAdminOpen: false,
      }
    },
    computed: {
      assessmentData() {
        return this.assessmentsStore.currentAssessment
      },

      annotations: function () {
        return this.assessmentData?.annotations
      },
      isAllowed() {
        return !this.group.read_only || isAdmin(this.globalStore.login.capabilities)
      },
      readOnly() {
        return !!this.group.read_only
      },
    },

    async mounted() {
      this.$root.$on(`annotation-added-${this.group.id}`, this.addAnnotation)
      this.$root.$on(`annotation-removed-${this.group.id}`, this.removeAnnotation)
      await this.assessmentsStore.fetch(this.group.id)
      await this.testsStore.fetchUsedTestsForGroup(this.group.id)
    },

    methods: {
      openTestAdmin() {
        this.isTestAdminOpen = true
      },
      closeTestAdmin() {
        this.isTestAdminOpen = false
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
        this.isTestAdminOpen = false
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
