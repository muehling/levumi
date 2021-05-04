<template>
    <b-container fluid v-cloak>
        <b-row class='mt-3'>
            <b-col md='12'>
                <div class='text-muted text-small'>Lernbereich auswählen</div>
                <b-button-group>
                    <b-button v-for="area in areas"
                              :key="area.id"
                              class='mr-1'
                              variant='outline-primary'
                              :pressed="selected_area == area.id"
                              @click="selected_area = area.id, selected_competence = -1, selected_family = -1, selected_test = -1"
                    >
                        {{area.name}}
                    </b-button>
                </b-button-group>
            </b-col>
        </b-row>
        <b-row class='mt-2' v-if="filtered_competences.length > 0">
            <b-col md='12'>
                <div class='text-muted text-small'>Kompetenz auswählen</div>
                <b-button-group>
                    <b-button v-for="competence in filtered_competences"
                              :key="competence.id"
                              class='mr-1'
                              variant='outline-primary'
                              :pressed="selected_competence == competence.id"
                              @click="selected_competence = competence.id, selected_family = -1, selected_test = -1"
                    >
                        {{competence.name}}
                    </b-button>
                </b-button-group>
            </b-col>
        </b-row>
        <b-row class='mt-2' v-if="filtered_families.length > 0">
            <b-col md='12'>
                <div class='text-muted text-small'>Testart auswählen</div>
                <b-button-group>
                    <b-button v-for="family in filtered_families"
                              :key="family.id"
                              class='mr-1'
                              variant='outline-primary'
                              :pressed="selected_family == family.id"
                              @click="selected_family = family.id, selected_test = -1"
                    >
                        {{family.name}}
                    </b-button>
                </b-button-group>
            </b-col>
        </b-row>
        <b-row class='mt-2' v-if="filtered_tests.length > 0">
            <b-col md='12'>
                <div class='text-muted text-small'>Niveaustufe auswählen</div>
                <b-button-group>
                    <b-button v-for="test in filtered_tests"
                              :key="test.id"
                              class='mr-1'
                              variant='outline-primary'
                              :pressed="selected_test == test.id"
                              @click="selected_test = test.id"
                    >
                        {{test.level}}
                    </b-button>
                </b-button-group>
            </b-col>
        </b-row>
        <b-row class='mt-3'>
            <b-col md='12'>
                <b-card no-body v-if="filtered_materials.length > 0">  <!-- b-tabs funktioniert nicht bei anfangs leerer Liste, daher eigene Lösung -->
                    <b-tabs card pills vertical>
                        <b-tab v-for="material in filtered_materials" :key="material.id" :title="material.name">
                            <material-view :material="material" :full="true"></material-view>
                        </b-tab>
                    </b-tabs>
                </b-card>
                <b-card v-else>
                    <div class='text-center text-muted'>
                        Wählen Sie aus, wofür sie Fördermaterial suchen. Es werden Ihnen immer alle passenden Materialen für Ihre aktuelle Auswahl angezeigt.<br/>
                        Manche Materialien sind für spezifische Niveaustufen eines Tests geeignet und werden erst angezeigt wenn diese ausgewählt ist.<br/>
                        Andere sind für ganze Testarten oder Kompetenzen geeignet und werden im Auswahlprozess schon vorab angezeigt.
                    </div>
                </b-card>
            </b-col>
        </b-row>
    </b-container>
</template>

<script>
    import Vue from 'vue'
    import MaterialView from './material-view'
    export default {
        name: "materials-app",
        components: {MaterialView},
        computed: {
            filtered_competences() {
                let res = []
                for (let i = 0; i < this.competences.length; ++i)
                    if (this.competences[i].area_id == this.selected_area)
                        res.push(this.competences[i])
                return res
            },
            filtered_families() {
                let res = []
                for (let i = 0; i < this.families.length; ++i)
                    if (this.families[i].competence_id == this.selected_competence)
                        res.push(this.families[i])
                return res
            },
            filtered_tests() {
                let res = []
                for (let i = 0; i < this.tests.length; ++i)
                    if (this.tests[i].test_family_id == this.selected_family)
                        res.push(this.tests[i])
                return res
            },
            filtered_materials() {
                let ids = []
                for (let s = 0; s < this.supports.length; ++s)
                {
                    if (this.supports[s].area_id === this.selected_area)
                        ids.push(this.supports[s].material_id)
                    if (this.supports[s].competence_id === this.selected_competence)
                        ids.push(this.supports[s].material_id)
                    if (this.supports[s].test_family_id === this.selected_family)
                        ids.push(this.supports[s].material_id)
                    if (this.supports[s].test_id === this.selected_test)
                        ids.push(this.supports[s].material_id)
                }
                let res = []
                for (let i = 0; i < ids.length; ++i)
                    for (let m = 0; m < this.materials.length; ++m)
                        if (this.materials[m].id == ids[i])
                            res.push(this.materials[m])
                return res.filter((x, i, a) => a.indexOf(x) == i)       //Doppelte Einträge entfernen, klappt wegen Objektidentität
            }
        },
        data: function () {
            return {
                areas: this.$root.areas,
                competences: this.$root.competences,
                materials: this.$root.materials,
                selected_area: -1,
                selected_competence: -1,
                selected_family: -1,
                selected_test: -1,
                supports: this.$root.supports,
                tests: this.$root.tests,
                families: this.$root.test_families
            }
        },
    }
</script>
