<template>
  <!-- Darstellung für reguläre Klasse: Buttons für Edit/Archive, Share, dann Schülertabelle  -->
  <div v-if="group.archive == false">
    <div v-if="!single" class="mb-1">
      <!-- Form zur Umbenennung -->
      <group-form
        v-if="group.owner"
        :group="group"
        @update:groups="updateGroup($event)"
      ></group-form>
    </div>
    <div v-if="!single" class="mb-2">
      <!-- Info/Form für Klassen teilen -->
      <share-form v-if="group.id" :group="group" @update:groups="updateGroup($event)"> </share-form>
    </div>
    <student-list v-if="group.key != null" :group="group.id" :read_only="read_only"> </student-list>
  </div>

  <!-- Darstellung für archivierte Klasse -->
  <div v-else>
    <p class="text-small">
      <em>Ins Archiv verschoben am {{ date }}</em
      ><br />
      <span>Schüler:innen: {{ group.size }}</span>
    </p>
    <b-button class="mr-1" variant="outline-primary" @click="reactivateGroup">
      <i class="fas fa-file-import"></i> Klasse aus dem Archiv holen
    </b-button>
    <b-btn variant="outline-danger" @click="requestDeleteGroup">
      <i class="fas fa-trash"></i> Klasse löschen
    </b-btn>
    <confirm-dialog ref="confirmDialog" />
  </div>
</template>

<script>
  import { ajax } from '../../utils/ajax'
  import { store } from '../../utils/store'
  import ConfirmDialog from '../shared/confirm-dialog.vue'
  import GroupForm from './group-form.vue'
  import ShareForm from './share-form.vue'
  import StudentList from './student-list.vue'

  export default {
    name: 'GroupView',
    components: {
      StudentList,
      GroupForm,
      ShareForm,
      ConfirmDialog
    },
    props: {
      groups: Array, //Alle benötigt, um Klassen aus Archiv zu verschieben
      group: Object,
      single: Boolean
    },
    computed: {
      date: function () {
        let date = new Date(this.group?.updated_at)
        return date.getDate() + '.' + (date.getMonth() + 1) + '.' + date.getFullYear()
      },
      read_only: function () {
        //Klassen nicht veränderbar, falls nur zur Ansicht geteilt, oder gerade ein Masquerading aktiv ist.
        return this.group.read_only || store.masquerade
      }
    },
    methods: {
      // Klasse aus dem Archiv holen
      async reactivateGroup() {
        const res = await ajax({
          url: '/groups/' + this.group.id + '?group[archive]=0',
          method: 'put'
        })
        const data = await res.json()
        if (data && res.status === 200) {
          this.updateGroup({
            object: data
          })
        }
      },
      /*****************************
       * update group and propagate to parent component
       ******************************/
      updateGroup({ object }) {
        this.$set(this.group, object)
        store.shareKeys[object.id] = object.key
        const groups = [...this.groups]
        const index = groups.findIndex(g => g.id === object.id)
        groups[index] = object
        this.$emit('update:groups', groups)
      },

      /*****************************
       * remove group and propagate to parent component
       ******************************/
      async requestDeleteGroup() {
        const ok = await this.$refs.confirmDialog.open({
          title: 'Klasse löschen',
          message: `Die Klasse wird mit allen Schüler:innen und allen Messergebnissen gelöscht! Sind Sie sicher?`,
          okText: 'Klasse löschen'
        })
        if (ok) {
          const res = await ajax({
            url: `/groups/${this.group.id}`,
            method: 'delete'
          })

          if (res.status === 200) {
            const remainingGroups = this.groups.filter(g => g.id !== this.group.id)
            this.$emit('update:groups', remainingGroups)
          }
        }
      }
    }
  }
</script>
