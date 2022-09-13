<template>
  <div>
    <div v-if="!!group.id" class="mb-2 mt-2">
      <b-btn
        v-b-toggle="'collapse_test_' + group.id"
        variant="outline-secondary"
        size="sm"
        @click="toggleAssessments()"
        ><i class="fas fa-list"></i> Testübersicht der Klasse</b-btn
      >
      <b-collapse :id="'collapse_test_' + group.id" class="mt-2 mb-4" :visible="false">
        <!-- Spinner für die AJAX-Requests zum Laden der Liste -->
        <div v-if="isLoading" class="spinner" style="padding-bottom: 75px">
          <div class="bounce1"></div>
          <div class="bounce2"></div>
          <div class="bounce3"></div>
        </div>
        <!-- Listenansicht für alle Tests -->
        <list-view
          v-else-if="list"
          :list="list"
          :group="group"
          :read_only="group.read_only"
          @update:list="
            list = undefined
            toggleAssessments()
          "
        >
        </list-view>
      </b-collapse>
    </div>
    <b-card bg-variant="light" class="mt-3">
      <b-row>
        <b-col md="12">
          <b-nav pills>
            <!-- Alle Lernbereiche -->
            <b-nav-item
              v-for="area in usedAreas"
              :key="area.info.id"
              :active="area.info.id == areaSelected"
              @click="
                area.used = true
                select_area(area.info.id)
              "
            >
              <span :class="area.used ? 'font-weight-bold' : 'text-muted'">{{
                area.info.name
              }}</span>
            </b-nav-item>
          </b-nav>

          <b-nav pills class="mt-1">
            <!-- Alle Kompetenzen des gewählten Lernbereichs -->
            <b-nav-item
              v-for="competence in usedCompetences"
              :id="group.id + '_competence_' + competence.info.id"
              :key="competence.info.id"
              :active="competence.info.id == competenceSelected"
              @click=";(competence.used = true), select_competence(competence.info.id)"
            >
              <span :class="competence.used ? 'font-weight-bold' : 'text-muted'">{{
                competence.info.name
              }}</span>
              <b-popover
                v-if="!competence.used && competence.info.description != undefined"
                :target="group.id + '_competence_' + competence.info.id"
                triggers="hover"
              >
                <div v-html="competence.info.description"></div>
              </b-popover>
            </b-nav-item>
          </b-nav>

          <b-nav pills class="mt-1">
            <!-- Alle Testfamilien der gewählten Kompetenz  -->
            <b-nav-item
              v-for="family in usedFamilies"
              :id="group.id + '_family_' + family.info.id"
              :key="family.info.id"
              :active="family.info.id == family_selected"
              @click=";(family.used = true), select_family(family.info.id)"
            >
              <span :class="family.used ? 'font-weight-bold' : 'text-muted'">{{
                family.info.name
              }}</span>
              <b-popover
                v-if="!family.used && family.info.description != undefined"
                :target="group.id + '_family_' + family.info.id"
                triggers="hover"
              >
                <div v-html="family.info.description"></div>
              </b-popover>
            </b-nav-item>
          </b-nav>

          <b-nav pills class="mt-1">
            <!-- Alle Niveaustufen der gewählten Testfamilie -->
            <b-nav-item
              v-for="test in usedTests"
              :id="group.id + '_test_' + test.info.id"
              :key="test.info.id"
              :active="test.info.id == test_selected"
              @click="
                test.used
                  ? test.versions.length == 1
                    ? loadAssessment(test.info.id, false)
                    : (test_selected = test.info.id)
                  : createAssessment(test, false)
              "
            >
              <span :class="test.used ? 'font-weight-bold' : 'text-muted'">{{
                test.info.level
              }}</span>
              <b-popover
                v-if="!test.used && test.info.description.short != undefined"
                :target="group.id + '_test_' + test.info.id"
                triggers="hover"
              >
                <div v-html="test.info.description.short"></div>
              </b-popover>
            </b-nav-item>
          </b-nav>

          <b-nav v-if="versions.length > 1" pills class="mt-1">
            <!-- Alle Versionen der gewählten Niveaustufe, falls vorhanden -->
            <b-nav-item
              v-for="version in usedVersions"
              :id="group.id + '_version_' + version.info.id"
              :key="version.info.id"
              :active="version.info.id == version_selected"
              @click="
                version.used
                  ? loadAssessment(version.info.id, true)
                  : createAssessment(version, true)
              "
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
        </b-col>
      </b-row>
    </b-card>
    <b-row>
      <b-col>
        <div v-if="!isLoadingUpdate && !results">
          <p class="m-5 text-center text-muted">
            <span v-if="student_name_parts.length == 0">
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
          :annotations="results.annotations"
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

  export default {
    name: 'GroupView',
    components: { AssessmentView, ListView },
    provide: function () {
      //Alle Teile der Kindnamen speichern, damit sie in Kommentaren verschlüsselt werden können.
      let todo = this.globalStore.studentsInGroups[this.group.id] || []

      for (let i = 0; i < todo.length; ++i) {
        this.student_name_parts = this.student_name_parts.concat(todo[i].name.split(/[^a-zäöüß_]/i))
      }
      const stopwords = ['von', 'und', 'auf', 'der', 'zu']
      this.student_name_parts = this.student_name_parts
        .filter(word => !stopwords.includes(word))
        .filter((v, i, a) => a.indexOf(v) === i)
      return {
        student_name_parts: this.student_name_parts,
      }
    },
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
        family_selected:
          this.$root.pre_select && this.$root.pre_select.group === this.group.id
            ? this.$root.pre_select.family
            : 0,
        list: undefined,
        results:
          this.$root.pre_select && this.$root.pre_select.group === this.group.id
            ? this.$root.pre_select.assessment
            : undefined,
        student_name_parts: [],
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
      empty: function () {
        //Ist überhaupt ein Assessment vorhanden?
        for (let i = 0; i < this.groupInfo?.areas.length; ++i) {
          if (this.groupInfo?.areas[i].used) {
            return false
          }
        }
        return true
      },
      //Alle zur aktuellen Familie passenden Tests, jeweils nur die aktuelle Version
      tests: function () {
        let res = []
        for (let i = 0; i < this.groupInfo?.tests.length; ++i) {
          if (
            this.groupInfo?.tests[i].info.test_family_id == this.family_selected &&
            this.groupInfo?.tests[i].info.label === 'Aktuell'
          ) {
            let versions = []
            let used = false
            for (let j = 0; j < this.groupInfo?.tests.length; ++j) {
              if (
                this.groupInfo?.tests[i].info.level == this.groupInfo?.tests[j].info.level &&
                this.groupInfo?.tests[j].info.test_family_id == this.family_selected
              ) {
                versions.push(this.groupInfo?.tests[j])
                if (this.groupInfo?.tests[j].used) {
                  used = true
                }
              }
            }
            res.push({ info: this.groupInfo?.tests[i].info, used: used, versions: versions })
          }
        }

        return res
      },
      //Alle Versionen des gewählten Tests
      versions() {
        let level = ''
        for (let i = 0; i < this.groupInfo?.tests.length; ++i) {
          if (this.groupInfo?.tests[i].info.id == this.test_selected) {
            level = this.groupInfo?.tests[i].info.level
          }
        }
        let res = []
        for (let i = 0; i < this.groupInfo?.tests.length; ++i) {
          if (
            this.groupInfo?.tests[i].info.level === level &&
            this.groupInfo?.tests[i].info.test_family_id == this.family_selected
          ) {
            res.push(this.groupInfo?.tests[i])
          }
        }
        return res.sort((a, b) => b.info.id - a.info.id)
      },
      usedAreas() {
        return this.groupInfo?.areas.filter(area => area.used || !this.group.read_only)
      },
      usedCompetences() {
        return this.groupInfo?.competences.filter(
          competence =>
            (competence.used || !this.group.read_only) &&
            competence.info.area_id == this.areaSelected
        )
      },
      usedFamilies() {
        return this.groupInfo?.families.filter(
          family =>
            (family.used || !this.group.read_only) &&
            family.info.competence_id == this.competenceSelected
        )
      },
      usedTests() {
        return this.tests.filter(test => test.used || !this.group.read_only)
      },
      usedVersions() {
        return this.versions.filter(
          version => version.used || (!version.info.archive && !this.group.read_only)
        )
      },
    },
    methods: {
      //Neues Assessment anlegen und, bei Erfolg, laden.
      createAssessment(test, isVersion) {
        //TODO not tested yet
        ajax({
          contentType: 'application/x-www-form-urlencoded',
          data: `test_id=${test.info.id}`,
          method: 'post',
          url: `/groups/${this.group.id}/assessments/`,
        }).then(() => {
          this.use_test(test.info.id)
          this.loadAssessment(test.info.id, isVersion)
        })
      },
      //Gewähltes Assessment nachladen und Daten in Assessment-View weiterreichen.
      async loadAssessment(test, isVersion) {
        if (isVersion) {
          this.version_selected = test
        } else {
          this.test_selected = test
        }
        this.isLoadingUpdate = true //Spinner anzeigen
        const res = await ajax({ url: `/groups/${this.group.id}/assessments/${test}` })
        if (res.status === 200) {
          const text = await res.text()
          this.results = JSON.parse(text)
          this.isLoadingUpdate = false //Spinner verstecken
        }
      },
      async toggleAssessments() {
        if (this.list != undefined) {
          this.list = undefined
          return
        }
        this.isLoading = true //Spinner anzeigen

        const res = await ajax({ url: `/groups/${this.group.id}/assessments` })
        if (res.status === 200) {
          const text = await res.text()
          this.list = JSON.parse(text)
          this.isLoading = false //Spinner verstecken
        }
      },
      //Lernbereich setzen und folgende Wahlmöglichkeiten zurücksetzen
      select_area(area) {
        this.areaSelected = area
        this.competenceSelected = -1
        this.family_selected = -1
        this.test_selected = -1
        this.version_selected = -1
        this.results = null
      },
      //Kompetenz setzen und folgende Wahlmöglichkeiten zurücksetzen
      select_competence(competence) {
        this.competenceSelected = competence
        this.family_selected = -1
        this.test_selected = -1
        this.version_selected = -1
        this.results = null
      },
      //Testfamilie setzen und folgende Wahlmöglichkeiten zurücksetzen
      select_family(family) {
        this.family_selected = family
        this.test_selected = -1
        this.version_selected = -1
        this.results = null
      },
      use_test(testId) {
        this.$emit('test-used', testId, this.index)
      },
      removeEntry(index) {
        this.results.series.splice(index, 1)
      },
    },
  }
</script>
