<template>
  <div id="target-controls">
    <b-collapse v-if="targetIsEnabled || dateUntilIsEnabled" id="target_collapse" v-model="visible">
      <b-form
          v-if="!readOnly || readonlySuppressed"
          class="border p-3"
          accept-charset="UTF-8"
          onsubmit="return false"
      >
        <b-alert :show="selectedStudentId !== -1 && storedIsNull" variant="info" class="d-inline-block">
          Hinweis: Die gezeigten Werte wurden aus der Klassenansicht übernommen. Wenn Sie hier andere Werte eintragen und speichern, so gelten sie ausschließlich für diese Schüler*in.
        </b-alert>
        <div v-if="targetIsEnabled" class="text-small row">
          <div class="col-12 col-md-3 col-xl-2">
            <label>Zielwert:</label>
          </div>
          <div class="col-12 col-md-4 col-xl-3">
            <b-form-input
              id="target_input"
              placeholder="Hier Zielwert eingeben"
              :value="targetVal"
              trim
              :formatter="targetFormatter"
              type="number"
              inputmode="decimal"
              min="0"
              step="0.01"
              lang="de"
              size="sm"
              @update="setTarget($event, dateUntilVal, deviationVal, true)"
            ></b-form-input>
          </div>
        </div>
        <div v-if="dateUntilIsEnabled" class="text-small row mt-2">
          <div class="col-12 col-md-3 col-xl-2">
            <label>Verfügbarer Zeitraum:</label>
          </div>
          <div class="col-12 col-md-4 col-xl-3">
            <b-form-input
              id="available_target_input"
              :value="dateUntilVal"
              placeholder="Bis wann soll das Ziel erreicht worden sein?"
              trim
              :formatter="dateFormatter"
              type="date"
              lang="de"
              size="sm"
              @update="setTarget(targetVal, $event, deviationVal, true)"
            ></b-form-input>
          </div>
        </div>
        <div v-if="deviationIsEnabled && targetIsEnabled" class="text-small row mt-2 mb-2">
          <div class="col-12 col-md-3 col-xl-2">
            <label>Erlaubte Abweichung:</label>
          </div>
          <div class="d-inline col-12 col-md-4 col-xl-3">
            <b-input-group size="sm" append="%">
              <b-form-input
                id="deviation_target_input"
                :value="deviationVal"
                placeholder="Angabe in Prozent"
                trim
                :formatter="deviationFormatter"
                type="number"
                inputmode="numeric"
                min="0"
                max="100"
                step="1"
                lang="de"
                size="sm"
                @update="setTarget(targetVal, dateUntilVal, $event, true)"
              ></b-form-input>
            </b-input-group>
          </div>
        </div>
        <div class="mt-3">
          <b-button
            variant="outline-success"
            size="sm"
            :disabled="!targetOrTimeValid"
            @click="changeStoredTarget(false)"
          >
            <i class="fas fa-check"></i> Wert{{ multipleValues ? 'e' : '' }} speichern
          </b-button>
          <!-- the click doesn't always need to trigger a request; when the stored target is null anyway then we can skip it -->
          <b-button
            :hidden="!(targetVal || dateUntilVal || deviationVal) && storedIsNull"
            class="ml-2"
            variant="outline-danger"
            size="sm"
            @click="storedIsNull ? restoreTarget() : changeStoredTarget(true)"
          >
            <i class="fas fa-check"></i> Wert{{ multipleValues ? 'e' : '' }} löschen
          </b-button>
          <b-button
            :hidden="
              (targetVal === targetValStored &&
                dateUntilVal === dateUntilStored &&
                deviationVal === deviationStored) ||
              storedIsNull
            "
            class="ml-2"
            variant="outline-warning"
            size="sm"
            @click="restoreTarget"
          >
            <i class="fas fa-check"></i> Wert{{ multipleValues ? 'e' : '' }} zurücksetzen
          </b-button>
        </div>
      </b-form>
    </b-collapse>
    <confirm-dialog ref="confirmDialog" />
  </div>
</template>

<script>
  import apiRoutes from '../../routes/api-routes'
  import { ajax } from '@/utils/ajax'
  import ConfirmDialog from '../../shared/confirm-dialog.vue'

  export default {
    name: 'TargetControls',
    components: { ConfirmDialog },
    inject: [
      'readOnly',
      'restoreTarget',
      'viewConfig',
      'setTarget',
      'targetStored',
      'loadStudentTargets',
    ],
    props: {
      targetIsEnabled: Boolean,
      dateUntilIsEnabled: Boolean,
      deviationIsEnabled: Boolean,
      targetVal: String,
      dateUntilVal: String,
      deviationVal: String,
      targetValStored: String,
      dateUntilStored: String,
      deviationStored: String,
      selectedStudentId: Number,
      targetControlVisible: Boolean,
      studentTargets: Array,
      targetValid: Boolean,
      test: Object,
      group: Object,
      readonlySuppressed: Boolean,
    },
    computed: {
      multipleValues() {
        return (this.dateUntilIsEnabled || this.deviationIsEnabled) && this.targetIsEnabled
      },
      storedIsNull() {
        return (
          this.dateUntilStored == null &&
          this.targetValStored == null &&
          this.deviationStored == null
        )
      },
      targetOrTimeValid() {
        return this.targetValid || this.dateUntilVal
      },
      targetId() {
        return this.targetStored?.id
      },
      visible: {
        get() {
          return this.targetControlVisible
        },
        set(value) {
          this.$emit('update:targetControlVisible', value)
        },
      },
    },
    methods: {
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
        //return printDate(val) // breaks the input, unfortunately
        return val
      },
      /**
       * Returns a string of an integer created by rounding a number constructed from the input.
       * This rounded number is clamped to the range [0,100].
       * If the input is empty it returns this empty input instead.
       * @param value
       * @returns {string}
       */
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
          res = await this.saveStudentTarget()
        }
        if (res?.status === 200) {
          await this.loadStudentTargets() // this function only loads the detail information for the current assessment
        }
      },
      async saveStudentTarget() {
        const sId = this.selectedStudentId === -1 ? null : this.selectedStudentId
        if (this.targetStored === null) {
          return ajax(
            apiRoutes.targets.createStudentTarget(this.group.id, this.test.id, {
              target: {
                view: this.viewConfig.key,
                value: this.targetVal,
                date_until: this.dateUntilVal,
                deviation: this.deviationVal,
                student_id: sId,
              },
            })
          )
        } else if (this.targetStored) {
          return ajax(
            apiRoutes.targets.updateStudentTarget(this.group.id, this.test.id, this.targetId, {
              target: {
                view: this.viewConfig.key,
                value: this.targetVal,
                date_until: this.dateUntilVal,
                deviation: this.deviationVal,
                student_id: sId,
              },
            })
          )
        }
      },
      async deleteStudentTarget() {
        const ok = await this.$refs.confirmDialog.open({
          title: 'Ziel löschen',
          message: `Die Zielwerte werden gelöscht. Dieser Vorgang kann nicht rückgängig gemacht werden.`,
          okText: 'Ziel löschen',
        })
        if (ok) {
          return ajax(
            apiRoutes.targets.deleteStudentTarget(this.group.id, this.test.id, this.targetId)
          )
        } else {
          return null
        }
      },
    },
  }
</script>
