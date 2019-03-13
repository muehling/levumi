<template>
    <b-card no-body class='mt-3 pb-0 mb-1'>
        <b-tabs pills card >

            <!-- Schüler anzeigen um Messung zu starten. TODO: passt nur für Lehrertests -->
            <b-tab title='Neue Messung'>
                <b-button-group>
                    <!-- Button erscheint grün, falls schon ein Ergebnis am selben Tag vorhanden ist. TODO: Lieber selbe Woche? -->
                    <b-button v-for="student in students"
                              :key="student.id"
                              :variant="hasResult(student.id) ? 'success' : 'outline-success'"
                              class='mr-2'
                              title='Jetzt testen'
                              @click="loadTest(student)"
                    >
                        {{student.name}}
                    </b-button>
                </b-button-group>
            </b-tab>

            <!-- Auswertungstab -->
            <b-tab title='Auswertung' active>
                <b-button-group>
                    <b-button v-for="(view, index) in configuration.views" class='mr-2' @click="view_selected = index">
                        {{ view.label }}
                    </b-button>
                </b-button-group>
                <div>
                    <apexchart width='100%' height='500px' :options="options" :series="series"></apexchart>
                </div>
            </b-tab>

            <!-- Liste der Messungen anzeigen -->
            <b-tab title='Messungen'>
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
            test: Number
        },
        computed: {
            weeks: function() {
                let weeks = [];
                for (let i = 0; i < this.results.length; ++i)
                    if (this.results[i].test_week != null)
                        weeks.push(this.results[i].test_week);
                weeks = weeks.filter((v, i, a) => a.indexOf(v) === i);
                console.log(weeks);
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
                for (let s = 0; s < this.students.length; ++s)
                    res.push({
                        'name': this.student_name(this.students[s].id),
                        'data': []
                    });
                for (let i = 0; i < this.results.length; ++i) {
                    let student = this.student_name(this.results[i].student_id);
                    let view = this.configuration.views[this.view_selected].label;
                        for (let r = 0; r < res.length; ++r)
                            if (res[r].name == student)
                                res[r].data.push(this.results[i].results[view]);
                }
                console.log(res);
                return res
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
            hasResult(student) { //Prüft ob es für "heute" schon ein Ergebnis gibt.
                let d = new Date();
                for (let i = 0; i < this.results.length; ++i)
                    if (this.results[i].student_id == student && (new Date(this.results[i].test_date)).toDateString() == d.toDateString())
                            return true;
                return false;
            },
            loadTest(student) { //Testfenster für Kind öffnen und auf Schließen warten.
                fetch('/students/' + student.id + '/results', {  //Test laden
                    method: 'post',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                        'X-Requested-With': 'XMLHttpRequest',
                        'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
                    },
                    credentials: 'include',
                    body: 'test_id=' + this.test
                })
                    .then(response => {    //Neues Fenster öffnen und Test dort anzeigen.
                        return response.text().then(text =>  {
                            let win = window.open();
                            win.document.open();
                            win.document.write(text);
                            win.document.close();
                            win.document.title = 'Testfenster ' + student.name;
                            let vue = this;
                            let timer = setInterval(function() {    //Warten bis Fenster geschlossen
                                if (win.closed) {
                                    clearInterval(timer);
                                    vue.$emit('update');
                                }
                            }, 500);
                    })
                    });
            }
        },
        data: function () {
            return {
                view_selected: 0,
                students: groups[this.group] || [],   //Zugriff auf globale Variable "groups"

                default_options: {
                    chart: {
                        id: 'chart',
                        type: 'line',
                        responsive: false
                    },
                    grid: {
                        padding: {
                            right: 15,
                            left: 15
                        }
                    },
                    labels: [],
                    xaxis: {
                        type: 'datetime',
                    },
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