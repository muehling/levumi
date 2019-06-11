<template>
    <b-container fluid v-cloak>
        <b-row class='mt-3'>
            <b-col md='12'>
                <b-button-group>
                    <b-button v-for="area in all_areas" :key="area.id" :pressed.sync="area.selected">
                        {{area.name}}
                    </b-button>
                </b-button-group>
            </b-col>
        </b-row>
        <b-row class='mt-3'>
            <b-col md='12'>
                <b-button-group>
                    <b-button v-for="competence in filtered_competences" :key="competence.id" :pressed.sync="competence.selected">
                        {{competence.name}}
                    </b-button>
                </b-button-group>
            </b-col>
        </b-row>
        <b-row class='mt-3'>
            <b-col md='12'>
                <b-button-group>
                    <b-button v-for="family in filtered_families" :key="family.id" :pressed.sync="family.selected">
                        {{family.name}}
                    </b-button>
                </b-button-group>
            </b-col>
        </b-row>
        <b-row class='mt-3'>
            <b-col md='12'>
                <b-button-group>
                    <b-button v-for="test in filtered_tests" :key="test.id" :pressed.sync="test.selected">
                        {{test.level}}
                    </b-button>
                </b-button-group>
            </b-col>
        </b-row>
        <b-row class='mt-3'>
            <b-col md='12'>
                <b-tabs pills vertical>
                    <b-tab v-for="material in filtered_materials" :key="material.id" :title="material.name">
                        <div v-html="material.description">
                        </div>
                    </b-tab>
                </b-tabs>
            </b-col>
        </b-row>
    </b-container>
</template>

<script>
    import Vue from 'vue'
    export default {
        name: "materials-app",
        computed: {
            all_areas() {
                for (let a = 0; a < this.areas.length; ++a)
                    if (this.areas[a].selected === undefined)
                        Vue.set(this.areas[a], 'selected', false);
                return this.areas
            },
            filtered_competences() {
                let res = []
                for (let c = 0; c < this.competences.length; ++c)
                    for (let a = 0; a < this.areas.length; ++a)
                        if (this.competences[c].area_id == this.areas[a].id && this.areas[a].selected)
                            res.push(this.competences[c])

                for (let i = 0; i < res.length; ++i)
                    Vue.set(res[i], 'selected', false);
                return res
            },
            filtered_families() {
                let res = []
                for (let f = 0; f < this.test_families.length; ++f)
                    for (let c = 0; c < this.competences.length; ++c)
                        if (this.test_families[f].competence_id == this.competences[c].id && this.competences[c].selected)
                            res.push(this.test_families[f])

                for (let i = 0; i < res.length; ++i)
                    Vue.set(res[i], 'selected', false);
                return res
            },
            filtered_tests() {
                let res = []
                for (let t = 0; t < this.tests.length; ++t)
                    for (let f = 0; f < this.test_families.length; ++f)
                        if (this.tests[t].test_family_id == this.test_families[f].id && this.test_families[f].selected)
                            res.push(this.tests[t])

                for (let i = 0; i < res.length; ++i)
                    Vue.set(res[i], 'selected', false);
                return res
            },
            filtered_materials() {
                let ids = []
                for (let s = 0; s < this.supports.length; ++s)
                {
                    if (this.supports[s].area_id != null)
                        for (let a = 0; a < this.areas.length; ++a)
                            if (this.areas[a].id == this.supports[s].area_id && this.areas[a].selected === true)
                                ids.push(this.supports[s].material_id)
                    if (this.supports[s].competence_id != null)
                        for (let c = 0; c < this.competences.length; ++c)
                            if (this.competences[c].id == this.supports[s].competence_id && this.competences[c].selected === true)
                                ids.push(this.supports[s].material_id)
                    if (this.supports[s].test_family_id != null)
                        for (let f = 0; f < this.test_families.length; ++f)
                            if (this.test_families[f].id == this.supports[s].test_family_id && this.test_families[f].selected === true)
                                ids.push(this.supports[s].material_id)
                    if (this.supports[s].test_id != null)
                        for (let t = 0; t < this.tests.length; ++t)
                            if (this.tests[t].id == this.supports[s].test_id && this.tests[t].selected === true)
                                ids.push(this.supports[s].material_id)
                }
                let res = []
                for (let i = 0; i < ids.length; ++i)
                    for (let m = 0; m < this.materials.length; ++m)
                        if (this.materials[m].id == ids[i])
                            res.push(this.materials[m])
                return res
            }
        },
        data: function () {
            return {
                areas: this.$root.areas,
                competences: this.$root.competences,
                materials: this.$root.materials,
                supports: this.$root.supports,
                tests: this.$root.tests,
                test_families: this.$root.test_families
            }
        },
    }
</script>

<style scoped>

</style>