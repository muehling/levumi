<template>
    <div class="mt-3">
        <table class="table table-condensed table-striped vue-table">
            <thead>
            <tr>
                <th>
                    Name
                </th>
                <th>
                    Login-Code
                </th>
                <th>
                    Bearbeiten
                </th>
            </tr>
            </thead>
            <tbody>
                <student-row v-for="(student, index) in this.students"
                             :key="student.id"
                             :student="student"
                             :group="group"
                             :index="index"
                             :empty="false"
                             v-on:update:students="update($event)"
                ></student-row>
                <student-row :student="{name: '', login: ''}"
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
    import StudentRow from "./student-row";

    export default {
        components: {StudentRow},
        props: {
            group: Number
        },
        data: function () {
            return {
                students: groups[this.group] || []
            }
        },
        methods: {
            update(val) { //Student einfügen, updaten oder löschen und View aktualisieren
                if (val.object != null) {
                    val.object.name = decrypt(val.object.name, val.object.id); //Namen für weitere Verwendung entschlüsseln
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
        name: "student-list"
    }
</script>
