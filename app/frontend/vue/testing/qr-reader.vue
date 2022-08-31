<template>
  <div>
    <video id="video" muted></video>
    <div id="error-msg"></div>
  </div>
</template>

<script>
  import QrScanner from 'qr-scanner'

  export default {
    data() {
      return {
        qrScanner: null,
      }
    },
    mounted() {
      let videoElem = document.getElementById('video')
      this.qrScanner = new QrScanner(videoElem, result => this.onDecode(result))
      this.qrScanner.start().then(
        () => {},
        () => {
          this.jQuery('#error-msg').text('Kann QR-Code nicht scannen. Ist die Kamera freigegeben?')
        }
      )
    },
    methods: {
      onDecode(result) {
        // Wenn der Scanner einen QR-Code erkannt hat, fülle das Input-Feld aus, stoppe den Scanner
        // und drücke den Submit Button
        const field = document.getElementById('login')
        field.value = result
        this.jQuery('#starten').click()
      },
    },
  }
</script>

<style>
  #video {
    width: 100%;
  }
</style>
