<template>
  <div v-if="loading" class="spinner" style="padding-bottom: 75px">
    <!-- Spinner während Login anzeigen -->
    <div class="bounce1"></div>
    <div class="bounce2"></div>
    <div class="bounce3"></div>
  </div>
  <div v-else-if="isLoggedIn">
    <b-alert :show="noTestsAvailable" variant="secondary">
      Gerade gibt es keine Tests für dich!
    </b-alert>
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
    <div class="footer-spacer"></div>
  </div>
  <div v-else>
    <!-- Login Form anzeigen -->
    <b-row>
      <b-col md="3"> </b-col>
      <b-col md="6">
        <div v-if="isManualInput">
          <b-card
            class="mt-5"
            style="font-size: 1.2em"
            header="Gleich geht es los! Gib in das Feld deinen eigenen Zugangscode ein."
          >
            <b-form
              id="code-form"
              ref="codeForm"
              action="/testen_login"
              method="post"
              accept-charset="UTF-8"
              @submit.prevent="handleSubmit"
            >
              <b-form-group>
                <input type="hidden" name="authenticity_token" :value="includeCSRFToken()" />
                <b-form-input
                  v-model="loginCode"
                  type="text"
                  name="login"
                  placeholder="Zugangscode"
                  style="font-size: 1.5em"
                  :formatter="format"
                />
                <b-alert :show="isCodeInvalid" variant="danger" class="mt-4"
                  >Falscher Zugangscode. Bitte überprüfe ihn nochmal oder wende dich an deine
                  Lehrkraft.</b-alert
                >
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
          <qr-reader :switch-qr="switchQr" />
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
        isManualInput: true,
        isCodeInvalid: false,
        loginCode: '',
      }
    },
    computed: {
      studentTests() {
        return this.tests.filter(test => !!test.test_info.student_test)
      },
      isLoggedIn() {
        return !!this.tests
      },
      noTestsAvailable() {
        return this.studentTests.length === 0
      },
    },
    created() {
      window.addEventListener('beforeunload', this.auto_logout)
      // QR-Reader Standardansicht für Tablet und Smartphones
      if (isMobile || isTablet) {
        this.isManualInput = false
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
      async checkCode() {
        const res = await ajax({
          url: '/testen_login',
          method: 'POST',
          data: { login: this.loginCode },
        })
        return res.status == 200
      },

      async handleSubmit() {
        const isCodeExisting = await this.checkCode()

        if (isCodeExisting) {
          this.$refs.codeForm.submit()
        } else {
          this.isCodeInvalid = true
        }
      },

      switchQr() {
        this.isCodeInvalid = false
        this.isManualInput = !this.isManualInput
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
  .footer-spacer {
    height: 4em;
  }
</style>
