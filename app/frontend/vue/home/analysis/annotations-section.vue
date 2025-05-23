<template>
  <div id="annotations-section">
    <div v-if="!readOnly" class="border p-3" accept-charset="UTF-8">
      <p>
        <strong>{{ titleDisplay }}</strong>
      </p>
      <div class="text-small row">
        <div class="col-12 col-md-3 col-lg-2">
          <label class="mt-1">Datumsbereich</label>
        </div>

        <div class="col-6 col-md-2">
          <b-form-select
            v-model="annotationStart"
            name="annotation[start]"
            :options="startLabels"
            size="sm" />
        </div>
        <div class="col-6 col-md-2">
          <b-form-select
            v-model="annotationEnd"
            name="annotation[end]"
            :options="endLabels"
            size="sm" />
        </div>
      </div>

      <div class="mt-3 text-small row">
        <div class="col-12 col-md-3 col-lg-2">
          <label class="mt-1">Anmerkungstyp</label>
        </div>
        <div class="col-12 col-md-4">
          <div class="d-flex flex-row">
            <b-dropdown
              v-model="showAnnotationCategories"
              :text="getAnnotationLabel(annotationCategoryId)"
              variant="outline-secondary">
              <b-dropdown-group
                v-for="(categoryGroup, index) in groupedAnnotationOptions"
                :key="index">
                <b-dropdown-item
                  v-for="option in categoryGroup"
                  :key="option.name"
                  class="text-small"
                  @click="annotationCategoryId = option.id">
                  {{ option.name }}
                </b-dropdown-item>
                <b-dropdown-divider />
              </b-dropdown-group>
            </b-dropdown>
          </div>
        </div>
      </div>
      <div class="mt-3">
        <b-button
          variant="outline-success"
          size="sm"
          :disabled="!datesValid"
          @click="submitAnnotation">
          <i class="fas fa-check"></i>
          Anmerkung speichern
        </b-button>
      </div>
    </div>
    <table class="table table-sm table-striped table-borderless mt-1 text-small">
      <thead>
        <tr>
          <th>Anmerkung für:</th>
          <th>Von</th>
          <th>Bis</th>
          <th>Anmerkung</th>
          <th v-if="!readOnly">Aktionen</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="a in currentAnnotations" :key="a.id">
          <td>{{ getStudentName(a.student_id) }}</td>
          <td>{{ formatDate(a.start) }}</td>
          <td>{{ formatDate(a.end) }}</td>
          <td>{{ getAnnotationLabel(a.annotation_category_id) }}</td>
          <td v-if="!readOnly" class="annotation-action-button">
            <b-button variant="outline-danger" class="btn-sm" @click="deleteAnnotation(a.id)">
              <i class="fas fa-trash"></i>
              Löschen
            </b-button>
          </td>
        </tr>
      </tbody>
    </table>

    <confirm-dialog ref="confirmDialog" />
  </div>
</template>

<script>
  import { ajax } from 'src/utils/ajax'
  import { getAnnotationLabel, getAnnotationOptions } from 'src/utils/helpers'
  import { printDate } from 'src/utils/date'
  import { useAssessmentsStore } from 'src/store/assessmentsStore'
  import apiRoutes from 'src/vue/routes/api-routes'
  import ConfirmDialog from 'src/vue/shared/confirm-dialog.vue'
  import isAfter from 'date-fns/isAfter'
  import isBefore from 'date-fns/isBefore'
  import isEqual from 'date-fns/isEqual'

  export default {
    name: 'AnnotationsSection',
    components: {
      ConfirmDialog,
    },

    props: {
      group: Object,
      selectedStudent: Object,
      selectedViewKey: String,
      test: Object,
      annotationControlVisible: Boolean,
      weeks: Array,
    },
    setup() {
      const assessmentsStore = useAssessmentsStore()
      return { assessmentsStore }
    },
    data: function () {
      return {
        annotationEnd: null,
        annotationStart: null,
        annotationCategoryId: 1,
        showAnnotationCategories: false,
      }
    },
    computed: {
      datesValid() {
        return (
          !!this.annotationStart &&
          !!this.annotationEnd &&
          (isBefore(new Date(this.annotationStart), new Date(this.annotationEnd)) ||
            isEqual(new Date(this.annotationStart), new Date(this.annotationEnd)))
        )
      },
      titleDisplay() {
        if (this.selectedStudent) {
          return `Anmerkungen für ${this.selectedStudent.name}`
        } else {
          return 'Anmerkungen für die ganze Klasse'
        }
      },
      startLabels() {
        let labels = this.weeks.map(week => ({ value: week, text: printDate(week) }))
        if (this.annotationEnd) {
          const end = new Date(this.annotationEnd)
          labels = labels.filter(label => {
            const start = new Date(label.value)
            return isBefore(start, end) || isEqual(start, end)
          })
        }
        labels.unshift({ value: null, text: 'Von...' })
        return labels
      },
      endLabels() {
        let labels = this.weeks.map(week => ({ value: week, text: printDate(week) }))
        if (this.annotationStart) {
          const end = new Date(this.annotationStart)
          labels = labels.filter(label => {
            const start = new Date(label.value)
            return isAfter(start, end) || isEqual(start, end)
          })
        }
        labels.unshift({ value: null, text: 'Bis...' })
        return labels
      },
      readOnly() {
        return false
      },
      currentAssessment() {
        {
          return this.assessmentsStore.currentAssessment
        }
      },
      annotations() {
        return this.currentAssessment.annotations
      },
      currentAnnotations() {
        if (!this.selectedStudent) {
          return this.currentAssessment.annotations
        }
        return this.currentAssessment.annotations.filter(annotation => {
          return (
            annotation.view === this.selectedViewKey &&
            ((this.selectedStudent && this.selectedStudent?.id == annotation.student_id) ||
              annotation.group_id != null)
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
      getStudentName(id) {
        if (!id) {
          return 'Ganze Klasse'
        }
        return this.group.students.find(student => student.id === id)?.name
      },
      formatDate(date) {
        return printDate(date)
      },
      async deleteAnnotation(id) {
        const ok = await this.$refs.confirmDialog.open({
          title: 'Anmerkung löschen',
          message: `Die Anmerkung wird gelöscht. Dieser Vorgang kann nicht rückgängig gemacht werden.`,
          okText: 'Anmerkung löschen',
        })
        if (ok) {
          const res = await ajax(apiRoutes.annotations.delete(id))
          if (res.status === 200) {
            const assessment = { ...this.assessmentsStore.currentAssessment }
            assessment.annotations = this.assessmentsStore.currentAssessment.annotations.filter(
              a => a.id !== id
            )
            this.assessmentsStore.currentAssessment = assessment
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
            view: this.selectedViewKey,
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
          const annotations = this.assessmentsStore.currentAssessment.annotations
          annotations.push(res.data)
          const assessment = { ...this.assessmentsStore.currentAssessment }
          assessment.annotations = annotations.sort((a, b) => (a.end > b.end ? -1 : 1))
          this.assessmentsStore.currentAssessment = assessment
          this.annotationCategoryId = this.minCategoryId
          this.annotationEnd = null
          this.annotationStart = null
        }
      },
    },
  }
</script>
