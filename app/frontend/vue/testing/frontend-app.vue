<template>
  <div v-if="loading" class="spinner" style="padding-bottom: 75px">
    <!-- Spinner während Login anzeigen -->
    <div class="bounce1"></div>
    <div class="bounce2"></div>
    <div class="bounce3"></div>
  </div>
  <div v-else-if="tests">
    <b-alert :show="no_tests()" variant="secondary"> Gerade gibt es keine Tests für dich! </b-alert>
    <!-- Übersicht anzeigen -->
    <div class="row">
      <div
        v-for="test in studentTests"
        :key="test.id"
        class="col-12 col-md-6 col-lg-4 col-xl-2 test-card"
      >
        <b-card
          class="w-100 m-2 shadow"
          body-class="test-card-body px-3"
          :title="test.test_info.family"
          :sub-title="test.test_info.level"
        >
          <template slot="header">
            <h4>{{ test.test_info.competence }}</h4>
            <h6>{{ test.test_info.area }}</h6>
          </template>
          <b-button
            block
            :href="'/students/' + student.id + '/results/new?test_id=' + test.test_info.id"
            :disabled="!test.open"
            :variant="test.open ? 'outline-success' : 'success'"
            @click="logout = false"
          >
            {{ test.open ? "Los geht's" : 'Nächste Woche wieder' }}
          </b-button>
        </b-card>
      </div>
    </div>
  </div>
  <div v-else>
    <!-- Login Form anzeigen -->
    <b-row>
      <b-col md="3"> </b-col>
      <b-col md="6">
        <div v-if="manually">
          <b-card
            class="mt-5"
            style="font-size: 1.2em"
            header="Gleich geht es los! Gebe in das Feld deinen eigenen Zugangscode ein."
          >
            <b-form id="form" action="/testen_login" method="post" accept-charset="UTF-8">
              <b-form-group>
                <input type="hidden" name="authenticity_token" :value="includeCSRFToken()" />
                <b-form-input
                  id="login"
                  :state="retry ? false : null"
                  type="text"
                  name="login"
                  placeholder="Zugangscode"
                  style="font-size: 1.5em"
                  :formatter="format"
                />
                <div class="invalid-feedback">
                  Falscher Zugangscode. Bitte überprüfe ihn nochmal oder wende dich an deine
                  Lehrkraft.
                </div>
              </b-form-group>
              <b-button style="font-size: 1.2em" type="submit" variant="primary">Starten</b-button>
              <b-button
                style="font-size: 1.2em; float: right"
                type="button"
                variant="primary"
                @click="switchQr()"
                >QR-Code</b-button
              >
            </b-form>
          </b-card>
        </div>
        <div v-else>
          <!--QR-Code scannen-->
          <b-card
            class="mt-5"
            style="font-size: 1.2em"
            header="Gleich geht es los! Halte den QR-Code vor die Kamera."
          >
            <b-form
              id="form"
              action="/testen_login"
              accept-charset="UTF-8"
              data-remote="true"
              data-type="json"
              method="post"
              @ajax:error="$bvModal.show('invalid_qr_code'), (retry = true)"
              @ajax:success="success"
            >
              <b-form-group>
                <input type="hidden" name="authenticity_token" :value="includeCSRFToken()" />
                <b-form-input
                  id="login"
                  :state="retry ? false : null"
                  type="text"
                  name="login"
                  placeholder="Zugangscode"
                  style="display: none"
                  :formatter="format"
                />
                <div class="invalid-feedback">
                  Falscher Zugangscode. Bitte überprüfe ihn nochmal oder wende dich an deine
                  Lehrkraft.
                </div>
                <b-modal
                  :id="'invalid_qr_code'"
                  :title="'Der gelesene QR-Code existiert nicht.'"
                  scrollable
                  hide-footer
                  lazy
                >
                </b-modal>
              </b-form-group>
              <qr-reader />
              <b-button
                id="starten"
                style="display: none"
                type="submit"
                variant="primary"
                @submit="loading = true"
                >Starten
              </b-button>
              <b-button
                style="font-size: 1.2em"
                type="button"
                variant="primary"
                @click="switchQr()"
              >
                Zugangscode eintippen
              </b-button>
            </b-form>
          </b-card>
        </div>
      </b-col>
      <b-col md="3"> </b-col>
    </b-row>
  </div>
</template>

<script>
  import QrReader from './qr-reader.vue'
  import { ajax, getCSRFToken } from '../../utils/ajax'

  import { isMobile, isTablet } from 'mobile-device-detect'
  export default {
    name: 'FrontendApp',
    components: {
      QrReader,
    },
    data: function () {
      return {
        tests: this.$root.tests,
        student: this.$root.student,
        retry: false,
        loading: false,
        logout: true,
        manually: true,
      }
    },
    computed: {
      studentTests() {
        return this.tests.filter(test => !!test.test_info.student_test)
      },
    },
    created() {
      window.addEventListener('beforeunload', this.auto_logout)
      // QR-Reader Standardansicht für Tablet und Smartphones
      if (isMobile || isTablet) {
        this.manually = false
      }
    },

    methods: {
      includeCSRFToken() {
        return getCSRFToken()
      },
      handleLogout() {
        ajax({ url: '/test_logout', method: 'post' })
      },
      auto_logout: function handler() {
        //Falls Tab geschlossen ohne vorher auszuloggen
        if (this.logout) {
          fetch('/testen_logout', {
            method: 'POST',
            headers: {
              Accept: 'text/javascript',
              'X-Requested-With': 'XMLHttpRequest',
              'X-CSRF-Token': getCSRFToken(),
            },
            credentials: 'include',
          })
        }
      },
      format(val) {
        return val.toUpperCase()
      },
      no_tests() {
        for (let i = 0; i < this.tests.length; ++i) {
          if (this.tests[i].test_info.student_test) {
            return false
          }
        }
        return true
      },
      success(event) {
        //Attributwerte aus AJAX Antwort übernehmen und View updaten
        this.tests = event.detail[0]['tests']
        this.student = event.detail[0]['student']
        this.loading = false
        //Details für eingeloggten student anzeigen
        this.jQuery('#navbar_text').html('Dein Login Code: ' + this.student.login)
        this.jQuery('#navbar_button')
          .html("<button class='btn btn-outline-secondary'>Abmelden</button>")
          .on('click', this.handleLogout)
      },
      switchQr() {
        this.manually = !this.manually
      },
    },
  }
</script>

<style>
  .test-card {
    min-width: 8em;
    display: flex;
    flex-grow: 1 !important;
  }
  .test-card-body {
    display: flex;
    flex-direction: column;
    justify-content: space-between;
  }
  .test-card > .card {
    hyphens: auto;
  }
</style>
