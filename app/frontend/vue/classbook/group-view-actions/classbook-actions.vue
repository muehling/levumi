<template>
  <div class="group-actions">
    <div v-if="permissions?.updateGroup">
      <group-form :group="group" @update:groups="updateGroup($event)" />
    </div>
    <hr />
    <div v-if="permissions?.setGroupFontSettings" class="row">
      <div class="col-3">
        <b-button
          variant="outline-secondary"
          class="my-2 d-inline"
          size="sm"
          @click="openFontsModal">
          <i class="fas fa-font"></i>
          Schrifteinstellungen
        </b-button>
        <context-help
          help-text="Hier können Sie die in den Tests verwendete Schriftart einstellen.
      Diese kann auch in der Liste individuell pro Schüler:in eingestellt werden. Individuelle Einstellungen haben Vorrang vor den Klasseneinstellungen."
          class-name="mt-2 ml-2" />
      </div>
      <div class="col-9 d-flex align-items-center">
        <span>Aktuelle Standard-Einstellung: {{ fontSettingsText }}</span>
      </div>
    </div>
    <hr />
    <div v-if="permissions.setGroupFontSettings" class="row">
      <div class="col-3 d-flex align-items-center">
        <b-button
          variant="outline-secondary"
          class="my-2 d-inline"
          size="sm"
          @click="toggleCalcSettings">
          <i class="fas fa-calculator"></i>
          Zahleneingabe
        </b-button>
        <context-help
          help-text="Hier können Sie das in Mathematik-Tests verwendete Layout des Eingabeelementes festlegen. Sie können zwischen dem Nummernblock-Layout und dem Telefonlayout wählen. Diese Einstellung gilt für die gesamte Klasse."
          class-name=" ml-2" />
      </div>
      <div v-if="!isCalcSettingsOpen" class="col-auto d-flex align-items-center">
        <div class="mr-3">
          <span>Aktuelle Standard-Einstellung: {{ calcSettings?.text }}</span>
        </div>
      </div>
      <div v-else class="mt-2 col-auto d-flex align-items-center">
        <b-form-radio-group
          v-slot="{ ariaDescribedby }"
          v-model="selectedCalcLayout"
          class="d-inline">
          <b-form-radio
            v-model="selectedCalcLayout"
            :aria-describedby="ariaDescribedby"
            name="calc-select-radios"
            value="numpad">
            Nummernblock
          </b-form-radio>
          <b-form-radio
            v-model="selectedCalcLayout"
            :aria-describedby="ariaDescribedby"
            name="calc-select-radios"
            value="phone">
            Telefontastatur
          </b-form-radio>
          <b-button
            variant="outline-success"
            class="my-2 d-inline"
            size="sm"
            :disabled="isCalcLayoutSaveDisabled"
            @click="saveSettings">
            <i class="fas fa-check"></i>
            Speichern
          </b-button>
        </b-form-radio-group>
      </div>
      <div :key="selectedCalcLayout" class="col pl-3 mx-3 calc-preview">
        <div class="row flex-nowrap">
          <div class="col border text-center text-small">
            {{ selectedCalcLayout === 'phone' ? '1' : '7' }}
          </div>
          <div class="col border text-center text-small">
            {{ selectedCalcLayout === 'phone' ? '2' : '8' }}
          </div>
          <div class="col border text-center text-small">
            {{ selectedCalcLayout === 'phone' ? '3' : '9' }}
          </div>
        </div>
        <div class="row flex-nowrap">
          <div class="col border text-center text-small">
            {{ selectedCalcLayout === 'phone' ? '4' : '4' }}
          </div>
          <div class="col border text-center text-small">
            {{ selectedCalcLayout === 'phone' ? '5' : '5' }}
          </div>
          <div class="col border text-center text-small">
            {{ selectedCalcLayout === 'phone' ? '6' : '6' }}
          </div>
        </div>
        <div class="row flex-nowrap">
          <div class="col border text-center text-small">
            {{ selectedCalcLayout === 'phone' ? '7' : '1' }}
          </div>
          <div class="col border text-center text-small">
            {{ selectedCalcLayout === 'phone' ? '8' : '2' }}
          </div>
          <div class="col border text-center text-small">
            {{ selectedCalcLayout === 'phone' ? '9' : '3' }}
          </div>
        </div>
        <div class="row flex-nowrap">
          <div class="col-4 border text-small text-center">0</div>
          <div class="col-8 border text-small text-center">Löschen</div>
        </div>
      </div>
    </div>
    <div v-if="permissions?.createQRCodes" class="d-inline">
      <hr />
      <b-button
        variant="success"
        class="my-2 d-inline"
        size="sm"
        :disabled="isGeneratingQrCodes"
        @click="exportQrCodes">
        <i :class="isGeneratingQrCodes ? 'fas fa-spinner fa-spin' : 'fas fa-print'"></i>
        QR-Code PDF erstellen
      </b-button>
      <context-help
        help-text="Mit dieser Aktion wird ein PDF mit QR-Codes zum Einloggen in die Testoberfläche erstellt. Die QR-Codes können ausgedruckt und an die Schüler:innen ausgeteilt werden."
        class-name="mt-2 ml-2" />
    </div>
    <div v-if="permissions?.archiveGroup" class="d-inline">
      <hr />
      <b-button class="my-2 d-inline" size="sm" variant="outline-secondary" @click="moveToArchive">
        <i class="fas fa-file-export"></i>
        Klasse in Archiv verschieben
      </b-button>
      <context-help
        help-text="Mit dieser Aktion wird die Klasse archiviert. Ist die Klasse mit anderen Personen geteilt, wird das Teilen automatisch beendet. Wird die Klasse wieder aus dem Archiv geholt, muss sie ggf. erneut mit den Personen geteilt werden."
        class-name="mt-2 ml-2" />
    </div>
    <confirm-dialog ref="confirmDialog" />
    <font-settings-modal
      v-if="isFontsModalOpen"
      :student-or-group="group"
      path="group"
      @hide-fonts-modal="closeFontsModal"
      @update="updateGroup" />
  </div>
</template>
<script>
  import { access } from 'src/utils/access'
  import { ajax } from 'src/utils/ajax'
  import { defaultCalcLayout } from 'src/utils/constants'
  import { getFontSettingsDescription, getCalcSettingsDescription } from 'src/utils/helpers'
  import { useGlobalStore } from 'src/store/store'
  import apiRoutes from 'src/vue/routes/api-routes'
  import ConfirmDialog from 'src/vue/shared/confirm-dialog.vue'
  import ContextHelp from 'src/vue/shared/context-help.vue'
  import FontSettingsModal from 'src/vue/classbook/modals/font-settings-modal.vue'
  import GroupForm from './group-form.vue'
  import jsPDF from 'jspdf'
  import QRCodeStyling from 'qr-code-styling'
  import Vue from 'vue'

  export default {
    name: 'ClassbookActions',
    components: { ContextHelp, ConfirmDialog, GroupForm, FontSettingsModal },
    props: { group: Object },
    setup() {
      const globalStore = useGlobalStore()
      return { globalStore }
    },
    data() {
      return {
        isGeneratingQrCodes: false,
        isFontsModalOpen: false,
        isCalcSettingsOpen: false,
        selectedCalcLayout: this.group.settings?.calculator_layout || defaultCalcLayout,
      }
    },
    computed: {
      isCalcLayoutSaveDisabled() {
        return this.group.settings.calculator_layout === this.selectedCalcLayout
      },
      permissions() {
        return access(this.group).classbook
      },
      students() {
        return this.globalStore.studentsInGroups[this.group.id] || []
      },
      fontSettingsText() {
        return getFontSettingsDescription(this.group.settings, this.group.settings)
      },
      calcSettings() {
        return getCalcSettingsDescription(this.group.settings, this.group.settings)
      },
    },

    methods: {
      updateGroup(data) {
        this.globalStore.setGroups(data.groups)
      },
      toggleCalcSettings() {
        this.isCalcSettingsOpen = !this.isCalcSettingsOpen
      },

      openFontsModal() {
        this.isFontsModalOpen = true
      },
      closeFontsModal() {
        this.isFontsModalOpen = false
      },
      async saveSettings() {
        const settings = { calculator_layout: this.selectedCalcLayout }
        const res = await ajax({
          ...apiRoutes.groups.update(this.group.id),
          data: { group: { settings } },
        })
        if (res.status === 200) {
          this.toggleCalcSettings()
          Vue.set(this.globalStore, 'groups', res.data.groups)
          Vue.set(this.globalStore, 'shareKeys', res.data.share_keys)
        }
      },
      async moveToArchive() {
        const answer = await this.$refs.confirmDialog.open({
          message: `Mit dieser Aktion wird diese Klasse ins Archiv verschoben. Sie kann jederzeit reaktiviert werden, erteilte Freigaben müssen dann jedoch ggf. erneut erteilt werden.`,
          cancelText: 'Abbrechen',
          okIntent: 'danger',
          title: 'Klasse archivieren',
        })
        if (!answer) {
          return
        }
        const res = await ajax({
          url: '/groups/' + this.group.id + '?group[archive]=1',
          method: 'put',
        })
        const data = res.data
        if (data && res.status === 200) {
          Vue.set(this.globalStore, 'groups', res.data.groups)
          Vue.set(this.globalStore, 'shareKeys', res.data.share_keys)
          this.$router.push('/klassenbuch/eigene_klassen')
          this.$emit('group-archived')
        }
      },
      async exportQrCodes() {
        this.isGeneratingQrCodes = true
        const pdf = new jsPDF()
        let height = 10

        for (let i = 0; i < this.group.students.length; i++) {
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
        pdf.save(`QR-Codes_${this.group.label.split(' ').join('_')}.pdf`)
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
<style>
  .calc-preview {
    max-width: 9em !important;
    border: 1px solid lightgray;
    animation: blink 1s ease-in-out 1;
  }

  @keyframes blink {
    0% {
      border-color: lightgray;
    }
    50% {
      border-color: red;
    }
    100% {
      border-color: lightgray;
    }
  }
</style>
