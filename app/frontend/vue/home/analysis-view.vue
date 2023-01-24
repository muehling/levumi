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
            view_selected = 0
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
            @click="toggle_active_collapse('annotation_collapse')"
            size="sm"
            variant="outline-secondary"
          >
            Anmerkungen
            <i class="when-closed fas fa-caret-down"></i>
            <i class="when-opened fas fa-caret-up"></i>
          </b-button>
          <b-button
              class="ml-2"
              id="target_btn"
              :class="target_control_visible ? null : 'collapsed'"
              :aria-expanded="target_control_visible ? 'true' : 'false'"
              aria-controls="target_collapse"
              @click="toggle_active_collapse('target_collapse')"
              size="sm"
              variant="outline-secondary"
          >
            Zielwert
            <i class="when-closed fas fa-caret-down"></i>
            <i class="when-opened fas fa-caret-up"></i>
          </b-button>
          <b-collapse id="target_collapse" v-model="target_control_visible" @shown="autoScroll('#target_collapse')">
            <b-form
              v-if="!readOnly"
              class="mt-2"
            >
              <b-form-row class="text-small">
                <b-col class="d-flex">
                  <label class="mr-3">Zielwert:</label>
                  <b-form-input
                    id="target_input"
                    v-model="target_val"
                    placeholder="Hier Zielwert eingeben"
                    trim
                    type="number"
                    inputmode="decimal"
                    min="0"
                    step="0.01"
                    lang="de"
                    size="sm"
                    @update="updateTarget"
                  ></b-form-input>
                </b-col>
              </b-form-row>
              <b-form-row class="mt-1">
                <b-col>
                  <b-button
                    variant="outline-success"
                    size="sm"
                    :disabled="!target_valid"
                    @click="save_target(false)"
                  >
                    <i class="fas fa-check"></i> Zielwert speichern
                  </b-button>
                  <!-- the click doesn't always need to trigger a request; when the stored target is null anyway then we can skip it -->
                  <b-button
                    :hidden="!target_valid && target_stored == null"
                    class="ml-2"
                    variant="outline-danger"
                    size="sm"
                    @click="target_stored == null ? restore_target() : save_target(true)"
                  >
                    <i class="fas fa-check"></i> Zielwert löschen
                  </b-button>
                  <b-button
                      :hidden="target_val === target_stored || target_stored == null"
                      class="ml-2"
                      variant="outline-warning"
                      size="sm"
                      @click="restore_target"
                  >
                    <i class="fas fa-check"></i> Zielwert zurücksetzen
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
    apexChartOptions,
    annotationsLineOptions,
    annotationsPointOptions,
    annotationsTargetOptions,
  } from './apexChartHelpers'
  import { encryptWithMasterKeyAndGroup, decryptStudentName } from '../../utils/encryption'
  import {ajax} from "@/utils/ajax";
  import apiRoutes from "@/vue/routes/api-routes";

  export default {
    name: 'AnalysisView',
  inject: ['autoScroll', 'printDate', 'readOnly', 'studentName', 'weeks', 'student_name_parts', 'groupTargetStored', 'fetchAssessments'],
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
        target_control_visible: false,
        target_val: this.groupTargetStored, // starts out as group target since no student is selected at start
        target_added: false,
        apexchart: null,
        default_options: apexChartOptions(this.weeks),
        studentSelected: -1,
        student_targets: [],
        view_selected: 0,
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
        return this.configuration.views[this.view_selected].columns || []
      },
      selectedViewType() {
        return this.configuration.views[this.view_selected].type
      },
      graph_visible() {
        return (
          this.configuration.views[this.view_selected].type === 'graph' ||
          this.configuration.views[this.view_selected].type === 'graph_table'
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
          this.configuration.views[this.view_selected].type === 'table' ||
          this.configuration.views[this.view_selected].type === 'graph_table'
        )
      },
      table_data() {
        if (this.configuration.views[this.view_selected].type === 'graph') {
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
                i < this.configuration.views[this.view_selected].column_keys.length;
                ++i
              ) {
                let key = this.configuration.views[this.view_selected].column_keys[i]
                let name = this.configuration.views[this.view_selected].columns[i]
                temp[name] =
                  this.results[r].views[this.configuration.views[this.view_selected].key][key]
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
      target_valid() {
        return this.target_val != null &&
            this.target_val.trim().length !== 0 &&
            !Number.isNaN(this.target_val) &&
            Number(this.target_val) >= 0
      },
      target_id() {
        return this.target_stored_raw?.id
      },
      target_stored() {
        // when target_stored_raw is undefined and a student is selected then this means that the stored target is defined as null (nothing stored)
        // this convention allows other actors that expect target_stored to be a number or null to work properly in both the group case and the individual student case
        let res
        if (this.studentSelected === -1) { res = this.groupTargetStored }
        else {
          const raw = this.target_stored_raw
          res = raw === undefined ? null : raw.value
        }
        return res
      },
      target_stored_raw() {
        return this.studentSelected === -1 ?
            undefined :
            this.student_targets.find(target => target.student_id === this.studentSelected)
      },
    },
    mounted() {
      this.load_student_targets()
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
        this.updateView()
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
          title = `${this.getStudentById(this.studentSelected).name} - ${view.label}`
          filename = `${this.group.label}_${this.test.shorthand}_${this.test.level}_Kindansicht`
        }
        await this.createPdf(title, filename)
      },

      createSeries(studentId, seriesKey) {
        const results = this.results.filter(result => result.student_id === studentId)
        const view = this.configuration.views[this.view_selected]
        return this.weeks.map(week => {
          const currentResult = results.find(r => r?.test_week === week)

          let yVal
          if (seriesKey) {
            yVal = currentResult?.views[view.key][seriesKey]?.toFixed(2) || null
          } else {
            yVal = currentResult?.views[view.key]?.toFixed(2) || null
          }
          return {
            x: this.printDate(week),
            y: yVal,
          }
        })
      },
      set_student(student_id) {
        const oldValue = this.studentSelected
        this.studentSelected = student_id
        if (student_id !== oldValue) {
          // if a new student is selected (or none meaning class view has been selected) update the target based on what is stored
          this.restore_target()
        }

        this.updateView()
      },
      updateView() {
        if (this.configuration.views[this.view_selected].type === 'table') {
          return
        }
        const view = this.configuration.views[this.view_selected]

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

        if (this.apexchart != null) {
          this.apexchart.destroy()
        }

        opt.chart.id = '#chart_' + this.group.id + '_' + this.test.id
        const options = { ...opt, series: graphData }

        this.apexchart = new ApexCharts(document.querySelector(opt.chart.id), options)
        this.apexchart.render()

        this.updateTarget() // should only be called after the chart has been rendered
      },
      // show or remove the horizontal target line on the chart;
      // should only be called after the chart has been rendered or before the chart has been created
      updateTarget() {
        if (this.apexchart == null) { return }  // without an active chart there's nothing to update
        if (this.target_added) {  // first, if there already is a target line remove it
          this.apexchart.removeAnnotation(annotationsTargetOptions(0).id) // targetY doesn't matter here
          this.target_added = false
        }
        if (this.target_valid) {
          this.apexchart.addYaxisAnnotation(annotationsTargetOptions(this.target_val))
          this.target_added = true  // necessary to keep track of because apexchart.removeAnnotation will fail if called without any dynamically added annotations
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
      restore_target() {
        this.target_val = this.target_stored
        this.updateTarget()
      },
      async save_target(reset) {
        // TODO: this cascade of conditions is slightly ugly, but I've not yet decided on the best way to solve it instead
        const res = await ajax(
          this.studentSelected === -1 ?
            apiRoutes.targets.saveGroup(this.group.id, this.test.id, {
              assessment: { target: reset ? null : this.target_val },
            })
            :
              this.target_stored !== null ?
                reset ?
                apiRoutes.targets.deleteStudent(this.group.id, this.test.id, this.target_id)
                :
                apiRoutes.targets.updateStudent(this.group.id, this.test.id, this.target_id, {
                  target: { value: this.target_val, student_id: this.studentSelected },
                })
              :
              apiRoutes.targets.createStudent(this.group.id, this.test.id, {
                target: { value: this.target_val, student_id: this.studentSelected },
              })
        )
        if (res.status === 200) {
          if (this.studentSelected === -1) {
            this.fetchAssessments()   // only has to be fetched when class targets are changed, as only they are included in the assessmentsStore
          } else {
            this.load_student_targets()   // this function instead only loads the detail information for the current assessment
          }
        }
      },
      async load_student_targets() {
        const res = await ajax(
          apiRoutes.targets.getStudents(this.group.id, this.test.id)
        )
        if (res.status === 200) {
          const text = await res.text()
          const result = JSON.parse(text)
          this.student_targets = result.targets
        } else {
          this.student_targets = []
        }
        // lastly set the displayed value to the just loaded one
        this.restore_target()
      },
      toggle_active_collapse(collapse_id) {
        // TODO: this is a bit clunky; could probably be solved more elegantly
        switch (collapse_id) {
          case 'annotation_collapse':
            this.target_control_visible = false
            this.annotation_visible = !this.annotation_visible
            break
          case 'target_collapse':
            this.annotation_visible = false
            this.target_control_visible = !this.target_control_visible
            break
        }
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
