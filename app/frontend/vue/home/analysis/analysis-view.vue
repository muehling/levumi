<template>
  <div>
    <div class="d-flex justify-content-between">
      <b-button-group class="ms-3" size="sm">
        <b-button
          class="me-2"
          size="sm"
          variant="outline-primary"
          :pressed="selectedStudentId === -1"
          :disabled="!has_group_views"
          @click="setStudentAndUpdate(-1)">
          Ganze Klasse
        </b-button>
        <b-dropdown
          right
          :text="
            studentsWithResults.find(s => s.id === selectedStudentId)?.name || 'Individualgraph'
          "
          :variant="selectedStudentId !== -1 ? 'primary' : 'outline-primary'"
          :disabled="!has_student_views"
          size="sm">
          <b-dropdown-item
            v-for="s in studentsWithResults"
            :key="s.id"
            class="text-small"
            @click="setStudentAndUpdate(s.id)">
            {{ s.name }}
          </b-dropdown-item>
        </b-dropdown>
      </b-button-group>
      <div v-if="isSupportFilterVisible" class="d-flex">
        <label class="text-small mt-1">Filtern nach Förderbedarf:</label>
        <b-dropdown
          :text="supportNeeds.find(need => need.id === selectedSupportNeedFilter)?.name"
          variant="primary"
          class="ms-2 text-right"
          right
          size="sm">
          <b-dropdown-item
            v-for="need in supportNeeds"
            :key="need.id"
            class="text-small"
            @click="selectedSupportNeedFilter = need.id">
            {{ need.name }}
          </b-dropdown-item>
        </b-dropdown>
      </div>
    </div>
    <b-row class="mt-2">
      <b-col>
        <b-button-group class="ms-3">
          <b-button
            v-for="(view, index) in viewsWithGroupAndStudent"
            :key="index"
            class="me-2 shadow-none"
            size="sm"
            variant="outline-secondary"
            :pressed="selectedView === view.key"
            @click="setSelectedView(view.key)">
            {{ view.label }}
          </b-button>
        </b-button-group>
      </b-col>
    </b-row>
    <b-row :hidden="!graph_visible">
      <b-col :key="forceUpdate">
        <apexchart
          v-if="hasChartData && currentChartType === 'line'"
          ref="levumiChart"
          type="line"
          height="500px"
          width="100%"
          :options="chartOptions"
          :series="chartSeries" />
        <apexchart
          v-else-if="hasChartData && currentChartType === 'bar'"
          ref="levumiChart"
          type="bar"
          height="500px"
          width="100%"
          :options="chartOptions"
          :series="chartSeries" />

        <div v-else style="height: 500px">
          <b-alert class="m-4 p-4" variant="danger" show>
            Zu den gewählten Filtereinstellungen sind keine Daten vorhanden!
          </b-alert>
        </div>
      </b-col>
    </b-row>
    <b-row :hidden="!annotationAndTargetRowVisible">
      <b-col>
        <b-row class="ms-1">
          <b-col>
            <b-button
              v-if="!readOnly"
              id="annotation_btn"
              v-b-toggle.annotation_collapse
              :aria-expanded="annotationControlVisible ? 'true' : 'false'"
              aria-controls="annotation_collapse"
              size="sm"
              :variant="`${annotationControlVisible ? 'outline-success' : 'outline-primary'}`"
              @click="toggleCollapse('annotation_collapse')">
              Anmerkungen
              <i
                :class="`when-closed fas ${
                  annotationControlVisible ? 'fa-caret-down' : 'fa-caret-up'
                }`"></i>
            </b-button>
            <b-button
              v-if="!readOnly"
              id="target_btn"
              v-b-toggle.target_collapse
              class="ms-2"
              :aria-expanded="targetControlVisible ? 'true' : 'false'"
              aria-controls="target_collapse"
              size="sm"
              :variant="`${targetControlVisible ? 'outline-success' : 'outline-primary'}`"
              @click="toggleCollapse('target_collapse')">
              Ziele und Trends
              <i
                :class="`when-closed fas ${
                  targetControlVisible ? 'fa-caret-down' : 'fa-caret-up'
                }`"></i>
            </b-button>
            <b-button class="ms-2" size="sm" variant="outline-primary" @click="exportGraph">
              <i class="fas fa-file-pdf"></i>
              PDF erzeugen
            </b-button>
          </b-col>
        </b-row>
        <b-row class="ms-1">
          <b-col class="me-4">
            <annotations-section
              v-if="annotationControlVisible"
              :group="group"
              :test="test"
              :selected-student="selectedStudent"
              :selected-view-key="selectedView"
              :weeks="weeks" />

            <target-controls
              v-if="targetControlVisible"
              :load-student-targets="loadStudentTargets"
              :view-config="viewConfig"
              :current-target="currentTarget"
              :student-targets="studentTargets"
              :selected-student-id="selectedStudentId"
              :test="test"
              :weeks="weeks"
              :group="group" />
          </b-col>
        </b-row>
      </b-col>
    </b-row>
    <hr class="section-divider" />
    <b-row v-if="isSupportSectionVisible" class="mt-4">
      <b-tabs class="w-100" pills no-body card>
        <b-tab
          v-if="isGroupSupportOverviewVisible"
          title="Übersicht Förderbedarf ganze Klasse"
          lazy>
          <support-group-overview :group="group" :test="test.id" />
        </b-tab>
        <b-tab
          v-if="hasItemDictionary && isGroupQualitativeOverviewVisible"
          title="Qualitative Auswertung Förderbedarf ganze Klasse"
          lazy>
          <support-group-qualitative :group="group" :test="test.id" />
        </b-tab>
      </b-tabs>
    </b-row>

    <b-row :hidden="!tableVisible">
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
              <td>{{ formatDate(entry.week) }}</td>
              <td v-for="col in columns" :key="col"><span v-html="entry[col]"></span></td>
            </tr>
          </tbody>
        </table>
      </div>
    </b-row>
    <hr v-if="selectedViewType != 'graph'" class="section-divider" />
    <b-row :hidden="!simpleTableVisible">
      <b-tabs class="w-100" pills no-body card>
        <b-tab title="Tabellarische Daten" lazy>
          <b-table
            id="simple-table"
            class="mt-4 text-small"
            small
            striped
            hover
            :fields="simpleTableFields"
            :items="simpleTableData" />
        </b-tab>
      </b-tabs>
    </b-row>
    <b-row v-if="selectedViewType === 'niveaus'">
      <niveau-overview
        :niv-config="viewConfig.niv_config"
        :info-attachments="info_attachments"></niveau-overview>
    </b-row>
  </div>
</template>

<script>
  import { ajax } from '@/utils/ajax'
  import { checkUserSettings } from '@/utils/user'
  import { toRaw } from 'vue'
  import { createSimpleTableData, createHtmlTableFromViewConfig } from './data/createTableData'
  import { createTrendline } from './linearRegressionHelpers'
  import { getTrendFromResults } from '@/utils/helpers'
  import { printDate } from '@/utils/date'
  import { useAssessmentsStore } from '@/store/assessmentsStore'
  import { useGlobalStore } from '@/store/store'
  import { useTestsStore } from '@/store/testsStore'
  import AnnotationsSection from './annotations-section.vue'
  import apiRoutes from '@/vue/routes/api-routes'
  import autoTable from 'jspdf-autotable'
  import compact from 'lodash/compact'
  import isEmpty from 'lodash/isEmpty'
  import jsPDF from 'jspdf'
  import NiveauOverview from '@/vue/home/analysis/niveau-overview.vue'
  import SupportGroupOverview from '@/vue/home/supports/support-group-overview.vue'
  import SupportGroupQualitative from '@/vue/home/supports/support-group-qualitative.vue'
  import takeRight from 'lodash/takeRight'
  import TargetControls from './target-controls.vue'
  import uniq from 'lodash/uniq'
  import {
    addTrendToChartData,
    annotationsLineOptions,
    annotationsPointOptions,
    targetAnnotationOptions,
    targetRangeAnnotationOptions,
    prepareOptions,
    apexChartOptions,
    quantile,
    postProcessGroupedStackedBars,
  } from './apexChartHelpers'

  export default {
    name: 'AnalysisView',
    components: {
      AnnotationsSection,
      NiveauOverview,
      TargetControls,
      SupportGroupOverview,
      SupportGroupQualitative,
    },

    props: {
      group: Object,
    },
    setup() {
      const testsStore = useTestsStore()
      const globalStore = useGlobalStore()
      const assessmentsStore = useAssessmentsStore()
      return { testsStore, globalStore, assessmentsStore }
    },
    data: function () {
      return {
        annotationControlVisible: false,
        chartOptions: apexChartOptions([]).line, // just so that apexcharts is happy being initialized correctly
        dateUntilVal: this.assessmentsStore.currentAssessment.settings?.date_until,
        deviationVal: null,
        forceUpdate: undefined,
        graphData: [],
        isInitting: true,
        isInitialized: false,
        maxY: 0,
        selectedStudentId: -1,
        selectedSupportNeedFilter: undefined,
        selectedView: undefined,
        simpleTableData: undefined,
        studentTargets: [],
        targetAdded: false,
        targetControlVisible: false,
        targetVal: null,
        info_attachments: undefined,
      }
    },
    computed: {
      test() {
        return this.assessmentsStore.currentAssessment?.test
      },
      results() {
        return this.assessmentsStore.currentAssessment?.series
      },
      students() {
        return this.globalStore.studentsInGroups[this.group.id] || []
      },

      readOnly() {
        return !!this.group.read_only
      },

      simpleTableFields() {
        const a = this.weeks.map(week => ({ key: printDate(week) }))
        a.unshift({ key: 'name' })
        return a
      },
      annotations() {
        return this.assessmentsStore.currentAssessment.annotations.slice()
      },
      configuration() {
        return this.assessmentsStore.currentAssessment.configuration // this is actually assessment.test.configuration
      },
      displaySupportFilterHint() {
        return !this.graphData.length && this.selectedSupportNeedFilter
      },
      hasChartData() {
        return !isEmpty(this.graphData) && this.isInitialized
      },
      weeks() {
        return compact(uniq(this.results?.map(w => w.test_week)))
      },
      isSupportInformationAvailable() {
        return this.assessmentsStore.getCurrentAssessment()?.configuration.item_dimensions
      },
      isSupportSectionVisible() {
        return (
          this.selectedViewType === 'graph' &&
          this.isSupportInformationAvailable &&
          (checkUserSettings(this.settings, 'visibilities.analysisView.groupSupportOverview') ||
            checkUserSettings(this.settings, 'visibilities.analysisView.groupQualitativeOverview'))
        )
      },
      isGroupSupportOverviewVisible() {
        return checkUserSettings(this.settings, 'visibilities.analysisView.groupSupportOverview')
      },
      isGroupQualitativeOverviewVisible() {
        return checkUserSettings(
          this.settings,
          'visibilities.analysisView.groupQualitativeOverview'
        )
      },
      isSupportFilterVisible() {
        return checkUserSettings(this.settings, 'visibilities.analysisView.supportFilter')
      },
      hasItemDictionary() {
        return this.assessmentsStore.getCurrentAssessment()?.configuration.item_dimensions
      },
      supportNeeds() {
        return [
          { name: 'Alle', id: undefined },
          { name: 'Hoher Förderbedarf', id: 'HIGH_SUPPORT' },
          { name: 'Mittlerer Förderbedarf', id: 'MEDIUM_SUPPORT' },
          { name: 'Aktuell kein zusätzlicher Förderbedarf', id: 'NO_SUPPORT' },
        ]
      },

      seriesByStudent() {
        const series = this.assessmentsStore.getSeriesByStudent()
        for (let s in series) {
          series[s] = takeRight(series[s], 3)
        }

        return series
      },

      settings() {
        return this.globalStore.login.settings
      },
      viewsWithGroupAndStudent() {
        return this.configuration.views.filter(
          view =>
            (this.selectedStudentId === -1 && view.group) ||
            (this.selectedStudentId !== -1 && view.student)
        )
      },
      currentChartType() {
        return this.chartOptions.chart.type || 'line'
      },
      viewConfig() {
        return this.currentViewConfig()
      },
      columns() {
        return this.viewConfig.columns || []
      },
      selectedViewType() {
        return this.viewConfig.type
      },
      graph_visible() {
        return this.selectedViewType === 'graph' || this.selectedViewType === 'graph_table'
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
        return this.configuration.views.some(view => view.student)
      },
      tableVisible() {
        return this.selectedViewType === 'table' || this.selectedViewType === 'graph_table'
      },
      simpleTableVisible() {
        return this.selectedViewType === 'graph' && !this.viewConfig.options?.chart?.stacked
      },

      annotationAndTargetRowVisible() {
        // groupedStackedBars are hacked in percentile bands and do not offer support for annotations or targets currently
        return this.graph_visible && !this.viewConfig.options?.chart?.stacked
      },
      table_data() {
        if (!this.tableVisible) {
          return []
        }
        return createHtmlTableFromViewConfig({
          weeks: this.weeks,
          results: this.results,
          viewConfig: this.viewConfig,
          selectedStudentId: this.selectedStudentId,
          columns: this.columns,
        })
      },
      studentsWithResults() {
        if (this.selectedSupportNeedFilter !== undefined) {
          {
            const series = this.assessmentsStore.getSeriesByStudent()
            for (let s in series) {
              const lastThree = takeRight(series[s], 3)
              series[s] = lastThree.map(result => {
                return result.report.positive.length
              })
            }

            const students = Object.entries(series).filter(
              s => getTrendFromResults(s[1]) === this.selectedSupportNeedFilter
            )
            const needyStudents = students.map(s => parseInt(s[0], 10))
            return this.students.filter(
              student => this.hasResults(student) && needyStudents.find(s => s == student.id)
            )
          }
        }

        return this.students.filter(student => this.hasResults(student))
      },
      selectedStudent() {
        return this.selectedStudentId !== -1
          ? this.students.find(student => student.id === this.selectedStudentId)
          : null
      },
      chartSeries() {
        return toRaw(this.graphData)
      },

      trendIsEnabled() {
        return this.assessmentsStore.currentAssessment.settings?.is_trend_enabled
      },

      deviationStored() {
        const dev = this.currentTarget?.deviation
        return dev === undefined ? null : dev
      },
      dateUntilStored() {
        const date = this.currentTarget?.date_until
        return date === undefined ? null : date
      },
      targetAndTimeValid() {
        return true //this.targetValid && this.dateUntilVal
      },
      targetValid() {
        return (
          this.targetVal != null &&
          this.targetVal.trim().length !== 0 &&
          !Number.isNaN(this.targetVal) &&
          Number(this.targetVal) >= 0
        )
      },
      targetValStored() {
        const val = this.currentTarget?.value
        return val === undefined ? null : val
      },
      currentTarget() {
        // when no target is defined return null (nothing stored)
        const sId = this.selectedStudentId === -1 ? null : this.selectedStudentId // group targets are stored under a null student
        const res = this.studentTargets.find(
          target => target.student_id === sId && target.view === this.viewConfig?.key
        )
        return res === undefined ? null : res
      },
      /** Returns the stored target INCLUDING THE GROUP TARGET.
       * So when there's no individual target, but a group target, the latter is returned, else 'null' */
      currentTargetInclGroup() {
        if (this.currentTarget !== null) {
          return this.currentTarget
        }
        const groupTarget = this.studentTargets.find(
          target => target.student_id === null && target.view === this.viewConfig?.key
        )
        return groupTarget === undefined ? null : groupTarget
      },
      /** Returns the deviation value of stored target INCLUDING THE GROUP TARGET.
       * So when there's no individual target, but a group target, the latter is returned, else 'null' */
      deviationStoredInclGroup() {
        const dev = this.currentTargetInclGroup?.deviation
        return dev === undefined ? null : dev
      },
      /** Returns the date value of the stored target INCLUDING THE GROUP TARGET.
       * So when there's no individual target, but a group target, the latter is returned, else 'null' */
      dateUntilStoredInclGroup() {
        const date = this.currentTargetInclGroup?.date_until
        return date === undefined ? null : date
      },
      /** Returns the numerical value of stored target INCLUDING THE GROUP TARGET.
       * So when there's no individual target, but a group target, the latter is returned, else 'null' */
      targetValStoredInclGroup() {
        const val = this.currentTargetInclGroup?.value
        return val === undefined ? null : val
      },
      maxYValue() {
        return Math.max(this.maxY, this.targetVal)
      },
    },
    watch: {
      annotations() {
        // this watcher might run before the chart is properly instantiated, resulting in Apexcharts
        // throwing an error when it tries to draw the annotations.
        if (this.isInitialized) {
          this.updateView(false)
        }
        if (this.trendIsEnabled) {
          this.updateView(true)
        }
      },
      settings() {
        this.forceUpdate = Symbol()
        this.isInitialized = false
        this.updateView(false)
      },
      studentsWithResults() {
        this.updateView(false)
      },
    },
    async mounted() {
      await this.loadStudentTargets()

      this.setStudentAndUpdate(
        this.has_group_views
          ? -1
          : this.studentsWithResults[this.studentsWithResults.length - 1]?.id || -1
          ? this.studentsWithResults[0]?.id || -1
          : -1
      )
    },
    methods: {
      formatDate(date) {
        return printDate(date)
      },
      currentViewConfig(key = this.selectedView) {
        if (key) {
          return this.configuration.views.find(view => view.key === key)
        } else {
          return this.configuration.views[0]
        }
      },

      async setSelectedView(key) {
        // if the new view is a niveau overview view make sure the info_attachments are loaded
        if (this.currentViewConfig(key).niv_config && this.info_attachments === undefined) {
          // load info_attachments for use in the niveau overview view
          const data = await ajax({ ...apiRoutes.tests.info_attachments(this.test.id) })
          const attachments = data.data.info_attachments
          this.info_attachments = attachments
        }
        this.selectedView = key
        this.restoreTarget(false)
        this.updateView(true)
      },
      getStudentName(id) {
        return this.students.find(student => student.id === id)?.name
      },

      async exportGraph() {
        let title
        let filename
        let view = this.viewConfig
        if (this.selectedStudentId === -1) {
          title = `Ganze Klasse - ${view.label}`
          filename = `${this.group.label}_${this.test.shorthand}_${this.test.level}_Klassenansicht`
        } else {
          title = `${this.getStudentName(this.selectedStudentId)} - ${view.label}`
          filename = `${this.group.label}_${this.test.shorthand}_${this.test.level}_Kindansicht`
        }
        const pdf = new jsPDF({ orientation: 'landscape' })
        pdf.text(this.test.full_name, 10, 10)
        pdf.text(title, 10, 20)
        const uri = await this.$refs.levumiChart?.dataURI()
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
      createGroupedStackedColumnData() {
        const view = this.viewConfig
        const series = []
        // create stackable elements with the names of the series
        for (const sName of view.series) {
          for (const q of [0.0, 0.25, 0.5, 0.75, 1.0]) {
            series.push({
              name: `${sName} ${q}`,
              group: sName,
              data: [],
            })
          }
        }
        // go over all test weeks
        this.weeks.forEach(week => {
          const wResults = this.results.filter(res => res?.test_week === week)
          // go through the results and for each category collect the values from all results
          for (const i in view.series_keys) {
            const series_key = view.series_keys[i]
            // collect only the results of the category and filter out undefined/null values
            let catResults = wResults
              .map(
                res =>
                  res?.views?.[view.uses_data_from ? view.uses_data_from : view.key]?.[series_key]
              )
              .filter(r => r !== undefined && r !== null)
            // calculate the quartiles for this category
            const quartiles = []
            for (const q of [0.0, 0.25, 0.5, 0.75, 1.0]) {
              quartiles.push(quantile(catResults, q))
            }
            // add the quantiles for this week to the matching series
            for (let j = 0; j < 5; ++j) {
              series[i * 5 + j].data.push(j === 0 ? quartiles[j] : quartiles[j] - quartiles[j - 1])
            }
          }
        })
        // postprocess the series: add artificial series to create separator lines for the quartiles
        const EPSILON = 0.009
        function decreaseBy(arrayToDecrease, amount) {
          arrayToDecrease.forEach((el, index, array) => {
            array[index] = el - amount
          })
        }
        for (let sIndex = view.series.length - 1; sIndex >= 0; --sIndex) {
          const sName = view.series[sIndex]
          // first take half an EPSILON off the first quartile and add that to the last quartile
          // this is to center the separator lines onto the values they are actually meant to represent
          decreaseBy(series[sIndex * 5 + 1].data, EPSILON / 2)
          decreaseBy(series[sIndex * 5 + 4].data, -(EPSILON / 2))
          for (let j = 4; j > 1; --j) {
            const q = 25 * j
            const indexToSplice = sIndex * 5 + j
            const referenceData = series[indexToSplice].data
            // add a series with values similar to the reference series, but increased by EPSILON
            series.splice(indexToSplice, 0, {
              name: `${sName} ${q}%-Perzentil`,
              group: sName,
              data: referenceData.map(() => EPSILON),
            })
            // decrease the reference series by EPSILON in order not to inflate the results
            decreaseBy(referenceData, EPSILON)
          }
        }
        this.forceUpdate = Symbol()
        return series
      },

      createSeries(studentId, seriesKey, dateNeedsFormatting) {
        const results = this.results.filter(result => result?.student_id === studentId)

        const res = this.weeks.map(week => {
          const currentResult = results.find(r => r?.test_week === week)

          // if a week has no results add a point with an empty y value for this week
          if (currentResult === null || currentResult === undefined) {
            return { x: dateNeedsFormatting ? printDate(week) : week, y: null }
          }
          let point = this.XYFromResult(currentResult, seriesKey, dateNeedsFormatting)
          point.y = point.y?.toFixed(2)
          if (point.y === undefined) {
            point.y = null
          }

          this.maxY = Math.max(this.maxY, parseInt(point.y, 10 || 0))
          return point
        })
        // return res.filter(r => r.y)
        return res
      },
      XYFromResult(result, seriesKey, dateNeedsFormatting) {
        if (result === null || result === undefined) {
          return undefined
        }
        let yVal
        // if `uses_data_from` is set use that as the key to retrieve the data series
        const viewKey = this.viewConfig.uses_data_from
          ? this.viewConfig.uses_data_from
          : this.viewConfig.key
        if (seriesKey) {
          yVal = result?.views[viewKey][seriesKey]
        } else {
          yVal = result?.views[viewKey]
        }
        const w = result.test_week
        return {
          x: dateNeedsFormatting ? printDate(w) : w ?? null,
          y: yVal,
        }
      },
      async setStudentAndUpdate(studentId) {
        const previouslySelectedStudent = this.selectedStudentId
        this.selectedStudentId = studentId

        // some combinations of views/selectedStudent/presence of results yield no views
        if (this.viewsWithGroupAndStudent.length) {
          await this.setSelectedView(this.viewsWithGroupAndStudent[0].key)
        }
        if (studentId !== previouslySelectedStudent) {
          // if a new student is selected (or none meaning class view has been selected) update the target based on what is stored
          this.restoreTarget(false) // don't redraw, as updateView is about to be called anyway
        }
        this.forceUpdate = Symbol()
        this.updateView()

        this.$emit('analysis-view-initialized')
      },

      updateView() {
        // return early if the view type has no graph
        if (!this.graph_visible) {
          return
        }
        const view = this.viewConfig

        let trueChartType = view.options?.chart?.type
        // if the chart type was not specified in the view config we default to line
        if (!trueChartType) {
          trueChartType = 'line'
        }

        const preparedOptions = prepareOptions(
          trueChartType,
          view.options,
          this.weeks,

          this.maxYValue
        )

        let target, target2
        if (this.targetVal) {
          target = targetAnnotationOptions(this.targetVal)
          const y2 =
            this.deviationVal > 0
              ? this.targetVal - this.targetVal * (this.deviationVal / 100)
              : null
          if (y2) {
            target2 = targetRangeAnnotationOptions(this.targetVal, y2)
          }
        }

        const { points, xaxis } = this.updateAnnotations()

        preparedOptions.annotations = { points, xaxis, yaxis: [target, target2] }

        // bar and grouped stacked bar are currently the only supported non-line charts
        const nonLineChart = ['bar'].includes(trueChartType)
        const stackedBarChart = trueChartType === 'bar' && view.options?.chart?.stacked
        let trendlineData = undefined
        let gData = undefined
        // group data
        if (this.selectedStudentId === -1) {
          if (stackedBarChart) {
            // in case this is a grouped stacked bar chart do not create a series per student, but instead create
            // a group of stacked bars per week for the whole class
            gData = this.createGroupedStackedColumnData()
          } else {
            // else this is a graph with one series per student reaching over all available dates
            gData = this.studentsWithResults.map(student => {
              return {
                name: student.name,
                type: trueChartType,
                data: this.createSeries(student.id, undefined, nonLineChart),
              }
            })
          }
        } else {
          const student = this.students.find(s => s.id === this.selectedStudentId)
          // individual student data with single series
          if (!view.series_keys) {
            gData = [
              {
                name: student.name,
                type: trueChartType,
                data: this.createSeries(student.id, undefined, nonLineChart),
              },
            ]
            if (this.trendIsEnabled && trueChartType !== 'bar') {
              // only create trend line data when the view is configured to show such
              // 'bar' charts do not support trends right now, as they are based on categories
              // hand over available time to make sure the line reaches up to this date IF extrapolation is enabled
              trendlineData = createTrendline(
                gData[0]?.data,
                this.dateUntilVal,
                this.annotations.filter(
                  a =>
                    a.trend_threshold &&
                    (a.student_id === student.id || a.student_id === null) &&
                    a.view === this.selectedView
                )
              )
            }
          } else {
            // individual student data with multiple series
            gData = view.series_keys.map((series_key, index) => {
              return {
                name: view.series[index],
                type: trueChartType,
                data: this.createSeries(student.id, series_key, nonLineChart),
              }
            })
          }
        }

        // trends and targets are displayed only for line graphs charts and views with a single series
        if (!nonLineChart && !view.series_keys) {
          if (trendlineData) {
            addTrendToChartData(gData, preparedOptions, trendlineData, trueChartType)
          }
          if (trendlineData || this.targetVal) {
            gData = this.expandXAxis(gData)
          }
        }

        this.chartOptions = { ...this.chartOptions, ...preparedOptions }

        this.graphData = gData

        if (stackedBarChart) {
          postProcessGroupedStackedBars(this.viewConfig)
        }

        if (this.simpleTableVisible) {
          this.simpleTableData = createSimpleTableData(gData, nonLineChart)
        }

        this.isInitialized = true
      },

      updateAnnotations() {
        //Kommentare einfügen

        const studentId = this.selectedStudentId !== -1 ? this.selectedStudentId : null

        // get annotations that need to be drawn in the current chart
        const applicableAnnotations = this.annotations.filter(
          annotation =>
            annotation.view === this.selectedView &&
            (annotation.student_id === studentId || annotation.student_id === null)
        )

        const xaxis = applicableAnnotations
          .filter(
            annotation =>
              annotation.view === this.selectedView &&
              (annotation.start !== annotation.end ||
                (annotation.student_id === null && annotation.start === annotation.end))
          )
          .map(annotation => annotationsLineOptions(annotation, this.weeks))

        const points = applicableAnnotations
          .filter(
            annotation =>
              annotation.view === this.selectedView &&
              annotation.start === annotation.end &&
              annotation.student_id !== null
          )
          .map(annotation => {
            const dataForAnnotation = this.graphData[0]?.data.find(d => d.x === annotation.start)
            return annotationsPointOptions(
              this.viewConfig,
              annotation,
              dataForAnnotation?.y,
              annotation.start
            )
          })

        return { points, xaxis }
      },

      /** Used in cases where the chart has already been rendered and only the target related data needs to be updated. */
      // todo if there are a lot of students (> ~50) in a group, the chart will lag considerably when updating. display loader again?
      redrawTarget() {
        this.updateView(false)
      },

      hasResults(student) {
        return this.results.some(result => result.student_id === student.id)
      },

      setTarget(targetVal, deviationVal, redraw) {
        this.targetVal = targetVal
        this.dateUntilVal = this.assessmentsStore.currentAssessment.settings?.date_until
        this.deviationVal = deviationVal
        if (redraw) {
          this.redrawTarget()
        }
      },

      /** Restores the target values to the latest state known to the database.
       * For individuals who have no own targets set yet the values of the group target are used here instead.
       * The assumption behind this is that when teachers haven't set a different target for an individual
       * they'd prefer to see the group target being applied instead of seeing no target at all. */
      restoreTarget(redraw = true) {
        this.setTarget(this.targetValStoredInclGroup, this.deviationStoredInclGroup, redraw)
      },

      expandXAxis(graphData) {
        if (!this.dateUntilVal) {
          return graphData
        }
        // only use the date if it lies after the last test result
        // TODO might be necessary to extract the maxDate from all results (see below)
        const maxDate = graphData[0]?.data.reduce((acc, d) => {
          console.log('debug', acc, d)
          return d?.x > acc ? d?.x : acc
        }, this.dateUntilVal)
        // to trick ApexCharts into drawing until there add an empty data point to all series
        // TODO: it would be nice if this could be achieved without polluting the data
        if (maxDate === this.dateUntilVal && graphData.length) {
          graphData.forEach(gd => gd.data.push({ x: this.dateUntilVal, y: null }))
        }
        return graphData
      },

      async loadStudentTargets() {
        const res = await ajax(apiRoutes.targets.getStudentTargets(this.group.id, this.test.id))
        if (res.status === 200) {
          const result = res.data

          this.studentTargets = result.targets
        } else {
          this.studentTargets = []
        }
        // lastly set the displayed value to the just loaded one
        this.restoreTarget()
      },

      toggleCollapse(collapseId) {
        switch (collapseId) {
          case 'annotation_collapse':
            this.targetControlVisible = false
            this.annotationControlVisible = !this.annotationControlVisible
            break
          case 'target_collapse':
            this.annotationControlVisible = false
            this.targetControlVisible = !this.targetControlVisible
            break
        }
      },
    },
  }
</script>
