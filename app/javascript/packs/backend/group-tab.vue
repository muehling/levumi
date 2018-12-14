<template>

     <div v-if="groups[index].archive == false">
         <b-table hover :items="students" :fields="['name', 'login']"></b-table>
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

    <div v-else>
        <p>Schüler_innen: {{students.length}}</p>
        <button class="btn btn-primary"
                :href="'/groups/' + groups[index].id"
                data-method="put"
                data-remote="true"
                data-params="group[archive]=0"
                v-on:ajax:success="set_archive(index, false)"
        >
            <i class="fas fa-file-import"></i> Klasse aus dem Archiv holen
        </button>
        <br/>
        <button class="btn btn-danger"
                :href="'/groups/' + groups[index].id"
                data-method="delete"
                data-remote="true"
                data-confirm="Die Klasse wird mit allen Schüler_innen und allen Messergebnissen gelöscht! Sind Sie sicher?"
                v-on:ajax:success="remove(index)"
        >
            <i class="fas fa-trash"></i> Klasse löschen
        </button>
    </div>

</template>

<script>
    import Rails from 'rails-ujs'

    export default {
        props: {
            groups: Array,
            index: Number,
            students: Array
        },
        methods: {
            update() {
                this.$emit("update:groups", this.groups);
            },
            set_archive(i, a) {
                this.groups[i].archive = a;
                this.update;
            },
            remove(i) {
                this.groups.splice(i, 1);
                this.update;
            }
        },
        name: "group-tab"
    }

</script>

<style>
</style>