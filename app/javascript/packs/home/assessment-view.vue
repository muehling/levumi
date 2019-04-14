<template>
    <b-card no-body class='mt-3 pb-0 mb-1'>
        <b-tabs pills card >

            <b-tab v-if="!read_only" title='Neue Messung' :active="deep_link">
                <div v-if="test_info.archive">
                    <p>Dieser Test wurde durch eine neuere Version ersetzt. Bitte verwenden Sie ab jetzt diese Version zum Testen, sie finden den neuen Test direkt oberhalb in der Auswahlliste!</p>
                </div>
                <div v-else-if="!student_test">
                    <!-- Schüler anzeigen um Messung zu starten. -->
                    <p>Klicken Sie auf einen Namen um den Test sofort in einem neuen Fenster zu starten. Grün hinterlege Namen wurden in dieser Woche bereits getestet!</p>
                    <b-button-group>
                        <!-- Button erscheint grün, falls schon ein Ergebnis in der aktuellen Woche vorhanden-->
                        <b-button v-for="student in students"
                                  :key="student.id"
                                  :variant="getResult(student.id) > 0 ? 'success' : 'outline-success'"
                                  :disabled="getResult(student.id) > 0"
                                  class='mr-2'
                                  :title="getResult(student.id) > 0 ? 'Bereits getestet' : 'Jetzt testen'"
                                  :href="'/students/' + student.id + '/results?test_id='+ test"
                                  data-method='post'
                        >
                            {{student.name}}
                        </b-button>
                    </b-button-group>
                </div>
                <div v-else>
                    <p>Diesen Test müssen die Schüler_innen mit ihrem <a href='/testen' target="_blank">eigenen Zugang</a> durchführen!</p>
                    <p>Hier können Sie sehen, welche Schüler_innen den Test in dieser Woche bereits durchgeführt haben - ihre Namen sind grün hinterlegt.</p>
                    <b-button-group class='mt-3'>
                        <!-- Button erscheint grün, falls schon ein Ergebnis vorhanden ist. -->
                        <b-button v-for="student in students"
                                  :key="student.id"
                                  :variant="getResult(student.id) > 0 ? 'success' : 'outline-secondary'"
                                  disabled
                        >
                            {{student.name}}
                        </b-button>
                    </b-button-group>
                </div>
            </b-tab>

            <!-- Auswertungstab Klasse -->
            <b-tab title='Auswertung' :active="!deep_link">
                <b-row>
                    <b-button-group class='ml-3'>
                        <b-button class='mr-2'
                                  size='sm'
                                  variant='outline-primary'
                                  :pressed="student_selected == -1"
                                  @click="student_selected = -1">Ganze Klasse</b-button>
                        <b-button v-for="(student, index) in students"
                                  :key="student.id"
                                  class='mr-2'
                                  size='sm'
                                  variant='outline-primary'
                                  :pressed="student_selected == index"
                                  @click="student_selected = index"
                        >
                            {{student.name}}
                        </b-button>
                    </b-button-group>
                </b-row>
                <b-row class='mt-2'>
                    <b-button-group class='ml-3'>
                        <b-button
                                v-for="(view, index) in configuration.views"
                                v-if="(student_selected == -1 && view.group) || (student_selected > -1 && view.student)"
                                :key="index"
                                class='mr-2'
                                size='sm'
                                variant='outline-secondary'
                                :pressed="view_selected == index"
                                @click="view_selected = index"
                        >
                            {{ view.label }}
                        </b-button>
                    </b-button-group>
                </b-row>
                <div id='chart_area_group'>
                    <apexchart width='100%' height='500px' :options="options" :series="series"></apexchart>
                </div>
            </b-tab>

            <!-- Liste der Messungen anzeigen -->
            <b-tab v-if="!read_only" title='Messungen'>
                <!-- Tabellen durch Rows nachbauen, wegen Collapse -->
                <!-- Header -->
                <b-row>
                    <b-col><b>Woche ab dem</b></b-col>
                    <b-col><b>Anzahl Ergebnisse</b></b-col>
                    <b-col><b>Details</b></b-col>
                </b-row>
                <!-- Nach Wochen gruppierte Einträge -->
                <div v-if="weeks.length == 0" class='mt-2'>
                    <b-row><b-col><p class='text-center text-muted'>Keine Messungen vorhanden.</p></b-col></b-row>
                </div>
                <div v-else v-for="(date, index) in weeks" class='mt-2'>
                    <b-row>
                        <b-col>{{ print_date(date) }}</b-col>
                        <b-col>{{ grouped_results[date].length }}</b-col>
                        <b-col>
                            <b-btn v-b-toggle="'collapse' + index" size='sm' variant='outline-secondary'>
                                <i class='when-closed fas fa-search-plus'></i>
                                <i class='when-opened fas fa-search-minus'></i>
                            </b-btn>
                        </b-col>
                    </b-row>
                    <!-- Aufklappbare Details -->
                    <b-collapse :id="'collapse' + index">
                        <b-card class='mt-2'>
                            <table class='table table-striped table-sm table-borderless'>
                                <thead>
                                <th>Datum</th>
                                <th>Schüler/-in</th>
                                <th>Aktionen</th>
                                </thead>
                                <tbody>
                                <tr v-for="result in grouped_results[date]">
                                    <td>{{ print_date(result.test_date) }}</td>
                                    <td>{{ student_name(result.student_id) }}</td>
                                </tr>
                                </tbody>
                            </table>
                        </b-card>
                    </b-collapse>
                </div>
            </b-tab>
        </b-tabs>
    </b-card>
</template>

<script>
    export default {
        props: {
            results: Array,
            configuration: Object,
            group: Number,
            test: Number,
            test_info: Object,
            read_only: Boolean,
            student_test: Boolean,
        },
        computed: {
            weeks: function() {
                let weeks = [];
                for (let i = 0; i < this.results.length; ++i)
                    if (this.results[i].test_week != null)
                        weeks.push(this.results[i].test_week);
                weeks = weeks.filter((v, i, a) => a.indexOf(v) === i);
                return weeks;
            },
            grouped_results: function() {
              let res = {}
              for (let i = 0; i < this.results.length; ++i)
                  if (res[this.results[i].test_week] === undefined)
                      res[this.results[i].test_week] = [this.results[i]];
                  else
                      res[this.results[i].test_week].push(this.results[i]);
              return res;
            },
            options: function() {
                let options = Object.assign({}, this.default_options, this.configuration.views[this.view_selected].options)
                options.labels = this.weeks;
                return options;
            },
            series: function() {
                let res = [];
                let weeks = this.weeks;
                let view = this.configuration.views[this.view_selected];
                if (this.student_selected == -1) {
                    for (let s = 0; s < this.students.length; ++s)
                        res.push({
                            'name': this.student_name(this.students[s].id),
                            'data': Array(weeks.length).fill(null)
                        });
                }
                else {
                    if (view.series == undefined) {
                        res.push({
                            'name': this.student_name(this.students[this.student_selected].id),
                            'data': Array(weeks.length).fill(null)
                        });
                    }
                    else
                        for (let s = 0; s < view.series.length; ++s)
                            res.push({
                                'name': view.series[s],
                                'data': Array(weeks.length).fill(null)
                            });
                }
                for (let i = 0; i < this.results.length; ++i) {
                    if (this.student_selected == -1 || view.series == undefined) {
                        let student = this.student_name(this.results[i].student_id);
                        let week = this.results[i].test_week;
                        for (let r = 0; r < res.length; ++r) {
                            if (res[r].name == student) {
                                for (let j = 0; j < weeks.length; ++j) {
                                    if (weeks[j] == week)
                                        res[r].data[j] = this.results[i].results[view.label];
                                }
                            }
                        }
                    }
                    else if (this.results[i].student_id == this.students[this.student_selected].id) {
                        let week = this.results[i].test_week;
                        for (let r = 0; r < view.series.length; ++r) {
                            for (let j = 0; j < weeks.length; ++j) {
                                if (weeks[j] == week)
                                    res[r].data[j] = this.results[i].results[view.label][view.series[r]];
                            }
                        }
                    }
                }
                return res;
            }
        },
        methods: {
            student_name(id) {   //Student-Objekt aus globaler Variable holen
                return get_student(this.group, id).name;
            },
            print_date(date) {   //Datumsanzeige formatieren
                let d = new Date(date);
                return d.toLocaleDateString('de-DE')
            },
            getResult(student) { //Prüft ob es für "heute" schon ein Ergebnis gibt.
                let d = new Date();
                let bow = new Date(d.setDate(d.getDate() - d.getDay() + (d.getDay() === 0 ? -6 : 1)));
                for (let i = 0; i < this.results.length; ++i)
                    if (this.results[i].student_id == student && (new Date(this.results[i].test_week).toDateString() == bow.toDateString()))
                            return this.results[i].id;
                return 0;
            }
        },
        data: function () {
            return {
                deep_link: this.$root.pre_select && this.$root.pre_select.test == this.test ? true : false,  //Wurde eine Anfrage für ein/dieses Assessment gestartet?
                view_selected: 0,
                student_selected: -1,
                students: groups[this.group] || [],   //Zugriff auf globale Variable "groups"

                default_options: {
                    chart: {
                        id: 'chart',
                        type: 'line',
                        toolbar: {
                            show: false,
                        },
                    },
                    grid: {
                        padding: {
                            right: 15,
                            left: 15
                        }
                    },
                    xaxis: {
                        type: 'datetime',
                    },
                    markers: {
                        size: 4,
                        hover: {
                            sizeOffset: 2
                        }
                    },
                    stroke: {
                        width: 1
                    }
                }
            }
        },
        name: 'assessment-view'
    }
</script>

<style scoped>
    /* Darstellung des Collapse durch CSS toggeln*/
    .collapsed > .when-opened,
    :not(.collapsed) > .when-closed {
        display: none;
    }
</style>