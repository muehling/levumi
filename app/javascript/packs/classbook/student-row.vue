<template>

    <tr>
        <td>
            <div v-if="!empty && !editMode">
                {{ student.name }}
            </div>
            <div v-else-if="editMode">
                <input type="text" class="form-control" v-model="name">
            </div>
            <div v-else>
                <b-btn class="btn" @click="editMode = true"><i class="fas fa-user-plus"></i> Schüler_in hinzufügen</b-btn>
            </div>
        </td>

        <td>
            {{ student.login }}
        </td>

        <td>
            <div v-if="!empty && !editMode">
                <b-btn class="btn" @click="editMode = !editMode"><i class="fas fa-user-edit"></i></b-btn>
            </div>
            <div v-else-if="editMode">
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

                <b-btn @click="editMode = !editMode"><i class="fas fa-times"></i> Abbrechen</b-btn>

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
            fields: Array,
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
                //URL-encoding?
               return "group=" + this.group + "&student[name]=" + encodeURIComponent(encrypt(this.name)); //Namen vor dem Senden verschlüsseln
            },
            update(event) {
                this.$emit("update:students", {index: this.index, object: event.detail[0]})
                if (this.index >= 0)  //Beim Anlegen Form offen lassen...
                    this.editMode = false;
                else
                    this.name = "";
            },
            remove() {
                this.$emit("update:students", {index: this.index, object: null})
            }
        },
        name: "student-row"
    }
</script>
