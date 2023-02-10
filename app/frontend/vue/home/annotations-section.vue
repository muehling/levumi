<template>
  <div>
    <b-button
      id="comment_btn"
      v-b-toggle="'annotation_collapse'"
      size="sm"
      variant="outline-secondary"
    >
      Anmerkungen
      <i class="when-closed fas fa-caret-down"></i>
      <i class="when-opened fas fa-caret-up"></i>
    </b-button>
    <b-collapse id="annotation_collapse" @shown="autoScroll('#annotation_collapse')">
      <b-form v-if="!readOnly" class="mt-2" accept-charset="UTF-8" @submit="submitAnnotation()">
        <b-form-row class="text-small">
          <b-col>
            <label>Datumsbereich</label>
          </b-col>
          <b-col>
            <b-form-select
              v-model="annotationStart"
              name="annotation[start]"
              :options="weekLabels(true)"
              size="sm"
            ></b-form-select>
          </b-col>
          <b-col>
            <b-form-select
              v-model="annotationEnd"
              name="annotation[end]"
              :options="weekLabels(false)"
              size="sm"
            ></b-form-select>
          </b-col>
        </b-form-row>
        <b-form-row class="mt-1">
          <b-col>
            <b-form-select
              v-model="annotationCategoryId"
              name="annotation[end]"
              :options="getAnnotationOptions()"
              size="sm"
            ></b-form-select>
          </b-col>
        </b-form-row>
        <b-form-row class="mt-1">
          <b-col>
            <b-button
              variant="outline-success"
              size="sm"
              :disabled="annotationEnd == null || annotationStart == null"
              @click="submitAnnotation"
            >
              <i class="fas fa-check"></i> Anmerkung speichern
            </b-button>
          </b-col>
        </b-form-row>
      </b-form>
      <table class="table table-sm table-striped table-borderless mt-1 text-small">
        <thead>
          <tr>
            <th>Von</th>
            <th>Bis</th>
            <th>Anmerkung</th>
            <th v-if="!readOnly">Aktionen</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="a in currentAnnotations" :key="a.id">
            <td>{{ printDate(a.start) }}</td>
            <td>{{ printDate(a.end) }}</td>
            <td>{{ getAnnotationLabel(a.annotation_category_id) }}</td>
            <td v-if="!readOnly">
              <!-- rails-ujs Link -->
              <a class="btn btn-block btn-sm btn-outline-danger" @click="deleteAnnotation(a.id)">
                <i class="fas fa-trash"></i> Löschen
              </a>
            </td>
          </tr>
        </tbody>
      </table>
    </b-collapse>
    <confirm-dialog ref="confirmDialog" />
  </div>
</template>

<script>
  import { ajax } from '../../utils/ajax'
  import { getAnnotationLabel, getAnnotationOptions } from '../../utils/helpers'
  import apiRoutes from '../routes/api-routes'
  import ConfirmDialog from '../shared/confirm-dialog.vue'

  export default {
    name: 'AnnotationsSection',
    components: {
      ConfirmDialog,
    },
    inject: ['autoScroll', 'printDate', 'readOnly', 'studentName', 'weeks'],
    props: {
      annotations: Array,
      group: Object,
      selectedStudent: Object,
      selectedView: Number,
      test: Object,
    },
    data: function () {
      return {
        annotationEnd: null,
        annotationStart: null,
        annotationCategoryId: null,
        // currentAnnotations: this.annotations,
      }
    },
    computed: {
      currentAnnotations: function () {
        return this.annotations.filter(annotation => {
          return (
            annotation.view === this.selectedView &&
            ((this.selectedStudent && this.selectedStudent?.id == annotation.student_id) ||
              (!this.selectedStudent && annotation.group_id != null))
          )
        })
      },
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
            //TODO emit something to update the annotations
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
          this.annotationCategoryId = null
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
