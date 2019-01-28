<template>
    <!-- Eine Zeile der Schülerübersicht -->
    <tr>
        <td>
            <!-- In-Place Editing durch "editMode", "empty" zeigt letzte Zeile an, die für neu anlegen verwendet wird -->
            <div v-if="!empty && !editMode">
                {{ student.name }}
            </div>
            <div v-else-if="editMode"> <!-- Form anzeigen -->
                <b-form-input type='text' class='form-control' v-model="name" size='sm' />
            </div>
            <div v-else> <!-- Anlegen Button anzeigen -->
                <b-btn class='btn' @click="editMode = true"><i class='fas fa-user-plus'></i> Schüler_in hinzufügen</b-btn>
            </div>
        </td>

        <td>
            <div v-if="!editMode">
                {{ student.login }}
            </div>
            <div v-else>
                <span class='text-muted'>nicht änderbar</span>
            </div>

        </td>

        <td>
            <div v-if="!editMode">
                <span v-if="student.gender != undefined">{{ options_gender[student.gender].text }}</span>
                <span v-else-if="!empty" class="text-muted">nicht erfasst</span>
            </div>
            <div v-else>
                <b-form-radio-group id="gender" v-model="gender" :options="options_gender" name='gender'>
                </b-form-radio-group>
            </div>
        </td>

        <td>
            <div v-if="!editMode">
                <span v-if="student.birthmonth != undefined">{{ student.birthmonth }}</span>
                <span v-else-if="!empty" class='text-muted'>nicht erfasst</span>
            </div>
            <div v-else>
                <b-form-select v-model="month" size="sm">
                    <option v-for="(month, index) in months" :value="index">{{month}}</option>
                </b-form-select>
                <b-form-select v-model="year" size="sm">
                    <option v-for="year in years()" :value="year">{{year}}</option>
                </b-form-select>
            </div>
        </td>

        <td>
            <div v-if="!editMode">
                <span v-if="student.sen != undefined">{{ options_sen[student.sen].text }}</span>
                <span v-else-if="!empty" class="text-muted">nicht erfasst</span>
            </div>
            <div v-else>
                <b-form-select id="sen" v-model="sen" :options="options_sen" size='sm' />
            </div>
        </td>

        <td>
            <div v-if="!editMode">
                <span v-if="student.migration != undefined">{{ options_migration[student.migration].text }}</span>
                <span v-else-if="!empty" class="text-muted">nicht erfasst</span>
            </div>
            <div v-else>
                <b-form-radio-group id="migration" v-model="migration" :options="options_migration" name='migration'>
                </b-form-radio-group>
            </div>

        </td>

        <td>
            <div v-if="!empty && !editMode">
                <b-btn class='btn' @click="editMode = true"><i class='fas fa-user-edit'></i></b-btn>
            </div>
            <div v-else-if="editMode">
                <!-- rails-ujs Link -->
                <b-link class='btn btn-success'
                   :href="'/students' + (empty ? '' : '/' + student.id)"
                   :disabled="name.length == 0"
                   :data-method="empty ? 'post' : 'put'"
                   data-remote='true'
                   :data-params="collectData()"
                   v-on:ajax:success="update"
                >
                    <i class='fas fa-check'></i> Speichern
                </b-link>
                <b-btn @click="editMode = false"><i class='fas fa-times'></i> Abbrechen</b-btn>
                <!-- rails-ujs Link -->
                <a v-if="!empty"
                   class='btn btn-danger float-right'
                   :href="'/students/' + student.id"
                   data-method='delete'
                   data-remote='true'
                   data-confirm='Schüler_in mit allen Messergebnissen löschen! Sind Sie sicher?'
                   v-on:ajax:success="remove"
                >
                    <i class='fas fa-trash'></i> Löschen
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
                editMode: false,
                name: this.student.name,

                //Defaultwerte für diese Werte, da sie ggf. nicht existieren!
                gender: this.student.gender != undefined ? this.student.gender : null,
                sen: this.student.sen != undefined ? this.student.sen : null,
                migration: this.student.migration != undefined ? this.student.migration : null,
                year: this.student.birthmonth != undefined ? (new Date(this.student.birthmonth)).getFullYear() : null,
                month: this.student.birthmonth != undefined ? (new Date(this.student.birthmonth)).getMonth() : null,

                years: function() {
                    let years = [];
                    let cur = (new Date()).getFullYear();
                    for (let i = cur - 3; i > cur - 21; --i)
                        years.push(i);
                    return years;
                }
            }
        },
        methods: {
            collectData() { //Daten aus den Inputs codieren für AJAX Request
               return 'group=' + this.group +
                   '&student[name]=' + encodeURIComponent(encrypt(this.name)) +
                   '&student[gender]=' + this.gender +
                   '&student[birthmonth]=' + this.year + '-' + (this.month + 1)  +
                   '&student[sen]=' + this.sen +
                   '&student[migration]=' + this.migration; //Namen vor dem Senden verschlüsseln
            },
            update(event) {                 //Wird bei erfolgreichem Create/Update aufgerufen
                //Zu Elternkomponente propagieren, dort werden die Daten aktuell gehalten
                this.$emit('update:students', {index: this.index, object: event.detail[0]})
                if (this.index >= 0)
                    this.editMode = false;
                else  //Beim Anlegen Form offen lassen und Input leeren, für mehrfaches Anlegen
                    this.name = "";
            },
            remove() {
                this.$emit('update:students', {index: this.index, object: null})
            }
        },
        beforeCreate() {
            // "Konstanten" definieren - werden für die Form-Elemente und zur Anzeige verwendet.
            this.options_gender = [
                {text: 'weiblich', value: '0'},
                {text: 'männlich', value: '1'}
            ];

            this.months = ['Januar', 'Februar', 'März', 'April', 'Mai', 'Juni', 'Juli', 'August', 'September', 'Oktober', 'November', 'Dezember'];

            this.options_sen = [
                { text: 'Keiner', value: 0 },
                { text: 'Lernen', value: 1 },
                { text: 'Geistige Entwicklung', value: 2 },
                { text: 'Emotional-soziale Entwicklung', value: 3 },
                { text: 'Sprache', value: 4 },
                { text: 'Anderer Förderbedarf', value: 5 }
            ];

            this.options_migration = [
                {text: 'Nein', value: '0'},
                {text: 'Ja', value: '1'}
            ];
        },
        name: 'student-row'
    }
</script>
