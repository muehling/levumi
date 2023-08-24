<template>
  <b-modal
    :id="'qr-code-modal'"
    :title="'QR-Code für ' + student.name"
    scrollable
    hide-footer
    static
    :visible="!!student"
    @hidden="hideModal"
  >
    <p>
      Code: {{ student.login }} <br />
      QR-Code:
    </p>
    <div class="text-center">
      <div :id="`qr-${student.id}`"></div>
    </div>
  </b-modal>
</template>
<script>
  import QRCodeStyling from 'qr-code-styling'
  export default {
    name: 'QrCodeModal',
    props: { student: Object },
    watch: {
      'student.id': {
        immediate: true,
        handler() {
          this.generateQRCode()
        },
      },
    },
    methods: {
      hideModal() {
        this.$emit('hide-student-row-modal')
      },
      generateQRCode() {
        if (!this.student.login) {
          return
        }
        const qrCode = new QRCodeStyling({
          width: 400,
          height: 400,
          type: 'canvas',
          data: `${window.location.origin}/testen_login?login=${this.student.login}`,
          dotsOptions: {
            color: '#000000',
          },
        })
        const el = document.getElementById('qr-' + this.student.id)
        qrCode.append(el)
      },
    },
  }
</script>
