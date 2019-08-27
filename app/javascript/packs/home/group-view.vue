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
                        <span :class="area.used ? 'font-weight-bold' : 'text-muted'">{{area.info.name}}</span>
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
                        <span :class="competence.used ? 'font-weight-bold' : 'text-muted'">{{competence.info.name}}</span>
                        <b-popover v-if="!competence.used && competence.info.description != undefined"
                                   :target="group.id + '_competence_' + competence.info.id"
                                   triggers="hover"
                        >
                            <div v-html="competence.info.description"> </div>
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
                        <span :class="family.used ? 'font-weight-bold' : 'text-muted'">{{family.info.name}}</span>
                        <b-popover v-if="!family.used && family.info.description != undefined"
                                   :target="group.id + '_family_' + family.info.id"
                                   triggers="hover"
                        >
                            <div v-html="family.info.description"> </div>
                        </b-popover>
                    </b-nav-item>
                </b-nav>

                <b-nav pills class='mt-1'>
                    <!-- Alle Niveaustufen der gewählten Testfamilie -->
                    <b-nav-item v-for="test in tests"
                                :key="test.info.id"
                                :id="group.id + '_test_' + test.info.id"
                                :active="test.info.id == test_selected"
                                v-if="test.used || !group.read_only"
                                @click="test.used ? (test.versions.length == 1 ? loadAssessment(test.info.id, false) : test_selected = test.info.id) : createAssessment(test, false)"
                    >
                        <span :class="test.used ? 'font-weight-bold' : 'text-muted'">{{test.info.level}}</span>
                        <b-popover v-if="!test.used && test.info.description.short != undefined"
                                   :target="group.id + '_test_' + test.info.id"
                                   triggers="hover"
                        >
                            <div v-html="test.info.description.short"> </div>
                        </b-popover>
                    </b-nav-item>
                </b-nav>

                <b-nav pills class='mt-1' v-if="versions.length > 1">
                    <!-- Alle Versionen der gewählten Niveaustufe, falls vorhanden -->
                    <b-nav-item v-for="version in versions"
                                :key="version.info.id"
                                :id="group.id + '_version_' + version.info.id"
                                :active="version.info.id == version_selected"
                                v-if="version.used || (!version.info.archive && !group.read_only)"
                                @click="version.used ? loadAssessment(version.info.id, true) : createAssessment(version, true)"
                    >
                        <span :class="version.used ? 'font-weight-bold' : 'text-muted'">{{version.info.label}}</span>
                        <b-popover v-if="!version.used && version.info.description.short != undefined"
                                   :target="group.id + '_version_' + version.info.id"
                                   triggers="hover"
                        >
                            <div v-html="version.info.description.short"> </div>
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
                             :active="results.active"
                             :annotations="results.annotations"
                             :configuration="results.configuration"
                             :group="group"
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
                version_selected: (this.$root.pre_select && this.$root.pre_select.group == this.group.id) ? this.$root.pre_select.test : 0, //Funktioniert, da bei Deep-Link immer die aktuelle Version gewählt sein muss.
                updating: false,
                results: (this.$root.pre_select && this.$root.pre_select.group == this.group.id) ? this.$root.pre_select.assessment : undefined
            }
        },
        computed: {
            //Alle zur aktuellen Familie passenden Tests, jeweils nur die aktuelle Version
            tests: function() {
                let res = []
                for (let i = 0; i < this.group_info.tests.length; ++i)
                  if (this.group_info.tests[i].info.test_family_id == this.family_selected && this.group_info.tests[i].info.label === "Aktuell") {
                      let versions = []
                      let used = false
                      for (let j = 0; j < this.group_info.tests.length; ++j)
                          if (this.group_info.tests[i].info.level == this.group_info.tests[j].info.level && this.group_info.tests[j].info.test_family_id == this.family_selected) {
                              versions.push(this.group_info.tests[j])
                              if (this.group_info.tests[j].used)
                                  used = true
                          }
                          res.push({info: this.group_info.tests[i].info, used: used, versions: versions})
                  }
                return res
            },
            //Alle Versionen des gewählten Tests
            versions: function() {
                let level = ""
                for (let i = 0; i < this.group_info.tests.length; ++i)
                    if (this.group_info.tests[i].info.id == this.test_selected)
                        level = this.group_info.tests[i].info.level
                let res = []
                for (let i = 0; i < this.group_info.tests.length; ++i)
                    if (this.group_info.tests[i].info.level === level && this.group_info.tests[i].info.test_family_id == this.family_selected)
                        res.push(this.group_info.tests[i])
                return res
            }
        },
        methods: {
             //Neues Assessment anlegen und, bei Erfolg, laden.
            createAssessment(test, isVersion) {
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
                    .then(response => {test.used = true; this.loadAssessment(test.info.id, isVersion)});
            },
            //Gewähltes Assessment nachladen und Daten in Assessment-View weiterreichen.
            loadAssessment(test, isVersion) {
                if (isVersion)
                    this.version_selected = test
                else
                    this.test_selected = test
                this.updating = true  //Spinner anzeigen
                //AJAX-Request senden
                fetch('/groups/' + this.group.id + '/assessments/' + test, {
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
            //Lernbereich setzen und folgende Wahlmöglichkeiten zurücksetzen
            select_area(area) {
                this.area_selected = area;
                this.competence_selected = -1
                this.family_selected = -1
                this.test_selected = -1
                this.version_selected = -1
                this.results = null
            },
            //Kompetenz setzen und folgende Wahlmöglichkeiten zurücksetzen
            select_competence(competence) {
                this.competence_selected = competence
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
            }
        },
        name: 'group-view'
    }
</script>