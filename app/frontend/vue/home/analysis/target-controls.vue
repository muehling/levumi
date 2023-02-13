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
              @click="saveTarget(false)"
          >
            <i class="fas fa-check"></i> Wert{{multipleValues ? 'e' : ''}} speichern
          </b-button>
          <!-- the click doesn't always need to trigger a request; when the stored target is null anyway then we can skip it -->
          <b-button
              :hidden="!(targetVal || dateUntilVal || deviationVal) && storedIsNull"
              class="ml-2"
              variant="outline-danger"
              size="sm"
              @click="storedIsNull ? restoreTarget() : saveTarget(true)"
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
  inject: ['autoScroll', 'readOnly', 'restoreTarget', 'currentView', 'setTarget', 'targetStoredRaw', 'groupTargetsStored', 'loadStudentTargets', 'fetchAssessments'],
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
      console.log(this.targetStoredRaw)
      return this.targetStoredRaw?.id
    },
  },
  methods: {
    async saveTarget(deleteTarget) {
      let res
      if (this.studentSelected === -1) {
        // group targets are saved in the assessment table which we don't delete rows from
        // therefore only update/overwrite the value even when deleting
        res = await this.saveGroupTarget(deleteTarget)
      }
      else {
        if (deleteTarget) {
          res = await this.deleteStudentTarget()
        } else {
          res = await this.saveStudentTarget()
        }
      }
      if (res.status === 200) {
        if (this.studentSelected === -1) {
          this.fetchAssessments()   // only has to be fetched when class targets are changed, as only they are included in the assessmentsStore
          if (deleteTarget) {
            this.setTarget(null, null, null, true)
          }
        } else {
          await this.loadStudentTargets()   // this function instead only loads the detail information for the current assessment
        }
      }
    },
    async saveGroupTarget(deleteTarget) {
      return ajax(
          apiRoutes.targets.saveGroupTarget(this.group.id, this.test.id, {
            assessment: {
              // we need to pass all unchanged targets (filter) plus the changed one (after ,)
              target: [...this.groupTargetsStored.filter((t) => t.view !== this.currentView.key),
                deleteTarget ?
                    {
                      view: this.currentView.key,
                      value: null, date_until: null,
                      deviation: null
                    }
                    :
                    {
                      view: this.currentView.key,
                      value: this.targetVal,
                      date_until: this.dateUntilVal,
                      deviation: this.deviationVal
                    }
              ]
            }
          })
      )
    },
    async saveStudentTarget() {
      if (this.targetStoredRaw === undefined) {
        return ajax (
            apiRoutes.targets.createStudentTarget(this.group.id, this.test.id, {
              target: {
                view: this.currentView.key,
                value: this.targetVal,
                date_until: this.dateUntilVal,
                deviation: this.deviationVal,
                student_id: this.studentSelected
              },
            })
        )
      } else {
        return ajax(
            apiRoutes.targets.updateStudentTarget(this.group.id, this.test.id, this.targetId, {
              target: {
                view: this.currentView.key,
                value: this.targetVal,
                date_until: this.dateUntilVal,
                deviation: this.deviationVal,
                student_id: this.studentSelected
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