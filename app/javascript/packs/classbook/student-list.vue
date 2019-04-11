<template>
    <div class='mt-3'>
        <table class='table table-sm table-striped table-responsive-md'>
            <thead>
            <tr>
                <th>Name</th>
                <th>Login-Code</th>
                <th>Geschlecht</th>
                <th>Geburtsmonat</th>
                <th>Förderbedarf</th>
                <th>Migrationshintergrund</th>
                <th>Bearbeiten</th>
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
                             :student="{name: '', login: ''}"
                             :key="0"
                             :group="group"
                             :index="-1"
                             :empty="true"
                             v-on:update:students="update($event)"
                ></student-row>
            </tbody>
        </table>
    </div>

</template>

<script>
    import StudentRow from './student-row';

    export default {
        components: {StudentRow},
        props: {
            group: Number,   //Benötigt um neue Schüler der Gruppe zuordnen zu können.
            read_only: Boolean
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
            }
        },
        name: 'student-list'
    }
</script>
