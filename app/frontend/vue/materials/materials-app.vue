<template>
  <b-container v-cloak fluid>
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
              v-for="area in mData.areas"
              :key="area.id"
              class="mr-1"
              variant="outline-primary"
              :pressed="selected_area == area.id"
              @click="
                selected_area = area.id
                selected_competence = -1
                selected_family = -1
                selected_test = -1
              "
            >
              {{ area.name }}
            </b-button>
          </b-button-group>
        </b-col>
      </b-row>
      <b-row v-if="filtered_competences.length > 0" class="mt-2">
        <b-col md="12">
          <div class="text-muted text-small">Kompetenz auswählen</div>
          <b-button-group>
            <b-button
              v-for="competence in filtered_competences"
              :key="competence.id"
              class="mr-1"
              variant="outline-primary"
              :pressed="selected_competence == competence.id"
              @click="
                selected_competence = competence.id
                selected_family = -1
                selected_test = -1
              "
            >
              {{ competence.name }}
            </b-button>
          </b-button-group>
        </b-col>
      </b-row>
      <b-row v-if="filtered_families.length > 0" class="mt-2">
        <b-col md="12">
          <div class="text-muted text-small">Testart auswählen</div>
          <b-button-group>
            <b-button
              v-for="family in filtered_families"
              :key="family.id"
              class="mr-1"
              variant="outline-primary"
              :pressed="selected_family == family.id"
              @click="
                selected_family = family.id
                selected_test = -1
              "
            >
              {{ family.name }}
            </b-button>
          </b-button-group>
        </b-col>
      </b-row>
      <b-row v-if="filtered_tests.length > 0" class="mt-2">
        <b-col md="12">
          <div class="text-muted text-small">Niveaustufe auswählen</div>
          <b-button-group>
            <b-button
              v-for="test in filtered_tests"
              :key="test.id"
              class="mr-1"
              variant="outline-primary"
              :pressed="selected_test == test.id"
              @click="selected_test = test.id"
            >
              {{ test.level }}
            </b-button>
          </b-button-group>
        </b-col>
      </b-row>
      <b-row class="mt-3">
        <b-col md="12">
          <b-card v-if="filtered_materials.length > 0" no-body>
            <!-- b-tabs funktioniert nicht bei anfangs leerer Liste, daher eigene Lösung -->
            <b-tabs card pills vertical>
              <b-tab
                v-for="material in filtered_materials"
                :key="material.id"
                :title="material.name"
              >
                <material-view :material="material" :full="true"></material-view>
              </b-tab>
            </b-tabs>
          </b-card>
          <b-card v-else>
            <div class="text-center text-muted">
              Wählen Sie aus, wofür sie Fördermaterial suchen. Es werden Ihnen immer alle passenden
              Materialen für Ihre aktuelle Auswahl angezeigt.<br />
              Manche Materialien sind für spezifische Niveaustufen eines Tests geeignet und werden
              erst angezeigt wenn diese ausgewählt ist.<br />
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
  import MaterialView from './material-view.vue'
  import { useMaterialsStore } from '../../store/materialsStore'
  import flatten from 'lodash/flatten'
  export default {
    name: 'MaterialsApp',
    components: { MaterialView },
    setup() {
      const materialsStore = useMaterialsStore()
      return { materialsStore }
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
      filtered_competences() {
        return this.mData.competences
          ? Object.values(this.mData.competences).filter(
              competence => competence.area_id === this.selected_area
            )
          : []
      },
      filtered_families() {
        return this.mData.test_families
          ? Object.values(this.mData.test_families).filter(
              family => family.competence_id === this.selected_competence
            )
          : []
      },
      filtered_tests() {
        return this.mData.tests
          ? Object.values(this.mData.tests).filter(
              test => test.test_family_id === this.selected_family
            )
          : []
      },
      filtered_materials() {
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
  }
</script>
