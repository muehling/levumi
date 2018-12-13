<template>

     <div v-if="group.archive == false">
         <b-table hover :items="students" :fields="['name', 'login']"></b-table>
         <i class="fas fa-user-plus"></i> Schüler_in hinzufügen
         <i class="fas fa-edit"></i> Klasse bearbeiten
         <a href="#" v-on:click="set_archive(group.id, true);"><i class="fas fa-file-export"></i> Klasse in Archiv verschieben</a>
         <i class="fas fa-trash"></i> Klasse löschen
     </div>

    <div v-else>
        <a href="#" v-on:click="set_archive(group.id, false);"><i class="fas fa-file-import"></i> Klasse aus dem Archiv holen</a>
    </div>

</template>

<script>
    export default {
        props: {
            group: Object,
            students: Array
        },
        methods: {
            set_archive: function(id, value) {
                Rails.ajax({
                    url: "/groups/" + id,
                    type: "GET",
                    success: function(data) {
                        console.log(data);
                    }
                });
            }
        },
        name: "group-tab"
    }
</script>

<style>
</style>