<template>
  <div class="d-inline">
    <div class="d-flex mb-3">
      <span class="flex-grow-1 pt-1">
        Wählen Sie die Klasse aus, in die Sie die Schüler:innen verschieben wollen.
      </span>
      <b-button v-b-toggle.move-explanation variant="outline-secondary" class="btn-sm">
        Hinweise
      </b-button>
    </div>

    <b-collapse id="move-explanation">
      <b-card class="mb-3">
        <ul>
          <li>
            Schüler:innen werden mit allen bisherigen Messergebnissen in die gewählte Klasse
            verschoben.
          </li>
          <li>Nur Schüler:innen der aktuellen Klasse können verschoben werden.</li>
          <li>
            Wenn Messergebnisse für einen Test vorhanden sind, der der Zielklasse bisher nicht
            zugeordnet ist, wird der Test für die Zielklasse aktiviert. Die bereits vorhandenen
            Schüler:innen werden jedoch erst einmal ausgeschlossen; wenn gewünscht, müssen die
            vorhandenen Schüler:innen manuell für die Teilnahme aktiviert werden.
          </li>
          <li>
            Wenn Messergebnisse zu einem in der Zielklasse pausierten Test vorhanden sind, wird
            dieser Test nicht automatisch aktiviert.
          </li>
        </ul>
      </b-card>
    </b-collapse>
    <b-form-select v-model="targetGroupId" :options="groupOptions" />
    <div v-if="targetGroupId">
      <hr />
      <p>Mit Klick auf eine Schüler:in wird diese in die ausgewählte Klasse verschoben.</p>
      <b-row>
        <b-col>
          <b-card>
            <div
              v-for="(student, index) in sourceGroupStudents"
              :key="student.id"
              :class="`move-student p-1 cursor-pointer${index % 2 ? ' bg-light' : ''}`"
              @mouseover="setActionArrow(1)"
              @mouseleave="setActionArrow(0)"
              @click="handleMoveStudent(student)">
              <span class="text-dark">{{ student.name }}</span>
            </div>
          </b-card>
        </b-col>
        <b-col cols="1" class="mt-4 text-center">
          <div class="action-arrow"><i :class="`fas fa-${actionArrow}`"></i></div>
        </b-col>
        <b-col>
          <div v-if="!!targetGroupId">
            <b-card>
              <div
                v-for="(student, index) in targetGroupStudents"
                :key="student.id"
                :class="`move-student p-1${index % 2 ? ' bg-light' : ''}`"
                @mouseover="setActionArrow(hasStudentMoved(student.id, targetGroupId) ? -1 : 0)"
                @mouseleave="setActionArrow(0)"
                @click="handleMoveStudent(student)">
                <span
                  :class="`${
                    hasStudentMoved(student.id, targetGroupId)
                      ? 'text-dark cursor-pointer'
                      : 'text-muted not-allowed'
                  }`">
                  {{ student.name }}
                </span>
              </div>
            </b-card>
            <b-button class="mt-3" variant="outline-secondary me-2" @click="reset">
              Abbrechen
            </b-button>
            <b-button class="mt-3" variant="outline-success" @click="handleMove">
              Schüler verschieben
            </b-button>
          </div>
        </b-col>
      </b-row>
    </div>
    <confirm-dialog ref="confirmDialog" />
  </div>
</template>
<script>
  import { useGlobalStore } from 'src/store/store'
  import { ajax } from 'src/utils/ajax'
  import { decryptStudentNames, encryptWithMasterKeyAndGroup } from 'src/utils/encryption'
  import apiRoutes from 'src/vue/routes/api-routes'
  import ConfirmDialog from 'src/vue/shared/confirm-dialog.vue'
  export default {
    name: 'MoveStudentDialog',
    components: { ConfirmDialog },
    props: { group: Object },
    setup() {
      const globalStore = useGlobalStore()
      return { globalStore }
    },
    data() {
      return {
        sourceGroupId: this.group.id,
        targetGroupId: null,
        sourceGroupStudents: this.globalStore.studentsInGroups[this.group.id],
        targetGroupStudents: [],
        movedStudents: [],
        actionArrow: '',
      }
    },
    computed: {
      allGroups() {
        return (
          this.globalStore.groups
            //.filter((group, index) => index > 0 && !group.read_only && !group.archive) // can be used for shares
            .filter(group => group.owner && !group.archive)
            .sort((a, b) => (a.label < b.label ? -1 : 1))
        )
      },
      groupOptions() {
        const options = this.allGroups
          .filter(group => group.id !== this.sourceGroupId)
          .map(group => ({
            text: group.label,
            value: group.id,
          }))
        options.unshift({ text: 'Bitte wählen Sie eine Klasse aus.', value: null })
        return options
      },
    },
    watch: {
      targetGroupId: {
        immediate: true,
        handler() {
          this.targetGroupStudents = this.globalStore.studentsInGroups[this.targetGroupId] || []
        },
      },
    },

    methods: {
      setActionArrow(arrow) {
        if (!this.targetGroupId) {
          return
        }
        switch (arrow) {
          case 1:
            this.actionArrow = 'arrow-right'
            break
          case 0:
            this.actionArrow = ''
            break
          case -1:
            this.actionArrow = 'arrow-left'
            break
        }
      },
      hasStudentMoved(studentId, groupId) {
        return !this.globalStore.studentsInGroups[groupId]?.find(s => s.id === studentId)
      },

      handleMoveStudent(student) {
        if (!this.targetGroupId) {
          return
        }
        if (this.sourceGroupStudents.find(s => s.id === student.id)) {
          this.sourceGroupStudents = this.sourceGroupStudents.filter(s => s.id !== student.id)
          this.targetGroupStudents = Array.from(this.targetGroupStudents)
          this.targetGroupStudents.push(student)
          this.movedStudents.push(student)
        } else {
          if (!this.hasStudentMoved(student.id, this.targetGroupId)) {
            return
          }
          this.targetGroupStudents = this.targetGroupStudents.filter(s => s.id !== student.id)
          this.sourceGroupStudents = Array.from(this.sourceGroupStudents)
          this.sourceGroupStudents.push(student)
          this.movedStudents = this.movedStudents.filter(s => s.id !== student.id)
        }
        this.setActionArrow(0)
      },
      reset() {
        this.sourceGroupStudents = this.globalStore.studentsInGroups[this.group.id]
        this.movedStudents = []
        this.targetGroupStudents = []
        this.targetGroupId = null
      },
      async handleMove() {
        const ok = await this.$refs.confirmDialog.open({
          message:
            'Die ausgewählten Schüler werden mit allen erfassten Messergebnissen in die ausgewählte Klasse verschoben.',
          okText: 'Ja, verschieben',
          cancelText: 'Abbrechen',
          title: 'Schüler verschieben',
        })
        if (!ok) {
          return
        }
        const data = {
          students: this.movedStudents.map(s => ({
            id: s.id,
            name: encryptWithMasterKeyAndGroup(s.name, this.targetGroupId),
          })),
          source_group_id: this.sourceGroupId,
          target_group_id: this.targetGroupId,
        }
        const res = await ajax({ ...apiRoutes.students.moveStudents, data })
        if (res.status === 200) {
          res.data.forEach(group => {
            const index = this.globalStore.groups.findIndex(g => g.id === group.id)
            this.globalStore.groups[index] = group
            this.globalStore.studentsInGroups[group.id] = decryptStudentNames(group)
          })
        }

        this.reset()
      },
    },
  }
</script>
<style>
  .not-allowed {
    cursor: not-allowed;
  }
  .cursor-pointer {
    cursor: pointer;
  }
  .action-arrow {
    width: 2em;
    height: 2em;
    font-size: 2em;
  }
  .move-student:hover {
    background-color: rgba(0, 0, 0, 0.075);
  }
  .move-student.bg-light:hover {
    background-color: rgba(0, 0, 0, 0.075) !important;
  }
</style>
