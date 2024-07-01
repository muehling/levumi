<template>
  <!--QR-Code scannen-->
  <b-card
    class="mt-5"
    style="font-size: 1.2em"
    header="Gleich geht es los! Halte den QR-Code vor die Kamera.">
    <div>
      <video id="video" muted></video>
      <div id="error-msg"></div>
    </div>
    <b-alert :show="isCodeInvalid" variant="danger" class="mt-4">
      Ungültiger QR-Code. Bitte überprüfe ihn nochmal oder wende dich an deine Lehrkraft.
    </b-alert>
    <b-button
      class="switch-qr-button"
      style=""
      type="button"
      variant="primary"
      @click="toggleInputMethod">
      Zugangscode eintippen
    </b-button>

    <b-form id="qr-form" ref="qrForm" action="/testen_login" method="post" accept-charset="UTF-8">
      <input name="authenticity_token" :value="includeCSRFToken()" />
      <b-form-input v-model="loginCode" type="text" name="login" />
    </b-form>
  </b-card>
</template>

<script>
  import QrScanner from 'qr-scanner'
  import { ajax, getCSRFToken } from '../../utils/ajax'

  export default {
    props: { switchQr: Function },
    data() {
      return {
        qrScanner: null,
        loginCode: '',
        isCodeInvalid: false,
        scannedString: '',
        scannerError: '',
      }
    },
    mounted() {
      let videoElem = document.getElementById('video')
      this.qrScanner = new QrScanner(videoElem, this.onDecode)
      this.qrScanner.start().then(
        () => {},
        () => {
          //this.jQuery('#error-msg').text('Kann QR-Code nicht scannen. Ist die Kamera freigegeben?')
          this.scannerError = 'Der QR-Code kann nicht gescannt werden. Ist die Kamera freigegeben?'
        }
      )
    },
    methods: {
      toggleInputMethod() {
        this.qrScanner.stop()
        this.switchQr()
      },
      includeCSRFToken() {
        return getCSRFToken()
      },
      async onDecode(result) {
        if (result === '' || this.scannedString === result) {
          return
        }

        this.scannedString = result
        // check if the QR code contains a fully qualified link to the test page or just the code
        const codeFromResult = this.getUrlParameterValue(result)

        if (codeFromResult) {
          this.loginCode = codeFromResult
        } else {
          this.loginCode = result
        }

        const isCodeExisting = await ajax({
          url: '/testen_login',
          method: 'POST',
          data: { login: this.loginCode },
        })

        if (isCodeExisting.status === 200) {
          this.$nextTick(() => {
            this.qrScanner.stop()
            this.$refs.qrForm.submit()
          })
        } else {
          this.isCodeInvalid = true
        }
      },
      getUrlParameterValue(testString) {
        try {
          const url = new URL(testString)
          if (!url.search.startsWith('?login=')) {
            return ''
          }

          const codeOnly = url.search.replace('?login=', '')
          if (codeOnly.length !== 6) {
            return ''
          }

          return codeOnly
        } catch (e) {
          return ''
        }
      },
    },
  }
</script>

<style>
  #video {
    width: 100%;
  }
  .switch-qr-button {
    font-size: 1.2em !important;
    float: right;
  }
  #qr-form {
    display: none;
  }
</style>
