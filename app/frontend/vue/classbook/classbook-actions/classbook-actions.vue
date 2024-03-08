<template>
  <div class="group-actions">
    <b-button
      v-if="!group.demo"
      v-b-toggle="'collapse_edit_' + group.id"
      class="mr-2"
      variant="outline-secondary"
      size="sm">
      <i class="fas fa-edit"></i>
      Klasse umbenennen
    </b-button>
    <b-button
      id="intro_cb_4"
      v-b-toggle="'collapse_share_' + group.id"
      class="mr-2"
      variant="outline-secondary"
      size="sm">
      <i class="fas fa-handshake"></i>
      Klasse teilen
    </b-button>
    <b-button v-b-modal.move-student-dialog size="sm" variant="outline-secondary" class="mr-2">
      Schüler:innen verschieben
    </b-button>
    <b-button
      v-if="canCreateQrCodes"
      variant="success"
      class="mr-2"
      size="sm"
      :disabled="isGeneratingQrCodes"
      @click="exportQrCodes">
      <i :class="isGeneratingQrCodes ? 'fas fa-spinner fa-spin' : 'fas fa-print'"></i>
      QR-Code PDF
    </b-button>
    <b-button
      id="intro_cb_3"
      class="float-right mr-2"
      size="sm"
      variant="outline-secondary"
      @click="moveToArchive">
      <i class="fas fa-file-export"></i>
      Klasse in Archiv verschieben
    </b-button>
  </div>
</template>
<script>
  import { ajax } from '../../../utils/ajax'
  import { useGlobalStore } from '../../../store/store'
  import jsPDF from 'jspdf'
  import QRCodeStyling from 'qr-code-styling'
  import Vue from 'vue'
  export default {
    name: 'ClassbookActions',
    props: { group: Object },
    setup() {
      const globalStore = useGlobalStore()
      return { globalStore }
    },
    data() {
      return {
        isGeneratingQrCodes: false,
      }
    },
    computed: {
      canCreateQrCodes() {
        return this.group.owner || (!this.group.read_only && !this.group.is_anonymous)
      },
    },
    methods: {
      async moveToArchive() {
        const res = await ajax({
          url: '/groups/' + this.group.id + '?group[archive]=1',
          method: 'put',
        })
        const data = res.data
        if (data && res.status === 200) {
          //this.globalStore.fetch()
          Vue.set(this.globalStore, 'groups', res.data)
        }
      },
      async exportQrCodes() {
        this.isGeneratingQrCodes = true
        const pdf = new jsPDF()
        let height = 10
        for (let i = 0; i < this.students.length; i++) {
          const qrCode = new QRCodeStyling({
            width: 400,
            height: 400,
            type: 'canvas',
            data: `${window.location.origin}/testen_login?login=${this.students[i].login}`,
            dotsOptions: {
              color: '#000000',
            },
          })
          const qrData = await qrCode.getRawData('jpeg')

          if (qrCode) {
            const base64Image = await this.blobToBase64(qrData)
            const levumiImg = new Image()
            levumiImg.src = '/images/shared/Levumi-normal.jpg'
            const studentName = this.students[i].name.startsWith('Kind_')
              ? '______________'
              : this.students[i].name

            pdf.addImage(base64Image, 'png', 10, height, 40, 40)
            pdf.addImage(levumiImg, 'png', 60, height, 40, 40)
            pdf.text('Name: ' + studentName, 110, height + 10)
            pdf.text('Code: ' + this.students[i].login, 110, height + 30)
            pdf.line(0, height + 43, 210, height + 45)
            height = height + 46
            if (height >= 250) {
              height = 10
              pdf.addPage()
            }
          }
        }
        pdf.save(`QR-Codes ${this.group.label}.pdf`)
        this.isGeneratingQrCodes = false
      },
      blobToBase64(blob) {
        return new Promise(resolve => {
          const reader = new FileReader()
          reader.onloadend = () => resolve(reader.result)
          reader.readAsDataURL(blob)
        })
      },
    },
  }
</script>
<style></style>
