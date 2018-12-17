<template>
    <div>
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
                students: JSON.parse(sessionStorage['students'])[this.group] || []
            }
        },
        methods: {
            update(val) { //Student einfügen, updaten oder löschen und View aktualisieren

                if (val.index == -1) //Create
                    this.students.push(val.object);
                else if (val.object != null) //Update
                    this.$set(this.students, val.index, val.object);
                else //Delete
                    this.students.splice(val.index, 1);

                //Globalen Session Store updaten
                let temp = JSON.parse(sessionStorage['students']);
                temp[this.group] = this.students;
                sessionStorage['students'] = JSON.stringify(temp);
            }
        },
        name: "student-list"
    }
</script>
