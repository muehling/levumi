<template>
  <div>
    <div v-if="group.archive === false" pills>
      <div v-if="!showActionTab">
        <share-status v-if="!group.owner" :group="group" />
        <b-button
          v-if="displayActionButton"
          size="sm"
          variant="outline-secondary"
          @click="handleNavigate('aktionen')">
          <i class="fas fa-gear"></i>
          Aktionen und Einstellungen
        </b-button>

        <student-list v-if="group.key != null" class="mt-4" :group="group" :read-only="readOnly" />
      </div>
      <div v-else-if="showActionTab">
        <b-button size="sm" variant="outline-secondary" @click="handleNavigate('liste')">
          <i class="fas fa-backward-step"></i>
          Zurück zur Liste
        </b-button>
        <b-row class="mt-4">
          <b-col sm="4" md="3">
            <group-view-actions-nav
              :current="currentNav"
              :group="group"
              @groupview::action="handleSwitchActionPage" />
          </b-col>
          <b-col>
            <b-card :title="actionCardTitle">
              <div v-if="currentNav === 'general'">
                <classbook-actions
                  v-if="permissions?.updateGroup"
                  :group="group"
                  @group-archived="selectedGroupId = undefined" />
              </div>
              <div v-if="currentNav === 'share' && permissions?.createShare">
                <share-form :group="group" @update:groups="updateGroup($event)" />
                <shares-display v-if="group.owner" :group="group" />
              </div>
              <div v-if="currentNav === 'movestudents' && permissions?.moveStudents">
                <move-student-dialog :group="group" />
              </div>
            </b-card>
          </b-col>
        </b-row>
      </div>
    </div>

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
  import { access } from 'src/utils/access'
  import { ajax } from 'src/utils/ajax'
  import { isMasquerading } from 'src/utils/user'
  import { useGlobalStore } from 'src/store/store'
  import ClassbookActions from './group-view-actions/classbook-actions.vue'
  import ConfirmDialog from '../shared/confirm-dialog.vue'
  import GroupViewActionsNav from './group-view-actions/group-view-actions-nav.vue'
  import isEmpty from 'lodash/isEmpty'
  import MoveStudentDialog from './group-view-actions/move-student-dialog.vue'
  import ShareForm from './group-view-actions/share-form.vue'
  import SharesDisplay from './shares-display.vue'
  import ShareStatus from './share-status.vue'
  import StudentList from './group-view-list/student-list.vue'
  import Vue from 'vue'

  export default {
    name: 'GroupView',
    components: {
      ClassbookActions,
      ConfirmDialog,
      GroupViewActionsNav,
      MoveStudentDialog,
      ShareForm,
      SharesDisplay,
      ShareStatus,
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
    data() {
      return { currentNav: 'general' }
    },
    computed: {
      actionCardTitle() {
        switch (this.currentNav) {
          case 'general':
            return 'Allgemein'
          case 'share':
            return 'Klasse teilen'
          case 'movestudents':
            return 'Schüler:innen verschieben'
        }
        return 'Unbekannte Aktion'
      },
      canCreateQrCodes() {
        return this.group.owner || (!this.group.read_only && !this.group.is_anonymous)
      },
      date: function () {
        let date = new Date(this.group?.updated_at)
        return date.getDate() + '.' + (date.getMonth() + 1) + '.' + date.getFullYear()
      },
      readOnly: function () {
        //Klassen nicht veränderbar, falls nur zur Ansicht geteilt, oder gerade ein Masquerading aktiv ist.
        return this.group.read_only || this.globalStore.masquerade
      },
      displayActionButton() {
        return !isEmpty(this.permissions) && this.group.key // shares without key are not accepted yet
      },
      displayActions() {
        return !isMasquerading() && this.group.id && this.group.owner
      },
      showActionTab() {
        return this.$route.path.endsWith('aktionen')
      },
      permissions() {
        return access(this.group).classbook
      },
      students() {
        return this.globalStore.studentsInGroups[this.group.id] || []
      },
    },
    watch: {
      '$route.params': {
        immediate: true,
        async handler(data) {
          if (data.groupId) {
            this.selectedGroupId = parseInt(data.groupId, 10)
          } else {
            this.selectedGroupId = this.group.id
          }
        },
      },
    },
    methods: {
      handleNavigate(path) {
        if (this.$route.path.endsWith(path)) {
          return
        }

        let classBookRoot
        if (this.$route.path.includes(this.selectedGroupId + '')) {
          classBookRoot = this.$route.path.split('/' + this.selectedGroupId)[0]
        } else if (this.$route.name === 'ClassbookShared') {
          classBookRoot = '/klassenbuch/geteilte_klassen'
        } else {
          classBookRoot = '/klassenbuch/eigene_klassen'
        }

        this.$router.push(`${classBookRoot}/${this.selectedGroupId}/${path}`)
      },
      handleSwitchActionPage(action) {
        this.currentNav = action
      },

      // Klasse aus dem Archiv holen
      async reactivateGroup() {
        const res = await ajax({
          url: '/groups/' + this.group.id + '?group[archive]=0',
          method: 'put',
        })
        const data = res.data
        if (data && res.status === 200) {
          Vue.set(this.globalStore, 'groups', res.data)
          this.$router.push(`/klassenbuch/eigene_klassen/${this.group.id}/liste`)
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
