<template>
    <div class='mt-3'>
        <table class='table table-sm table-striped table-responsive-md text-small'>
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
                <student-row v-for="(student, index) in this.students"
                             :key="student.id"
                             :student="student"
                             :group="group"
                             :index="index"
                             :empty="false"
                             :read_only="read_only"
                             v-on:update:students="update($event)"
                ></student-row>
            <!-- Zusätzliche Reihe mit "leerem" Objekt zum Anlegen -->
                <student-row v-if="!read_only"
                             :student="{name: '', login: '', tags: []}"
                             :key="0"
                             :group="group"
                             :index="-1"
                             :empty="true"
                             :open="students.length === 0"
                             v-on:update:students="update($event)"
                ></student-row>
            </tbody>
        </table>
      <b-button @click="export_qrcodes"><i class="fas fa-print"></i> QR-Code PDF</b-button>
      <!-- Bereich der später ins PDF kommt -->
      <div id="pdfdiv" v-for="(student, index) in this.students" style="display: none">
        <qr-code :id="'qr_code_'+student.id"
                 :text= student.login
        ></qr-code>
        <br>
        <hr>
      </div>
    </div>

</template>

<script>
    import StudentRow from './student-row';
    import jsPDF from 'jspdf';

    export default {
        components: {StudentRow},
        props: {
            group: Number,   //Benötigt um neue Schüler der Gruppe zuordnen zu können.
            read_only: Boolean,
        },
        data: function () {
            return {
                students: groups[this.group] || []
            }
        },
        methods: {
            update(val) { //Student einfügen, updaten oder löschen und View aktualisieren
                if (val.object != null) {
                    val.object.name = decrypt(val.object.name, "Kind_" + val.object.id, this.group); //Namen für weitere Verwendung entschlüsseln
                    if (val.index > -1) //Update
                        this.$set(this.students, val.index, val.object);
                    else //Create
                        this.students.push(val.object);
                }
                else //Delete
                    this.students.splice(val.index, 1);

                //Global updaten - vermutlich unnötig?
                groups[this.group] = this.students;
            },
          export_qrcodes() {
            let pdf = new jsPDF()
            let height = 10
            for(let i = 0; i < this.students.length; i++){
              let base64Image = $('#qr_code_'+ this.students[i].id +' img').attr('src')
              pdf.addImage(base64Image, 'png', 10, height, 40, 40)
              pdf.text("Name: " + this.students[i].name, 60, height+10)
              pdf.text("Code: " + this.students[i].login, 60, height+30)
              pdf.line(0,height+43,210,height+45)
              height = height + 46
              if (height >= 250){
                height = 10
                pdf.addPage()
              }
            }
            pdf.save('qr_codes.pdf')
          },
        },
        name: 'student-list'
    }
</script>
