<template>
    <div>
        <b-container>
            <b-row>
                <b-col sm-3>Name</b-col>
                <b-col sm-3>Login</b-col>
                <b-col sm-3>Bearbeiten</b-col>
            </b-row>
            <b-row
                v-for="student in this.students"
                :key="student.id"
            >
                <b-col sm-3>{{student.name}}</b-col>
                <b-col sm-3>{{student.login}}</b-col>
                <b-col sm-3><i class="fas fa-edit"></i></b-col>
            </b-row>
            <b-row>
                <b-col sm-3><i class="fas fa-user-plus"></i> Schüler_in hinzufügen</b-col>
            </b-row>
        </b-container>

    </div>
</template>

<script>
    export default {
        props: {
            group: Number
        },
        data: function () {
            return {
                students: JSON.parse(sessionStorage['students'])[this.group]
            }
        },
        name: "student-list"
    }
</script>
