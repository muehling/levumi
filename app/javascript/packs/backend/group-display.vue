<template>

    <!-- Schülertabelle für reguläre Klasse -->
    <div v-if="groups[index].archive == false">

        <div class="mb-2">
            <b-btn v-b-toggle="'collapse_' + groups[index].id"><i class="fas fa-edit"></i> Klasse bearbeiten</b-btn>
            <a class="btn"
               :href="'/groups/' + groups[index].id"
               data-method="put"
               data-remote="true"
               data-params="group[archive]=1"
               v-on:ajax:success="set_archive(index, true)"
            >
                <i class="fas fa-file-export"></i> Klasse in Archiv verschieben
            </a>

            <b-collapse :id="'collapse_' + groups[index].id" class="mt-2">
                <b-card>
                    <group-form
                            :group="groups[index]"
                            :index="index"
                            v-on:update:groups="update($event)"
                    ></group-form>
                </b-card>
            </b-collapse>
        </div>

        <b-table hover :items="students" :fields="['name', 'login']">
        </b-table>
        <i class="fas fa-user-plus"></i> Schüler_in hinzufügen
    </div>

    <!-- Archivdarstellung für archivierte Klasse -->
    <div v-else>
        <p>Schüler_innen: {{students.length}}</p>
        <a class="btn"
                :href="'/groups/' + groups[index].id"
                data-method="put"
                data-remote="true"
                data-params="group[archive]=0"
                v-on:ajax:success="set_archive(index, false)"
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
    export default {
        components: {GroupForm},
        props: {
            groups: Array,
            index: Number,
            students: Array
        },
        methods: {
            update(val) { //Klasse updaten und View updaten
                this.$set(this.groups, val.index, val.object);
                this.$emit("update:groups", this.groups);
            },
            set_archive(i, a) { //Wert für archive ändern und View updaten
                this.groups[i].archive = a;
                this.$emit("update:groups", this.groups);
            },
            remove(i) { //Klasse entfernen und View updaten
                this.groups.splice(i, 1);
                this.$emit("update:groups", this.groups);
            }
        },
        name: "group-display"
    }
</script>

<style>
</style>