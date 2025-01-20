<template>
  <div id="target-controls">
    <b-form v-if="!readOnly" class="border p-3" accept-charset="UTF-8">
      <div class="d-inline-flex">
        <p class="mb-3 me-3">Globale Einstellungen</p>
        <context-help
          help-text="Diese Einstellungen gelten sowohl für die ganze Klasse als auch für einzelne Schüler:innen." />
      </div>
      <div class="text-small row">
        <div class="col-12 col-md-3 col-xl-2">
          <label label-for="trend-input">Test-Durchschnitt anzeigen:</label>
        </div>
        <div class="col-12 col-md-4 col-xl-3 d-inline-flex">
          <b-form-checkbox
            id="trend-input"
            v-model="showTestAverage"
            size="sm"
            switch
            @change="saveAssessmentSettings" />
          <context-help
            help-text="Mit dieser Option wird der Durchschnittswert aller bisherigen Messungen dieses Tests eingeblendet. Der Durchschnitt wird als gepunktete Linie dargestellt, die Standardabweichung als grauer Bereich."
            class-name="mt-1 ms-3" />
        </div>
      </div>
      <div class="text-small row">
        <div class="col-12 col-md-3 col-xl-2">
          <label label-for="trend-input">Trend anzeigen:</label>
        </div>
        <div class="col-12 col-md-4 col-xl-3 d-inline-flex">
          <b-form-checkbox
            id="trend-input"
            v-model="showTrends"
            size="sm"
            switch
            @change="saveAssessmentSettings" />
          <context-help
            help-text="Mit dieser Option wird aus den bisherigen Messungen einer Schüler:in ein Trend bis 
            zum eingegebenen Enddatum generiert. Die Trendlinie wird nicht in der Klassenansicht dargestellt,
             sondern nur in den Individualgraphen."
            class-name="mt-1 ms-3" />
        </div>
      </div>
      <div class="text-small row mt-2">
        <div class="col-12 col-md-3 col-xl-2">
          <label>Verfügbarer Zeitraum:</label>
        </div>
        <div class="col-12 col-md-4 col-xl-3 d-inline-flex">
          <b-form-input
            id="available_target_input"
            v-model="dateUntil"
            trim
            :formatter="dateFormatter"
            type="date"
            :min="minDate"
            lang="de"
            size="sm" />
          <context-help
            help-text="Dieses Datum bestimmt, bis zu welchem Datum die Zeitachse des Diagramms erweitert wird. Zielwerte gelten für dieses Datum;
            Trendlinien werden bis zu diesem Datum extrapoliert."
            class-name="mt-1 ms-3" />
        </div>
      </div>
      <hr />
      <div class="d-inline-flex">
        <p class="mb-3 me-3">
          {{
            selectedStudentId === -1
              ? 'Klassen-Einstellungen '
              : `Spezifische Einstellungen für ${
                  group.students.find(student => student.id === selectedStudentId)?.name
                }`
          }}
        </p>
      </div>
      <div v-if="showClassTargetForStudent && selectedStudentId !== -1">
        <BAlert :model-value="true" class="p-2">
          <span class="text-small">
            Der angezeigte Zielwert ist auf Klassenebene festgelegt. Sie können für diese Schüler:in
            einen eigenen Zielwert festlegen.
          </span>
        </BAlert>
      </div>
      <div class="text-small row">
        <div class="col-12 col-md-3 col-xl-2">
          <label>Zielwert:</label>
        </div>
        <div class="col-12 col-md-4 col-xl-3 d-inline-flex">
          <b-form-input
            id="target_input"
            placeholder="Hier Zielwert eingeben"
            trim
            :model-value="target"
            :formatter="targetFormatter"
            type="number"
            inputmode="decimal"
            min="0"
            step="0.01"
            lang="de"
            @input="handleNumberInput"
            size="sm" />
          <context-help
            help-text="Der Zielwert wird als an-/absteigende Gerade, ausgehend vom ersten Messwert, dargestellt. In Verbindung mit einer extrapolierten Trendlinie lässt sich abschätzen, ob eine Schüler:in den vorgebenen Zielwert erreichen kann. "
            class-name="mt-1 ms-3" />
        </div>
      </div>

      <div class="text-small row mt-2 mb-2">
        <div class="col-12 col-md-3 col-xl-2">
          <label>Abweichungsbereich</label>
        </div>
        <div class="d-inline col-12 col-md-4 col-xl-3 d-inline-flex">
          <b-input-group size="sm" append="%">
            <b-form-input
              id="deviation_target_input"
              v-model="deviation"
              placeholder="Angabe in Prozent"
              trim
              :formatter="deviationFormatter"
              type="number"
              inputmode="numeric"
              min="0"
              max="99"
              step="1"
              lang="de"
              size="sm" />
          </b-input-group>
          <context-help
            help-text="Dieser Wert bestimmt, wie weit die Ergebnisse maximal vom vorgegebenen Zielwert abweichen sollten."
            class-name="mt-1 ms-3" />
        </div>
      </div>
      <div class="mt-3">
        <b-button variant="outline-success" size="sm" @click="changeStoredTarget(false)">
          <i class="fas fa-check"></i>
          Speichern
        </b-button>
        <b-button
          :disabled="!currentTarget"
          class="ms-2"
          variant="outline-danger"
          size="sm"
          @click="changeStoredTarget(true)">
          <i class="fas fa-x"></i>
          Löschen
        </b-button>
      </div>
    </b-form>

    <confirm-dialog ref="confirmDialog" />
  </div>
</template>

<script>
  import apiRoutes from '../../routes/api-routes'
  import { ajax } from '@/utils/ajax'
  import ConfirmDialog from '../../shared/confirm-dialog.vue'
  import { useGlobalStore } from 'src/store/store'
  import { useAssessmentsStore } from 'src/store/assessmentsStore'
  import ContextHelp from 'src/vue/shared/context-help.vue'

  export default {
    name: 'TargetControls',
    components: { ConfirmDialog, ContextHelp },
    props: {
      currentTarget: Object,
      targetVal: String,
      dateUntilVal: String,
      deviationVal: String,
      selectedStudentId: Number,
      targetControlVisible: Boolean,
      studentTargets: Array,
      loadStudentTargets: Function,
      viewConfig: Object,
      test: Object,
      group: Object,
      weeks: Array,
    },
    setup() {
      const globalStore = useGlobalStore()
      const assessmentsStore = useAssessmentsStore()

      return { globalStore, assessmentsStore }
    },
    data() {
      const target =
        this.selectedStudentId !== -1
          ? this.studentTargets.find(t => t.student_id === this.selectedStudentId)
          : this.studentTargets.find(t => t.student_id === null)

      return {
        target: target?.value,
        dateUntil: this.assessmentsStore.currentAssessment.settings?.date_until,
        deviation: target?.deviation,
        showTrends: this.assessmentsStore.currentAssessment.settings?.is_trend_enabled,
        showTestAverage: this.assessmentsStore.currentAssessment.settings?.is_test_average_enabled,
        showClassTargetForStudent: false,
      }
    },
    computed: {
      minDate() {
        return this.weeks[0]
      },
      readOnly() {
        return this.group.read_only
      },
    },
    watch: {
      currentTarget: {
        immediate: true,
        handler() {
          if (!this.currentTarget?.student_id) {
            this.showClassTargetForStudent = true
          } else {
            this.showClassTargetForStudent = false
          }
        },
      },
      selectedStudentId: {
        immediate: true,
        handler() {
          let target =
            this.selectedStudentId !== -1
              ? this.studentTargets.find(t => t.student_id === this.selectedStudentId)
              : this.studentTargets.find(t => t.student_id === null)
          if (!target) {
            target = this.studentTargets.find(t => t.student_id === null)
          }
          this.target = target?.value
          this.deviation = target?.deviation
        },
      },
    },
    methods: {
      handleNumberInput(e) {
        const val = parseFloat(e.target.value)
        if (!isNaN(val) && val >= 0) {
          this.target = val
        } else if (!isNaN(val)) {
          this.target = val * -1
        }
      },
      async saveAssessmentSettings() {
        const res = await ajax(
          apiRoutes.assessments.update(this.group.id, this.test.id, {
            assessment: {
              settings: {
                is_trend_enabled: this.showTrends,
                date_until: this.dateUntil,
                is_test_average_enabled: this.showTestAverage,
              },
            },
          })
        )
        if (res.status === 200) {
          this.assessmentsStore.setCurrentAssessment(res.data)
        }
      },

      /**
       * Returns a string of a number rounded to two digits, if a number can be constructed from the input.
       * If not, it returns an empty string.
       * @param value
       * @returns {string}
       */
      targetFormatter(value) {
        if (value === '') {
          return ''
        }
        const num = Number(value)
        if (!Number.isFinite(num)) {
          return ''
        }
        const twoDigitString = num.toFixed(2)
        return twoDigitString === '' ? '' : Number(twoDigitString).toString()
      },
      dateFormatter(val) {
        return val
      },

      deviationFormatter(value) {
        if (value === '') {
          return ''
        }
        return Math.max(Math.min(Math.round(value), 100), 0).toString()
      },

      async changeStoredTarget(deleteTarget) {
        let res
        if (deleteTarget) {
          res = await this.deleteStudentTarget()
        } else {
          await this.saveAssessmentSettings()
          res = await this.saveStudentTarget()
        }
        if (res?.status === 200) {
          this.globalStore.setGenericMessage({ message: 'Die Änderungen wurden gespeichert!' })
          await this.loadStudentTargets() // this function only loads the detail information for the current assessment
        }
      },

      async saveStudentTarget() {
        const sId = this.selectedStudentId === -1 ? null : this.selectedStudentId
        const data = {
          view: this.viewConfig.key,
          value: this.target,
          deviation: this.deviation,
        }
        if (!this.currentTarget) {
          if (sId !== -1) {
            data.student_id = sId
          }
          return ajax(
            apiRoutes.targets.createStudentTarget(this.group.id, this.test.id, {
              target: data,
            })
          )
        } else if (this.currentTarget) {
          return ajax(
            apiRoutes.targets.updateStudentTarget(
              this.group.id,
              this.test.id,
              this.currentTarget?.id,
              {
                target: data,
              }
            )
          )
        }
        this.saveAssessmentSettings()
      },
      async deleteStudentTarget() {
        const ok = await this.$refs.confirmDialog.open({
          title: 'Ziel löschen',
          message: `Die Zielwerte werden gelöscht. Dieser Vorgang kann nicht rückgängig gemacht werden.`,
          okText: 'Ziel löschen',
        })
        if (ok) {
          return ajax(
            apiRoutes.targets.deleteStudentTarget(
              this.group.id,
              this.test.id,
              this.currentTarget?.id
            )
          )
        } else {
          return null
        }
      },
    },
  }
</script>
