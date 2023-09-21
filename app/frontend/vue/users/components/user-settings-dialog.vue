<template>
  <div>
    <b-modal id="edit-user-dialog" ref="editDialog" hide-footer>
      <template #modal-title> Einstellungen </template>
      <div class="user-settings">
        <b-card>
          <b class="mb-2 d-inline-block">Grafische Auswertung</b>
          <b-form-checkbox v-model="targets.enabled" name="targets-enabled" switch>
            Ziele verwenden
            <span
              v-b-popover.hover="
                `Ziele werden als gestrichelte Linien im Diagramm dargestellt und lassen sich im Abschnitt 'Ziele und Trends' einstellen. Sie können sowohl auf Klassen- als auch auf individueller Ebene vergeben werden.`
              "
              style="font-size: 1rem"
              class="mt-1 ml-2"
            >
              <i class="fas fa-circle-question"></i>
            </span>
          </b-form-checkbox>
          <b-form-checkbox v-model="trends.enabled" name="trends-enabled" switch>
            Trendlinien verwenden
            <span
              v-b-popover.hover="
                `Trendlinien dienen zur besseren Visualisierung des Lernverlaufs. Sie stehen nur für die Individualgraphen der Schüler:innen zur Verfügung.`
              "
              style="font-size: 1rem"
              class="mt-1 ml-2"
            >
              <i class="fas fa-circle-question"></i>
            </span>
          </b-form-checkbox>
          <b-button
            v-b-toggle.extended-graph-settings
            class="mt-2"
            variant="outline-primary"
            :disabled="!targets.enabled && !trends.enabled"
            @click="extendedGraphSettingsVisible = !extendedGraphSettingsVisible"
          >
            Erweiterte Einstellungen
            <i
              :class="`when-closed fas ${
                extendedGraphSettingsVisible ? 'fa-caret-down' : 'fa-caret-up'
              }`"
            ></i>
          </b-button>
          <b-collapse id="extended-graph-settings" class="mt-2">
            <b-card>
              <b :class="targets.enabled ? '' : 'text-muted'">Ziele</b>
              <b-form-checkbox
                v-model="targets.deviation"
                :disabled="!targets.enabled"
                name="deviations-enabled"
                switch
              >
                Abweichungen anzeigen
                <span
                  v-b-popover.hover="
                    `Abweichungen werden als Bereich unterhalb der gestrichelten Ziel-Linie dargestellt. Sie visualisieren den Bereich, in dem ein Ergebnis, dass das vorgegebene Ziel nicht erreicht hat, noch akzeptable ist.`
                  "
                  style="font-size: 1rem"
                  class="mt-1 ml-2"
                >
                  <i class="fas fa-circle-question"></i>
                </span>
              </b-form-checkbox>
              <b-form-checkbox
                v-model="targets.slope"
                :disabled="!targets.enabled"
                name="sloped-targetes"
                switch
              >
                An-/Absteigende Ziele
                <span
                  v-b-popover.hover="
                    `Ist diese Option aktiviert, wird die Ziellinie als Gerade, ausgehend vom Durchschnitt der ersten Messpunkte, hin zum Zielwert dargestellt.`
                  "
                  style="font-size: 1rem"
                  class="mt-1 ml-2"
                >
                  <i class="fas fa-circle-question"></i>
                </span>
              </b-form-checkbox>
              <hr class="mt-1 mb-2" />
              <b :class="trends.extrapolate ? '' : 'text-muted'">Trendlinien</b>
              <b-form-checkbox
                v-model="trends.extrapolate"
                :disabled="!trends.enabled"
                name="extrapolation-enabled"
                switch
              >
                Trendlinien extrapolieren
                <span
                  v-b-popover.hover="
                    `Mit dieser Option kann die Trendlinie bis zum Ende des eingestellten verfügbaren Zeitraums verlängert werden.`
                  "
                  style="font-size: 1rem"
                  class="mt-1 ml-2"
                >
                  <i class="fas fa-circle-question"></i>
                </span>
              </b-form-checkbox>
            </b-card>
          </b-collapse>
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
        targets: { enabled: false, deviation: true, slope: true },
        trends: { enabled: false, extrapolate: true },
        user: undefined,

        extendedGraphSettingsVisible: false,
      }
    },
    methods: {
      open(data = {}) {
        this.$refs.editDialog.show()
        this.targets = data.user.settings?.targets || this.targets
        this.trends = data.user.settings?.trends || this.trends
        this.user = data.user
      },
      async handleSubmit() {
        const data = {
          user: {
            settings: JSON.stringify({
              ...this.user.settings,
              targets: {
                enabled: this.targets.enabled,
                deviation: this.targets.deviation,
                slope: this.targets.slope,
              },
              trends: { enabled: this.trends.enabled, extrapolate: this.trends.extrapolate },
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
