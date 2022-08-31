<template>
  <!-- Darstellung für reguläre Klasse: Buttons für Edit/Archive, Share, dann Schülertabelle  -->
  <div v-if="groups[index].archive == false">
    <div v-if="!single" class="mb-1">
      <!-- Form zur Umbenennung -->
      <group-form
        v-if="groups[index].owner"
        :group="groups[index]"
        :index="index"
        @update:groups="updateGroup($event)"
      ></group-form>
    </div>
    <div v-if="!single" class="mb-2">
      <!-- Info/Form für Klassen teilen -->
      <share-form
        v-if="index > 0"
        :group="groups[index]"
        :index="index"
        @update:groups="updateGroup($event)"
      >
      </share-form>
    </div>
    <student-list v-if="groups[index].key != null" :group="groups[index].id" :read_only="read_only">
    </student-list>
  </div>

  <!-- Darstellung für archivierte Klasse -->
  <div v-else>
    <p class="text-small">
      <em>Ins Archiv verschoben am {{ date }}</em
      ><br />
      <span>Schüler:innen: {{ groups[index].size }}</span>
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
  import GroupForm from './group-form.vue'
  import ShareForm from './share-form.vue'
  import StudentList from './student-list.vue'
  import ConfirmDialog from '../shared/confirm-dialog.vue'
  import { ajax } from '../../utils/ajax'

  export default {
    name: 'GroupView',
    components: {
      StudentList,
      GroupForm,
      ShareForm,
      ConfirmDialog,
    },
    props: {
      groups: Array, //Alle benötigt, um Klassen aus Archiv zu verschieben
      index: Number,
      single: Boolean,
    },
    computed: {
      date: function () {
        let date = new Date(this.groups[this.index].updated_at)
        return date.getDate() + '.' + (date.getMonth() + 1) + '.' + date.getFullYear()
      },
      read_only: function () {
        //Klassen nicht veränderbar, falls nur zur Ansicht geteilt, oder gerade ein Masquerading aktiv ist.
        return this.groups[this.index].read_only || masquerade
      },
    },
    methods: {
      // Klasse aus dem Archiv holen
      async reactivateGroup() {
        const res = await ajax({
          url: '/groups/' + this.groups[this.index].id + '?group[archive]=0',
          method: 'put',
        })
        const data = await res.json()
        if (data && res.status === 200) {
          this.updateGroup({
            index: this.index,
            object: data,
          })
        }
      },
      // update group and propagate to parent component
      updateGroup({ index, object }) {
        this.$set(this.groups, index, object)
        keys[object.id] = object.key
        this.$emit('update:groups', this.groups)
      },
      // remove group and propagate to parent component
      async requestDeleteGroup() {
        const ok = await this.$refs.confirmDialog.open({
          message: `Die Klasse wird mit allen Schüler:innen und allen Messergebnissen gelöscht! Sind Sie sicher?`,
          okText: 'Klasse löschen',
        })
        if (ok) {
          const res = await ajax({
            url: `/groups/${this.groups[this.index].id}`,
            method: 'delete',
          })

          if (res.status === 200) {
            const remainingGroups = this.groups.filter(g => g.id !== this.groups[this.index].id)
            this.$emit('update:groups', remainingGroups)
          }
        }
      },
    },
  }
</script>
