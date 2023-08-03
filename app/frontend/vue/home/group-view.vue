<template>
  <div classname="group-view">
    <div v-if="!!group.id" class="mb-2 mt-2">
      <b-btn v-b-toggle="'collapse_test_' + group.id" variant="outline-secondary" size="sm">
        <i class="fas fa-list"></i> Testübersicht der Klasse</b-btn
      >
      <b-collapse :id="'collapse_test_' + group.id" class="mt-2 mb-4" :visible="false">
        <!-- Listenansicht für alle Tests -->
        <list-view :group="group" :read_only="group.read_only" @set-preselect="setPreselect">
        </list-view>
      </b-collapse>
    </div>
    <b-card bg-variant="light" class="mt-3">
      <b-nav pills>
        <!-- Alle Lernbereiche -->
        <b-nav-item
          v-for="area in usedAreas"
          :key="area.id"
          :active="area.id == areaSelected"
          lazy
          @click="setSelectedArea(area.id)"
        >
          <span :class="area.used ? 'font-weight-bold' : ''">{{ area.name }}</span>
        </b-nav-item>
      </b-nav>

      <hr v-if="areaSelected && areaSelected !== -1" />
      <b-nav v-if="areaSelected && areaSelected !== -1 && enableTestTypes" pills class="mt-1">
        <!-- Alle Typen -->
        <b-nav-item
          v-for="testType in usedTestTypes"
          :id="group.id + '_test_type_' + testType.id"
          :key="testType.id"
          :active="testType.id == testTypeSelected"
          lazy
          @click="setSelectedTestType(testType.id)"
        >
          <span :class="testType.used ? 'font-weight-bold' : ''">{{ testType.name }}</span>
          <b-popover
            v-if="testType.description"
            :target="group.id + '_test_type_' + testType.id"
            triggers="hover"
            placement="topright"
          >
            <div v-html="testType.description"></div>
          </b-popover>
        </b-nav-item>
      </b-nav>

      <hr v-if="testTypeSelected && testTypeSelected !== -1 && enableTestTypes" />
      <b-nav v-if="testTypeSelected && testTypeSelected !== -1" pills class="mt-1">
        <!-- Alle Kompetenzen des gewählten Lernbereichs -->
        <b-nav-item
          v-for="competence in usedCompetences"
          :id="group.id + '_competence_' + competence.id"
          :key="competence.id"
          :active="competence.id == competenceSelected"
          lazy
          @click="setSelectedCompetence(competence.id)"
        >
          <span :class="competence.used ? 'font-weight-bold' : ''">{{ competence.name }}</span>
          <b-popover
            v-if="!competence.used && competence.description != undefined"
            :target="group.id + '_competence_' + competence.id"
            triggers="hover"
          >
            <div v-html="competence.description"></div>
          </b-popover>
        </b-nav-item>
      </b-nav>
      <hr v-if="competenceSelected && competenceSelected !== -1" />
      <b-nav v-if="competenceSelected && competenceSelected !== -1" pills class="mt-1">
        <!-- Alle Testfamilien der gewählten Kompetenz  -->
        <b-nav-item
          v-for="family in usedFamilies"
          :id="group.id + '_family_' + family.id"
          :key="family.id"
          :active="family.id == familySelected"
          lazy
          @click="setSelectedFamily(family.id)"
        >
          <span :class="family.used ? 'font-weight-bold' : ''">{{ family.name }}</span>
          <b-popover
            v-if="!family.used && family.description != undefined"
            :target="group.id + '_family_' + family.id"
            triggers="hover"
          >
            <div v-html="family.description"></div>
          </b-popover>
        </b-nav-item>
      </b-nav>
      <hr v-if="familySelected && familySelected !== -1" />
      <b-nav v-if="familySelected && familySelected !== -1" pills class="mt-1">
        <!-- Alle Niveaustufen der gewählten Testfamilie -->
        <b-nav-item
          v-for="test in usedTests"
          :id="group.id + '_test_' + test.info.id"
          :key="test.info.id"
          :active="test.info.id === test_selected"
          lazy
          @click="handleClickTest(test)"
        >
          <span :class="test.used ? 'font-weight-bold' : 'text-muted'">{{ test.info.level }}</span>
          <b-popover
            v-if="!test.used && test.info.description?.short !== undefined"
            :target="group.id + '_test_' + test.info.id"
            triggers="hover"
          >
            <div v-html="test.info.description.short"></div>
          </b-popover>
        </b-nav-item>
      </b-nav>
      <hr v-if="versions.length > 1" />
      <b-nav v-if="versions.length > 1" pills class="mt-1">
        <!-- Alle Versionen der gewählten Niveaustufe, falls vorhanden -->
        <b-nav-item
          v-for="version in usedVersions"
          :id="group.id + '_version_' + version.info.id"
          :key="version.info.id"
          :active="version.info.id === version_selected"
          lazy
          @click="handleClickVersion(version)"
        >
          <span :class="version.used ? 'font-weight-bold' : 'text-muted'">{{
            version.info.label
          }}</span>
          <b-popover
            v-if="!version.used && version.info.description.short != undefined"
            :target="group.id + '_version_' + version.info.id"
            triggers="hover"
          >
            <div v-html="version.info.description.short"></div>
          </b-popover>
        </b-nav-item>
      </b-nav>
    </b-card>
    <b-row :id="'assessment-jump' + group.id">
      <b-col>
        <div v-if="!isLoadingUpdate && !results">
          <p class="m-5 text-center text-muted">
            <span v-if="globalStore.studentsInGroups[group.id].length == 0">
              Aktuell sind noch keine Schüler:innen für die Klasse angelegt. Bitte legen Sie diese
              zuerst im Klassenbuch an, damit Sie testen können!
            </span>
            <span v-else-if="empty">
              Wählen Sie zuerst einen Lernbereich und dann aus der sich erweiternden Liste das
              Konstrukt, die Testfamilie und die Niveaustufe mit der Sie arbeiten möchten.
              <br />
              Informationen über alle Tests finden Sie oben unter dem Menüpunkt Testübersicht.
            </span>
            <span v-else>
              Kehren Sie zu Ihren vorherigen Tests zurück (fett gedruckt) oder wählen Sie einen
              neuen Test aus der Liste.
            </span>
          </p>
        </div>
        <!-- Spinner für die AJAX-Requests zum Laden eines gewählten Assessments-->
        <div v-if="isLoadingUpdate" class="spinner" style="padding-bottom: 75px">
          <div class="bounce1"></div>
          <div class="bounce2"></div>
          <div class="bounce3"></div>
        </div>

        <assessment-view
          v-else-if="results"
          :active="results.active"
          :annotations="annotations"
          :configuration="results.configuration"
          :excludes="results.excludes"
          :group="group"
          :read-only="group.read_only"
          :results="results.series"
          :student-test="results.student_test"
          :test="results.test"
          @update="loadAssessment(test_selected)"
          @remove-entry="removeEntry"
        >
        </assessment-view>
      </b-col>
    </b-row>
  </div>
</template>

<script>
  import { ajax } from '../../utils/ajax'
  import { useGlobalStore } from '../../store/store'
  import AssessmentView from './assessment-view.vue'
  import ListView from './list-view.vue'
  import isEmpty from 'lodash/isEmpty'

  export default {
    name: 'GroupView',
    components: { AssessmentView, ListView },

    props: {
      group: Object,
      groupInfo: Object,
      index: Number,
    },
    setup() {
      const globalStore = useGlobalStore()
      return { globalStore }
    },
    data: function () {
      return {
        areaSelected:
          this.$root.pre_select && this.$root.pre_select.group === this.group.id
            ? this.$root.pre_select.area
            : 0,
        competenceSelected:
          this.$root.pre_select && this.$root.pre_select.group === this.group.id
            ? this.$root.pre_select.competence
            : 0,
        enableTestTypes: false, // TODO when removed, also adapt ll. 28, 50, 425, 227-228
        familySelected:
          this.$root.pre_select && this.$root.pre_select.group === this.group.id
            ? this.$root.pre_select.family
            : 0,
        testTypeSelected: this.enableTestTypes
          ? 1
          : this.$root.pre_select && this.$root.pre_select.group === this.group.id
          ? this.$root.pre_select.type
          : undefined,

        results:
          this.$root.pre_select && this.$root.pre_select.group === this.group.id
            ? this.$root.pre_select.assessment
            : undefined,
        test_selected:
          this.$root.pre_select && this.$root.pre_select.group === this.group.id
            ? this.$root.pre_select.test
            : 0,
        isLoadingUpdate: false,
        isLoading: false,
        version_selected:
          this.$root.pre_select && this.$root.pre_select.group === this.group.id
            ? this.$root.pre_select.test
            : 0, //Funktioniert, da bei Deep-Link immer die aktuelle Version gewählt sein muss.
      }
    },
    computed: {
      testMetaData: function () {
        return this.globalStore.staticData.testMetaData
      },
      annotations: function () {
        return this.results.annotations
      },
      empty: function () {
        //Ist überhaupt ein Assessment vorhanden?
        return this.groupInfo.length > 0
      },
      tests: function () {
        let res = []
        for (let i = 0; i < this.testMetaData?.tests.length; ++i) {
          if (
            this.testMetaData?.tests[i].test_family_id == this.familySelected &&
            this.testMetaData?.tests[i].label === 'Aktuell'
          ) {
            let versions = []
            let used = false
            for (let j = 0; j < this.testMetaData?.tests.length; ++j) {
              if (
                this.testMetaData?.tests[i].level == this.testMetaData?.tests[j].level &&
                this.testMetaData?.tests[j].test_family_id == this.familySelected
              ) {
                versions.push(this.testMetaData?.tests[j])
                used = !!this.groupInfo.used_test_ids.find(
                  testId => testId === this.testMetaData?.tests[j].id
                )
              }
            }
            res.push({ info: this.testMetaData?.tests[i], used, versions })
          }
        }

        return res
      },
      //Alle Versionen des gewählten Tests
      versions() {
        const level = this.testMetaData.tests.find(test => test.id === this.test_selected)?.level

        const res = this.testMetaData.tests.reduce((acc, test) => {
          if (test.level === level && test.test_family_id === this.familySelected) {
            const used = !!this.groupInfo.used_test_ids.find(id => id === test.id)
            acc.push({ info: test, used })
          }
          return acc
        }, [])

        return res.sort((a, b) => b?.info.id - a?.info.id)
      },
      usedAreas() {
        return this.testMetaData.areas
          .reduce((acc, area) => {
            area.used = !!this.groupInfo.used_test_ids.some(usedId =>
              area.test_ids.find(testId => testId === usedId)
            )
            if (area.used || !this.group.read_only) {
              acc.push(area)
            }
            return acc
          }, [])
          .sort((a, b) => (b?.name < a?.name ? 1 : -1))
      },
      usedCompetences() {
        return this.testMetaData?.competences
          .reduce((acc, competence) => {
            competence.used = !!this.groupInfo.used_test_ids.some(usedId =>
              competence.test_ids.find(testId => testId === usedId)
            )

            if (
              (competence.used || !this.group.read_only) &&
              competence.area_id === this.areaSelected &&
              competence.used_test_types.find(test_type => test_type === this.testTypeSelected)
            ) {
              acc.push(competence)
            }
            return acc
          }, [])
          .sort((a, b) => (b?.name < a?.name ? 1 : -1))
      },
      usedFamilies() {
        return this.testMetaData?.test_families
          .reduce((acc, family) => {
            family.used = !!this.groupInfo.used_test_ids.some(usedId =>
              family.test_ids.find(testId => testId === usedId)
            )
            if (
              (family.used || !this.group.read_only) &&
              family.competence_id === this.competenceSelected &&
              family.used_test_types.find(test_type => test_type === this.testTypeSelected)
            ) {
              acc.push(family)
            }
            return acc
          }, [])
          .sort((a, b) => (b?.name < a?.name ? 1 : -1))
      },
      usedTests() {
        return this.tests
          .filter(test => {
            return (
              (this.groupInfo.used_test_ids.find(t => t.id === test.info.id) ||
                !this.group.read_only) &&
              (test.info.test_type_id === this.testTypeSelected ||
                (test.info.test_type_id === null && this.testTypeSelected === 1))
            )
          })
          .sort((a, b) => (b?.level < a?.level ? 1 : -1))
      },
      usedTestTypes() {
        const currentArea = this.testMetaData.areas.find(area => area.id === this.areaSelected)

        const typeLabels = this.globalStore.staticData.testTypes.filter(testType => {
          return currentArea.used_test_types.find(testTypeId => testTypeId === testType.id)
        })
        if (isEmpty(typeLabels)) {
          typeLabels.unshift(this.globalStore.staticData.testTypes[0])
        }
        //TODO sobald das TestTypes-Feature angeschaltet wird, müssen hier die used-Flags an die TestTypes gemapped werden.
        return typeLabels
      },
      usedVersions() {
        return this.versions.filter(
          version => version.used || (!version.info.archive && !this.group.read_only)
        )
      },
    },
    async mounted() {
      this.$root.$on(`annotation-added-${this.group.id}`, this.addAnnotation)
      this.$root.$on(`annotation-removed-${this.group.id}`, this.removeAnnotation)
    },

    methods: {
      addAnnotation(annotation) {
        const annotations = this.results.annotations
        annotations.splice(0, 0, annotation)
        this.$set(this.results, 'annotations', annotations)
      },
      removeAnnotation(annotationId) {
        const annotations = this.results.annotations.filter(a => annotationId !== a.id)
        this.$set(this.results, 'annotations', annotations)
      },
      async setPreselect(data) {
        this.areaSelected = data.area
        this.competenceSelected = data.competence
        this.familySelected = data.family
        this.testTypeSelected = data.type
        this.test_selected = data.test

        await this.$nextTick() // wait until computed properties have refreshed
        const test = this.usedTests.find(t => t.info.id === data.test)

        this.loadAssessment(test, false)
        this.jQuery('html, body').animate(
          { scrollTop: this.jQuery('#assessment-jump' + this.group.id).offset().top },
          'slow'
        )
      },

      handleClickTest(test) {
        this.test_selected = -1
        this.version_selected = 0
        this.results = undefined
        if (test.used) {
          if (test.versions.length === 1) {
            this.loadAssessment(test, false)
          } else {
            this.test_selected = test.info.id
          }
        } else {
          this.createAssessment(test, false)
        }
      },

      handleClickVersion(version) {
        this.test_selected = -1
        this.version_selected = 0
        this.results = undefined
        if (version.used) {
          this.loadAssessment(version, true)
        } else {
          this.createAssessment(version, true)
        }
      },

      //Neues Assessment anlegen und, bei Erfolg, laden.
      createAssessment(test, isVersion) {
        if (test.info.archive) {
          return
        }
        if (test.info.label !== 'Aktuell') {
          this.loadAssessment(test, isVersion)
        } else {
          ajax({
            contentType: 'application/x-www-form-urlencoded',
            data: `test_id=${test.info.id}`,
            method: 'post',
            url: `/groups/${this.group.id}/assessments/`,
          }).then(() => {
            this.propagateUsedTest(test.info.id)
            this.loadAssessment(test, isVersion)
          })
        }
      },
      //Gewähltes Assessment nachladen und Daten in Assessment-View weiterreichen.
      async loadAssessment(test, isVersion) {
        if (isVersion) {
          this.version_selected = test.info.id
        } else {
          this.test_selected = test.info.id
        }
        //return
        if (!test.info.id) {
          return
        }
        this.isLoadingUpdate = true //Spinner anzeigen
        const res = await ajax({ url: `/groups/${this.group.id}/assessments/${test.info.id}` }) // TODO: durch api-routes Aufruf ersetzen
        if (res.status === 200) {
          const text = await res.text()
          this.results = JSON.parse(text)
          this.isLoadingUpdate = false //Spinner verstecken
        } else if (res.status === 404) {
          // safety net in case no assessment could be found.
          this.createAssessment({ info: { id: test.info.id } }, isVersion)
        } else {
          // only hide spinner, nothing to show
          this.isLoadingUpdate = false
          this.results = {}
        }
      },

      //Lernbereich setzen und folgende Wahlmöglichkeiten zurücksetzen
      setSelectedArea(area) {
        this.areaSelected = area
        if (this.usedTestTypes.length === 1 || !this.enableTestTypes) {
          this.testTypeSelected = 1
        } else {
          this.testTypeSelected = -1
        }
        this.competenceSelected = -1
        this.familySelected = -1
        this.test_selected = -1
        this.version_selected = 0
        this.results = null
      },
      setSelectedTestType(testType) {
        this.testTypeSelected = testType
        this.competenceSelected = -1
        this.familySelected = -1
        this.test_selected = -1
        this.version_selected = 0
        this.results = null
      },
      //Kompetenz setzen und folgende Wahlmöglichkeiten zurücksetzen
      setSelectedCompetence(competence) {
        this.competenceSelected = competence
        this.familySelected = -1
        this.test_selected = -1
        this.version_selected = 0
        this.results = null
      },
      //Testfamilie setzen und folgende Wahlmöglichkeiten zurücksetzen
      setSelectedFamily(family) {
        this.familySelected = family
        this.test_selected = -1
        this.version_selected = 0
        this.results = null
      },

      propagateUsedTest(testId) {
        this.$emit('test-used', testId, this.group.id)
      },
      removeEntry(index) {
        this.results.series.splice(index, 1)
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
