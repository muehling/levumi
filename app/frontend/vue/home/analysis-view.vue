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
          @click="updateView(-1)"
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
            v-b-toggle="'annotation_collapse'"
            hidden="true"
            size="sm"
            variant="outline-secondary"
          >
            Anmerkungen
            <i class="when-closed fas fa-caret-down"></i>
            <i class="when-opened fas fa-caret-up"></i>
          </b-button>
          <b-collapse id="annotation_collapse" @shown="autoScroll('#annotation_collapse')">
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
  </div>
</template>

<script>
  import deepmerge from 'deepmerge'
  import ApexCharts from 'apexcharts'
  import jsPDF from 'jspdf'
  import {
    apexChartOptions,
    annotationsLineOptions,
    annotationsPointOptions,
  } from './apexChartHelpers'
  import { encryptWithMasterKeyAndGroup, decryptStudentName } from '../../utils/encryption'

  export default {
    name: 'AnalysisView',
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
        annotation_end: null,
        annotation_start: null,
        annotation_text: '',
        apexchart: null,
        default_options: apexChartOptions(this.weeks),
        studentSelected: -1,
        view_selected: 0,
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
    },
    mounted() {
      this.studentSelected = this.has_group_views
        ? -1
        : this.studentsWithResults[this.studentsWithResults.length - 1].id
        ? this.studentsWithResults[0].id
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
      export_graph() {
        this.apexchart.dataURI().then(uri => {
          let pdf = new jsPDF({ orientation: 'landscape' })
          pdf.text(this.test.full_name, 10, 10)
          if (this.studentSelected == -1) {
            pdf.text('Ganze Klasse - ' + this.configuration.views[this.view_selected].label, 10, 20)
            pdf.addImage(
              uri['imgURI'],
              'PNG',
              10,
              40,
              pdf.internal.pageSize.getWidth() - 15,
              pdf.internal.pageSize.getHeight() - 120
            )
            pdf.save(
              this.group.label +
                '_' +
                this.test.shorthand +
                this.test.level +
                '_' +
                'Klassenansicht' +
                '.pdf'
            )
          } else {
            pdf.text(
              this.getStudentById(this.studentSelected).name +
                ' - ' +
                this.configuration.views[this.view_selected].label,
              10,
              20
            )
            pdf.addImage(
              uri['imgURI'],
              'PNG',
              10,
              40,
              pdf.internal.pageSize.getWidth() - 15,
              pdf.internal.pageSize.getHeight() - 120
            )
            pdf.save(
              this.group.label +
                '_' +
                this.test.shorthand +
                this.test.level +
                '_' +
                'Kindansicht' +
                '.pdf'
            )
          }
        })
      },
      updateView(studentId) {
        this.studentSelected = studentId
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

        //x-Achsen Beschriftung mit Testwochen
        if (view.options.chart.type === 'line') {
          opt.xaxis.labels.formatter = function (value, timestamp, index) {
            if (index >= this.weeks.length) {
              return ''
            } else {
              return this.printDate(this.weeks[index])
            }
          }.bind(this)
        } else {
          for (let i = 0; i < opt.xaxis.categories.length; ++i) {
            opt.xaxis.categories[i] = this.printDate(opt.xaxis.categories[i])
          }
        }
        //Ergebnisse aufbereiten
        let res = []
        //Ein "leeres" Objekt für alle Datenserien anlegen
        if (this.studentselected == -1) {
          for (let s = 0; s < this.students.length; ++s) {
            if (this.has_results(this.students[s])) {
              res.push({
                name: this.getStudentName(this.students[s].id),
                data: [],
              })
            }
          }
        } else {
          if (view.series == undefined) {
            res.push({
              name: this.getStudentName(this.studentSelected),
              data: [],
            })
          } else {
            for (let s = 0; s < view.series.length; ++s) {
              res.push({
                name: view.series[s],
                data: [],
              })
            }
          }
        }

        //Unterscheidung zw. Bar & Line Graphen wegen Bug in Apexcharts
        if (view.options.chart.type === 'bar') {
          for (let r = 0; r < res.length; ++r) {
            res[r].data = JSON.parse(JSON.stringify(this.weeks))
            res[r].data.fill(null)
          }
        }

        let maxY = view.options.yaxis ? (view.options.yaxis.max ? view.options.yaxis.max : 0) : 0 //Für Platzierung der Kommentare

        //Leere Objekte füllen
        for (let i = 0; i < this.results.length; ++i) {
          if (this.studentSelected == -1 || view.series == undefined) {
            let student = this.getStudentName(this.results[i].student_id)
            let yVal = this.results[i].views[view.key].toFixed(2) //Macht das Runden hier immer Sinn?
            if (yVal > maxY) {
              maxY = yVal
            }
            for (let r = 0; r < res.length; ++r) {
              if (res[r].name == student) {
                //Unterscheidung zw. Bar & Line Graphen wegen Bug in Apexcharts
                if (view.options.chart.type === 'bar') {
                  res[r].data[this.weeks.indexOf(this.results[i].test_week)] = yVal
                } else {
                  res[r].data.push({
                    x: this.weeks.indexOf(this.results[i].test_week),
                    y: yVal,
                  })
                }
                break
              }
            }
          } else if (this.results[i].student_id == this.studentSelected) {
            for (let r = 0; r < view.series.length; ++r) {
              if (!(view.series_keys[r] in this.results[i].views[view.key])) {
                continue
              }
              let yVal = this.results[i].views[view.key][view.series_keys[r]].toFixed(2) //Macht das Runden hier immer Sinn?
              if (yVal > maxY) {
                maxY = yVal
              }
              if (this.results[i].views[view.key][view.series_keys[r]] != undefined) {
                if (view.options.chart.type === 'bar') {
                  //Unterscheidung zw. Bar & Line Graphen wegen Bug in Apexcharts
                  res[r].data[this.weeks.indexOf(this.results[i].test_week)] = yVal
                } else {
                  res[r].data.push({
                    x: this.weeks.indexOf(this.results[i].test_week),
                    y: yVal,
                  })
                }
              }
            }
          }
        }

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
        const options = { ...opt, series: res }

        this.apexchart = new ApexCharts(document.querySelector(opt.chart.id), options)
        this.apexchart.render()
      },
      success(event) {
        //Attributwerte aus AJAX Antwort übernehmen und View updaten
        this.annotations.splice(0, 0, event.detail[0])
        this.annotation_start = null
        this.annotation_end = null
        this.annotation_text = ''
        this.updateView(-1)
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
