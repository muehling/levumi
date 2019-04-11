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
                <small id="nameHelp" class="form-text text-muted">Name des Kindes, wird verschlüsselt gespeichert!</small>
            </div>
            <div v-else> <!-- Anlegen Button anzeigen -->
                <b-btn variant='outline-secondary' size='sm' @click="editMode = true"><i class='fas fa-user-plus'></i> Anlegen</b-btn>
            </div>
        </td>

        <td>
            <div v-if="editMode">
                <small class='form-text text-muted'>nicht änderbar</small>
            </div>
            <div v-else>
                {{ student.login }}
            </div>
        </td>

        <td>
            <div v-if="editMode">
                <b-form-radio-group id="gender" v-model="gender" :options="options_gender" name='gender'>
                </b-form-radio-group>
            </div>
            <div v-else>
                <span v-if="student.gender != undefined">{{ options_gender[student.gender].text }}</span>
                <span v-else-if="!empty" class="text-muted">nicht erfasst</span>
            </div>
        </td>

        <td>
            <div v-if="editMode">
                <b-form-select v-model="month" size="sm">
                    <option v-for="(month, index) in months" :value="index">{{month}}</option>
                </b-form-select>
                <b-form-select v-model="year" size="sm">
                    <option v-for="year in years()" :value="year">{{year}}</option>
                </b-form-select>
            </div>
            <div v-else>
                <span v-if="student.birthmonth != undefined">{{ student.birthmonth }}</span>
                <span v-else-if="!empty" class='text-muted'>nicht erfasst</span>
            </div>
        </td>

        <td>
            <div v-if="editMode">
                <b-form-select id="sen" v-model="sen" :options="options_sen" size='sm' />
                <small id="focusHelp" class="form-text text-muted">Diagnostizierter sonderpädagogischer Förderbedarf?</small>
            </div>
            <div v-else>
                <span v-if="student.sen != undefined">{{ options_sen[student.sen].text }}</span>
                <span v-else-if="!empty" class="text-muted">nicht erfasst</span>
            </div>
        </td>

        <td>
            <div v-if="editMode">
                <b-form-radio-group id="migration" v-model="migration" :options="options_migration" name='migration'>
                </b-form-radio-group>
                <small id="focusHelp" class="form-text text-muted">Kind oder Eltern im Ausland geboren?</small>
            </div>
            <div v-else>
                <span v-if="student.migration != undefined">{{ options_migration[student.migration].text }}</span>
                <span v-else-if="!empty" class="text-muted">nicht erfasst</span>
            </div>
        </td>

        <td>
            <span v-if="!read_only && !empty && !editMode">
                <b-btn variant='outline-secondary' size='sm' @click="editMode = true"><i class='fas fa-user-edit'></i></b-btn>
            </span>
            <span v-else-if="!read_only && editMode">
                <b-button-toolbar>
                    <b-button-group>
                        <!-- rails-ujs Link -->
                        <b-link class='btn btn-sm btn-outline-success mr-1'
                                :href="'/students' + (empty ? '' : '/' + student.id)"
                                title='Speichern'
                                :disabled="name.length == 0"
                                :data-method="empty ? 'post' : 'put'"
                                data-remote='true'
                                :data-params="collectData()"
                                v-on:ajax:success="update"
                        >
                            <i class='fas fa-check'></i>
                        </b-link>
                    </b-button-group>
                    <b-button-group>
                        <b-link class='btn btn-sm btn-outline-secondary mr-2' href='#' title='Abbrechen' @click="editMode = false"><i class='fas fa-times'></i></b-link>
                    </b-button-group>
                    <b-button-group>
                        <!-- rails-ujs Link -->
                        <a v-if="!empty"
                           class='btn btn-block btn-sm btn-outline-danger'
                           :href="'/students/' + student.id"
                           data-method='delete'
                           data-remote='true'
                           :data-confirm="student.name +  ' mit allen Messergebnissen löschen! Sind Sie sicher?'"
                           v-on:ajax:success="remove"
                        >
                            <i class='fas fa-trash'></i> Löschen
                        </a>
                    </b-button-group>
                </b-button-toolbar>
            </span>
        </td>
    </tr>

</template>

<script>

    export default {
        props: {
            student: Object,
            group: Number,
            empty: Boolean,
            index: Number,
            read_only: Boolean
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
                    for (let i = cur - 3; i > cur - 30; --i)
                        years.push(i);
                    return years;
                }
            }
        },
        methods: {
            collectData() { //Daten aus den Inputs codieren für AJAX Request
               let res ='group=' + this.group + '&student[name]=' + encodeURIComponent(encrypt(this.name, this.group));  //Namen vor dem Senden verschlüsseln
                //Restliche Attribute anfügen, falls vorhanden
               if (this.gender != null)
                   res += '&student[gender]=' + this.gender;
               if (this.year != null && this.month != null)
                   res += '&student[birthmonth]=' +  this.year + '-' + (this.month + 1);
               if (this.sen != null)
                   res += '&student[sen]=' + this.sen;
               if (this.migration != null)
                   res += '&student[migration]=' + this.migration;
               return res;
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
                {text: 'weiblich', value: '0', disabled: 0},
                {text: 'männlich', value: '1', disabled: 0}
            ];

            this.months = ['Januar', 'Februar', 'März', 'April', 'Mai', 'Juni', 'Juli', 'August', 'September', 'Oktober', 'November', 'Dezember'];

            this.options_sen = [
                { text: 'Keiner', value: 0 },
                { text: 'Lernen', value: 1 },
                { text: 'Geistige Entwicklung', value: 2 },
                { text: 'Emotional-soziale Entwicklung', value: 3 },
                { text: 'Sprache', value: 4 },
                { text: 'Körperlich-motorische Entwicklung', value: 5 },
                { text: 'Sehen', value: 6 },
                { text: 'Hören', value: 7 },
                { text: 'Autismus', value: 8 }
            ];

            this.options_migration = [
                {text: 'Nein', value: '0', disabled: 0},
                {text: 'Ja', value: '1', disabled: 0}
            ];
        },
        name: 'student-row'
    }
</script>
