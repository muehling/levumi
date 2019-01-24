<template>
    <!-- Eine Zeile der Schülerübersicht -->
    <tr>
        <td>
            <!-- In-Place Editing durch "editMode", "empty" zeigt letzte Zeile an, die für neu anlegen verwendet wird -->
            <div v-if="!empty && !editMode">
                {{ student.name }}
            </div>
            <div v-else-if="editMode"> <!-- Form anzeigen -->
                <input type="text" class="form-control" v-model="name">
            </div>
            <div v-else> <!-- Anlegen Button anzeigen -->
                <b-btn class="btn" @click="editMode = true"><i class="fas fa-user-plus"></i> Schüler_in hinzufügen</b-btn>
            </div>
        </td>

        <td>
            {{ student.login }}
        </td>

        <td>
            <div v-if="!empty && !editMode">
                <b-btn class="btn" @click="editMode = true"><i class="fas fa-user-edit"></i></b-btn>
            </div>
            <div v-else-if="editMode">
                <!-- rails-ujs Link -->
                <b-link class="btn btn-success"
                   :href="'/students' + (empty ? '' : '/' + student.id)"
                   :disabled="name.length == 0"
                   :data-method="empty ? 'post' : 'put'"
                   data-remote="true"
                   :data-params="collectData()"
                   v-on:ajax:success="update"
                >
                    <i class="fas fa-check"></i> Speichern
                </b-link>
                <b-btn @click="editMode = false"><i class="fas fa-times"></i> Abbrechen</b-btn>
                <!-- rails-ujs Link -->
                <a v-if="!empty"
                   class="btn btn-danger float-right"
                   :href="'/students/' + student.id"
                   data-method="delete"
                   data-remote="true"
                   data-confirm="Schüler_in mit allen Messergebnissen löschen! Sind Sie sicher?"
                   v-on:ajax:success="remove"
                >
                    <i class="fas fa-trash"></i> Löschen
                </a>
            </div>
        </td>
    </tr>

</template>

<script>
    export default {
        props: {
            student: Object,
            group: Number,
            empty: Boolean,
            index: Number
        },
        data: function () {
            return {
                name: this.student.name,
                editMode: false
            }
        },
        methods: {
            collectData() { //Daten aus den Inputs codieren für AJAX Request
               return "group=" + this.group + "&student[name]=" + encodeURIComponent(encrypt(this.name)); //Namen vor dem Senden verschlüsseln
            },
            update(event) {                 //Wird bei erfolgreichem Create/Update aufgerufen
                //Zu Elternkomponente propagieren, dort werden die Daten aktuell gehalten
                this.$emit("update:students", {index: this.index, object: event.detail[0]})
                if (this.index >= 0)
                    this.editMode = false;
                else  //Beim Anlegen Form offen lassen und Input leeren, für mehrfaches Anlegen
                    this.name = "";
            },
            remove() {
                this.$emit("update:students", {index: this.index, object: null})
            }
        },
        name: "student-row"
    }
</script>
