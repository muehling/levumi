<template>
  <div>
    <b-modal id="edit-user-dialog" ref="editDialog" hide-footer>
      <template #modal-title> Einstellungen </template>
      <div class="user-settings">
        <b-card>
          <b class="mb-2 d-inline-block">Grafische Auswertung</b>
          <b-form-checkbox v-model="targets.enabled" name="targets-enabled" switch>
            Ziele verwenden
          </b-form-checkbox>
          <b-form-checkbox v-model="trends.enabled" name="trends-enabled" switch>
            Trendlinien verwenden
          </b-form-checkbox>
        </b-card>
        <div class="d-flex justify-content-end">
          <b-button variant="outline-secondary" class="m-1" @click="_close">Schließen</b-button>
          <b-button variant="outline-success" class="m-1" @click="handleSubmit">Speichern</b-button>
        </div>
      </div>
    </b-modal>
    <info-dialog ref="infoDialog" />
  </div>
</template>
<script>
  import { ajax } from '../../../utils/ajax'
  import apiRoutes from '../../routes/api-routes'
  import InfoDialog from '../../shared/info-dialog.vue'
  export default {
    name: 'UserSettingsDialog',
    components: { InfoDialog },
    data() {
      return {
        targets: { enabled: false },
        trends: { enabled: false },
        user: undefined,
      }
    },
    methods: {
      open(data = {}) {
        this.$refs.editDialog.show()
        this.targets.enabled = data.user.settings?.targetsEnabled
        this.trends.enabled = data.user.settings?.trendsEnabled
        this.user = data.user
      },
      async handleSubmit() {
        const data = {
          user: {
            settings: JSON.stringify({
              targets: { enabled: this.targets.enabled },
              trends: { enabled: this.trends.enabled },
            }),
          },
        }
        const res = await ajax({
          ...apiRoutes.users.update(this.user.id),
          data: data,
        })
        if (res.status === 200) {
          this.$emit('refetch', res)
          this.$refs.infoDialog.open({
            message: !this.isNew
              ? 'Ihre Daten wurden erfolgreich geändert!'
              : 'Account wurde erfolgreich angelegt!',
            title: 'Speichern erfolgreich',
            okText: 'Schließen',
          })
          this._close()
        } else {
          const error = await res.json()
          this.errors = error.errors
        }
      },
      /* handleSuccess(res) {
        this.$emit('refetch', res)
        this.$refs.infoDialog.open({
          message: 'Ihre Einstellungen wurden erfolgreich geändert!',
          title: 'Speichern erfolgreich',
          okText: 'Schließen',
        })
        this._close()
      },*/
      cancelEdit() {
        this._close()
      },
      _close() {
        this.$refs.editDialog.hide()
        this.user = {}
      },
    },
  }
</script>
