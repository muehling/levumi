<template>
  <div>
    <b-row class="d-flex justify-content-between">
      <b-button-group class="ml-3" size="sm">
        <b-button
          class="mr-2"
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
      <div v-if="isSupportFilterVisible">
        <label class="text-small">Filtern nach Förderbedarf:</label>
        <b-dropdown
          :text="supportNeeds.find(need => need.id === selectedSupportNeedFilter)?.name"
          variant="primary"
          class="ml-2 text-right"
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
    </b-row>
    <b-row class="mt-2">
      <b-button-group class="ml-3">
        <b-button
          v-for="(view, index) in viewsWithGroupAndStudent"
          :key="index"
          class="mr-2 shadow-none"
          size="sm"
          variant="outline-secondary"
          :pressed="selectedView === view.key"
          @click="setSelectedView(view.key)">
          {{ view.label }}
        </b-button>
      </b-button-group>
    </b-row>
    <b-row :hidden="!graph_visible">
      <b-col>
        <apexchart
          v-if="graphData.length"
          ref="levumiChart"
          :key="forceUpdate"
          :type="currentChartType"
          height="500px"
          width="100%"
          :options="chartOptions"
          :series="chartSeries" />
        <div v-else-if="displaySupportFilterHint" class="m-4 p-4" style="height: 500px">
          <b-alert class="m-4 p-4" variant="danger" show>
            Zu den gewählten Filtereinstellungen sind keine Daten vorhanden!
          </b-alert>
        </div>
      </b-col>
    </b-row>
    <b-row :hidden="!annotationAndTargetRowVisible">
      <b-col>
        <b-row class="ml-1">
          <b-col>
            <b-button
              v-if="!readOnly"
              id="annotation_btn"
              :aria-expanded="annotationControlVisible ? 'true' : 'false'"
              aria-controls="annotation_collapse"
              size="sm"
              :variant="`${annotationControlVisible ? 'primary' : 'outline-primary'}`"
              @click="toggleCollapse('annotation_collapse')">
              Anmerkungen
              <i
                :class="`when-closed fas ${
                  annotationControlVisible ? 'fa-caret-down' : 'fa-caret-up'
                }`"></i>
            </b-button>
            <b-button
              v-if="(targetIsEnabled || dateUntilIsEnabled) && !readOnly"
              id="target_btn"
              class="ml-2"
              :aria-expanded="targetControlVisible ? 'true' : 'false'"
              aria-controls="target_collapse"
              size="sm"
              :variant="`${targetControlVisible ? 'primary' : 'outline-primary'}`"
              @click="toggleCollapse('target_collapse')">
              Ziele und Trends
              <i
                :class="`when-closed fas ${
                  targetControlVisible ? 'fa-caret-down' : 'fa-caret-up'
                }`"></i>
            </b-button>
            <b-button class="ml-2" size="sm" variant="outline-primary" @click="exportGraph">
              <i class="fas fa-file-pdf"></i>
              PDF erzeugen
            </b-button>
          </b-col>
        </b-row>
        <b-row class="ml-1">
          <b-col class="mr-4">
            <annotations-section
              :annotations="annotations"
              :group="group"
              :test="test"
              :selected-student="selectedStudent"
              :selected-view-key="selectedView"
              :annotation-control-visible.sync="annotationControlVisible"
              :trend-is-enabled="trendIsEnabled"
              @annotation-removed="removeAnnotation" />
            <TargetControls
              :target-val="targetVal"
              :deviation-val="deviationVal"
              :date-until-val="dateUntilVal"
              :date-until-is-enabled="dateUntilIsEnabled"
              :target-is-enabled="targetIsEnabled"
              :deviation-is-enabled="deviationIsEnabled"
              :target-val-stored="targetValStored"
              :date-until-stored="dateUntilStored"
              :deviation-stored="deviationStored"
              :student-targets="studentTargets"
              :selected-student-id="selectedStudentId"
              :target-control-visible.sync="targetControlVisible"
              :target-valid="targetValid"
              :test="test"
              :group="group"></TargetControls>
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
              <td>{{ printDate(entry.week) }}</td>
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
          <b-table-lite
            id="simple-table"
            class="mt-4 text-small"
            small
            striped
            hover
            :items="simpleTableData"></b-table-lite>
        </b-tab>
      </b-tabs>
    </b-row>
    <b-row v-if="niveaus_visible" :hidden="!niveaus_visible">
      <niveau-overview :niv-config="nivConfig"></niveau-overview>
    </b-row>
  </div>
</template>

<script>
  import { ajax } from '@/utils/ajax'
  import { checkUserSettings } from '@/utils/user'
  import { computed } from 'vue'
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
  import isObject from 'lodash/isObject'
  import jsPDF from 'jspdf'
  import NiveauOverview from '@/vue/home/analysis/niveau-overview.vue'
  import SupportGroupOverview from '@/vue/home/supports/support-group-overview.vue'
  import SupportGroupQualitative from '@/vue/home/supports/support-group-qualitative.vue'
  import takeRight from 'lodash/takeRight'
  import TargetControls from './target-controls.vue'
  import uniq from 'lodash/uniq'
  import {
    addTargetToChartData,
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

    inject: ['studentName', 'printDate', 'readOnly'], //TODO injection of weeks didn't work in some cases. check for other props as well
    provide: function () {
      return {
        restoreTarget: this.restoreTarget, // allowing the target controls to restore and set the target themselves
        setTarget: this.setTarget,
        loadStudentTargets: this.loadStudentTargets,
        targetStored: computed(() => this.targetStored), // computed necessary for reactivity
        viewConfig: computed(() => this.viewConfig),
        testData: computed(() => this.testData),
        weeks: computed(() => this.weeks),
      }
    },
    props: {
      annotations: Array,
      configuration: Object,
      group: Object,
      results: Array,
      students: Array,
      test: Object,
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
        dateUntilVal: null,
        deviationVal: null,
        forceUpdate: undefined,
        graphData: [],
        isInitialized: false,
        maxY: 0,
        selectedStudentId: -1,
        selectedSupportNeedFilter: undefined,
        selectedView: this.test?.configuration.views[0].key,
        simpleTableData: undefined,
        studentTargets: [],
        targetAdded: false,
        targetControlVisible: false,
        targetVal: null,
      }
    },
    computed: {
      displaySupportFilterHint() {
        return !this.graphData.length && this.selectedSupportNeedFilter
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
        if (this.selectedView) {
          return this.configuration.views.find(view => view.key === this.selectedView)
        } else {
          return this.configuration.views[0]
        }
      },
      nivConfig() {
        return this.viewConfig.niv_config
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
      niveaus_visible() {
        return this.selectedViewType === 'niveaus'
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
        return [...this.graphData]
      },
      targetIsSlopeVariant() {
        return this.settings.targets?.slope
      },
      targetIsEnabled() {
        return this.settings.targets?.enabled
      },
      dateUntilIsEnabled() {
        return this.settings.targets?.enabled || this.settings.trends?.enabled
      },
      deviationIsEnabled() {
        return this.targetIsEnabled && this.settings.targets?.deviation
      },
      trendIsEnabled() {
        return this.settings.trends?.enabled
      },
      extrapolationIsEnabled() {
        return this.settings.trends?.extrapolate
      },
      deviationStored() {
        const dev = this.targetStored?.deviation
        return dev === undefined ? null : dev
      },
      dateUntilStored() {
        const date = this.targetStored?.date_until
        return date === undefined ? null : date
      },
      targetAndTimeValid() {
        return this.targetValid && this.dateUntilVal
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
        const val = this.targetStored?.value
        return val === undefined ? null : val
      },
      targetStored() {
        // when no target is defined return null (nothing stored)
        const sId = this.selectedStudentId === -1 ? null : this.selectedStudentId // group targets are stored under a null student
        const res = this.studentTargets.find(
          target => target.student_id === sId && target.view === this.viewConfig?.key
        )
        return res === undefined ? null : res
      },
      /** Returns the stored target INCLUDING THE GROUP TARGET.
       * So when there's no individual target, but a group target, the latter is returned, else 'null' */
      targetStoredInclGroup() {
        if (this.targetStored !== null) {
          return this.targetStored
        }
        const groupTarget = this.studentTargets.find(
          target => target.student_id === null && target.view === this.viewConfig?.key
        )
        return groupTarget === undefined ? null : groupTarget
      },
      /** Returns the deviation value of stored target INCLUDING THE GROUP TARGET.
       * So when there's no individual target, but a group target, the latter is returned, else 'null' */
      deviationStoredInclGroup() {
        const dev = this.targetStoredInclGroup?.deviation
        return dev === undefined ? null : dev
      },
      /** Returns the date value of the stored target INCLUDING THE GROUP TARGET.
       * So when there's no individual target, but a group target, the latter is returned, else 'null' */
      dateUntilStoredInclGroup() {
        const date = this.targetStoredInclGroup?.date_until
        return date === undefined ? null : date
      },
      /** Returns the numerical value of stored target INCLUDING THE GROUP TARGET.
       * So when there's no individual target, but a group target, the latter is returned, else 'null' */
      targetValStoredInclGroup() {
        const val = this.targetStoredInclGroup?.value
        return val === undefined ? null : val
      },
      testData() {
        //TODO this is the only used for the attachedLevelImages. Might be better
        //TODO to include the information in this.test to save an api call.
        return this.testsStore.tests
          .find(area => area.id === this.test.area_id)
          .competences?.find(competence => competence.id === this.test.competence_id)
          .test_families?.find(family => family.id === this.test.test_family_id)
          .tests?.find(test => test.id === this.test.id)
      },
      attachedLevelImages() {
        return this.testData?.info_attachments.filter(
          attachment =>
            attachment.content_type.startsWith('image') && attachment.filename.startsWith('Niveau')
        )
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
          this.updateAnnotations()
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
    async created() {
      //TODO testsStore.fetch is quite expensive and only used once for some very particular information, see computed testData
      //TODO should be replaced with a different api endpoint
      if (!this.testsStore.tests.length) {
        await this.testsStore.fetch()
      }
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
      setSelectedView(key) {
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
        return series
      },

      createSeries(studentId, seriesKey, formatDate) {
        const results = this.results.filter(result => result?.student_id === studentId)

        return this.weeks.map(week => {
          const currentResult = results.find(r => r?.test_week === week)?.views?.[
            this.viewConfig.uses_data_from ? this.viewConfig.uses_data_from : this.viewConfig.key
          ]

          // if a week has no results add a point with an empty y value for this week
          if (currentResult === null || currentResult === undefined) {
            return { x: formatDate ? printDate(week) : week, y: null }
          }
          let point = this.XYFromResult(currentResult, seriesKey, formatDate, week)
          point.y = point.y?.toFixed(2)
          if (point.y === undefined) {
            point.y = null
          }

          this.maxY = Math.max(this.maxY, parseInt(point.y, 10 || 0))
          return point
        })
      },
      XYFromResult(result, seriesKey, formatDate, week) {
        if (result === null || result === undefined) {
          return undefined
        }
        let yVal

        const view = this.viewConfig

        if (seriesKey) {
          yVal = result?.[seriesKey]
        } else {
          // fixme result shouldn't be either object or number
          if (!isObject(result)) {
            yVal = result
          } else {
            yVal = result?.views[view.key]
          }
        }
        if (yVal === undefined) {
          yVal = null
        }
        return {
          x: formatDate ? printDate(week) : week ?? null,
          y: yVal,
        }
      },
      setStudentAndUpdate(studentId) {
        const previouslySelectedStudent = this.selectedStudentId
        this.selectedStudentId = studentId
        let animateChange = false
        // some combinations of views/selectedStudent/presence of results yield no views
        if (this.viewsWithGroupAndStudent.length) {
          this.setSelectedView(this.viewsWithGroupAndStudent[0].key)
        }
        if (studentId !== previouslySelectedStudent) {
          // if a new student is selected (or none meaning class view has been selected) update the target based on what is stored
          this.restoreTarget(false) // don't redraw, as updateView is about to be called anyway
          animateChange = true
        }
        this.updateView(animateChange)
      },

      async updateView(animate) {
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
          this.targetIsSlopeVariant,
          this.targetIsEnabled,
          animate,
          this.maxYValue
        )

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
                this.extrapolationIsEnabled ? this.dateUntilVal : null,
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
          if (this.targetIsEnabled) {
            this.appendSlopeTarget(gData, preparedOptions)
          }
          if (
            (trendlineData && this.extrapolationIsEnabled) ||
            (this.targetIsEnabled && this.targetIsSlopeVariant && this.targetVal)
          ) {
            this.expandXAxis(gData)
          }
        }

        this.graphData = []
        await this.$nextTick() // wait until the chart data is reset before setting the options, otherwise apexcharts will throw errors
        this.chartOptions = { ...this.chartOptions, ...preparedOptions }
        this.graphData = gData

        await this.$nextTick() // wait until the chart update is complete, otherwise the annotations will throw errors
        if (this.targetIsEnabled) {
          this.updateNonSlopeTarget()
        }
        this.updateAnnotations()
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
              dataForAnnotation.y,
              annotation.start
            )
          })
        // somehow, this.$refs.levumiChart.clearAnnotations() will only clear either point or xaxis-annotations, thus the loop
        this.annotations.forEach(annotation => {
          this.$refs.levumiChart?.removeAnnotation('a' + annotation.id)
        })

        xaxis.forEach(annotation => this.$refs.levumiChart?.addXaxisAnnotation(annotation))
        points.forEach(annotation => this.$refs.levumiChart?.addPointAnnotation(annotation))
      },

      // append the slope target line on the chart if the slope variant is chosen by the current view
      appendSlopeTarget(graphData, opt) {
        if (!this.targetIsSlopeVariant || !this.targetAndTimeValid) {
          return
        }
        // for the slope variant of a target line we need to add a series that will form this line and set chart options for it
        // first calculate the start point
        let startWeek = this.weeks.reduce((acc, w) => (w < acc ? w : acc), '2090-01-01')
        const startWeekResults = this.results.filter(res => res.test_week === startWeek)
        let startY
        if (this.selectedStudentId === -1) {
          // if no student is selected then calculate the average over the results of the first week
          startY =
            startWeekResults.reduce((acc, res) => {
              return acc + this.XYFromResult(res, null)?.y || 0
            }, 0) / startWeekResults.length
        } else {
          // if a student IS selected take their first result as the starting point
          const firstResult = this.results.reduce(
            (acc, res) => {
              return res.student_id === this.selectedStudentId &&
                Date.parse(res.test_week) < Date.parse(acc.test_week)
                ? res
                : acc
            },
            // if people still use this Levumi code in the year 90000 this will of course break
            // but then again, this means they wouldn't have looked at it for 88000 years... (specified max date is somewhere around 270000)
            { test_week: new Date(Date.UTC(90000, 12, 24)) }
          )
          startWeek = firstResult.test_week
          startY = this.XYFromResult(firstResult, null)?.y
        }
        const deviate = this.deviationIsEnabled

        const startPoint = { x: startWeek, y: startY }
        const startPointRange = deviate
          ? {
              x: startWeek,
              y: [startY, startY],
            }
          : null
        // the end point is then created by combining the date until which the target is to be reached with the chosen target value
        // when a deviation is desired also create a y value lowered by the accepted deviation
        const endPoint = { x: this.dateUntilVal, y: this.targetVal }
        const endPointRange = deviate
          ? {
              x: this.dateUntilVal,
              y: [this.targetVal * (1 - this.deviationVal / 100) + '', this.targetVal],
            }
          : null

        let endConditionY

        if (deviate) {
          endConditionY = undefined != endPointRange.y[0] && undefined != endPointRange.y[1]
        } else {
          endConditionY = undefined != endPoint.y
        }

        if (startPoint.x && endPoint.x && startY != undefined && endConditionY) {
          // if both start and end are well-defined add their line as a series
          addTargetToChartData(
            graphData,
            opt,
            deviate,
            startPoint,
            endPoint,
            startPointRange,
            endPointRange
          )
        }
      },

      // updates only the horizontal target lines as this is implemented through dynamic annotations
      // should only be called after the chart has been rendered or before the chart has been created
      updateNonSlopeTarget() {
        if (this.targetAdded) {
          // first, if there already is a target line remove it
          this.$refs.levumiChart?.removeAnnotation('target-annotation') // line for target itself
          this.$refs.levumiChart?.removeAnnotation('target-range-annotation') // range for allowed deviation
          this.targetAdded = false
        }

        if (this.targetValid && !this.targetIsSlopeVariant) {
          const y2 =
            this.deviationIsEnabled && this.deviationVal > 0
              ? this.targetVal - this.targetVal * (this.deviationVal / 100)
              : null
          if (y2) {
            this.$refs.levumiChart?.addYaxisAnnotation(
              targetRangeAnnotationOptions(this.targetVal, y2)
            )
          }

          this.$refs.levumiChart?.addYaxisAnnotation(targetAnnotationOptions(this.targetVal))
          this.targetAdded = true // necessary to keep track of because apexchart.removeAnnotation will fail if called without any dynamically added annotations
        }
      },

      /** Used in cases where the chart has already been rendered and only the target related data needs to be updated. */
      redrawTarget() {
        if (this.targetIsEnabled) {
          this.updateView(false)
        }
      },

      hasResults(student) {
        return this.results.some(result => result.student_id === student.id)
      },

      removeAnnotation(id) {
        this.$refs.levumiChart?.removeAnnotation('a' + id)
      },

      setTarget(targetVal, dateUntilVal, deviationVal, redraw) {
        this.targetVal = targetVal
        this.dateUntilVal = dateUntilVal
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
        this.setTarget(
          this.targetValStoredInclGroup,
          this.dateUntilStoredInclGroup,
          this.deviationStoredInclGroup,
          redraw
        )
      },

      expandXAxis(graphData) {
        // if an end date has been chosen make sure the x-axis reaches/includes this date
        // SIDE-FACT: technically expanding the x-axis isn't necessary when there's a slope target or an extrapolated trend
        //            as these automatically lead to this effect themselves, but I don't think we should check for that here
        if (!this.dateUntilIsEnabled || !this.dateUntilVal) {
          return
        }
        // only use the date if it lies after the last test result
        const maxDate = graphData[0]?.data.reduce((acc, d) => {
          return d.x > acc ? d.x : acc
        }, this.dateUntilVal)
        // to trick ApexCharts into drawing until there add an empty data point to the first series
        // TODO: it would be nice if this could be achieved without polluting the data
        if (maxDate === this.dateUntilVal) {
          graphData[0]?.data.push({ x: this.dateUntilVal, y: null })
        }
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
