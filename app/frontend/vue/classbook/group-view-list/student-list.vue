<template>
  <div class="mt-3">
    <table class="table table-sm table-striped table-hover table-responsive-md text-small">
      <thead>
        <tr>
          <th>Name</th>
          <th>Login-Code</th>
          <th>Geschlecht</th>
          <th>Geburtsdatum</th>
          <th>Förderbedarf</th>
          <th>Weitere Merkmale</th>
          <th>Aktionen</th>
        </tr>
      </thead>
      <tbody>
        <!-- Eine Reihe pro existierendem Schüler -->
        <student-row
          v-for="(student, index) in students"
          :key="student.id"
          :student="student"
          :group="group"
          :index="index"
          :empty="false"
          @click-student-action="handleClickStudent"
          @delete-student="deleteStudent"
          @update-student="updateStudent"></student-row>
        <!-- Zusätzliche Reihe mit "leerem" Objekt zum Anlegen -->
        <student-row
          v-if="!readOnly"
          :key="-1"
          :student="{ name: '', login: '', tags: [] }"
          :group="group"
          :index="-1"
          :empty="true"
          :open="students.length === 0"
          @update-student="updateStudent"></student-row>
      </tbody>
    </table>
    <test-info-modal
      v-if="selectedStudent && selectedModal === 'test-info'"
      :student="selectedStudent"
      @hide-student-row-modal="resetSelectedStudent" />
    <qr-code-modal
      v-if="selectedStudent && selectedModal === 'qr-code'"
      :student="selectedStudent"
      @hide-student-row-modal="resetSelectedStudent" />
    <font-settings-modal
      v-if="selectedStudent && selectedModal === 'font-settings'"
      :student="selectedStudent"
      @hide-student-row-modal="resetSelectedStudent"
      @update="updateStudent" />
  </div>
</template>

<script>
  import { decryptStudentName } from 'src/utils/encryption'
  import { useGlobalStore } from 'src/store/store'
  import StudentRow from './student-row.vue'
  import TestInfoModal from 'src/vue/classbook/modals/test-info-modal.vue'
  import QrCodeModal from 'src/vue/classbook/modals/qr-code-modal.vue'
  import FontSettingsModal from 'src/vue/classbook/modals/font-settings-modal.vue'

  export default {
    name: 'StudentList',
    components: { StudentRow, TestInfoModal, QrCodeModal, FontSettingsModal },
    props: {
      group: Object,
      readOnly: Boolean,
    },
    setup() {
      const globalStore = useGlobalStore()
      return { globalStore }
    },
    data: function () {
      return { selectedStudent: undefined, selectedModal: undefined }
    },
    computed: {
      students() {
        const allStudents = this.globalStore.studentsInGroups[this.group.id]
        return allStudents || []
      },
    },

    methods: {
      resetSelectedStudent() {
        this.selectedStudent = undefined
        this.action = undefined
      },
      handleClickStudent(student, action) {
        this.selectedStudent = student
        this.selectedModal = action
      },
      deleteStudent(data) {
        const students = this.students.filter(s => s.id !== data.id)
        this.globalStore.setStudentsInGroup({ groupId: this.group.id, students: students })
      },

      updateStudent(data) {
        const students = [...this.students]

        data.name = decryptStudentName(data.name, 'Kind_' + data.id, this.group.id)
        let student = students.find(s => s.id === data.id)
        if (student) {
          const index = students.findIndex(s => s.id === data.id)
          students[index] = data
        } else {
          students.push(data)
        }

        this.globalStore.setStudentsInGroup({ groupId: this.group.id, students: students })
      },
    },
  }
</script>
