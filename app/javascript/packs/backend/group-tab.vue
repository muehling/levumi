<template>

     <div v-if="group.archive == false">
         <b-table hover :items="students" :fields="['name', 'login']"></b-table>
         <i class="fas fa-user-plus"></i> Schüler_in hinzufügen
         <i class="fas fa-edit"></i> Klasse bearbeiten
         <a :href="'/groups/' + group.id" data-method="put" data-remote="true" data-params="group[archive]=1"><i class="fas fa-file-export"></i> Klasse in Archiv verschieben</a>
         <i class="fas fa-trash"></i> Klasse löschen
     </div>

    <div v-else>
        <p>Schüler_innen: {{students.length}}</p>
        <a :href="'/groups/' + group.id" data-method="put" data-remote="true" data-params="group[archive]=0"><i class="fas fa-file-import"></i> Klasse aus dem Archiv holen</a>
    </div>

</template>

<script>
    export default {
        props: {
            group: Object,
            students: Array
        },
        name: "group-tab"
    }
</script>

<style>
</style>