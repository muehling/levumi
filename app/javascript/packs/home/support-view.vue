<template>
    <div>
        <!-- Spinner für die AJAX-Requests zum Laden eines gewählten Assessments-->
        <div class='spinner' style='padding-bottom: 75px' v-if="loading">
            <div class='bounce1'></div>
            <div class='bounce2'></div>
            <div class='bounce3'></div>
        </div>
        <div v-else>
            <b-tabs pills>
                <b-tab v-for="entry in suggestions" :key="entry.student.id" :title="student_name(entry.student)">
                    <b-tabs pills card vertical class='mt-2'>
                        <b-tab v-for="material in entry.materials" :key="material.id" :title="material.name">
                            <material-view :material="material" :full="false"></material-view>
                        </b-tab>
                    </b-tabs>
                </b-tab>
            </b-tabs>
        </div>

    </div>
</template>

<script>
    import MaterialView from '../materials/material-view'
    export default {
        components: {MaterialView},
        name: "support-view",
        props: {
          group: Number,
          test: Number
        },
        data: function() {
          return {
              loading: true,
              suggestions: []
          }
        },
        methods: {
            student_name(id) {   //Student-Objekt aus globaler Variable holen
                return get_student(this.group, id).name;
            }
        },
        created() {
            fetch('/materials?test=' + this.test + '&group=' + this.group, {
                headers: {
                    'Accept': 'text/javascript',
                    'X-Requested-With': 'XMLHttpRequest',
                    'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
                },
                credentials: 'include'
            })
                .then(response => {
                    return response.text().then(text =>  {
                        this.suggestions = JSON.parse(text);
                        this.loading = false;  //Spinner verstecken
                    });
                });
        }
    }
</script>
