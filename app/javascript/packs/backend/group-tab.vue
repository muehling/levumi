<template>

    <!-- Form für neue Klasse -->
    <div v-if="index == 0">
        <b-form inline
                action="/groups"
                accept-charset="UTF-8"
                method="post"
                data-remote="true"
                v-on:ajax:success="add"
        >
            <label class="sr-only" for="label">Klassenbezeichner</label>
            <b-input class="mr-2" id="label" v-model="label" name="group[label]" placeholder="Klassenbezeichner"/>
            <b-button type="submit" variant="primary" :disabled="label.trim().length === 0">Anlegen</b-button>
        </b-form>
    </div>

    <!-- Schülertabelle für reguläre Klasse -->
    <div v-else-if="groups[index].archive == false">
        <b-table hover :items="students" :fields="['name', 'login']">
        </b-table>
        <i class="fas fa-user-plus"></i> Schüler_in hinzufügen
        <i class="fas fa-edit"></i> Klasse bearbeiten
        <a
             :href="'/groups/' + groups[index].id"
             data-method="put"
             data-remote="true"
             data-params="group[archive]=1"
             v-on:ajax:success="set_archive(index, true)"
        >
         <i class="fas fa-file-export"></i> Klasse in Archiv verschieben
        </a>
    </div>

    <!-- Archivdarstellung für archivierte Klasse -->
    <div v-else>
        <p>Schüler_innen: {{students.length}}</p>
        <a class="btn btn-primary"
                :href="'/groups/' + groups[index].id"
                data-method="put"
                data-remote="true"
                data-params="group[archive]=0"
                v-on:ajax:success="set_archive(index, false)"
        >
            <i class="fas fa-file-import"></i> Klasse aus dem Archiv holen
        </a>
        <br/>
        <a class="btn btn-danger"
                :href="'/groups/' + groups[index].id"
                data-method="delete"
                data-remote="true"
                data-confirm="Die Klasse wird mit allen Schüler_innen und allen Messergebnissen gelöscht! Sind Sie sicher?"
                v-on:ajax:success="remove(index)"
        >
            <i class="fas fa-trash"></i> Klasse löschen
        </a>
    </div>

</template>

<script>
    export default {
        props: {
            groups: Array,
            index: Number,
            students: Array
        },
        data: function () {
          return {
              label: ""
          }
        },
        methods: {
            update() { //Neu-Rendern der Übersicht erzwingen
                this.$emit("update:groups", this.groups);
            },
            set_archive(i, a) { //Wert für archive ändern und View updaten
                this.groups[i].archive = a;
                this.update;
            },
            remove(i) { //Klasse entfernen und View updaten
                this.groups.splice(i, 1);
                this.update;
            },
            add(event) { //Klasse einfügen und View updaten
                this.groups.splice(1, 0, event.detail[0]); //event.detail[0] enthält das Objekt der Ajax-Antwort in rails-ujs
                this.update;
            }
        },
        name: "group-tab"
    }
</script>

<style>
</style>