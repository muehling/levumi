<template>
  <div class="mt-3">
    <b-card
      v-if="students.length === 0 && group.read_only"
      bg-variant="white"
      class="col-lg-8 col-xl-6 mt-3">
      Keine Schüler:innen vorhanden!
    </b-card>
    <table v-else class="table table-sm table-striped table-hover table-responsive-md text-small">
      <thead>
        <tr>
          <th>Name</th>
          <th>
            Login-Code
            <context-help
              help-text="Login-Code der Schüler:in. Unter 'Aktionen und Einstellungen' können Sie ein PDF mit diesen Codes zum Ausdrucken und Austeilen an die Schüler:innen erzeugen." />
          </th>
          <th>Geschlecht</th>
          <th>Geburtsdatum</th>
          <th>Förderbedarf</th>
          <th>Weitere Merkmale</th>
          <th>
            Schriftart
            <context-help
              help-text="Aktuell verwendete Schrifteinstellungen. Fett gedruckte Zeilen weichen von der unter 'Aktionen und Einstellungen' festgelegten Standard-Schriftart ab." />
          </th>
          <th>
            Aktionen
            <context-help
              help-text="<i class='text-secondary me-3 fas fa-text-height'></i>Individuelle Schrifteinstellungen<br/>
               <i class='text-secondary me-3 fas fa-user-edit'></i>Informationen bearbeiten<br/>
               <i class='text-secondary me-3 fas fa-qrcode'></i>QR-Code anzeigen<br/>
               <i class='text-secondary me-3 fas fa-circle-info'></i>Zugewiesene Tests anzeigen
              " />
          </th>
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
      :student-or-group="selectedStudent"
      :default-settings="group.settings"
      path="student"
      @hide-student-row-modal="resetSelectedStudent"
      @update-font-settings="updateStudent" />
  </div>
</template>

<script>
  import { decryptStudentName } from 'src/utils/encryption'
  import { useGlobalStore } from 'src/store/store'
  import StudentRow from './student-row.vue'
  import TestInfoModal from 'src/vue/classbook/modals/test-info-modal.vue'
  import QrCodeModal from 'src/vue/classbook/modals/qr-code-modal.vue'
  import FontSettingsModal from 'src/vue/classbook/modals/font-settings-modal.vue'
  import ContextHelp from 'src/vue/shared/context-help.vue'

  export default {
    name: 'StudentList',
    components: { StudentRow, TestInfoModal, QrCodeModal, FontSettingsModal, ContextHelp },
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
