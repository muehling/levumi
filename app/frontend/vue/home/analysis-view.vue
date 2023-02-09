<template>
  <div>
    <b-row>
      <b-button-group class="ml-3" size="sm">
        <b-button
          class="mr-2"
          size="sm"
          variant="outline-primary"
          :pressed="studentSelected === -1"
          :disabled="!has_group_views"
          @click="
            selectedView = 0
            updateView(-1)
          "
          >Ganze Klasse</b-button
        >
        <b-dropdown
          right
          :text="studentsWithResults.find(s => s.id === studentSelected)?.name || 'Individualgraph'"
          :variant="studentSelected !== -1 ? 'primary' : 'outline-primary'"
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
      <div :id="'chart_' + group.id + '_' + test.id" style="min-width: 100%"></div>
    </b-row>
    <b-row :hidden="!graph_visible">
      <b-col>
        <div class="ml-2">
          <annotations-section
            :annotations="annotations"
            :group="group"
            :test="test"
            :selected-student="selectedStudent"
            :selected-view="selectedView"
          />
        </div>
      </b-col>
      <b-col>
        <b-button
          class="float-right mr-4"
          size="sm"
          variant="outline-primary"
          @click="export_graph"
        >
          <i class="fas fa-file-pdf"></i>
          PDF erzeugen
        </b-button>
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
  import ApexCharts from 'apexcharts'
  import autoTable from 'jspdf-autotable'
  import deepmerge from 'deepmerge'
  import jsPDF from 'jspdf'
  import {
    apexChartOptions,
    annotationsLineOptions,
    annotationsPointOptions,
  } from './apexChartHelpers'
  import { decryptStudentName } from '../../utils/encryption'
  import { printDate } from '../../utils/date'

  export default {
    name: 'AnalysisView',
    components: { AnnotationsSection },
    inject: ['autoScroll', 'readOnly', 'studentName', 'weeks', 'student_name_parts'],
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
        apexchart: null,
        default_options: apexChartOptions(this.weeks),
        studentSelected: -1,
        selectedView: 0,
        simpleTableData: undefined,
      }
    },
    computed: {
      viewsWithGroupAndStudent() {
        return this.configuration.views.filter(
          view =>
            (this.studentSelected === -1 && view.group) ||
            (this.studentSelected !== -1 && view.student)
        )
      },
      columns() {
        return this.configuration.views[this.selectedView].columns || []
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
              this.results[r].student_id === this.studentSelected &&
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
        return this.studentSelected !== -1
          ? this.students.find(student => student.id === this.studentSelected)
          : null
      },
    },
    watch: {
      annotations() {
        this.updateView(this.studentSelected)
      },
    },
    mounted() {
      this.studentSelected = this.has_group_views
        ? -1
        : this.studentsWithResults[this.studentsWithResults.length - 1]?.id || -1
        ? this.studentsWithResults[0]?.id || -1
        : -1
      this.updateView(this.studentSelected)
    },
    methods: {
      setSelectedView(index) {
        this.view_selected = index
        this.updateView(this.studentSelected)
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
        const uri = await this.apexchart.dataURI()
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
        if (this.studentSelected == -1) {
          title = `Ganze Klasse - ${view.label}`
          filename = `${this.group.label}_${this.test.shorthand}_${this.test.level}_Klassenansicht`
        } else {
          title = `${this.getStudentById(this.studentSelected).name} - ${view.label}`
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
        this.studentSelected = studentId
        if (this.configuration.views[this.selectedView].type === 'table') {
          return
        }
        const view = this.configuration.views[this.selectedView]

        let opt =
          view.options.chart.type === 'bar' ? this.default_options.bar : this.default_options.line

        opt = deepmerge(opt, view.options)

        //Default für y-Achse: 10% Luft nach oben
        if (opt.yaxis === undefined) {
          opt.yaxis = {}
        }
        if (opt.yaxis.max === undefined) {
          opt.yaxis.max = function (max) {
            return 1.1 * max
          }
        }

        let graphData

        // create graph data
        if (this.studentSelected == -1) {
          graphData = this.studentsWithResults.map(student => {
            return { name: student.name, data: this.createSeries(student.id) }
          })
        } else {
          const student = this.students.find(s => s.id === this.studentSelected)
          if (!view.series_keys) {
            graphData = [{ name: student.name, data: this.createSeries(student.id) }]
          } else {
            graphData = view.series_keys.map((series_key, index) => {
              return { name: view.series[index], data: this.createSeries(student.id, series_key) }
            })
          }
        }

        this.simpleTableData = graphData.map(lineData => {
          const data = lineData.data.reduce((acc, d) => {
            acc[d.x] = d.y || '-'
            return acc
          }, {})
          return {
            name: lineData.name,
            ...data,
          }
        })

        //Kommentare einfügen
        opt['annotations'] = {
          position: 'front',
          xaxis: [],
          points: [],
        }

        const applicableAnnotations = this.annotations.filter(
          annotation =>
            annotation.view === this.selectedView &&
            (annotation.student_id === this.studentSelected ||
              (this.studentSelected === -1 && annotation.group_id !== null))
        )

        opt.annotations.points = applicableAnnotations.map(annotation => {
          if (annotation.start !== annotation.end && view.options.chart.type === 'line') {
            //Fall 1: Bereichsanmerkung (nur für Liniengraphen)
            return annotationsLineOptions(annotation, this.weeks)
          }
          //Fall 2: Wochenanmerkungen, umgesetzt als Punktanmerkung
          else {
            const dataForAnnotation = graphData[0].data.find(
              d => d.x === printDate(annotation.start)
            )
            return annotationsPointOptions(view, annotation, dataForAnnotation.y, annotation.start)
          }
        })

        if (this.apexchart != null) {
          this.apexchart.destroy()
        }

        opt.chart.id = '#chart_' + this.group.id + '_' + this.test.id
        const options = { ...opt, series: graphData }

        this.apexchart = new ApexCharts(document.querySelector(opt.chart.id), options)
        this.apexchart.render()
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
