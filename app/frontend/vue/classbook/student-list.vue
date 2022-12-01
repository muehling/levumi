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
          :group-id="groupId"
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
          :group-id="groupId"
          :index="-1"
          :empty="true"
          :open="students.length === 0"
          @update:students="update($event)"
        ></student-row>
      </tbody>
    </table>
  </div>
</template>

<script>
  import { decryptStudentName } from '../../utils/encryption'
  import { useGlobalStore } from '../../store/store'
  import StudentRow from './student-row.vue'

  export default {
    name: 'StudentList',
    components: { StudentRow },
    props: {
      groupId: Number, //Benötigt um neue Schüler der Gruppe zuordnen zu können.
      readOnly: Boolean,
    },
    setup() {
      const globalStore = useGlobalStore()
      return { globalStore }
    },
    data() {
      return {
        students: [...this.globalStore.studentsInGroups[this.groupId]] || [],
      }
    },
    methods: {
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
