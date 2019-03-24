<template>

    <div class='spinner' style='padding-bottom: 75px' v-if="loading">
        <!-- Spinner während Login anzeigen -->
        <div class='bounce1'></div>
        <div class='bounce2'></div>
        <div class='bounce3'></div>
    </div>
    <div v-else-if="tests">
        <!-- Übersicht anzeigen -->
        <b-row>
            <b-col>
                <b-card-group deck>
                    <b-card class='mt-3' v-for="test in tests">
                        <template slot='header'>
                            {{test.id}}
                        </template>
                        Läuft ab am: {{test.expires_on}}
                        <b-btn>Los geht's</b-btn>
                    </b-card>
                </b-card-group>
            </b-col>
        </b-row>
    </div>
    <div v-else>
        <!-- Login Form anzeigen -->
        <b-row>
            <b-col md='3'>
            </b-col>
            <b-col md='6'>
                <b-card class='mt-5' header='Gleich geht es los, bitte gib noch deinen Zugangscode ein'>
                    <b-form
                            action='/login_frontend'
                            accept-charset='UTF-8'
                            data-remote='true'
                            method='post'
                            v-on:ajax:error="loading=false; retry=true"
                            v-on:ajax:success="success"
                    >
                        <b-form-group>
                            <b-form-input :state="retry ? false : null" type='text' name='login' id='login' placeholder='Zugangscode'/>
                            <div class='invalid-feedback'>
                                Falscher Zugangscode. Bitte überprüfe ihn nochmal oder wende dich an deine Lehrkraft.
                            </div>
                        </b-form-group>
                        <b-btn type='submit' variant='primary' v-on:submit="loading=true">Einloggen</b-btn>
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
        data: function () {
            return {
                tests: this.$root.tests,
                retry: false,
                loading: false
            }
        },
        methods: {
            success(event) { //Attributwerte aus AJAX Antwort übernehmen und View updaten
                this.tests = event.detail[0];
                this.loading = false;
            }
        },
        name: 'frontend-app'
    }
</script>
