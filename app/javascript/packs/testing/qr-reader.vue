<template>
  <div>
    <video id="video" muted></video>
  </div>
</template>

<script>
// Import for QR-Scanner
// Quelle: https://github.com/nimiq/qr-scanner
import QrScanner from 'qr-scanner';
import QrScannerWorkerPath from '!!file-loader!../../../../node_modules/qr-scanner/qr-scanner-worker.min.js';

QrScanner.WORKER_PATH = QrScannerWorkerPath;


export default {
  data(){
    return {
      qrScanner: null,
    }
  },
  mounted() {
    let videoElem = document.getElementById("video");
    this.qrScanner = new QrScanner(videoElem, result => this.onDecode(result));
    this.qrScanner.start();
  },
  methods:{
    onDecode(result){
      // Wenn der Scanner einen QR-Code erkannt hat, fülle das Input-Feld aus, stoppe den Scanner
      // und drücke den Submit Button
      const field = document.getElementById('login');
      field.value = result;
      $("#starten").click();
    }
  }
}
</script>

<style>
  #video{
    width: 100%;
  }
</style>