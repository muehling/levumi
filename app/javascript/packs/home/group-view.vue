<template>
<div>
    <b-card bg-variant='light' class='mt-3'>
        <b-row>
            <b-col md='12'>

                <b-nav pills>
                    <!-- Aktuell in Assessments verwendete Lernbereiche -->
                    <b-nav-item v-for="area in group_info.areas"
                                v-if="area.used"
                                :key="area.info.id"
                                :active="area.info.id == area_selected"
                                @click="select_area(area.info.id)"
                    >
                        {{area.info.name}}
                    </b-nav-item>
                    <!-- Weitere Lernbereiche -->
                    <b-nav-item
                            v-for="area in group_info.areas"
                            v-if="!area.used"
                            :key="area.info.id"
                            @click="area.used = true; select_area(area.info.id)"
                    >
                        <em>{{area.info.name}}</em>
                    </b-nav-item>

                </b-nav>

                <b-nav pills class='mt-1'>
                    <!-- Aktuell in Assessments verwendete Kompetenzen des gewählten Lernbereichs -->
                    <b-nav-item v-for="competence in group_info.competences"
                                :key="competence.info.id"
                                :active="competence.info.id == competence_selected"
                                v-if="competence.used && competence.info.area_id == area_selected"
                                @click="select_competence(competence.info.id)"
                    >
                        {{competence.info.name}}
                    </b-nav-item>
                    <!-- Weitere Kompetenzen des gewählten Lernbereichs -->
                    <b-nav-item
                            v-for="competence in group_info.competences"
                            :key="competence.info.id"
                            v-if="!competence.used && competence.info.area_id == area_selected"
                            @click="competence.used = true; select_competence(competence.info.id)"
                    >
                        <em>{{competence.info.name}}</em>
                    </b-nav-item>

                </b-nav>

                <b-nav pills class='mt-1'>
                    <!-- Aktuell in Assessments verwendete Testfamilien der gewählten Kompetenz  -->
                    <b-nav-item v-for="family in group_info.families"
                                :key="family.info.id"
                                :active="family.info.id == family_selected"
                                v-if="family.used && family.info.competence_id == competence_selected"
                                @click="select_family(family.info.id)"
                    >
                        {{family.info.name}}
                    </b-nav-item>
                    <!-- Weitere Testfamilien der gewählten Kompetenz  -->
                    <b-nav-item
                            v-for="family in group_info.families"
                            :key="family.info.id"
                            v-if="!family.used && family.info.competence_id == competence_selected"
                            @click="family.used = true; select_family(family.info.id)"
                    >
                        <em>{{family.info.name}}</em>
                    </b-nav-item>
                </b-nav>

                <b-nav pills class='mt-1'>
                    <!-- Aktuell in Assessments verwendete Niveaustufen der gewählten Testfamilie -->
                    <b-nav-item v-for="test in group_info.tests"
                                :key="test.info.id"
                                :active="test.info.id == test_selected"
                                v-if="test.used && test.info.test_family_id == family_selected"
                                @click="loadAssessment(test.info.id)"
                    >
                        {{test.info.level}}
                    </b-nav-item>
                    <!-- Weitere Niveaustufen der gewählten Testfamilie -->
                    <b-nav-item
                            v-for="test in group_info.tests"
                            :key="test.info.id"
                            v-if="!test.used && test.info.test_family_id == family_selected"
                            @click="test.used = true; createAssessment(test)"
                    >
                        <em>{{test.info.level}}</em>
                    </b-nav-item>
                </b-nav>

            </b-col>
        </b-row>
    </b-card>
    <b-row>
        <b-col>
            <!-- Spinner für die AJAX-Requests zum Laden eines gewählten Assessments-->
            <div class='spinner' style='padding-bottom: 75px' v-if="updating">
                <div class='bounce1'></div>
                <div class='bounce2'></div>
                <div class='bounce3'></div>
            </div>

            <assessment-view v-else-if="results"
                             :group="group.id"
                             :results="results"
            >
            </assessment-view>
        </b-col>
    </b-row>

</div>
</template>

<script>
    import AssessmentView from './assessment-view';
    export default {
        components: {AssessmentView},
        props: {
            group: Object,
            group_info: Object
        },
        data: function () {
            return {
                area_selected: 0,
                competence_selected: 0,
                family_selected: 0,
                test_selected: 0,
                updating: false,
                results: undefined
            }
        },
        methods: {
            //Lernbereich setzen und folgende Wahlmöglichkeiten zurücksetzen
            select_area(area) {
                this.area_selected = area;
                this.competence_selected = -1;
                this.family_selected = -1;
                this.test_selected = -1
                $('#main-' + this.group_info.id).hide();   //Ggf. angezeigtes Assessment verstecken
            },
            //Kompetenz setzen und folgende Wahlmöglichkeiten zurücksetzen
            select_competence(competence) {
                this.competence_selected = competence;
                this.family_selected = -1;
                this.test_selected = -1
                $('#main-' + this.group_info.id).hide(); //Ggf. angezeigtes Assessment verstecken
            },
            //Testfamilie setzen und folgende Wahlmöglichkeiten zurücksetzen
            select_family(family) {
                this.family_selected = family;
                this.test_selected = -1
                $('#main-' + this.group_info.id).hide(); //Ggf. angezeigtes Assessment verstecken
            },
            //Prüfen, ob noch unverwendete Lernbereiche existieren
            areasLeft() {
                for (let i = 0; i < this.group_info.areas.length; ++i)
                    if (!this.group_info.areas[i].used)
                        return true;
                return false;
            },
            //Prüfen, ob noch unverwendete Kompetenzen existieren
            competencesLeft(area) {
                for (let i = 0; i < this.group_info.competences.length; ++i)
                    if (!this.group_info.competences[i].used && this.group_info.competences[i].info.area_id == area)
                        return true;
                return false;
            },
            //Prüfen, ob noch unverwendete Testfamilien existieren
            familiesLeft(competence) {
                for (let i = 0; i < this.group_info.families.length; ++i)
                    if (!this.group_info.families[i].used && this.group_info.families[i].info.competence_id == competence)
                        return true;
                return false;
            },
            //Prüfen, ob noch unverwendete Niveaustufen existieren
            testsLeft(family) {
                for (let i = 0; i < this.group_info.tests.length; ++i)
                    if (!this.group_info.tests[i].used && this.group_info.tests[i].info.test_family_id == family)
                        return true;
                return false;
            },
            //Gewähltes Assessment nachladen und Daten in Assessment-View weiterreichen.
            loadAssessment(test) {
                this.test_selected = test;
                this.updating = true;  //Spinner anzeigen
                //AJAX-Request senden
                fetch('/groups/' + this.group.id + '/assessments/' + this.test_selected, {
                    headers: {
                        'Accept': 'text/javascript',
                        'X-Requested-With': 'XMLHttpRequest',
                        'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
                    },
                    credentials: 'include'
                })
                    .then(response => {
                        return response.text().then(text =>  {
                            this.results = JSON.parse(text);
                            this.updating = false;  //Spinner verstecken
                        });
                    });
            },
            //Neues Assessment anlegen und, bei Erfolg, laden.
            createAssessment(test) {
                fetch('/groups/' + this.group.id + '/assessments/', {
                    method: 'post',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                        'X-Requested-With': 'XMLHttpRequest',
                        'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
                    },
                    credentials: 'include',
                    body: 'test_id=' + test.info.id
                })
                    .then(response => this.loadAssessment(test.info.id));
            }
        },
        name: 'group-view'
    }
</script>

<style>
    .nav>li>a {
        padding-top: 4px;
        padding-bottom: 4px;
    }
</style>