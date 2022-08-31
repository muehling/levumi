<template>
  <div class="mt-3">
    <table class="table table-sm table-striped table-responsive-md text-small">
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
          :student="{ ...student }"
          :group="group"
          :index="index"
          :empty="false"
          :read-only="readOnly"
          @update:students="update($event)"
        >
        </student-row>
        <!-- Zusätzliche Reihe mit "leerem" Objekt zum Anlegen -->
        <student-row
          v-if="!readOnly"
          :key="0"
          :student="{ name: '', login: '', tags: [] }"
          :group="group"
          :index="-1"
          :empty="true"
          :open="students.length === 0"
          @update:students="update($event)"
        ></student-row>
      </tbody>
    </table>
    <b-button @click="exportQrCodes"
      ><i class="fas fa-print"></i> QR-Code PDF</b-button
    >
    <!-- Bereich der später ins PDF kommt -->
    <div v-for="student in students" style="display: none">
      <qr-code :id="'qr_code_' + student.id" :value="student.login" />
      <br />
      <hr />
    </div>
  </div>
</template>

<script>
  import StudentRow from './student-row.vue'
  import jsPDF from 'jspdf'

  export default {
    name: 'StudentList',
    components: { StudentRow },
    props: {
      group: Number, //Benötigt um neue Schüler der Gruppe zuordnen zu können.
      readOnly: Boolean,
    },
    data() {
      return {
        // TODO this needs to go in some global store instead of the global namespace
        students: groups[this.group] || [],
      }
    },
    methods: {
      update(val) {
        //Student einfügen, updaten oder löschen und View aktualisieren
        if (val.object !== null) {
          val.object.name = decrypt(
            val.object.name,
            'Kind_' + val.object.id,
            this.group
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

        //Global updaten - vermutlich unnötig?
        groups[this.group] = this.students
      },
      exportQrCodes() {
        const pdf = new jsPDF()
        let height = 10
        for (let i = 0; i < this.students.length; i++) {
          const qrElement = $('#qr_code_' + this.students[i].id + ' canvas')[0]
          if (qrElement) {
            const base64Image = qrElement.toDataURL('image/jpeg', 1)
            pdf.addImage(base64Image, 'png', 10, height, 40, 40)
            pdf.text('Name: ' + this.students[i].name, 60, height + 10)
            pdf.text('Code: ' + this.students[i].login, 60, height + 30)
            pdf.line(0, height + 43, 210, height + 45)
            height = height + 46
            if (height >= 250) {
              height = 10
              pdf.addPage()
            }
          }
        }
        pdf.save('qr_codes.pdf')
      },
    },
  }
</script>
