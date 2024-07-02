<template>
  <b-container fluid>
    <div v-if="isLoading">
      <div class="spinner">
        <div class="bounce1"></div>
        <div class="bounce2"></div>
        <div class="bounce3"></div>
      </div>
    </div>
    <div v-else>
      <b-row class="mt-3">
        <b-col md="12">
          <div class="text-muted text-small">Lernbereich auswählen</div>
          <b-button-group>
            <b-button
              v-for="area in filteredAreas"
              :key="area.id"
              class="me-1"
              variant="outline-primary"
              :pressed="selected_area == area.id"
              @click="setSelectedArea(area.id)">
              {{ area.name }}
            </b-button>
          </b-button-group>
        </b-col>
      </b-row>
      <b-row v-if="filteredCompetences.length > 0" class="mt-2">
        <b-col md="12">
          <div class="text-muted text-small">Kompetenz auswählen</div>
          <b-button-group>
            <b-button
              v-for="competence in filteredCompetences"
              :key="competence.id"
              class="me-1"
              variant="outline-primary"
              :pressed="selected_competence == competence.id"
              @click="setSelectedCompetence(competence.id)">
              {{ competence.name }}
            </b-button>
          </b-button-group>
        </b-col>
      </b-row>
      <b-row v-if="filteredTestFamilies.length > 0" class="mt-2">
        <b-col md="12">
          <div class="text-muted text-small">Testart auswählen</div>
          <b-button-group>
            <b-button
              v-for="family in filteredTestFamilies"
              :key="family.id"
              class="me-1"
              variant="outline-primary"
              :pressed="selected_family == family.id"
              @click="setSelectedFamily(family.id)">
              {{ family.name }}
            </b-button>
          </b-button-group>
        </b-col>
      </b-row>
      <b-row v-if="filteredTests.length > 0" class="mt-2">
        <b-col md="12">
          <div class="text-muted text-small">Niveaustufe auswählen</div>
          <b-button-group>
            <b-button
              v-for="test in filteredTests"
              :key="test.id"
              class="me-1"
              variant="outline-primary"
              :pressed="selected_test == test.id"
              @click="selected_test = test.id">
              {{ test.level }}
            </b-button>
          </b-button-group>
        </b-col>
      </b-row>
      <b-row class="mt-3">
        <b-col md="12">
          <b-card v-if="filteredMaterials.length > 0" no-body>
            <!-- b-tabs funktioniert nicht bei anfangs leerer Liste, daher eigene Lösung -->
            <b-tabs card pills vertical>
              <b-tab
                v-for="material in filteredMaterials"
                :key="material.id"
                :title="material.name">
                <material-view :material="material" :full="true"></material-view>
              </b-tab>
            </b-tabs>
          </b-card>
          <b-card v-else>
            <div class="text-center text-muted">
              Wählen Sie aus, wofür sie Fördermaterial suchen. Es werden Ihnen immer alle passenden
              Materialen für Ihre aktuelle Auswahl angezeigt.
              <br />
              Manche Materialien sind für spezifische Niveaustufen eines Tests geeignet und werden
              erst angezeigt wenn diese ausgewählt ist.
              <br />
              Andere sind für ganze Testarten oder Kompetenzen geeignet und werden im Auswahlprozess
              schon vorab angezeigt.
            </div>
          </b-card>
        </b-col>
      </b-row>
    </div>
  </b-container>
</template>

<script>
  import { checkUserSettings } from '../../utils/user'
  import { useGlobalStore } from '../../store/store'
  import { useMaterialsStore } from '../../store/materialsStore'
  import flatten from 'lodash/flatten'
  import MaterialView from './material-view.vue'
  export default {
    name: 'MaterialsApp',
    components: { MaterialView },
    setup() {
      const globalStore = useGlobalStore()
      const materialsStore = useMaterialsStore()
      return { materialsStore, globalStore }
    },
    data: function () {
      return {
        selected_area: -1,
        selected_competence: -1,
        selected_family: -1,
        selected_test: -1,
      }
    },
    computed: {
      isLoading() {
        return this.materialsStore.isLoading
      },
      mData() {
        return this.materialsStore.materials
      },
      filteredAreas() {
        // hides ARTH materials from everyone who does not have hideArthMaterials set to true
        //TODO remove check once DDM is done. then, always return all areas.
        if (
          checkUserSettings(
            this.globalStore.login.settings,
            'visibilities.general.hideArthMaterials'
          ) ||
          !checkUserSettings(this.globalStore.login.settings, 'visibilities.general')
        ) {
          const arthIds = this.mData.tests
            .filter(test => test.shorthand === 'ARTH' || test.shorthand === 'ARTH_SHORT')
            .map(test => test.area_id)
          return this.mData.areas.filter(area => arthIds.findIndex(id => id === area.id))
        } else {
          return this.mData.areas
        }
      },
      filteredCompetences() {
        return this.mData.competences
          ? Object.values(this.mData.competences).filter(
              competence => competence.area_id === this.selected_area
            )
          : []
      },
      filteredTestFamilies() {
        return this.mData.test_families
          ? Object.values(this.mData.test_families).filter(
              family => family.competence_id === this.selected_competence
            )
          : []
      },
      filteredTests() {
        return this.mData.tests
          ? Object.values(this.mData.tests).filter(
              test => test.test_family_id === this.selected_family
            )
          : []
      },
      filteredMaterials() {
        const supports = this.mData.supports ? Object.values(this.mData.supports) : []

        const materialIds = flatten([
          supports
            .filter(support => support.area_id === this.selected_area)
            .map(n => n.material_id),
          supports
            .filter(support => support.competence_id === this.selected_competence)
            .map(n => n.material_id),
          supports
            .filter(support => support.test_family_id === this.selected_family)
            .map(n => n.material_id),
          supports
            .filter(support => support.test_id === this.selected_test)
            .map(n => n.material_id),
        ])

        const materials = this.mData.materials ? this.mData.materials : []
        return materials.filter(material => materialIds.findIndex(m => m === material.id) !== -1)
      },
    },
    async created() {
      await this.materialsStore.fetch()
    },
    methods: {
      setSelectedArea(id) {
        this.selected_area = id
        this.selected_competence = -1
        this.selected_family = -1
        this.selected_test = -1
      },
      setSelectedCompetence(id) {
        this.selected_competence = id
        this.selected_family = -1
        this.selected_test = -1
      },
      setSelectedFamily(id) {
        this.selected_family = id
        this.selected_test = -1
      },
    },
  }
</script>
