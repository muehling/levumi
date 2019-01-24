<template>
    <b-card no-body>
        <b-tabs pills card vertical>

            <!-- Schüler anzeigen um Messung zu starten. TODO: passt nur für Lehrertests -->
            <b-tab title="Neue Messung">
                <b-button v-for="student in students"
                          :key="student.id"
                >
                    {{student.name}}
                </b-button>
            </b-tab>

            <!-- Auswertungstab -->
            <b-tab title="Auswertung" active>
               Auswertung
            </b-tab>

            <!-- Liste der Messungen anzeigen -->
            <b-tab title="Messungen">
                <!-- Tabellen durch Rows nachbauen, wegen Collapse -->
                <!-- Header -->
                <b-row>
                    <b-col><b>Woche ab dem</b></b-col>
                    <b-col><b>Anzahl Ergebnisse</b></b-col>
                    <b-col><b>Details</b></b-col>
                </b-row>
                <!-- Nach Wochen gruppierte Einträge -->
                <div v-for="(date, index) in Object.keys(results)" class="mt-2">
                    <b-row>
                        <b-col>{{ print_date(date) }}</b-col>
                        <b-col>{{ results[date].length}}</b-col>
                        <b-col>
                            <b-btn v-b-toggle="'collapse' + index" class="btn btn-outline-primary">
                                <i class="when-closed fas fa-search-plus"></i>
                                <i class="when-opened fas fa-search-minus"></i>
                            </b-btn>
                        </b-col>
                    </b-row>
                    <!-- Aufklappbare Details -->
                    <b-collapse :id="'collapse' + index">
                        <b-card class="mt-2">
                            <table class="table table-striped table-borderless">
                                <thead>
                                <th>Datum</th>
                                <th>Schüler/-in</th>
                                <th>Aktionen</th>
                                </thead>
                                <tbody>
                                <tr v-for="result in results[date]">
                                    <td>{{ print_date(result.created_at) }}</td>
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
        name: "assessment-view",
        props: {
            results: Object,
            group: Number
        },
        methods: {
            student_name(id) {   //Student-Objekt aus globaler Variable holen
                return get_student(this.group, id).name;
            },
            print_date(date) {   //Datumsanzeige formatieren
                let d = new Date(date);
                return d.toLocaleDateString("de-DE")
            }
        },
        data: function () {
            return {
                students: groups[this.group] || []
            }
        },
    }
</script>

<style scoped>
    /* Darstellung des Collapse durch CSS toggeln*/
    .collapsed > .when-opened,
    :not(.collapsed) > .when-closed {
        display: none;
    }
</style>