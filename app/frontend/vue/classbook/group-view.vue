<template>
  <!-- Darstellung für reguläre Klasse: Buttons für Edit/Archive, Share, dann Schülertabelle  -->
  <div v-if="group.archive == false">
    <div v-if="!single" class="mb-1">
      <!-- Form zur Umbenennung -->
      <group-form
        v-if="group.owner"
        :group="group"
        @update:groups="updateGroup($event)"
      ></group-form>
    </div>
    <div v-if="!single" class="mb-2">
      <!-- Info/Form für Klassen teilen -->
      <share-form v-if="displayShareForm" :group="group" @update:groups="updateGroup($event)">
      </share-form>
    </div>
    <b-button
      v-if="canCreateQrCodes"
      variant="success"
      class="mb-1 btn-sm"
      :disabled="isGeneratingQrCodes"
      @click="exportQrCodes"
    >
      <i :class="isGeneratingQrCodes ? 'fas fa-spinner fa-spin' : 'fas fa-print'"></i> QR-Code PDF
    </b-button>
    <student-list v-if="group.key != null" :group-id="group.id" :read-only="read_only">
    </student-list>
  </div>

  <!-- Darstellung für archivierte Klasse -->
  <div v-else>
    <p class="text-small">
      <em>Ins Archiv verschoben am {{ date }}</em
      ><br />
      <span>Schüler:innen: {{ group.size }}</span>
    </p>
    <b-button class="mr-1" variant="outline-primary" @click="reactivateGroup">
      <i class="fas fa-file-import"></i> Klasse aus dem Archiv holen
    </b-button>
    <b-btn variant="outline-danger" @click="requestDeleteGroup">
      <i class="fas fa-trash"></i> Klasse löschen
    </b-btn>
    <confirm-dialog ref="confirmDialog" />
  </div>
</template>

<script>
  import { ajax } from '../../utils/ajax'
  import { isMasquerading } from '../../utils/user'
  import { useGlobalStore } from '../../store/store'
  import ConfirmDialog from '../shared/confirm-dialog.vue'
  import GroupForm from './group-form.vue'
  import jsPDF from 'jspdf'
  import QRCodeStyling from 'qr-code-styling'
  import ShareForm from './share-form.vue'
  import StudentList from './student-list.vue'

  export default {
    name: 'GroupView',
    components: {
      StudentList,
      GroupForm,
      ShareForm,
      ConfirmDialog,
    },
    props: {
      groups: Array, //Alle benötigt, um Klassen aus Archiv zu verschieben
      group: Object,
      single: Boolean,
    },
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
        //TODO restore once DDM is done
        //return this.group.owner || (!this.group.read_only && !this.group.is_anonymous)
        return true
      },
      date: function () {
        let date = new Date(this.group?.updated_at)
        return date.getDate() + '.' + (date.getMonth() + 1) + '.' + date.getFullYear()
      },
      read_only: function () {
        //Klassen nicht veränderbar, falls nur zur Ansicht geteilt, oder gerade ein Masquerading aktiv ist.
        return this.group.read_only || this.globalStore.masquerade
      },
      displayShareForm() {
        return !isMasquerading(this.globalStore.login) && this.group.id
      },
      students() {
        return this.globalStore.studentsInGroups[this.group.id] || []
      },
    },
    methods: {
      // Klasse aus dem Archiv holen
      async reactivateGroup() {
        const res = await ajax({
          url: '/groups/' + this.group.id + '?group[archive]=0',
          method: 'put',
        })
        const data = await res.json()
        if (data && res.status === 200) {
          this.updateGroup({
            object: data,
          })
        }
      },
      /*****************************
       * update group and propagate to parent component
       ******************************/
      updateGroup({ object }) {
        this.$set(this.group, object)
        //store.shareKeys[object.id] = object.key
        this.globalStore.setShareKey({ key: object.id, value: object.key })
        const groups = [...this.groups]
        const index = groups.findIndex(g => g.id === object.id)
        groups[index] = object
        this.$emit('update:groups', groups)
      },

      /*****************************
       * delete group and propagate to parent component
       ******************************/
      async requestDeleteGroup() {
        const ok = await this.$refs.confirmDialog.open({
          title: 'Klasse löschen',
          message: `Die Klasse wird mit allen Schüler:innen und allen Messergebnissen gelöscht! Sind Sie sicher?`,
          okText: 'Klasse löschen',
        })
        if (ok) {
          const res = await ajax({
            url: `/groups/${this.group.id}`,
            method: 'delete',
          })

          if (res.status === 200) {
            const remainingGroups = this.groups.filter(g => g.id !== this.group.id)
            this.$emit('update:groups', remainingGroups)
          }
        }
      },
      blobToBase64(blob) {
        return new Promise((resolve, _) => {
          const reader = new FileReader()
          reader.onloadend = () => resolve(reader.result)
          reader.readAsDataURL(blob)
        })
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
    },
  }
</script>
