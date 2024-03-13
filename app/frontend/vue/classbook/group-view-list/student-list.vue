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
          :group-id="groupId"
          :index="index"
          :empty="false"
          :read-only="readOnly"
          @click-student-action="handleClickStudent"
          @update:students="update($event)"></student-row>
        <!-- Zusätzliche Reihe mit "leerem" Objekt zum Anlegen -->
        <student-row
          v-if="!readOnly"
          :key="0"
          :student="{ name: '', login: '', tags: [] }"
          :group-id="groupId"
          :index="-1"
          :empty="true"
          :open="students.length === 0"
          @update:students="update($event)"></student-row>
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
      @update="update" />
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
      groupId: Number, //Benötigt um neue Schüler der Gruppe zuordnen zu können.
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
        const allStudents = this.globalStore.studentsInGroups
        return allStudents[this.groupId] || []
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
      update(val) {
        //Student einfügen, updaten oder löschen und View aktualisieren
        if (val.object !== null) {
          val.object.name = decryptStudentName(
            val.object.name,
            'Kind_' + val.object.id,
            this.groupId
          ) //Namen für weitere Verwendung entschlüsseln
          if (val.index > -1) {
            // update
            this.$set(this.students, val.index, val.object)
          } else {
            // create
            this.students.push(val.object)
          }
        } // delete
        else {
          this.students.splice(val.index, 1)
        }

        this.globalStore.setStudentsInGroup({ groupId: this.groupId, students: this.students })
      },
    },
  }
</script>
../../../utils/encryption../../../store/store
