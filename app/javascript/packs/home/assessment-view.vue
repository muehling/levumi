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
                <div v-if="Object.keys(results).length == 0" class='mt-2'>
                    <b-row><b-col><p class='text-center text-muted'>Keine Messungen vorhanden.</p></b-col></b-row>
                </div>
                <div v-else v-for="(date, index) in Object.keys(results)" class='mt-2'>
                    <b-row>
                        <b-col>{{ print_date(date) }}</b-col>
                        <b-col>{{ results[date].length}}</b-col>
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
                                <tr v-for="result in results[date]">
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
            results: Object,
            group: Number,
            test: Number
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
                let dates = Object.keys(this.results);
                for (let i = 0; i < dates.length; ++i)
                    for (let r = 0; r < this.results[dates[i]].length; ++r) {
                        if (this.results[dates[i]][r].student_id == student && (new Date(this.results[dates[i]][r].test_date)).toDateString() == d.toDateString())
                            return true;
                    }
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
                students: groups[this.group] || [],   //Zugriff auf globale Variable "groups"

                options: {
                    annotations: {
                        yaxis: [{
                            y: 8200,
                            borderColor: '#00E396',
                            label: {
                                borderColor: '#00E396',
                                style: {
                                    color: '#fff',
                                    background: '#00E396',
                                },
                                text: 'Support',
                            }
                        }],
                        xaxis: [{
                            x: new Date('23 Nov 2017').getTime(),
                            strokeDashArray: 0,
                            borderColor: '#775DD0',
                            label: {
                                borderColor: '#775DD0',
                                style: {
                                    color: '#fff',
                                    background: '#775DD0',
                                },
                                text: 'Anno Test',
                            }
                        }, {
                            x: new Date('03 Dec 2017').getTime(),
                            borderColor: '#FEB019',
                            label: {
                                borderColor: '#FEB019',
                                style: {
                                    color: '#fff',
                                    background: '#FEB019',
                                },
                                orientation: 'horizontal',
                                text: 'New Beginning',
                            }
                        }],
                        points: [{
                            x: new Date('27 Nov 2017').getTime(),
                            y: 8506.9,
                            marker: {
                                size: 8,
                                fillColor: '#fff',
                                strokeColor: 'red',
                                radius: 2
                            },
                            label: {
                                borderColor: '#FF4560',
                                offsetY: 0,
                                style: {
                                    color: '#fff',
                                    background: '#FF4560',
                                },

                                text: 'Point Annotation',
                            }
                        }]
                    },
                    chart: {
                        id: 'chart',
                        type: 'line',
                        responsive: false
                    },
                    dataLabels: {
                        enabled: false
                    },
                    stroke: {
                        curve: 'straight'
                    },
                    grid: {
                        padding: {
                            right: 15,
                            left: 15
                        }
                    },
                    labels: ['2017-11-13', '2017-11-27', '2017-12-01', '2017-12-13', '2017-12-23', '2018-01-01', '2018-01-13', '2018-01-23'],
                    xaxis: {
                        type: 'datetime',
                    },
            },

                series: [{
                    name: 'Adam',
                    data: [30, 40, 45, 50, 49, 60, 70, 91]},
                    {name: 'Eva',
                    data: [24, 37, 40, 37, 41, 52, 55, 60]
                }]

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