<template>
  <div>
    <b-row>
      <b-button-group class="ml-3" size="sm">
        <b-button
          class="mr-2"
          size="sm"
          variant="outline-primary"
          :pressed="selectedStudentId === -1"
          :disabled="!has_group_views"
          @click="
            selectedView = 0
            updateView(-1)
          "
          >Ganze Klasse</b-button
        >
        <b-dropdown
          right
          :text="
            studentsWithResults.find(s => s.id === selectedStudentId)?.name || 'Individualgraph'
          "
          :variant="selectedStudentId !== -1 ? 'primary' : 'outline-primary'"
          :disabled="!has_student_views"
          size="sm"
        >
          <b-dropdown-item
            v-for="s in studentsWithResults"
            :key="s.id"
            class="text-small"
            @click="updateView(s.id)"
          >
            {{ s.name }}
          </b-dropdown-item>
        </b-dropdown>
      </b-button-group>
    </b-row>
    <b-row class="mt-2">
      <b-button-group class="ml-3">
        <b-button
          v-for="(view, index) in viewsWithGroupAndStudent"
          :key="index"
          class="mr-2 shadow-none"
          size="sm"
          variant="outline-secondary"
          :pressed="selectedView === index"
          @click="setSelectedView(index)"
        >
          {{ view.label }}
        </b-button>
      </b-button-group>
    </b-row>
    <b-row :hidden="!graph_visible">
      <b-col>
        <apexchart ref="levumiChart" type="bar" :options="chartOptions" :series="chartSeries" />
      </b-col>
    </b-row>
    <b-row :hidden="!graph_visible">
      <b-col>
        <div class="ml-2">
          <b-button class="mr-4 mb-3" size="sm" variant="outline-primary" @click="export_graph">
            <i class="fas fa-file-pdf"></i>
            PDF erzeugen
          </b-button>
          <annotations-section
            :annotations="annotations"
            :group="group"
            :test="test"
            :selected-student="selectedStudent"
            :selected-view="selectedView"
            @annotation-removed="removeAnnotation"
          />
        </div>
      </b-col>
    </b-row>
    <b-row :hidden="!table_visible">
      <div id="table" class="m-4" style="width: 100%">
        <table class="table table-sm table-striped table-borderless mt-1 text-small">
          <thead>
            <tr>
              <th>Woche ab dem</th>
              <th v-for="col in columns" :key="col">{{ col }}</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="entry in table_data" :key="entry.week">
              <td>{{ printDate(entry.week) }}</td>
              <td v-for="col in columns" :key="col"><span v-html="entry[col]"></span></td>
            </tr>
          </tbody>
        </table>
      </div>
    </b-row>
    <b-row :hidden="selectedViewType !== 'graph'">
      <b-table-lite
        id="simple-table"
        class="mt-4 text-small"
        small
        striped
        hover
        :items="simpleTableData"
      ></b-table-lite>
    </b-row>
  </div>
</template>

<script>
  import AnnotationsSection from './annotations-section.vue'
  import autoTable from 'jspdf-autotable'
  import deepmerge from 'deepmerge'
  import jsPDF from 'jspdf'
  import {
    apexChartOptions,
    annotationsLineOptions,
    annotationsPointOptions,
    prepareOptions,
  } from './apexChartHelpers'
  import { decryptStudentName } from '../../utils/encryption'
  import { printDate } from '../../utils/date'

  export default {
    name: 'AnalysisView',
    components: { AnnotationsSection },
    inject: ['autoScroll', 'printDate', 'readOnly', 'studentName', 'weeks', 'student_name_parts'],
    props: {
      annotations: Array,
      configuration: Object,
      group: Object,
      results: Array,
      students: Array,
      test: Object,
    },
    data: function () {
      return {
        default_options: apexChartOptions(this.weeks),
        selectedStudentId: -1,
        selectedView: 0,
        simpleTableData: undefined,
        chartOptions: {},
        graphData: [],
        isChartInitialized: false,
      }
    },
    computed: {
      viewsWithGroupAndStudent() {
        return this.configuration.views.filter(
          view =>
            (this.selectedStudentId === -1 && view.group) ||
            (this.selectedStudentId !== -1 && view.student)
        )
      },
      columns() {
        return this.configuration.views[this.selectedView].columns || []
      },
      currentView() {
        return this.configuration.views[this.selectedView]
      },
      selectedViewType() {
        return this.configuration.views[this.selectedView].type
      },
      graph_visible() {
        return (
          this.configuration.views[this.selectedView].type === 'graph' ||
          this.configuration.views[this.selectedView].type === 'graph_table'
        )
      },
      has_group_views() {
        for (let i = 0; i < this.configuration.views.length; ++i) {
          if (this.configuration.views[i].group == true) {
            return true
          }
        }
        return false
      },
      has_student_views() {
        for (let i = 0; i < this.configuration.views.length; ++i) {
          if (this.configuration.views[i].student == true) {
            return true
          }
        }
        return false
      },
      table_visible() {
        return (
          this.configuration.views[this.selectedView].type === 'table' ||
          this.configuration.views[this.selectedView].type === 'graph_table'
        )
      },
      table_data() {
        if (this.configuration.views[this.selectedView].type === 'graph') {
          return []
        }
        let weeks = this.weeks.slice().reverse()
        let res = []
        for (let w = 0; w < weeks.length; ++w) {
          let found = false
          for (let r = 0; r < this.results.length; ++r) {
            if (
              this.results[r].student_id === this.selectedStudentId &&
              this.results[r].test_week === weeks[w]
            ) {
              let temp = {}
              for (
                let i = 0;
                i < this.configuration.views[this.selectedView].column_keys.length;
                ++i
              ) {
                let key = this.configuration.views[this.selectedView].column_keys[i]
                let name = this.configuration.views[this.selectedView].columns[i]
                temp[name] =
                  this.results[r].views[this.configuration.views[this.selectedView].key][key]
                if (temp[name] === undefined) {
                  temp[name] = '-'
                }
              }
              res.push(deepmerge({ week: weeks[w] }, temp))
              found = true
              break
            }
          }
          if (!found) {
            let temp = {}
            for (let c = 0; c < this.columns.length; ++c) {
              temp[this.columns[c]] = '-'
            }
            res.push(deepmerge({ week: weeks[w] }, temp))
          }
        }
        return res
      },
      studentsWithResults() {
        return this.students.filter(student => this.has_results(student))
      },
      selectedStudent() {
        return this.selectedStudentId !== -1
          ? this.students.find(student => student.id === this.selectedStudentId)
          : null
      },
      chartSeries() {
        return [...this.graphData]
      },
    },
    watch: {
      annotations() {
        this.updateAnnotations()
      },
    },
    mounted() {
      this.selectedStudentId = this.has_group_views
        ? -1
        : this.studentsWithResults[this.studentsWithResults.length - 1]?.id || -1
        ? this.studentsWithResults[0]?.id || -1
        : -1
      this.updateView(this.selectedStudentId)
    },
    methods: {
      setSelectedView(index) {
        this.selectedView = index
        this.updateView(this.selectedStudentId)
      },
      getStudentName(id) {
        return this.students.find(student => student.id === id)?.name
      },
      decode_text(text) {
        const id = this.group.id
        return text.replace(/\{"iv[^}]*\}/g, function (match) {
          return decryptStudentName(match, '{Name}', id)
        })
      },

      async createPdf(title, filename) {
        const pdf = new jsPDF({ orientation: 'landscape' })
        pdf.text(this.test.full_name, 10, 10)
        pdf.text(title, 10, 20)
        const uri = await this.$refs.levumiChart.dataURI()
        pdf.addImage(
          uri['imgURI'],
          'PNG',
          10,
          40,
          pdf.internal.pageSize.getWidth() - 15,
          pdf.internal.pageSize.getHeight() - 120
        )
        pdf.addPage()
        autoTable(pdf, { html: '#simple-table' })

        pdf.save(filename + '.pdf')
      },

      async export_graph() {
        let title
        let filename
        let view = this.configuration.views[this.selectedView]
        if (this.selectedStudentId == -1) {
          title = `Ganze Klasse - ${view.label}`
          filename = `${this.group.label}_${this.test.shorthand}_${this.test.level}_Klassenansicht`
        } else {
          title = `${this.getStudentName(this.selectedStudentId)} - ${view.label}`
          filename = `${this.group.label}_${this.test.shorthand}_${this.test.level}_Kindansicht`
        }
        await this.createPdf(title, filename)
      },

      createSeries(studentId, seriesKey) {
        const results = this.results.filter(result => result.student_id === studentId)
        const view = this.configuration.views[this.selectedView]
        return this.weeks.map(week => {
          const currentResult = results.find(r => r?.test_week === week)

          let yVal
          if (seriesKey) {
            yVal = currentResult?.views[view.key][seriesKey]?.toFixed(2) || null
          } else {
            yVal = currentResult?.views[view.key]?.toFixed(2) || null
          }
          return {
            x: printDate(week),
            y: yVal,
          }
        })
      },
      updateView(studentId) {
        this.selectedStudentId = studentId
        if (this.configuration.views[this.selectedView].type === 'table') {
          return
        }
        const view = this.configuration.views[this.selectedView]

        this.chartOptions = prepareOptions(view.options.chart.type, view.options, this.weeks)

        // group data
        if (this.selectedStudentId == -1) {
          this.graphData = this.studentsWithResults.map(student => {
            return { name: student.name, data: this.createSeries(student.id) }
          })
        } else {
          const student = this.students.find(s => s.id === this.selectedStudentId)
          // individual student data with single series
          if (!view.series_keys) {
            this.graphData = [{ name: student.name, data: this.createSeries(student.id) }]
          } else {
            // individual student data with multiple series
            this.graphData = view.series_keys.map((series_key, index) => {
              return { name: view.series[index], data: this.createSeries(student.id, series_key) }
            })
          }
        }

        // this is the input for <b-table-lite> component, which is shown below the graph
        this.simpleTableData = this.graphData.map(lineData => {
          const data = lineData.data.reduce((acc, d) => {
            acc[d.x] = d.y || '-'
            return acc
          }, {})
          return {
            name: lineData.name,
            ...data,
          }
        })
        this.updateAnnotations()
      },

      updateAnnotations() {
        //Kommentare einfügen

        const studentId = this.selectedStudentId !== -1 ? this.selectedStudentId : null

        // get annotations that need to be drawn in the current chart
        const applicableAnnotations = this.annotations.filter(
          annotation => annotation.view === this.selectedView && annotation.student_id === studentId
        )

        const xaxis = applicableAnnotations
          .filter(
            annotation =>
              annotation.start !== annotation.end ||
              (studentId === null && annotation.start === annotation.end)
          )
          .map(annotation => annotationsLineOptions(annotation, this.weeks))

        const points = applicableAnnotations
          .filter(annotation => annotation.start === annotation.end && studentId !== null)
          .map(annotation => {
            const dataForAnnotation = this.graphData[0].data.find(
              d => d.x === printDate(annotation.start)
            )
            return annotationsPointOptions(
              this.currentView,
              annotation,
              dataForAnnotation.y,
              annotation.start
            )
          })

        // somehow, this.$refs.levumiChart.clearAnnotations() will only clear either point or xaxis-annotations, thus the loop
        this.annotations.forEach(annotation =>
          this.$refs.levumiChart.removeAnnotation('a' + annotation.id)
        )
        xaxis.forEach(annotation => this.$refs.levumiChart.addXaxisAnnotation(annotation))
        points.forEach(annotation => this.$refs.levumiChart.addPointAnnotation(annotation))
      },
      removeAnnotation(id) {
        this.$refs.levumiChart.removeAnnotation('a' + id)
      },

      has_results(student) {
        for (let i = 0; i < this.results.length; ++i) {
          if (this.results[i].student_id == student.id) {
            return true
          }
        }
        return false
      },
    },
  }
</script>

<style scoped>
  /* Darstellung des Collapse durch CSS toggeln*/
  .collapsed > .when-opened,
  :not(.collapsed) > .when-closed {
    display: none;
  }
</style>
