<template>
  <div>
    <classbook-actions :group="group" />
    <!-- Darstellung für reguläre Klasse: Buttons für Edit/Archive, Share, dann Schülertabelle  -->
    <div v-if="group.archive == false">
      <div v-if="!single" class="mb-1">
        <!-- Form zur Umbenennung -->
        <group-form v-if="displayActions" :group="group" @update:groups="updateGroup($event)" />
      </div>
      <div v-if="!single" class="mb-2">
        <!-- Info/Form für Klassen teilen -->
        <share-form v-if="true" :group="group" @update:groups="updateGroup($event)" />
      </div>
      <move-student-dialog v-if="displayActions" :group="group" />

      <shares-display v-if="group.owner" :group="group" />
      <student-list v-if="group.key != null" :group-id="group.id" :read-only="read_only" />
    </div>

    <!-- Darstellung für archivierte Klasse -->
    <div v-else>
      <p class="text-small">
        <em>Ins Archiv verschoben am {{ date }}</em>
        <br />
        <span>Schüler:innen: {{ group.size }}</span>
      </p>
      <b-button class="mr-1" variant="outline-primary" @click="reactivateGroup">
        <i class="fas fa-file-import"></i>
        Klasse aus dem Archiv holen
      </b-button>
      <b-btn variant="outline-danger" @click="requestDeleteGroup">
        <i class="fas fa-trash"></i>
        Klasse löschen
      </b-btn>
      <confirm-dialog ref="confirmDialog" />
    </div>
  </div>
</template>

<script>
  import { ajax } from '../../utils/ajax'
  import { isMasquerading } from '../../utils/user'
  import { useGlobalStore } from '../../store/store'
  import ClassbookActions from './classbook-actions/classbook-actions.vue'
  import ConfirmDialog from '../shared/confirm-dialog.vue'
  import GroupForm from './group-form.vue'
  import MoveStudentDialog from './move-student-dialog.vue'
  import ShareForm from './share-form.vue'
  import StudentList from './student-list.vue'
  import Vue from 'vue'
  import SharesDisplay from './shares-display.vue'

  export default {
    name: 'GroupView',
    components: {
      ClassbookActions,
      ConfirmDialog,
      GroupForm,
      MoveStudentDialog,
      ShareForm,
      SharesDisplay,
      StudentList,
    },
    props: {
      groups: Array, //Alle benötigt, um Klassen aus Archiv zu verschieben
      group: Object,
      single: Boolean,
    },
    setup() {
      const globalStore = useGlobalStore()
      return { globalStore }
    },

    computed: {
      canCreateQrCodes() {
        //TODO restore once DDM is done
        //return this.group.owner || (!this.group.read_only && !this.group.is_anonymous)
        return true
      },
      date: function () {
        let date = new Date(this.group?.updated_at)
        return date.getDate() + '.' + (date.getMonth() + 1) + '.' + date.getFullYear()
      },
      read_only: function () {
        //Klassen nicht veränderbar, falls nur zur Ansicht geteilt, oder gerade ein Masquerading aktiv ist.
        return this.group.read_only || this.globalStore.masquerade
      },
      displayActions() {
        return !isMasquerading() && this.group.id && !this.group.read_only
      },
      students() {
        return this.globalStore.studentsInGroups[this.group.id] || []
      },
    },
    methods: {
      // Klasse aus dem Archiv holen
      async reactivateGroup() {
        const res = await ajax({
          url: '/groups/' + this.group.id + '?group[archive]=0',
          method: 'put',
        })
        const data = res.data
        if (data && res.status === 200) {
          Vue.set(this.globalStore, 'groups', res.data)
          //  this.updateGroup({
          //    object: data,

          //  })
        }
      },
      /*****************************
       * update group and propagate to parent component
       ******************************/
      updateGroup({ object }) {
        this.$set(this.group, object)
        //store.shareKeys[object.id] = object.key
        this.globalStore.setShareKey({ key: object.id, value: object.key })
        const groups = [...this.groups]
        const index = groups.findIndex(g => g.id === object.id)
        groups[index] = object
        this.$emit('update:groups', groups)
      },

      /*****************************
       * delete group and propagate to parent component
       ******************************/
      async requestDeleteGroup() {
        const ok = await this.$refs.confirmDialog.open({
          title: 'Klasse löschen',
          message: `Die Klasse wird mit allen Schüler:innen und allen Messergebnissen gelöscht! Sind Sie sicher?`,
          okText: 'Klasse löschen',
        })
        if (ok) {
          const res = await ajax({
            url: `/groups/${this.group.id}`,
            method: 'delete',
          })

          if (res.status === 200) {
            const remainingGroups = this.groups.filter(g => g.id !== this.group.id)
            this.$emit('update:groups', remainingGroups)
          }
        }
      },
    },
  }
</script>
