<template>

    <div class='spinner' style='padding-bottom: 75px' v-if="loading">
        <!-- Spinner während Login anzeigen -->
        <div class='bounce1'></div>
        <div class='bounce2'></div>
        <div class='bounce3'></div>
    </div>
    <div v-else-if="tests">
        <b-alert :show="no_tests()"  variant='secondary'>
            Gerade gibt es keine Tests für dich!
        </b-alert>
        <!-- Übersicht anzeigen -->
        <b-card-group deck>
            <b-card class='mt-3'
                    v-for="test in tests"
                    v-if="test.test_info.student_test"
                    :key="test.id"
                    :title="test.test_info.family"
                    :sub-title="test.test_info.level"
            >
                <template slot='header'>
                    <h4>{{test.test_info.competence}}</h4>
                    <h6>{{test.test_info.area}}</h6>
                </template>
                <b-button block variant='primary'
                          :href="'/students/' + student + '/results?test_id='+ test.test_info.id"
                          data-method='post'
                          :disabled="!test.open"
                          :variant="test.open ? 'outline-success' : 'success'"
                          @click="kick = false"
                >
                    {{test.open ? 'Los geht\'s' : 'Nächste Woche wieder'}}
                </b-button>
            </b-card>
        </b-card-group>
    </div>
    <div v-else>
        <!-- Login Form anzeigen -->
        <b-row>
            <b-col md='3'>
            </b-col>
            <b-col md='6'>
                <b-card class='mt-5' style="font-size:1.4em" header='Gleich geht es los! Gebe in das Feld deinen eigenen Zugangscode ein.'>
                    <b-form
                            action='/login_frontend'
                            accept-charset='UTF-8'
                            data-remote='true'
                            method='post'
                            v-on:ajax:error="loading=false; retry=true"
                            v-on:ajax:success="success"
                    >
                        <b-form-group>
                            <b-form-input :state="retry ? false : null" type='text' name='login' id='login' placeholder='Zugangscode' style="font-size:1.5em"/>
                            <div class='invalid-feedback'>
                                Falscher Zugangscode. Bitte überprüfe ihn nochmal oder wende dich an deine Lehrkraft.
                            </div>
                        </b-form-group>
                        <b-button style="font-size:1.2em" type='submit' variant='primary' v-on:submit="loading=true">Einloggen</b-button>
                    </b-form>
                </b-card>
            </b-col>
            <b-col md='3'>
            </b-col>
        </b-row>
    </div>
</template>

<script>
    export default {
        created() {
            window.addEventListener('beforeunload', this.handler)
        },
        data: function () {
            return {
                tests: this.$root.tests,
                student: this.$root.student,
                retry: false,
                loading: false,
                kick: true
            }
        },
        methods: {
            no_tests() {
              for (let i = 0; i < this.tests.length; ++i)
                  if (this.tests[i].test_info.student_test)
                      return false
              return true
            },
            success(event) { //Attributwerte aus AJAX Antwort übernehmen und View updaten
                this.tests = event.detail[0]['tests']
                this.student = event.detail[0]['student']
                this.loading = false
            },
            handler: function handler(event) {
                if(this.kick){
                    fetch('/kick_frontend', {
                        method: 'POST',
                        headers: {
                            'Accept': 'text/javascript',
                            'X-Requested-With': 'XMLHttpRequest',
                            'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
                        },
                        credentials: 'include'
                    });
                }
            }
        },
        name: 'frontend-app'
    }
</script>
