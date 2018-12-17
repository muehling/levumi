<template>

    <!-- Schülertabelle für reguläre Klasse -->
    <div v-if="groups[index].archive == false">
        <div class="mb-2">
            <group-form
                    :group="groups[index]"
                    :index="index"
                    v-on:update:groups="update($event)"
            ></group-form>
        </div>

        <student-list
                :group="groups[index].id"
        >
        </student-list>
    </div>

    <!-- Archivdarstellung für archivierte Klasse -->
    <div v-else>
        <p>
            <em>Ins Archiv verschoben am {{ date }}</em><br/>
            Schüler_innen: {{groups[index].size}}
        </p>
        <a class="btn"
                :href="'/groups/' + groups[index].id"
                data-method="put"
                data-remote="true"
                data-params="group[archive]=0"
                v-on:ajax:success="update({index: index, object: $event.detail[0]})"
        >
            <i class="fas fa-file-import"></i> Klasse aus dem Archiv holen
        </a>

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
    import GroupForm from "./group-form";
    import StudentList from "./student-list";
    export default {
        components: {StudentList, GroupForm},
        props: {
            groups: Array,
            index: Number
        },
        computed: {
            date: function() {
                let date = new Date(this.groups[this.index].updated_at);
                return date.getDate() + '.' + (date.getMonth() + 1) + '.' + date.getFullYear()
            }
        },
        methods: {
            update(val) { //Klasse updaten und View aktualisieren
                this.$set(this.groups, val.index, val.object);
                this.$emit("update:groups", this.groups);
            },
            remove(i) { //Klasse entfernen und View aktualisieren
                this.groups.splice(i, 1);
                this.$emit("update:groups", this.groups);
            }
        },
        name: "group-display"
    }
</script>
