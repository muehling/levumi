<template>
    <b-card no-body class='mt-3 pb-0 mb-1'>
        <b-tabs pills card>

            <b-tab :active="deep_link" class='m-3'>
                <div slot='title'>Messungen <span v-if="!is_active" class="badge badge-danger"><i class='fas fa-pause'></i></span></div>
                <!-- Neue Messungen -->
                <div class='alert alert-secondary' v-if="!read_only">
                    <div v-if="test.archive">
                        <p>Dieser Test wurde durch eine neuere Version ersetzt. Bitte verwenden Sie ab jetzt diese Version zum Testen, sie finden den neuen Test direkt oberhalb in der Auswahlliste!</p>
                    </div>
                    <div v-else-if="students.length == 0">
                        <p>Es sind in dieser Klasse noch keine Schüler*innen angelegt. Um in dieser Klasse Testen zu können, legen Sie bitte neue Schüler*innen im Klassenbuch an.</p>
                    </div>
                    <div v-else-if="!student_test">
                        <p class='text-light bg-secondary'>&nbsp;Durchführung</p>
                        <p class='text-small'>{{test.description.usage}}</p>
                        <p class='text-light bg-secondary'>&nbsp;Hinweise</p>
                        <p class='text-small'>Klicken Sie auf einen Namen um den Test sofort zu starten. Am Ende des Tests werden Sie auf diese Seite zurückgeleitet.<br/>
                            Grün hinterlege Namen wurden in dieser Woche bereits getestet. Wenn Sie erneut testen möchten, löschen Sie bitte zuerst die vorherige Messung unten aus der Liste!</p>
                        <!-- Schüler anzeigen um Messung zu starten. -->
                        <b-button-group size='sm' class='flex-wrap'>
                            <!-- Button erscheint grün, falls schon ein Ergebnis in der aktuellen Woche vorhanden-->
                            <b-button v-for="student in students"
                                      :key="student.id"
                                      :variant="get_result(student.id) > 0 ? 'success' : 'outline-success'"
                                      :disabled="get_result(student.id) > 0"
                                      class='mr-2'
                                      :title="get_result(student.id) > 0 ? 'Bereits getestet' : 'Jetzt testen'"
                                      :href="'/students/' + student.id + '/results?test_id='+ test.id"
                                      data-method='post'
                            >
                                {{student.name}}
                            </b-button>
                        </b-button-group>
                    </div>
                    <div v-else>
                        <p class='text-light bg-secondary'>&nbsp;Durchführung</p>
                        <p>{{test.description.usage}}</p>
                        <p class='text-light bg-secondary'>&nbsp;Hinweise</p>
                        <p>Diesen Test müssen die Schüler*innen mit ihrem Logincode (unter dem Namen) in ihrem <a href='/testen' target="_blank">eigenen Zugang</a> durchführen!</p>
                        <p>Der Test ist jede Woche automatisch verfügbar, außer Sie pausieren die Testung.</p>
                        <p>Hier können Sie sehen, welche Schüler*innen den Test in dieser Woche bereits durchgeführt haben - ihre Namen sind grün hinterlegt.</p>
                        <!-- Schüler nur als Info anzeigen -->
                        <b-button-group size='sm' class='flex-wrap'>
                            <!-- Button erscheint grün, falls schon ein Ergebnis vorhanden ist. -->
                            <b-button v-for="student in students"
                                      :key="student.id"
                                      :variant="get_result(student.id) > 0 ? 'success' : 'outline-secondary'"
                                      disabled
                            >
                                {{student.name}}<br/>{{student.login}}
                            </b-button>
                        </b-button-group>
                        <br/>
                        <!-- rails-ujs Link beinhaltet Auth_Token-->
                        <a v-if="is_active"
                           class='btn btn-sm btn-danger mt-3'
                           :href="'/groups/' + group.id + '/assessments/' + test.id"
                           data-method='put'
                           data-remote='true'
                           data-params='assessment[active]=0'
                           v-on:ajax:success="is_active = false"
                        >
                            <i class='fas fa-pause'></i> Wöchentliche Testung pausieren
                        </a>
                        <a v-else
                           class='btn btn-sm btn-success mt-3'
                           :href="'/groups/' + group.id + '/assessments/' + test.id"
                           data-method='put'
                           data-remote='true'
                           data-params='assessment[active]=1'
                           v-on:ajax:success="is_active = true"
                        >
                            <i class='fas fa-play'></i> Wöchentliche Testung aktivieren
                        </a>
                    </div>
                </div>
                <!-- Liste der alten Messungen -->
                <div v-if="weeks.length > 0">
                    <!-- Tabellen durch Rows nachbauen, wegen Collapse -->
                    <!-- Header -->
                    <b-row>
                        <b-col><b>Woche ab dem</b></b-col>
                        <b-col><b>Anzahl Ergebnisse</b></b-col>
                        <b-col><b>Details</b></b-col>
                    </b-row>
                    <!-- Nach Wochen gruppierte Einträge -->
                    <div v-for="(date, index) in weeks.slice().reverse()" class='mt-2'>
                        <b-row>
                            <b-col>{{ print_date(date) }}</b-col>
                            <b-col>{{ grouped_results[date].length }}</b-col>
                            <b-col>
                                <b-btn v-b-toggle="'collapse_' + index" size='sm' variant='outline-secondary'>
                                    <i class='when-closed fas fa-caret-down'></i>
                                    <i class='when-opened fas fa-caret-up'></i>
                                </b-btn>
                            </b-col>
                        </b-row>
                        <!-- Aufklappbare Details -->
                        <b-collapse :id="'collapse_' + index" v-on:shown="auto_scroll('#collapse_' + index)">
                            <b-card class='mt-2'>
                                <table class='table table-striped table-sm table-borderless'>
                                    <thead>
                                    <th>Datum</th>
                                    <th>Schüler*in</th>
                                    <th>Positive Items</th>
                                    <th>Negative Items</th>
                                    <th>Trend</th>
                                    <th v-if="!read_only" >Aktionen</th>
                                    </thead>
                                    <tbody>
                                    <tr v-for="result in grouped_results[date]">
                                        <td>{{ print_date(result.data.test_date) }}</td>
                                        <td>{{ student_name(result.data.student_id) }}</td>
                                        <td><span v-for="(item, index) in result.data.report.positive">{{(index > 0 ? ', ' : '') + item}}</span></td>
                                        <td><span v-for="(item, index) in result.data.report.negative">{{(index > 0 ? ', ' : '') + item}}</span></td>
                                        <td>
                                            <i class='fas fa-arrow-up' v-if="result.data.report.total > 0"></i>
                                            <i class='fas fa-arrow-right' v-else-if="result.data.report.total == 0"></i>
                                            <i class='fas fa-arrow-down' v-else></i>
                                        </td>
                                        <td v-if="!read_only">
                                            <b-btn small
                                                   variant='outline-danger'
                                                   title='Diese Messung löschen'
                                                   :href="'/students/' + result.data.student_id + '/results/' + result.data.id"
                                                   data-remote='true'
                                                   data-method='delete'
                                                   data-confirm='Diese Messung unwiderruflich löschen! Sind Sie sicher?'
                                                   v-on:ajax:success="remove(result.index, index)"
                                            >
                                                <i class='fas fa-trash'></i>
                                            </b-btn>
                                        </td>
                                    </tr>
                                    </tbody>
                                </table>
                            </b-card>
                        </b-collapse>
                    </div>
                </div>
            </b-tab>

            <!-- Auswertungstab mit Graph -->
            <b-tab title='Auswertung' :active="!deep_link" @click="auto_scroll('#comment_btn')" class='m-3' :disabled="weeks.length == 0 || configuration.views.length == 0">
                <analysis-view
                        :key="test.id"
                        :annotations="annotations"
                        :configuration="configuration"
                        :group="group"
                        :results="results"
                        :students="students"
                        :test="test"
                ></analysis-view>
            </b-tab>

            <!-- Vorschläge für Fördermaterial -->
             <b-tab title='Fördern'>
                <support-view
                        :group="group.id"
                        :test="test.id"
                >
                </support-view>
            </b-tab>

            <!-- Testinfos darstellen -->
            <b-tab title='Testinfos'>
                <div v-html="test.description.full"></div>
            </b-tab>
        </b-tabs>
    </b-card>
</template>

<script>
    import AnalysisView from './analysis-view'
    import SupportView from './support-view'
    export default {
        components: {AnalysisView, SupportView},
        props: {
            active: Boolean,
            annotations: Array,
            configuration: Object,
            group: Object,
            read_only: Boolean,
            results: Array,
            student_test: Boolean,
            test: Object,
        },
        computed: {
            grouped_results: function() { //Results nach Wochen gruppieren, für die Ergebnisliste
              let res = {}
              for (let i = 0; i < this.results.length; ++i)
                  if (res[this.results[i].test_week] === undefined)
                      res[this.results[i].test_week] = [{index: i, data: this.results[i]}];
                  else
                      res[this.results[i].test_week].push({index: i, data: this.results[i]});
              return res;
            },
            weeks: function () {
                let weeks = [];
                for (let i = 0; i < this.results.length; ++i)
                    if (this.results[i].test_week != null)
                        weeks.push(this.results[i].test_week);
                weeks = weeks.filter((v, i, a) => a.indexOf(v) === i);
                return weeks;
            }
        },
        methods: {
            auto_scroll(element) { //Scrollt Seite, bis übergebenes Element sichtbar ist.
                window.$(element)[0].scrollIntoView(false);
            },
            get_result(student) { //Prüft ob es für "heute" schon ein Ergebnis gibt.
                let d = new Date();
                let bow = new Date(d.setDate(d.getDate() - d.getDay() + (d.getDay() === 0 ? -6 : 1)));
                for (let i = 0; i < this.results.length; ++i)
                    if (this.results[i].student_id == student && (new Date(this.results[i].test_week).toDateString() == bow.toDateString()))
                        return this.results[i].id;
                return 0;
            },
            print_date(date) {   //Datumsanzeige formatieren
                let d = new Date(date);
                return d.toLocaleDateString('de-DE')
            },
            remove(index, collapse) { //Löscht einen Eintrag aus der Ergebnisliste
                let last = true;
                for (let i = 0; i < this.results.length; ++i)
                    if (i != index && this.results[i].test_week == this.results[index].test_week) {
                        last = false;
                        break;
                    }
                if (last) //Letzter Eintrag der Woche wird gelöscht => Collapse erst schließen
                    this.$root.$emit('bv::toggle::collapse', 'collapse_' + collapse);
                this.results.splice(index, 1);
            },
            student_name(id) {   //Student-Objekt aus globaler Variable holen
                return get_student(this.group.id, id).name;
            }
        },
        data: function () {
            return {
                is_active: this.active, //Als Datum, damit es geändert werden kann
                deep_link: this.$root.pre_select && this.$root.pre_select.test == this.test.id ? true : false,  //Wurde eine Anfrage für ein/dieses Assessment gestartet?
                students: groups[this.group.id] || [],   //Zugriff auf globale Variable "groups"
            }
        },
        provide: function () {
            return {
                auto_scroll: this.auto_scroll,
                print_date: this.print_date,
                read_only: this.read_only,
                student_name: this.student_name,
                weeks: this.weeks,
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