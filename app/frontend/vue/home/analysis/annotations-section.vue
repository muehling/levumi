<template>
  <div id="annotations-section">
    <b-collapse id="annotation_collapse" v-model="visible">
      <b-form
        v-if="!readOnly"
        class="border p-3"
        accept-charset="UTF-8"
        @submit="submitAnnotation()"
      >
        <div class="text-small row">
          <div class="col-12 col-md-3 col-lg-2">
            <label class="mt-1">Datumsbereich</label>
          </div>
          <div class="col-6 col-md-2">
            <b-form-select
              v-model="annotationStart"
              name="annotation[start]"
              :options="weekLabels(true)"
              size="sm"
            ></b-form-select>
          </div>
          <div class="col-6 col-md-2">
            <b-form-select
              v-model="annotationEnd"
              name="annotation[end]"
              :options="weekLabels(false)"
              size="sm"
            ></b-form-select>
          </div>
        </div>
        <div class="mt-3 text-small row">
          <div class="col-12 col-md-3 col-lg-2">
            <label class="mt-1">Anmerkungstyp</label>
          </div>
          <div class="col-12 col-md-4">
            <div class="d-flex flex-row">
              <b-dropdown v-model="annotationCategoryId" variant="outline-secondary">
                <template #button-content>
                  <span class="text-small">{{ getAnnotationLabel(annotationCategoryId) }}</span>
                </template>
                <b-dropdown-group
                  v-for="(categoryGroup, index) in groupedAnnotationOptions"
                  :key="index"
                >
                  <b-dropdown-item
                    v-for="option in categoryGroup"
                    :key="option.name"
                    class="text-small"
                    @click="annotationCategoryId = option.id"
                  >
                    {{ option.name }}
                  </b-dropdown-item>
                  <b-dropdown-divider />
                </b-dropdown-group>
              </b-dropdown>
              <span
                v-b-popover.hover="
                  'Fehlt ein Anmerkungstyp? Bitte wenden Sie sich an das Support-Team.'
                "
                style="font-size: 1rem"
                class="ml-2 mt-1"
                ><i class="fas fa-circle-question"></i
              ></span>
            </div>
          </div>
        </div>
        <div v-if="trendIsEnabled" class="mt-3 text-small row">
          <div class="col-12 col-md-3 col-lg-2">
            <label class="mt-1">Start neuer Trendlinie</label>
          </div>
          <div class="col-12 col-md-4">
            <div class="d-flex flex-row">
              <b-form-checkbox
                v-model="annotationIsTrendThreshold"
                :disabled="annotationStart !== annotationEnd"
                size="sm"
              ></b-form-checkbox>
              <span
                v-b-popover.hover="
                  'Umfasst eine Anmerkung nur ein einziges Datum, so können Trends für die Bereiche ' +
                  'vor und nach der Anmerkung erstellt werden.'
                "
                style="font-size: 1rem"
                class="ml-2 mt-1"
                ><i class="fas fa-circle-question"></i
              ></span>
            </div>
          </div>
        </div>
        <div class="mt-3">
          <b-button
            variant="outline-success"
            size="sm"
            :disabled="annotationEnd == null || annotationStart == null"
            @click="submitAnnotation"
          >
            <i class="fas fa-check"></i> Anmerkung speichern
          </b-button>
        </div>
      </b-form>
      <table class="table table-sm table-striped table-borderless mt-1 text-small">
        <thead>
          <tr>
            <th>Von</th>
            <th>Bis</th>
            <th>Anmerkung</th>
            <th v-if="trendIsEnabled">Trend-Bruchstelle</th>
            <th v-if="!readOnly">Aktionen</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="a in currentAnnotations" :key="a.id">
            <td>{{ printDate(a.start) }}</td>
            <td>{{ printDate(a.end) }}</td>
            <td>{{ getAnnotationLabel(a.annotation_category_id) }}</td>
            <td v-if="trendIsEnabled">
              <i :class="a.trend_threshold ? 'fas fa-check' : 'fas fa-xmark'"></i>
            </td>
            <td v-if="!readOnly" class="annotation-action-button">
              <b-button variant="outline-danger" class="btn-sm" @click="deleteAnnotation(a.id)">
                <i class="fas fa-trash"></i> Löschen
              </b-button>
            </td>
          </tr>
        </tbody>
      </table>
    </b-collapse>
    <confirm-dialog ref="confirmDialog" />
  </div>
</template>

<script>
  import { ajax } from '../../../utils/ajax'
  import { getAnnotationLabel, getAnnotationOptions } from '../../../utils/helpers'
  import apiRoutes from '../../routes/api-routes'
  import ConfirmDialog from '../../shared/confirm-dialog.vue'

  export default {
    name: 'AnnotationsSection',
    components: {
      ConfirmDialog,
    },
    inject: ['printDate', 'readOnly', 'studentName', 'weeks'],
    props: {
      annotations: Array,
      group: Object,
      selectedStudent: Object,
      selectedView: Number,
      test: Object,
      annotationControlVisible: Boolean,
      trendIsEnabled: Boolean,
    },
    data: function () {
      return {
        annotationEnd: null,
        annotationStart: null,
        annotationCategoryId: 1,
        annotationIsTrendThreshold: false,
      }
    },
    computed: {
      visible: {
        get() {
          return this.annotationControlVisible
        },
        set(value) {
          this.$emit('update:annotationControlVisible', value)
        },
      },
      currentAnnotations: function () {
        return this.annotations.filter(annotation => {
          return (
            annotation.view === this.selectedView &&
            ((this.selectedStudent && this.selectedStudent?.id == annotation.student_id) ||
              (!this.selectedStudent && annotation.group_id != null))
          )
        })
      },
      minCategoryId: function () {
        return getAnnotationOptions().reduce((acc, option) => Math.min(acc, option.id), Infinity)
      },

      groupedAnnotationOptions: function () {
        const allOptions = getAnnotationOptions()
        const maxGroupValue = allOptions.reduce((acc, option) => Math.max((acc, option.group)), 0)
        const groups = []
        for (let i = 1; i <= maxGroupValue; i++) {
          groups[i - 1] = allOptions.filter(option => option.group === i)
        }

        return groups
      },
    },
    mounted: function () {
      this.annotationCategoryId = this.minCategoryId
    },

    methods: {
      async deleteAnnotation(id) {
        const ok = await this.$refs.confirmDialog.open({
          title: 'Anmerkung löschen',
          message: `Die Anmerkung wird gelöscht. Dieser Vorgang kann nicht rückgängig gemacht werden.`,
          okText: 'Anmerkung löschen',
        })
        if (ok) {
          const res = await ajax(apiRoutes.annotations.delete(id))
          if (res.status === 200) {
            // two emits are necessary: the first to update the global annotations in group-view, the second to update the chart
            this.$root.$emit(`annotation-removed-${this.group.id}`, id)
            this.$emit('annotation-removed', id)
          }
        }
      },
      getAnnotationLabel(id) {
        return getAnnotationLabel(id)
      },
      getAnnotationOptions() {
        return getAnnotationOptions()
      },
      async submitAnnotation(e) {
        e.preventDefault()
        e.stopPropagation()
        const data = {
          annotation: {
            start: this.annotationStart,
            end: this.annotationEnd,
            annotation_category_id: this.annotationCategoryId,
            trend_threshold: this.annotationIsTrendThreshold,
            view: this.selectedView,
          },
        }

        if (this.selectedStudent) {
          data.annotation.student_id = this.selectedStudent?.id
        } else {
          data.annotation.group_id = this.group.id
        }

        const res = await ajax({
          ...apiRoutes.annotations.create(this.group.id, this.test.id),
          data,
        })

        if (res.status === 200) {
          const parsedResult = await res.json()
          this.$root.$emit(`annotation-added-${this.group.id}`, parsedResult)
          this.annotationIsTrendThreshold = false
          this.annotationCategoryId = this.minCategoryId
          this.annotationEnd = null
          this.annotationStart = null
        }
      },
      weekLabels(start) {
        const labels = this.weeks.map(week => ({ value: week, text: this.printDate(week) }))
        labels.unshift({ value: null, text: start ? 'Von...' : 'Bis...' })
        return labels
      },
    },
  }
</script>

<style>
  #annotations-section .annotation-action-button {
    width: 1%;
    white-space: nowrap;
  }
</style>
