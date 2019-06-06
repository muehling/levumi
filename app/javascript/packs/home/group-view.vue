<template>
<div>

    <b-card bg-variant='light' class='mt-3'>
        <b-row>
            <b-col md='12'>

                <b-nav pills>
                    <!-- Alle Lernbereiche -->
                    <b-nav-item v-for="area in group_info.areas"
                                v-if="area.used || !group.read_only"
                                :key="area.info.id"
                                :active="area.info.id == area_selected"
                                @click="area.used = true;select_area(area.info.id)"
                    >
                        <span :class="area.used ? '' : 'text-muted'">{{area.info.name}}</span>
                    </b-nav-item>
                </b-nav>

                <b-nav pills class='mt-1'>
                    <!-- Alle Kompetenzen des gewählten Lernbereichs -->
                    <b-nav-item v-for="competence in group_info.competences"
                                :key="competence.info.id"
                                :id="group.id + '_competence_' + competence.info.id"
                                :active="competence.info.id == competence_selected"
                                v-if="(competence.used || !group.read_only) && (competence.info.area_id == area_selected)"
                                @click="competence.used = true; select_competence(competence.info.id)"
                    >
                        <span :class="competence.used ? '' : 'text-muted'">{{competence.info.name}}</span>
                        <b-popover v-if="!competence.used"
                                   :target="group.id + '_competence_' + competence.info.id"
                                   triggers="hover"
                        >
                            {{competence.info.description}}
                        </b-popover>
                    </b-nav-item>
                </b-nav>

                <b-nav pills class='mt-1'>
                    <!-- Alle Testfamilien der gewählten Kompetenz  -->
                    <b-nav-item v-for="family in group_info.families"
                                :key="family.info.id"
                                :id="group.id + '_family_' + family.info.id"
                                :active="family.info.id == family_selected"
                                v-if="(family.used || !group.read_only) && (family.info.competence_id == competence_selected)"
                                @click="family.used=true; select_family(family.info.id)"
                    >
                        <span :class="family.used ? '' : 'text-muted'">{{family.info.name}}</span>
                        <b-popover v-if="!family.used"
                                   :target="group.id + '_family_' + family.info.id"
                                   triggers="hover"
                        >
                            {{family.info.description}}
                        </b-popover>
                    </b-nav-item>
                </b-nav>

                <b-nav pills class='mt-1'>
                    <!-- Alle Niveaustufen der gewählten Testfamilie -->
                    <b-nav-item v-for="test in group_info.tests"
                                :key="test.info.id"
                                :id="group.id + '_test_' + test.info.id"
                                :active="test.info.id == test_selected"
                                v-if="(test.used || !group.read_only) && (test.info.test_family_id == family_selected)"
                                @click="test.used ? loadAssessment(test.info.id) : createAssessment(test)"
                    >
                        <!-- TODO: Veraltet lieber als Dropdown, oder... ? -->
                        <span :class="test.used ? '' : 'text-muted'">{{test.info.level}} {{test.info.archive ? '(veraltet)' : ''}}</span>
                        <b-popover v-if="!test.used"
                                   :target="group.id + '_test_' + test.info.id"
                                   triggers="hover"
                        >
                            {{test.info.description.short}}
                        </b-popover>
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
                             :annotations="results.annotations"
                             :configuration="results.configuration"
                             :group="group.id"
                             :read_only="group.read_only"
                             :results="results.series"
                             :student_test="results.student_test"
                             :test="results.test"
                             v-on:update="loadAssessment(test_selected)"
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
                area_selected: (this.$root.pre_select && this.$root.pre_select.group == this.group.id) ? this.$root.pre_select.area : 0,
                competence_selected: (this.$root.pre_select && this.$root.pre_select.group == this.group.id) ? this.$root.pre_select.competence : 0,
                family_selected: (this.$root.pre_select && this.$root.pre_select.group == this.group.id) ? this.$root.pre_select.family : 0,
                test_selected: (this.$root.pre_select && this.$root.pre_select.group == this.group.id) ? this.$root.pre_select.test : 0,
                updating: false,
                results: (this.$root.pre_select && this.$root.pre_select.group == this.group.id) ? this.$root.pre_select.assessment : undefined
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
                    .then(response => {test.used = true; this.loadAssessment(test.info.id)});
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