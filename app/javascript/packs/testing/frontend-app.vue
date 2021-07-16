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
                          :href="'/students/' + student.id + '/results/new?test_id='+ test.test_info.id"
                          :disabled="!test.open"
                          :variant="test.open ? 'outline-success' : 'success'"
                          @click="logout = false"
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
              <div v-if="manually">
                <b-card class='mt-5' style="font-size:1.2em" header='Gleich geht es los! Gebe in das Feld deinen eigenen Zugangscode ein.'>
                  <b-form
                      action='/testen_login'
                      accept-charset='UTF-8'
                      data-remote='true'
                      data-type='json'
                      method='post'
                      v-on:ajax:error="loading=false, retry=true"
                      v-on:ajax:success="success"
                      id='form'
                  >
                    <b-form-group>
                      <b-form-input :state="retry ? false : null"
                                    type='text'
                                    name='login'
                                    id='login'
                                    placeholder='Zugangscode'
                                    style="font-size:1.5em"
                                    :formatter="format"
                      />
                      <div class='invalid-feedback'>
                        Falscher Zugangscode. Bitte überprüfe ihn nochmal oder wende dich an deine Lehrkraft.
                      </div>
                    </b-form-group>
                    <b-button style="font-size:1.2em" type='submit' variant='primary' v-on:submit="loading=true">Starten</b-button>
                    <b-button style="font-size:1.2em; float:right" type='button' variant='primary' @click="switchQr()">QR-Code</b-button>
                  </b-form>
                </b-card>
              </div>
              <div v-else>
                <!--QR-Code scannen-->
                <b-card class='mt-5' style="font-size:1.2em"
                        header='Gleich geht es los! Halte den QR-Code vor die Kamera.'>
                  <b-form
                      action='/testen_login'
                      accept-charset='UTF-8'
                      data-remote='true'
                      data-type='json'
                      method='post'
                      v-on:ajax:error="$bvModal.show('invalid_qr_code'),retry=true"
                      v-on:ajax:success="success"
                      id='form'
                  >
                    <b-form-group>
                      <b-form-input :state="retry ? false : null"
                                    type='text'
                                    name='login'
                                    id='login'
                                    placeholder='Zugangscode'
                                    style="display: none"
                                    :formatter="format"
                      />
                      <div class='invalid-feedback'>
                        Falscher Zugangscode. Bitte überprüfe ihn nochmal oder wende dich an deine Lehrkraft.
                      </div>
                      <b-modal :id="'invalid_qr_code'"
                               :title="'Der gelesene QR-Code existiert nicht.'"
                               scrollable
                               hide-footer
                               lazy>
                      </b-modal>
                    </b-form-group>
                    <qr-reader></qr-reader>
                    <b-button style="display: none" type='submit' variant='primary' v-on:submit="loading=true" id='starten'>Starten
                    </b-button>
                    <b-button style="font-size:1.2em;" type='button' variant='primary' @click="switchQr()">
                      Zugangscode eintippen
                    </b-button>
                  </b-form>
                </b-card>
              </div>
            </b-col>
            <b-col md='3'>
            </b-col>
        </b-row>
    </div>
</template>

<script>
import QrReader from './qr-reader';
import { isMobile, isTablet } from 'mobile-device-detect'
    export default {
      components: {
        QrReader
      },
        created() {
            window.addEventListener('beforeunload', this.auto_logout)
          // QR-Reader Standardansicht für Tablet und Smartphones
          if(isMobile || isTablet){
            this.manually = false
          }
        },
        data: function () {
            return {
                tests: this.$root.tests,
                student: this.$root.student,
                retry: false,
                loading: false,
                logout: true,
                manually: true
            }
        },
        methods: {
            auto_logout: function handler(event) {  //Falls Tab geschlossen ohne vorher auszuloggen
                if(this.logout){
                    fetch('/testen_logout', {
                        method: 'POST',
                        headers: {
                            'Accept': 'text/javascript',
                            'X-Requested-With': 'XMLHttpRequest',
                            'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
                        },
                        credentials: 'include'
                    });
                }
            },
            format(val) {
                return val.toUpperCase()
            },
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
                //Details für eingeloggten student anzeigen
                window.$('#navbar_text').html('Dein Login Code: ' + this.student.login)
                window.$('#navbar_button').html("<a class='btn btn-outline-secondary' href='/testen_logout' data-method='post'>Abmelden</a>")
            },
            switchQr() {
              this.manually = !this.manually
            }
        },
        name: 'frontend-app'
    }
</script>
