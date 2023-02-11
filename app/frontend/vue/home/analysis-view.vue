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
            setSelectedView(0)
            set_student(-1)
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
            @click="set_student(s.id)"
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
          :pressed="view_selected === index"
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
          <b-button
            id="comment_btn"
            :class="annotation_visible ? null : 'collapsed'"
            :aria-expanded="annotation_visible ? 'true' : 'false'"
            aria-controls="annotation_collapse"
            @click="toggleActiveCollapse('annotation_collapse')"
            size="sm"
            variant="outline-secondary"
          >
            Anmerkungen
            <i class="when-closed fas fa-caret-down"></i>
            <i class="when-opened fas fa-caret-up"></i>
          </b-button>
          <b-button
              class="ml-2"
              v-if="targetIsEnabled"
              id="target_btn"
              :class="targetControlVisible ? null : 'collapsed'"
              :aria-expanded="targetControlVisible ? 'true' : 'false'"
              aria-controls="target_collapse"
              @click="toggleActiveCollapse('target_collapse')"
              size="sm"
              variant="outline-secondary"
          >
            Ziel
            <i class="when-closed fas fa-caret-down"></i>
            <i class="when-opened fas fa-caret-up"></i>
          </b-button>
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
                    v-model="targetVal"
                    placeholder="Hier Zielwert eingeben"
                    trim
                    type="number"
                    inputmode="decimal"
                    min="0"
                    step="0.01"
                    lang="de"
                    size="sm"
                    @update="redrawTarget"
                  ></b-form-input>
                </b-col>
              </b-form-row>
              <b-form-row v-if="dateUntilIsEnabled" class="text-small mt-1">
                <b-col class="d-flex">
                  <label class="mr-3">Verfügbarer Zeitraum:</label>
                  <b-form-input
                      id="available_target_input"
                      v-model="dateUntilVal"
                      placeholder="Bis wann soll das Ziel erreicht worden sein?"
                      trim
                      type="date"
                      lang="de"
                      size="sm"
                      @update="redrawTarget"
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
                          v-model="deviationVal"
                          placeholder="Angabe in Prozent"
                          trim
                          type="number"
                          inputmode="numeric"
                          min="0"
                          max="100"
                          step="1"
                          lang="de"
                          size="sm"
                          @update="redrawTarget"
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
                    <i class="fas fa-check"></i> Wert{{dateUntilIsEnabled ? 'e' : ''}} speichern
                  </b-button>
                  <!-- the click doesn't always need to trigger a request; when the stored target is null anyway then we can skip it -->
                  <b-button
                    :hidden="!(targetVal || dateUntilVal || deviationVal) && storedIsNull"
                    class="ml-2"
                    variant="outline-danger"
                    size="sm"
                    @click="storedIsNull ? restoreTarget() : saveTarget(true)"
                  >
                    <i class="fas fa-check"></i> Wert{{dateUntilIsEnabled ? 'e' : ''}} löschen
                  </b-button>
                  <b-button
                      :hidden="(targetVal === targetValStored && dateUntilVal === dateUntilStored && deviationVal === deviationStored) || storedIsNull"
                      class="ml-2"
                      variant="outline-warning"
                      size="sm"
                      @click="restoreTarget"
                  >
                    <i class="fas fa-check"></i> Wert{{dateUntilIsEnabled ? 'e' : ''}} zurücksetzen
                  </b-button>
                </b-col>
              </b-form-row>
            </b-form>
          </b-collapse>
          <b-collapse id="annotation_collapse" v-model="annotation_visible" @shown="autoScroll('#annotation_collapse')">
            <b-form
              v-if="!readOnly"
              class="mt-2"
              :action="'/groups/' + group.id + '/assessments/' + test.id + '/annotations'"
              accept-charset="UTF-8"
              method="post"
              data-remote="true"
              @submit="encode_text()"
              @ajax:success="success"
            >
              <b-form-row class="text-small">
                <b-col>
                  <label>Datumsbereich</label>
                </b-col>
                <b-col>
                  <b-form-select
                    v-model="annotation_start"
                    name="annotation[start]"
                    :options="week_labels(true)"
                    size="sm"
                  ></b-form-select>
                </b-col>
                <b-col>
                  <b-form-select
                    v-model="annotation_end"
                    name="annotation[end]"
                    :options="week_labels(false)"
                    size="sm"
                  ></b-form-select>
                </b-col>
              </b-form-row>
              <b-form-row class="mt-1">
                <b-col>
                  <!-- Hidden Field mit user bzw group id -->
                  <input
                    v-if="studentSelected == -1"
                    type="hidden"
                    :value="group.id"
                    name="annotation[group_id]"
                  />
                  <input
                    v-else
                    type="hidden"
                    :value="students[studentSelected]?.id"
                    name="annotation[student_id]"
                  />
                  <!-- Hidden Field mit view -->
                  <input type="hidden" :value="view_selected" name="annotation[view]" />
                  <b-form-textarea
                    v-model="annotation_text"
                    class="text-small"
                    name="annotation[content]"
                    placeholder="Hier die Anmerkung eingeben..."
                    rows="2"
                    max-rows="3"
                  >
                  </b-form-textarea>
                </b-col>
              </b-form-row>
              <b-form-row class="mt-1">
                <b-col>
                  <b-button
                    type="submit"
                    variant="outline-success"
                    size="sm"
                    :disabled="
                      annotation_text.trim().length === 0 ||
                      annotation_end == null ||
                      annotation_start == null
                    "
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
                <tr
                  v-for="(a, i) in annotations"
                  v-if="
                    a.view == view_selected &&
                    ((studentSelected != -1 &&
                      students.find(s => s.id === studentSelected)?.id == a.student_id) ||
                      (studentSelected == -1 && a.group_id != null))
                  "
                  :key="a.id"
                >
                  <td>{{ printDate(a.start) }}</td>
                  <td>{{ printDate(a.end) }}</td>
                  <td>{{ decode_text(a.content) }}</td>
                  <td v-if="!readOnly">
                    <!-- rails-ujs Link -->
                    <a
                      class="btn btn-block btn-sm btn-outline-danger"
                      :href="
                        '/groups/' + group.id + '/assessments/' + test.id + '/annotations/' + a.id
                      "
                      data-method="delete"
                      data-remote="true"
                      data-confirm="Anmerkung löschen! Sind Sie sicher?"
                      @ajax:success="annotations.splice(i, 1)"
                    >
                      <i class="fas fa-trash"></i> Löschen
                    </a>
                  </td>
                </tr>
              </tbody>
            </table>
          </b-collapse>
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
import ApexCharts from 'apexcharts'
import autoTable from 'jspdf-autotable'
import deepmerge from 'deepmerge'
import jsPDF from 'jspdf'
import {
  addTargetToChartData,
  addTrendToChartData,
  annotationsTargetOptions,
  apexChartOptions,
} from './apexChartHelpers'
import {decryptStudentName, encryptWithMasterKeyAndGroup} from '../../utils/encryption'
import {ajax} from "@/utils/ajax";
import apiRoutes from "@/vue/routes/api-routes";
import {createTrendline} from "@/vue/home/linearRegressionHelpers";
import {cloneDeep} from "lodash";

export default {
    name: 'AnalysisView',
  inject: ['autoScroll', 'printDate', 'readOnly', 'studentName', 'weeks', 'student_name_parts', 'groupTargetsStored', 'fetchAssessments'],
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
        annotation_visible: false,
        annotation_end: null,
        annotation_start: null,
        annotation_text: '',
        dateUntilVal: null,
        deviationVal: 0,
        targetControlVisible: false,
        targetVal: null,
        targetAdded: false,
        apexchart: null,
        default_options: apexChartOptions(this.weeks),
        studentSelected: -1,
        student_targets: [],
        view_selected: 0,
        simpleTableData: undefined,
        graphDataCache: null,
        optCache: null,
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
      currentView() {
        return this.configuration.views[this.view_selected]
      },
      columns() {
        return this.currentView.columns || []
      },
      selectedViewType() {
        return this.currentView.type
      },
      graph_visible() {
        return (
          this.currentView.type === 'graph' ||
          this.currentView.type === 'graph_table'
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
          this.currentView.type === 'table' ||
          this.currentView.type === 'graph_table'
        )
      },
      table_data() {
        if (this.currentView.type === 'graph') {
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
                i < this.currentView.column_keys.length;
                ++i
              ) {
                let key = this.currentView.column_keys[i]
                let name = this.currentView.columns[i]
                temp[name] =
                  this.results[r].views[this.currentView.key][key]
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
      targetIsSlopeVariant() {
        return Boolean(this.currentView.targetOptions?.type === 'slope')
      },
      targetIsEnabled() {
        return !this.currentView.series_keys && Boolean(this.currentView.targetOptions?.enabled)
      },
      dateUntilIsEnabled() {
        // if a slope target is to be shown then we need dateUntil anyway
        return Boolean(this.currentView.targetOptions?.selectEndDate) || (this.targetIsEnabled && this.targetIsSlopeVariant)
      },
      deviationIsEnabled() {
        return Boolean(this.currentView.targetOptions?.selectDeviation)
      },
      trendIsEnabled() {
        return Boolean(this.currentView.trendOptions?.enabled)
      },
      extrapolationIsEnabled() {
        return Boolean(this.currentView.trendOptions?.extrapolate)
      },
      deviationStored() {
        return this.targetStored?.deviation || null
      },
      storedIsNull() {
        return this.dateUntilStored == null && this.targetValStored == null && this.dateUntilStored == null
      },
      dateUntilStored() {
        return this.targetStored?.date_until || null
      },
      targetOrTimeValid() {
        return this.targetValid || this.dateUntilVal
      },
      targetAndTimeValid() {
        return this.targetValid && this.dateUntilVal
      },
      targetValid() {
        return this.targetVal != null &&
            this.targetVal.trim().length !== 0 &&
            !Number.isNaN(this.targetVal) &&
            Number(this.targetVal) >= 0
      },
      targetId() {
        return this.targetStoredRaw?.id
      },
      targetValStored() {
        return this.targetStored?.value || null
      },
      targetStored() {
        // when targetStoredRaw is undefined and a student is selected then this means that the stored target is defined as null (nothing stored)
        // this convention allows other actors that expect targetStored to be a number or null to work properly in both the group case and the individual student case
        let res
        if (this.studentSelected === -1) {
          const results = this.groupTargetsStored  // results on all views
          res = results?.find((r) => r.view === this.currentView?.key) // find the one belonging to the current view
        }
        else {
          res = this.targetStoredRaw
        }
        return res === undefined ? null : res
      },
      targetStoredRaw() {
        return this.studentSelected === -1 ?
            undefined :
            this.student_targets  // find the target belonging to this student in the current view
                .find(target => target.student_id === this.studentSelected && target.view === this.currentView?.key)
      },
    },
    mounted() {
      // also sets the initial values for dateUntil and targetVal when in group view, due to call to restoreTarget
      this.loadStudentTargets()
      this.set_student(this.has_group_views
        ? -1
        : this.studentsWithResults[this.studentsWithResults.length - 1]?.id || -1
        ? this.studentsWithResults[0]?.id || -1
        : -1
      )
    },
    methods: {
      setSelectedView(index) {
        this.view_selected = index
        // restore the target to the stored state of the new view, as each view has its own target data
        // don't redraw as we're calling updateView next
        this.restoreTarget(false)
        // destroy the chart to reset the options
        this.updateView(true)
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
      encode_text() {
        const id = this.group.id
        for (let i = 0; i < this.student_name_parts.length; ++i) {
          const re = new RegExp(
            '[^a-zaöüß_](' +
              this.student_name_parts[i] +
              ')[^a-zaöüß_]|' +
              '^(' +
              this.student_name_parts[i] +
              ')[^a-zaöüß_]|' +
              '[^a-zaöüß_](' +
              this.student_name_parts[i] +
              ')$|' +
              '^(' +
              this.student_name_parts[i] +
              ')$',
            'gi'
          )
          const match = re.exec(this.annotation_text)
          if (match != null) {
            for (let m = 0; m < match.length; ++m) {
              this.annotation_text = this.annotation_text.replace(
                re,
                function (match, p1, p2, p3, p4) {
                  if (p1 != undefined) {
                    return match.replace(p1, encryptWithMasterKeyAndGroup(p1, id))
                  }
                  if (p2 != undefined) {
                    return match.replace(p2, encryptWithMasterKeyAndGroup(p2, id))
                  }
                  if (p3 != undefined) {
                    return match.replace(p3, encryptWithMasterKeyAndGroup(p3, id))
                  } else {
                    return match.replace(p4, encryptWithMasterKeyAndGroup(p4, id))
                  }
                }
              )
            }
          }
        }
        return true
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
        let view = this.configuration.views[this.view_selected]
        if (this.studentSelected == -1) {
          title = `Ganze Klasse - ${view.label}`
          filename = `${this.group.label}_${this.test.shorthand}_${this.test.level}_Klassenansicht`
        } else {
          title = `${this.getStudentName(this.studentSelected)} - ${view.label}`
          filename = `${this.group.label}_${this.test.shorthand}_${this.test.level}_Kindansicht`
        }
        await this.createPdf(title, filename)
      },
      createSeries(studentId, seriesKey) {
        const results = this.results.filter(result => result.student_id === studentId)
        return this.weeks.map(week => {
          const currentResult = results.find(r => r?.test_week === week)
          // if a week has no results add a point with an empty y value for this week
          if (!currentResult) {
            return { x: week, y: null }
          }
          let point = this.XYFromResult(currentResult, seriesKey)
          point.y = point.y?.toFixed(2) || null
          return point
        })
      },
      XYFromResult(result, seriesKey) {
        if (!result) return undefined
        let yVal
        const view = this.currentView
        if (seriesKey) {
          yVal = result?.views[view.key][seriesKey] || null
        } else {
          yVal = result?.views[view.key] || null
        }
        return {
          x: result?.test_week || null,
          y: yVal,
        }
      },
      set_student(student_id) {
        const oldValue = this.studentSelected
        this.studentSelected = student_id
        if (student_id !== oldValue) {
          // if a new student is selected (or none meaning class view has been selected) update the target based on what is stored
          this.restoreTarget(false) // don't redraw, as updateView is about to be called anyway
        }
        this.updateView()
      },
      updateView(destroyOld = false) {
        const view = this.currentView
        if (view.type === 'table') { return }

        // if any series wants to be of type rangeArea then the whole chart needs to be
        // therefore we need to save the "true" chart type to hand over to all non-rangeArea series (i.e. all except the slope target)
        let trueChartType = view.options.chart.type
        if (trueChartType !== 'line' && trueChartType !== 'bar' && trueChartType !== 'rangeArea') {
          trueChartType = 'line'
        }
        let opt
        // only when targets are enabled and a slope target is desired and a line or rangeArea chart, only then use an rangeArea chart
        const needRangeAreaChart = this.targetIsSlopeVariant && this.targetIsEnabled && (trueChartType === 'line' || trueChartType === 'rangeArea')
        if (needRangeAreaChart) {
          opt = this.default_options.rangeArea
        } else {
          // we allow only bar and rangeArea as custom chart types, all others default to line
          switch (trueChartType) {
            case 'bar':
              opt = this.default_options.bar
              break
            case 'rangeArea':
              opt = this.default_options.rangeArea
              break
            default:
              opt = this.default_options.line
          }
        }

        opt = deepmerge(opt, view.options)
        // when a slope target is desired we need to change the type to rangeArea
        if (needRangeAreaChart) { opt.chart.type = 'rangeArea' }

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
        let trendlineData = undefined

        // create graph data
        if (this.studentSelected == -1) {
          graphData = this.studentsWithResults.map(student => {
            return { name: student.name, type: trueChartType, data: this.createSeries(student.id) }
          })
        } else {
          const student = this.students.find(s => s.id === this.studentSelected)
          if (!view.series_keys) {
            graphData = [{ name: student.name, type: trueChartType, data: this.createSeries(student.id) }]
            // only create trend line data when a single series is shown
            if (this.trendIsEnabled) {  // only create trend line data when the view is configured to show such
              // hand over available time to make sure the line reaches up to this date IF extrapolation is enabled
              trendlineData = createTrendline(
                  graphData[0]?.data,
                  this.extrapolationIsEnabled ? this.dateUntilVal : null
              )
            }
          } else {
            graphData = view.series_keys.map((series_key, index) => {
              return { name: view.series[index], type: trueChartType, data: this.createSeries(student.id, series_key) }
            })
          }
        }

        this.simpleTableData = graphData.map(lineData => {
          const data = lineData.data.reduce((acc, d) => {
            // createSeries contains raw dates, so we need to format them here
            acc[this.printDate(d.x)] = d.y || '-'
            return acc
          }, {})
          return {
            name: lineData.name,
            ...data,
          }
        })

        //Kommentare einfügen
        /* DISABLED FOR NOW AS IT LEADS TO AN ERROR AND IS UNUSED ANYWAY
        opt['annotations'] = {
          position: 'front',
          xaxis: [],
          points: [],
        }
        for (let i = 0; i < this.annotations.length; ++i) {
          if (
            this.annotations[i].view == this.view_selected &&
            ((this.studentSelected != -1 &&
              this.studentSelected == this.annotations[i].student_id) ||
              (this.studentSelected == -1 && this.annotations[i].group_id != null))
          ) {
            if (
              this.annotations[i].start != this.annotations[i].end &&
              view.options.chart.type === 'line'
            ) {
              //Fall 1: Bereichsanmerkung (nur für Liniengraphen)
              opt['annotations']['xaxis'].push(annotationsLineOptions(this.annotations[i]))
            }
            //Fall 2: Wochenanmerkungen, umgesetzt als Punktanmerkung
            else {
              opt['annotations']['points'].push(
                annotationsPointOptions(view, this.annotations[i], 1)
              ) //FIXME hardcoded parameter 1 is certainly not correct
            }
          }
        }
        */

        opt.chart.id = '#chart_' + this.group.id + '_' + this.test.id

        // for views without series keys we might draw a trend line and a target depending on the view config
        if (!view.series_keys) {
          // for views only showing one student also create a trend line over the values
          // (can also be something else like trend bars, depending on the true chart type)
          addTrendToChartData(graphData, opt, trendlineData, trueChartType)
          if (this.targetIsEnabled) {
            // at this point cache the graphData and options so that targets can be re-added more easily later
            // in case they change dynamically
            // NOTE: for graphData structuredClone is OK, as long as there won't be functions in the data, which would be weird
            this.graphDataCache = structuredClone(graphData)
            // workaround for cloning options as structuredClone is not able to clone functions (such as the y.max we set)
            this.optCache = cloneDeep(opt)
            this.appendSlopeTarget(graphData, opt)
          }
        }
        this.expandXAxis(graphData)

        const options = { ...opt, series: graphData }

        // only create the chart once and from then on update it dynamically
        // except when we need to destroy (i.e. on view change, see below)
        if (destroyOld && this.apexchart != null) {
          this.apexchart.destroy()
          this.apexchart = null
        }
        if (this.apexchart == null) {
          this.apexchart = new ApexCharts(document.querySelector(opt.chart.id), options)
          this.apexchart.render()
        } else {
          // An annoying thing is that updateOptions only _merges in_ changes instead of writing everything new
          // This means that we need to force apexcharts to undefine all fields that may have been defined (so... all)
          // For this we could call updateOptions with options designed to set all possible fields, in accordance with the
          // documentation, back to undefined before merging our real changes over that. BUT THAT WOULD BE INSANE.
          // So instead we just destroy the chart on view change and recreate it... and apply special care to
          // set back / undefine all option fields that we actually know we might be touching ourselves whilst staying in one view
          // TODO: There has to be a better way for this.
          this.apexchart.updateOptions(options)
        }

        if (this.targetIsEnabled) {
          this.updateAnnotationTarget() // should only be called after the chart has been rendered
        }
      },
      // append the slope target line on the chart if the slope variant is chosen by the current view
      appendSlopeTarget(graphData, opt) {
        if (!this.targetIsSlopeVariant || !this.targetAndTimeValid) { return }
        // for the slope variant of a target line we need to add a series that will form this line and set chart options for it
        // first calculate the start point
        let startWeek = this.weeks.reduce((acc, w) => w < acc ? w : acc)
        const startWeekResults = this.results.filter((res) => res.test_week === startWeek)
        let startY
        if (this.studentSelected === -1) {
          // if no student is selected then calculate the average over the results of the first week
          startY = startWeekResults.reduce((acc, res) => {
            return acc + this.XYFromResult(res, null)?.y || 0
          }, 0) / startWeekResults.length
        } else {
          // if a student IS selected take their first result as the starting point
          const firstResult = this.results.reduce((acc, res) => {
              return res.student_id === this.studentSelected && Date.parse(res.test_week) < Date.parse(acc.test_week) ? res : acc
            },
            // if people still use this Levumi code in the year 90000 this will of course break
            // but then again, this means they wouldn't have looked at it for 88000 years... (specified max date is somewhere around 270000)
            { test_week: new Date(Date.UTC(90000,12,24)) }
          )
          startWeek = firstResult.test_week
          startY = this.XYFromResult(firstResult, null)?.y
        }
        const deviate = this.deviationVal > 0
        const startPoint = { x: startWeek, y: deviate ? [startY, startY] : startY }
        // the end point is then created by combining the date until which the target is to be reached with the chosen target value
        // when a deviation is desired also create a y value lowered by the accepted deviation
        const endPoint = {
          x: this.dateUntilVal,
          y: deviate ? [this.targetVal * (1 - this.deviationVal / 100) , this.targetVal] : this.targetVal
        }
        if (startPoint.x && endPoint.x && startY != undefined
            && (deviate ? undefined != endPoint.y[0] && undefined != endPoint.y[1] : undefined != endPoint.y)) {
          // if both start and end are well-defined add their line as a series
          addTargetToChartData(graphData, opt, deviate, startPoint, endPoint)
        }
      },
      // updates only the horizontal target lines as this is implemented through dynamic annotations
      // should only be called after the chart has been rendered or before the chart has been created
      updateAnnotationTarget() {
        if (this.apexchart == null) { return }  // without an active chart there's nothing to update
        if (this.targetAdded) {  // first, if there already is a target line remove it
          this.apexchart.removeAnnotation(annotationsTargetOptions(0).id) // targetY doesn't matter here
          this.targetAdded = false
        }
        if (this.targetValid && !this.targetIsSlopeVariant) {
          const y2 = (this.deviationIsEnabled && this.deviationVal > 0) ? this.targetVal - this.targetVal * (this.deviationVal / 100) : null
          this.apexchart.addYaxisAnnotation(annotationsTargetOptions(this.targetVal, y2))
          this.targetAdded = true  // necessary to keep track of because apexchart.removeAnnotation will fail if called without any dynamically added annotations
        }
      },
      /** Used in cases where the chart has already been rendered and only the target related data needs to be updated. */
      redrawTarget() {
        if (!this.targetIsEnabled || this.apexchart == null) { return }
        let graphData = structuredClone(this.graphDataCache)
        // workaround for cloning options as structuredClone is not able to clone functions (such as the y.max we set)
        let opt = cloneDeep(this.optCache)
        this.appendSlopeTarget(graphData, opt)
        this.expandXAxis(graphData)

        const options = { ...opt, series: graphData }
        this.apexchart.updateOptions(options, false, false, false)
        if (!this.targetIsSlopeVariant) {
          this.updateAnnotationTarget()
        }
      },
      success(event) {
        //Attributwerte aus AJAX Antwort übernehmen und View updaten
        this.annotations.splice(0, 0, event.detail[0])
        this.annotation_start = null
        this.annotation_end = null
        this.annotation_text = ''
        this.set_student(-1)  // TODO: warum wird hier eigentlich auf die Klassenansicht navigiert?
      },
      week_labels(start) {
        let res = [{ value: null, text: start ? 'Von...' : 'Bis...' }]
        for (let i = this.weeks.length - 1; i >= 0; --i) {
          res.push({
            value: this.weeks[i],
            text: this.printDate(this.weeks[i]),
          })
        }
        return res
      },
      has_results(student) {
        for (let i = 0; i < this.results.length; ++i) {
          if (this.results[i].student_id == student.id) {
            return true
          }
        }
        return false
      },
      setTarget(targetVal, dateUntilVal, deviationVal, redraw) {
        this.targetVal = targetVal
        this.dateUntilVal = dateUntilVal
        this.deviationVal = deviationVal
        if (redraw) { this.redrawTarget() }
      },
      restoreTarget(redraw = true) {
        this.setTarget(this.targetValStored, this.dateUntilStored, this.deviationStored, redraw)
      },
      expandXAxis(graphData) {
        // if an end date has been chosen make sure the x-axis reaches/includes this date
        // SIDE-FACT: technically expanding the x-axis isn't necessary when there's a slope target or an extrapolated trend
        // SIDE-FACT: as these automatically lead to this effect themselves, but I don't think we should check for that here
        if (!this.dateUntilIsEnabled || !this.dateUntilVal) { return }
        // only use the date if it lies after the last test result
        const maxDate = graphData[0]?.data.reduce((acc, d) => {
          return d.x > acc ? d.x : acc
        }, this.dateUntilVal)
        // to trick ApexCharts into drawing until there add an empty data point to the first series
        // TODO: it would be nice if this could be achieved without polluting the data
        if (maxDate === this.dateUntilVal) {
          graphData[0]?.data.push({x: this.dateUntilVal, y: null})
        }
      },
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
            this.loadStudentTargets()   // this function instead only loads the detail information for the current assessment
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
        if (this.targetStored === null) {
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
      async loadStudentTargets() {
        const res = await ajax(
            apiRoutes.targets.getStudentTargets(this.group.id, this.test.id)
        )
        if (res.status === 200) {
          const text = await res.text()
          const result = JSON.parse(text)
          this.student_targets = result.targets
        } else {
          this.student_targets = []
        }
        // lastly set the displayed value to the just loaded one
        this.restoreTarget()
      },
      toggleActiveCollapse(collapse_id) {
        // TODO: this is a bit clunky; could probably be solved more elegantly
        switch (collapse_id) {
          case 'annotation_collapse':
            this.targetControlVisible = false
            this.annotation_visible = !this.annotation_visible
            break
          case 'target_collapse':
            this.annotation_visible = false
            this.targetControlVisible = !this.targetControlVisible
            break
        }
      }
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
