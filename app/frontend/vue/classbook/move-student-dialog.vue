<template>
  <div class="d-inline">
    <b-button v-b-modal.move-student-dialog size="sm" variant="outline-secondary">
      Schüler:innen verschieben
    </b-button>
    <b-modal
      id="move-student-dialog"
      size="lg"
      title="Schüler:innen verschieben"
      button-size="sm"
      ok-variant="outline-success"
      ok-title="Verschieben"
      cancel-variant="outline-secondary"
      cancel-title="Abbrechen"
      @ok="handleConfirmMove"
      @cancel="handleCancel"
    >
      <p>{{ helpText }}</p>
      <hr />
      <b-row>
        <b-col>
          <b-form-select v-model="sourceGroupId" :options="groupOptions" />
          <div
            v-for="(student, index) in sourceGroupStudents"
            :key="student.id"
            :class="`p-2${index % 2 ? ' bg-light' : ''}`"
          >
            <span role="button" class="text-secondary" @click="handleMoveStudent(student)">
              {{ student.name + getStudentSuffix(student.id, sourceGroupId) }}</span
            >
          </div>
        </b-col>

        <b-col>
          <b-form-select v-model="targetGroupId" :options="groupOptions" />
          <div
            v-for="(student, index) in targetGroupStudents"
            :key="student.id"
            :class="`p-2${index % 2 ? ' bg-light' : ''}`"
          >
            <span role="button" class="text-secondary" @click="handleMoveStudent(student)">
              {{ student.name + getStudentSuffix(student.id, targetGroupId) }}
            </span>
          </div>
        </b-col>
      </b-row>
    </b-modal>
  </div>
</template>
<script>
  import { useGlobalStore } from '../../store/store'
  export default {
    name: 'MoveStudentDialog',
    props: { group: Object },
    setup() {
      const globalStore = useGlobalStore()
      return { globalStore }
    },
    data() {
      return {
        sourceGroupId: this.group.id,
        targetGroupId: undefined,
        sourceGroupStudents: [],
        targetGroupStudents: [],
      }
    },
    computed: {
      allGroups() {
        return this.globalStore.groups
          .filter((group, index) => index > 0 && group.owner && !group.archive)
          .sort((a, b) => (a.label < b.label ? -1 : 1))
      },
      groupOptions() {
        return this.allGroups.map(group => ({
          text: group.label,
          value: group.id,
          disabled: group.id === this.sourceGroupId || group.id === this.targetGroupId,
        }))
      },
      helpText() {
        return this.targetGroupId
          ? 'Mit Klick auf eine Schüler:in wird diese in die jeweils andere Klasse verschoben.'
          : 'Wählen Sie die Klasse aus, in die Sie die Schüler:innen verschieben wollen.'
      },
    },
    watch: {
      sourceGroupId: {
        immediate: true,
        handler() {
          this.sourceGroupStudents = this.globalStore.studentsInGroups[this.sourceGroupId] || []
          this.targetGroupStudents = this.globalStore.studentsInGroups[this.targetGroupId] || []
        },
      },
      targetGroupId: {
        immediate: true,
        handler() {
          this.sourceGroupStudents = this.globalStore.studentsInGroups[this.sourceGroupId] || []
          this.targetGroupStudents = this.globalStore.studentsInGroups[this.targetGroupId] || []
        },
      },
    },

    methods: {
      getStudentSuffix(studentId, groupId) {
        return this.globalStore.studentsInGroups[groupId].find(s => s.id === studentId)
          ? ''
          : ' (verschoben)'
      },

      handleMoveStudent(student) {
        if (!this.targetGroupId) {
          return
        }
        if (this.sourceGroupStudents.find(s => s.id === student.id)) {
          this.sourceGroupStudents = this.sourceGroupStudents.filter(s => s.id !== student.id)
          this.targetGroupStudents = Array.from(this.targetGroupStudents)
          this.targetGroupStudents.push(student)
        } else {
          this.targetGroupStudents = this.targetGroupStudents.filter(s => s.id !== student.id)
          this.sourceGroupStudents = Array.from(this.sourceGroupStudents)
          this.sourceGroupStudents.push(student)
        }
      },
      reset() {
        this.sourceGroupStudents = []
        this.targetGroupStudents = []
        this.targetGroupId = undefined
      },
      handleConfirmMove() {
        console.log('yay, confirm')
        this.reset()
      },
      handleCancel() {
        this.reset()
      },
    },
  }
</script>
