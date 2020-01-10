<template>

    <!-- Darstellung für reguläre Klasse: Buttons für Edit/Archive, Share, dann Schülertabelle  -->
    <div v-if="groups[index].archive == false">
        <div class='mb-1' v-if="!single">
            <!-- Form zur Umbenennung -->
            <group-form
                    v-if="groups[index].owner"
                    :group="groups[index]"
                    :index="index"
                    v-on:update:groups="update($event)"
            ></group-form>
        </div>
        <div class='mb-2' v-if="!single">
            <!-- Info/Form für Klassen teilen -->
            <share-form
                    v-if="index > 0"
                    :group="groups[index]"
                    :index="index"
                    v-on:update:groups="update($event)"
            ></share-form>
        </div>
        <student-list
                v-if="groups[index].key != null"
                :group="groups[index].id"
                :read_only="read_only"
        >
        </student-list>
    </div>

    <!-- Darstellung für archivierte Klasse -->
    <div v-else>
        <p class='text-small'>
            <em>Ins Archiv verschoben am {{ date }}</em><br/>
            <span >Schüler*innen: {{groups[index].size}}</span>
        </p>
        <!-- rails-ujs Link beinhaltet Auth_Token-->
        <a class='btn btn-sm btn-outline-primary'
           :href="'/groups/' + groups[index].id"
           data-method='put'
           data-remote='true'
           data-params='group[archive]=0'
           v-on:ajax:success="update({index: index, object: $event.detail[0]})"
        >
            <i class='fas fa-file-import'></i> Klasse aus dem Archiv holen
        </a>

        <!-- rails-ujs Link beinhaltet Auth_Token-->
        <a class='btn btn-sm btn-outline-danger'
           :href="'/groups/' + groups[index].id"
           data-method='delete'
           data-remote='true'
           data-confirm='Die Klasse wird mit allen Schüler*innen und allen Messergebnissen gelöscht! Sind Sie sicher?'
           v-on:ajax:success="remove(index)"
        >
            <i class='fas fa-trash'></i> Klasse löschen
        </a>
    </div>

</template>

<script>
    import GroupForm from './group-form';
    import ShareForm from './share-form';
    import StudentList from './student-list';

    export default {
        components: {StudentList, GroupForm, ShareForm},
        props: {
            groups: Array,       //Alle benötigt, um Klassen aus archiv zu verschieben
            index: Number,
            single: Boolean
        },
        computed: {
            date: function() {
                let date = new Date(this.groups[this.index].updated_at);
                return date.getDate() + '.' + (date.getMonth() + 1) + '.' + date.getFullYear()
            },
            read_only: function() {
                //Klassen nicht veränderbar, falls nur zur Ansicht geteilt, oder gerade ein Masquerading aktiv ist.
                return this.groups[this.index].read_only || masquerade
            }
        },
        methods: {
            update(val) { //Klasse updaten und View aktualisieren
                this.$set(this.groups, val.index, val.object);
                keys[val.object.id] = val.object.key;
                this.$emit('update:groups', this.groups);
            },
            remove(i) { //Klasse entfernen und View aktualisieren
                this.groups.splice(i, 1);
                this.$emit('update:groups', this.groups);
            }
        },
        name: 'group-view'
    }
</script>
