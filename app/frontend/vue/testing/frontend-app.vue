<template>
  <div>
    <nav class="navbar sticky-top navbar-expand-lg navbar-light bg-light mx-4">
      <a class="navbar-brand" href="/">
        <img
          :src="'/images/shared/Levumi-normal_small.png'"
          alt="Levumi-Icon"
          width="48"
          height="48" />
        Levumi
      </a>
      <ul class="navbar-nav ms-auto">
        <li v-if="isLoggedIn" id="navbar_button" class="nav-item">
          <b-button variant="outline-secondary" @click="handleLogout">Abmelden</b-button>
        </li>
      </ul>
      <ul class="navbar-nav ms-auto">
        <li v-if="isLoggedIn" id="navbar_text" class="navbar-text">
          {{ student?.login ? `Dein Login-Code: ${student.login}` : '' }}
        </li>
      </ul>
    </nav>
    <div id="container" class="container-fluid">
      <div v-if="isLoading" class="spinner" style="padding-bottom: 75px">
        <!-- Spinner während Login anzeigen -->
        <div class="bounce1"></div>
        <div class="bounce2"></div>
        <div class="bounce3"></div>
      </div>
      <div v-else-if="isLoggedIn">
        <div class="container">
          <b-alert :model-value="noTestsAvailable" variant="secondary">
            Gerade gibt es keine Tests für dich!
          </b-alert>
        </div>
        <!-- Übersicht anzeigen -->
        <div class="row">
          <div
            v-for="test in studentTests"
            :key="test.id"
            class="col-12 col-md-6 col-lg-4 col-xl-2 test-card">
            <b-card class="w-100 m-2 shadow" body-class="test-card-body px-3">
              <template slot="title">
                <h4>{{ test.test_info.competence }}</h4>
                <p class="mb-0">{{ test.test_info.area }}</p>
              </template>
              <hr class="mt-0" />
              <h4>{{ test.test_info.family }}</h4>
              <p class="mb-4">{{ test.test_info.level }}</p>

              <b-button
                block
                :href="`/students/${student.id}/results/new?test_id=${test.test_info.id}`"
                :disabled="!test.open"
                :variant="test.open ? 'outline-success' : 'success'"
                :aria-label="test.open ? `Los geht's` : 'Nächste Woche wieder'">
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
          <b-col md="3"></b-col>
          <b-col md="6">
            <div v-if="isManualInput">
              <b-card
                class="mt-5"
                style="font-size: 1.2em"
                header="Gleich geht es los! Gib in das Feld deinen eigenen Zugangscode ein.">
                <b-form
                  id="code-form"
                  ref="codeForm"
                  accept-charset="UTF-8"
                  aria-label="Zugangscode eingeben"
                  @submit.prevent.stop="handleLogin">
                  <b-form-group aria-label="Zugangscode eingeben" class="mb-3">
                    <b-form-input
                      v-model="loginCode"
                      type="text"
                      name="login"
                      placeholder="Zugangscode"
                      style="font-size: 1.5em"
                      :formatter="format"
                      @focus="resetMessages" />
                    <b-alert :model-value="isCodeInvalid" variant="danger" class="mt-4">
                      Falscher Zugangscode. Bitte überprüfe ihn nochmal oder wende dich an deine
                      Lehrkraft.
                    </b-alert>
                    <b-alert :model-value="isCodeEmpty" variant="danger" class="mt-4">
                      Bitte gib deinen Zugangscode ein.
                    </b-alert>
                  </b-form-group>
                  <b-button style="font-size: 1.2em" variant="primary" @click="handleLogin">
                    Starten
                  </b-button>
                  <b-button
                    style="font-size: 1.2em; float: right"
                    type="button"
                    variant="primary"
                    @click="switchQr()">
                    QR-Code
                  </b-button>
                </b-form>
              </b-card>
            </div>
            <div v-else>
              <qr-reader :switch-qr="switchQr" @code-scanned="handleScannedCode" />
            </div>
          </b-col>
          <b-col md="3"></b-col>
        </b-row>
      </div>
    </div>
    <confirm-dialog ref="confirmDialog" />
  </div>
</template>

<script>
  import { isMobile, isTablet } from 'mobile-device-detect'
  import QrReader from './qr-reader.vue'
  import ConfirmDialog from '../shared/confirm-dialog.vue'
  export default {
    name: 'FrontendApp',
    components: {
      QrReader,
      ConfirmDialog,
    },
    data: function () {
      return {
        tests: this.$root.tests,
        student: this.$root.student,
        retry: false,
        isLoading: false,
        isManualInput: true,
        isCodeInvalid: false,
        isCodeEmpty: false,
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
      if (!this.student && window.location.search && window.location.search.startsWith('?login=')) {
        this.loginCode = window.location.search.split('=')[1]
        this.handleLogin()
      }

      // QR-Reader Standardansicht für Tablet und Smartphones
      if (isMobile || isTablet) {
        this.isManualInput = false
      }
    },

    methods: {
      async handleLogout() {
        const res = await fetch('/testen_logout', {
          method: 'POST',
          headers: {
            Accept: 'text/html',
            'Content-Type': 'application/json',
            'X-Requested-With': 'XMLHttpRequest',
            'X-CSRF-Token': document.getElementsByName('csrf-token')[0].getAttribute('content'),
          },
          credentials: 'include',
        })
        if (res.status === 200) {
          this.loginCode = undefined
          this.student = undefined
          this.tests = undefined
          this.isCodeInvalid = false
          this.isCodeEmpty = false
        }
      },

      format(val) {
        return val.toUpperCase()
      },

      handleScannedCode(code) {
        this.loginCode = code
        this.handleLogin()
      },
      resetMessages() {
        this.isCodeInvalid = false
        this.isCodeEmpty = false
        this.loginCode = ''
      },
      async handleLogin() {
        this.isCodeInvalid = false
        if (!this.loginCode) {
          this.isCodeEmpty = true
          return
        }
        this.isLoading = true
        this.isCodeEmpty = false

        const res = await fetch('/testen_login', {
          method: 'POST',
          headers: {
            Accept: 'application/json',
            'Content-Type': 'application/json',
            'X-Requested-With': 'XMLHttpRequest',
            'X-CSRF-Token': document.getElementsByName('csrf-token')[0].getAttribute('content'),
          },
          credentials: 'include',
          body: JSON.stringify({ login: this.loginCode }),
        })

        let data
        switch (res.status) {
          case 200:
            data = await res.json()
            this.student = data.student
            this.tests = data.tests
            break
          case 401:
            await this.$refs.confirmDialog.open({
              hideCancelButton: true,
              message: 'Etwas ist schiefgegangen. Bitte probiere es gleich noch einmal!',
              okIntent: 'outline-success',
              okText: 'Ok',
              title: 'Ups',
            })
            window.location.reload()
            break
          default:
            this.isCodeInvalid = true
        }
        this.isLoading = false
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
    max-width: 20em !important;
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
