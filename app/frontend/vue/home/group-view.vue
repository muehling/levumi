<template>
  <div classname="group-view">
    <div v-if="readOnly">
      <p>
        Diese Klasse ist mit Ihnen zur Ansicht geteilt, daher können Sie keine eigenen Messungen
        durchführen oder Einstellungen ändern.
      </p>
    </div>
    <div v-if="!!group.id" class="mb-2 mt-2">
      <list-view :group="group" />
      <create-assessment-view
        v-if="isAllowed"
        :group="group"
        :group-info="groupInfo"
        @select-test="setPreselect"
      />
    </div>
    <assessment-view :group="group" :current-test-id="testSelected" />
  </div>
</template>

<script>
  import { isAdmin } from '../../utils/user'
  import { useAssessmentsStore } from '../../store/assessmentsStore'
  import { useGlobalStore } from '../../store/store'
  import AssessmentView from './assessment-view.vue'
  import CreateAssessmentView from './create-assessment-view.vue'
  import ListView from './list-view.vue'

  export default {
    name: 'GroupView',
    components: { AssessmentView, ListView, CreateAssessmentView },

    props: {
      group: Object,
      groupInfo: Object,
      isActive: Boolean,
    },
    setup() {
      const globalStore = useGlobalStore()
      const assessmentsStore = useAssessmentsStore()
      return { globalStore, assessmentsStore }
    },
    data: function () {
      return {
        areaSelected:
          this.$root.pre_select && this.$root.pre_select.groupId === this.group.id
            ? this.$root.pre_select.areaId
            : 0,
        competenceSelected:
          this.$root.pre_select && this.$root.pre_select.groupId === this.group.id
            ? this.$root.pre_select.competenceId
            : 0,
        familySelected:
          this.$root.pre_select && this.$root.pre_select.groupId === this.group.id
            ? this.$root.pre_select.familyId
            : 0,
        enableTestTypes: true, // TODO when removed, also adapt ll. 28, 50, 425, 227-228
        testTypeSelected: this.enableTestTypes
          ? 1
          : this.$root.pre_select && this.$root.pre_select.groupId === this.group.id
          ? this.$root.pre_select.testTypeId
          : this.globalStore.staticData.testMetaData.test_types[0], // equals computed defaultTestType
        results:
          this.$root.pre_select && this.$root.pre_select.groupId === this.group.id
            ? this.$root.pre_select.assessmentId
            : undefined,
        testSelected:
          this.$root.pre_select && this.$root.pre_select.groupId === this.group.id
            ? this.$root.pre_select.testId
            : 0,
        isLoadingUpdate: false,
        isLoading: false,
        versionSelected:
          this.$root.pre_select && this.$root.pre_select.group === this.group.id
            ? this.$root.pre_select.test
            : 0, //Funktioniert, da bei Deep-Link immer die aktuelle Version gewählt sein muss.
      }
    },
    computed: {
      assessmentData() {
        return this.assessmentsStore.currentAssessment
      },
      defaultTestType() {
        return this.testMetaData.test_types[0]
      },
      testMetaData: function () {
        return this.globalStore.staticData.testMetaData
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
    /* watch: {
      '$route.params': {
        immediate: true,
        handler(data) {
          if (!data.testId) {
            return
          }
          const test = this.globalStore.staticData.testMetaData.tests.find(
            test => test.id === data.testId
          )
          if (!test) {
            return
          }
          // might happen that there is more than one group-view mounted. In this case, only update the relevant one.
          if (data.groupId !== this.group.id) {
            return
          }

          const preselect = {
            areaId: test.area_id,
            competenceId: test.competence_id,
            familyId: test.test_family_id,
            typeId: test.test_type_id || this.defaultTestType.id,
            testId: test.id,
          }
          this.setPreselect(preselect, false, true)
        },
      },
    },*/
    async mounted() {
      this.$root.$on(`annotation-added-${this.group.id}`, this.addAnnotation)
      this.$root.$on(`annotation-removed-${this.group.id}`, this.removeAnnotation)
    },

    methods: {
      addAnnotation(annotation) {
        const annotations = this.assessmentData.annotations
        annotations.splice(0, 0, annotation)
        this.$set(this.assessmentData, 'annotations', annotations)
      },

      removeAnnotation(annotationId) {
        const annotations = this.assessmentData.annotations.filter(a => annotationId !== a.id)
        this.$set(this.assessmentData, 'annotations', annotations)
      },

      async setPreselect(data, isVersion) {
        this.testSelected = data.testId
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
