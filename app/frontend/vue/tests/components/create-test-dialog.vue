<template>
  <div>
    <b-modal
      id="create-test-dialog"
      ref="testImportDialog"
      title="Test importieren"
      hide-footer
      @hidden="_clear">
      <div v-if="isLoading" class="card card-body align-items-center">
        <div v-if="isLoading" class="spinner">
          <div class="bounce1"></div>
          <div class="bounce2"></div>
          <div class="bounce3"></div>
        </div>
        Hochladen...
      </div>
      <div v-else-if="uploadStep === 1" class="card card-body">
        Test-Datei auswählen:
        <b-form-file
          v-model="file"
          class="mb-3"
          accept=".zip"
          :state="Boolean(file)"
          placeholder="Datei wählen oder hier ablegen..."
          drop-placeholder="Datei hier ablegen..."></b-form-file>
        <b-button class="mt-3" variant="outline-primary" @click="checkUploadVersion">
          <i class="fas fa-file-upload me-2"></i>
          Datei überprüfen
        </b-button>
      </div>
      <div v-else-if="uploadStep === 2" class="card card-body">
        <p><strong>Folgende Informationen wurden in der hochgeladenen Datei gefunden:</strong></p>

        <div class="row ps-3">
          <div class="col-4 p-0"><strong>Kurzbezeichnung:</strong></div>
          <div class="col-8">{{ testInfo.shorthand }}</div>
        </div>
        <div class="row ps-3">
          <div class="col-4 p-0"><strong>Lernbereich:</strong></div>
          <div class="col-8">{{ testInfo.area }}</div>
        </div>
        <div class="row ps-3">
          <div class="col-4 p-0"><strong>Testtyp:</strong></div>
          <div class="col-8">{{ testInfo.testType }}</div>
        </div>
        <div class="row ps-3">
          <div class="col-4 p-0"><strong>Kompetenz:</strong></div>
          <div class="col-8">{{ testInfo.competence }}</div>
        </div>
        <div class="row ps-3">
          <div class="col-4 p-0"><strong>Testfamilie:</strong></div>
          <div class="col-8">{{ testInfo.testFamily }}</div>
        </div>
        <div class="row ps-3">
          <div class="col-4 p-0"><strong>Level:</strong></div>
          <div class="col-8">{{ testInfo.level }}</div>
        </div>
        <div class="row ps-3">
          <div class="col-4 p-0"><strong>Version:</strong></div>
          <div class="col-8">{{ testInfo.version }}</div>
        </div>
        <div class="row ps-3">
          <div class="col-4 p-0"><strong>Verantwortlich:</strong></div>
          <div class="col-8">{{ testInfo.responsible }}</div>
        </div>
        <div class="row ps-3 pt-2">
          <div class="col p-0">
            <i>{{ versionHint }}</i>
          </div>
        </div>

        <b-form-checkbox v-if="testInfo.isNewVersion" v-model="keepMaterials">
          Existierendes Fördermaterial beibehalten
        </b-form-checkbox>
        <div class="d-flex justify-content-end">
          <b-button class="mt-3" variant="outline-danger" @click="_close">
            <i class="fas fa-cancel me-2"></i>
            Abbrechen
          </b-button>
          <b-button
            class="mt-3 ms-3"
            variant="outline-primary"
            :disabled="testInfo.isDisallowedVersion"
            @click="importTest">
            <i class="fas fa-file-upload me-2"></i>
            Test hochladen
          </b-button>
        </div>
      </div>
    </b-modal>
  </div>
</template>
<script>
  import { ajax } from '../../../utils/ajax'
  import apiRoutes from '../../routes/api-routes'
  import { useGlobalStore } from '../../../store/store'
  import JSZip from 'jszip'

  export default {
    name: 'CreateTestDialog',
    props: {
      users: Array,
    },
    setup() {
      const globalStore = useGlobalStore()
      return { globalStore }
    },
    data() {
      return {
        file: undefined,
        updateOnly: false,
        keepMaterials: false,
        isLoading: false,
        uploadStep: 1,
        testInfo: {},
      }
    },
    computed: {
      versionHint() {
        if (this.testInfo.isNewTest) {
          return 'Neuer Test'
        } else if (this.testInfo.isNewVersion) {
          return 'Neue Version, bestehender Test wird archiviert'
        } else {
          return 'Version vorhanden, bestehender Test wird aktualisiert'
        }
      },
    },
    methods: {
      open() {
        this.$refs.testImportDialog.show()
      },
      _close() {
        this.$refs.testImportDialog.hide()
      },
      _clear() {
        this.file = undefined
        this.keepMaterials = false
        this.isLoading = false
        this.uploadStep = 1
        this.testInfo = {}
      },

      async checkUploadVersion() {
        const zipContent = await JSZip.loadAsync(this.file)
        const testJson = zipContent.files['test.json']
        if (!testJson) {
          this.globalStore.setErrorMessage('test.json konnte nicht gefunden werden!')
          return
        }
        const content = await testJson.async('text')
        let contentObj
        try {
          contentObj = JSON.parse(content)
        } catch (e) {
          this.globalStore.setErrorMessage('test.json ist fehlerhaft: ' + e)
          return
        }

        // if (!contentObj.responsible) {
        //   this.globalStore.setErrorMessage('Keine Kontakt-Emailadresse in test.json enthalten!')
        //   return
        // }
        if (!contentObj.version || !contentObj.shorthand) {
          this.globalStore.setErrorMessage(
            'Version oder Kurzbezeichnung sind nicht in test.json enthalten!'
          )
          return
        }

        const res = await ajax({
          ...apiRoutes.tests.checkUploadVersion,
          data: { version: contentObj.version, shorthand: contentObj.shorthand },
        })

        this.isLoading = false
        switch (res.status) {
          case 200:
            break
          default:
            this.globalStore.setErrorMessage('Ein unbekannter Fehler ist aufgetreten!')
            return
        }
        if (res.data.is_disallowed_version) {
          this.globalStore.setErrorMessage(
            'Die hochzuladende Version ist älter die vorhandene Version!'
          )
          return
        }

        const data = res.data
        this.testInfo = {
          area: contentObj.area,
          testType: contentObj.test_type,
          competence: contentObj.competence,
          isNewVersion: data.is_new_version,
          isNewTest: data.is_new_test,
          level: contentObj.level,
          shorthand: contentObj.shorthand,
          testFamily: contentObj.family,
          version: contentObj.version,
          responsible: contentObj.responsible,
        }

        this.uploadStep = 2
      },
      async importTest() {
        const formData = new FormData()
        formData.append('test[file]', this.file)

        if (this.keepMaterials) {
          formData.append('update_material', true)
        }

        this.isLoading = true
        const res = await ajax({
          ...apiRoutes.tests.import,
          data: formData,
        })
        this.isLoading = false
        switch (res.status) {
          case 200:
            this.globalStore.setGenericMessage({
              title: 'Import erfolgreich',
              message: 'Der Test wurde erfolgreich importiert!',
            })
            this.$emit('test-import:success')
            this.globalStore.fetch()
            break
          case 406:
            this.globalStore.setErrorMessage('Beim Import ist ein Fehler aufgetreten!')
            break
          case 422:
            this.globalStore.setErrorMessage(res.data.message)
            break
          default:
            this.globalStore.setErrorMessage('Ein unbekannter Fehler ist aufgetreten!')
        }

        this._close()
      },
    },
  }
</script>
