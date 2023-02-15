<template>
  <b-collapse id="target_collapse" v-if="targetIsEnabled" v-model="targetControlVisible" @shown="autoScroll('#target_collapse')">
    <b-form
        v-if="!readOnly"
        class="mt-2"
        onsubmit="return false"
    >
      <b-form-row class="text-small">
        <b-col class="d-flex">
          <label class="mr-3">Zielwert:</label>
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
        </b-col>
      </b-form-row>
      <b-form-row v-if="dateUntilIsEnabled" class="text-small mt-1">
        <b-col class="d-flex">
          <label class="mr-3">Verfügbarer Zeitraum:</label>
          <b-form-input
              id="available_target_input"
              :value="dateUntilVal"
              placeholder="Bis wann soll das Ziel erreicht worden sein?"
              trim
              type="date"
              lang="de"
              size="sm"
              @update="setTarget(targetVal, $event, deviationVal, true)"
          ></b-form-input>
        </b-col>
      </b-form-row>
      <b-form-row v-if="deviationIsEnabled" class="text-small mt-1 mb-2">
        <b-col class="d-flex">
          <label class="mr-3">Erlaubte Abweichung:</label>
          <div class="d-inline">
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
        </b-col>
      </b-form-row>
      <b-form-row class="mt-1">
        <b-col>
          <b-button
              variant="outline-success"
              size="sm"
              :disabled="!targetOrTimeValid"
              @click="changeStoredTarget(false)"
          >
            <i class="fas fa-check"></i> Wert{{multipleValues ? 'e' : ''}} speichern
          </b-button>
          <!-- the click doesn't always need to trigger a request; when the stored target is null anyway then we can skip it -->
          <b-button
              :hidden="!(targetVal || dateUntilVal || deviationVal) && storedIsNull"
              class="ml-2"
              variant="outline-danger"
              size="sm"
              @click="storedIsNull ? restoreTarget() : changeStoredTarget(true)"
          >
            <i class="fas fa-check"></i> Wert{{multipleValues ? 'e' : ''}} löschen
          </b-button>
          <b-button
              :hidden="(targetVal === targetValStored && dateUntilVal === dateUntilStored && deviationVal === deviationStored) || storedIsNull"
              class="ml-2"
              variant="outline-warning"
              size="sm"
              @click="restoreTarget"
          >
            <i class="fas fa-check"></i> Wert{{multipleValues ? 'e' : ''}} zurücksetzen
          </b-button>
        </b-col>
      </b-form-row>
    </b-form>
  </b-collapse>
</template>

<script>

import apiRoutes from "../../routes/api-routes";
import {ajax} from "@/utils/ajax";

export default {
  name: "TargetControls",
  inject: ['autoScroll', 'readOnly', 'restoreTarget', 'currentView', 'setTarget', 'targetStored', 'loadStudentTargets'],
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
    studentSelected: Number,
    targetControlVisible: Boolean,
    studentTargets: Array,
    test: Object,
    group: Object,
  },
  data: function() {
    return {
      targetValLocal: this.deviationVal,
      dateUntilValLocal: this.dateUntilVal,
      deviationValLocal: this.deviationVal,
    }
  },
  computed: {
    multipleValues() {
      return this.dateUntilIsEnabled || this.deviationIsEnabled
    },
    storedIsNull() {
      return this.dateUntilStored == null && this.targetValStored == null && this.deviationStored == null
    },
    targetOrTimeValid() {
      return this.targetValid || this.dateUntilVal
    },
    targetId() {
      return this.targetStored?.id
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
      if (value === '')
        return ''
      const num = Number(value)
      if (!Number.isFinite(num))
        return ''
      const twoDigitString = num.toFixed(2)
      return twoDigitString === '' ? '' : Number(twoDigitString).toString()
    },
    /**
     * Returns a string of an integer created by rounding a number constructed from the input.
     * This rounded number is clamped to the range [0,100].
     * If the input is empty it returns this empty input instead.
     * @param value
     * @returns {string}
     */
    deviationFormatter(value) {
      if (value === '')
        return ''
      return Math.max(Math.min(Math.round(value), 100), 0).toString()
    },
    async changeStoredTarget(deleteTarget) {
      let res
      if (deleteTarget) {
        res = await this.deleteStudentTarget()
      } else {
        res = await this.saveStudentTarget()
      }
      if (res.status === 200) {
          await this.loadStudentTargets()   // this function only loads the detail information for the current assessment
      }
    },
    async saveStudentTarget() {
      const sId = this.studentSelected === -1 ? null : this.studentSelected
      if (this.targetStored === null) {
        return ajax (
            apiRoutes.targets.createStudentTarget(this.group.id, this.test.id, {
              target: {
                view: this.currentView.key,
                value: this.targetVal,
                date_until: this.dateUntilVal,
                deviation: this.deviationVal,
                student_id: sId
              },
            })
        )
      } else if (this.targetStored) {
        return ajax(
            apiRoutes.targets.updateStudentTarget(this.group.id, this.test.id, this.targetId, {
              target: {
                view: this.currentView.key,
                value: this.targetVal,
                date_until: this.dateUntilVal,
                deviation: this.deviationVal,
                student_id: sId
              },
            })
        )
      }
    },
    async deleteStudentTarget() {
      return ajax(apiRoutes.targets.deleteStudentTarget(this.group.id, this.test.id, this.targetId))
    },
  },
}
</script>