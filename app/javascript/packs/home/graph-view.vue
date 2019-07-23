<template>
    <div>
        <b-row>
            <b-button-group class='ml-3'>
                <b-button class='mr-2'
                          size='sm'
                          variant='outline-primary'
                          :pressed="student_selected == -1"
                          @click="student_selected = -1; view_selected = 0; updateGraph();">Ganze Klasse</b-button>
                <b-button v-for="(student, index) in students"
                          :key="student.id"
                          class='mr-2'
                          size='sm'
                          variant='outline-primary'
                          :pressed="student_selected == index"
                          @click="student_selected = index; updateGraph();"
                >
                    {{student.name}}
                </b-button>
            </b-button-group>
        </b-row>
        <b-row class='mt-2'>
            <b-button-group class='ml-3'>
                <b-button
                        v-for="(view, index) in configuration.views"
                        v-if="(student_selected == -1 && view.group) || (student_selected > -1 && view.student)"
                        :key="index"
                        class='mr-2'
                        size='sm'
                        variant='outline-secondary'
                        :pressed="view_selected == index"
                        @click="view_selected = index; updateGraph();"
                >
                    {{ view.label }}
                </b-button>
            </b-button-group>
        </b-row>
        <b-row>
            <div id='chart'></div>
        </b-row>
        <b-row>
            <b-col>
                <div class='ml-2'>
                    <b-button id='comment_btn' size='sm' variant='outline-secondary' v-b-toggle="'annotation_collapse'">
                        Anmerkungen
                        <i class='when-closed fas fa-caret-down'></i>
                        <i class='when-opened fas fa-caret-up'></i>
                    </b-button>
                    <b-collapse id='annotation_collapse' v-on:shown="auto_scroll('#annotation_collapse')">
                        <b-form class='mt-2'
                                :action="'/groups/' + group + '/assessments/' + test.id + '/annotations'"
                                accept-charset='UTF-8'
                                method='post'
                                data-remote='true'
                                v-on:ajax:success="success"
                        >
                            <b-form-row class='text-small'>
                                <b-col>
                                    <label>Datumsbereich</label>
                                </b-col>
                                <b-col>
                                    <b-form-select name='annotation[start]' v-model="annotation_start" :options="week_labels(true)" size='sm'></b-form-select>
                                </b-col>
                                <b-col>
                                    <b-form-select name='annotation[end]' v-model="annotation_end" :options="week_labels(false)" size='sm'></b-form-select>
                                </b-col>
                            </b-form-row>
                            <b-form-row class='mt-1'>
                                <b-col>
                                    <!-- Hidden Field mit user bzw group id -->
                                    <input v-if="student_selected == -1"
                                           type='hidden'
                                           :value="group"
                                           name='annotation[group_id]'
                                    />
                                    <input v-else
                                           type='hidden'
                                           :value="students[student_selected].id"
                                           name='annotation[student_id]'
                                    />
                                    <!-- Hidden Field mit view -->
                                    <input type='hidden'
                                           :value="view_selected"
                                           name='annotation[view]'
                                    />
                                    <b-form-textarea
                                            class='text-small'
                                            name='annotation[content]'
                                            v-model="annotation_text"
                                            placeholder="Hier die Anmerkung eingeben..."
                                            rows="2"
                                            max-rows="3"
                                    >
                                    </b-form-textarea>
                                </b-col>
                            </b-form-row>
                            <b-form-row class='mt-1'>
                                <b-col>
                                    <b-button
                                            type='submit'
                                            variant='outline-success'
                                            size='sm'
                                            :disabled="annotation_text.trim().length === 0 || annotation_end == null || annotation_start == null"
                                    >
                                        <i class='fas fa-check'></i> Anmerkung speichern
                                    </b-button>
                                </b-col>
                            </b-form-row>
                        </b-form>
                        <table class='table table-sm table-striped table-borderless mt-1 text-small'>
                            <thead>
                            <tr>
                                <th>Von</th>
                                <th>Bis</th>
                                <th>Anmerkung</th>
                                <th>Aktionen</th>
                            </tr>
                            </thead>
                            <tbody>
                            <tr v-for="(a, i) in annotations"
                                v-if="a.view == view_selected && ((student_selected != -1 && students[student_selected].id == a.student_id) || (student_selected == -1 && a.group_id != null))"
                                :key="a.id"
                            >
                                <td>{{print_date(a.start)}}</td>
                                <td>{{print_date(a.end)}}</td>
                                <td>{{a.content}}</td>
                                <td>
                                    <!-- rails-ujs Link -->
                                    <a class='btn btn-block btn-sm btn-outline-danger'
                                       :href="'/groups/' + group + '/assessments/' + test.id + '/annotations/' + a.id"
                                       data-method='delete'
                                       data-remote='true'
                                       data-confirm='Anmerkung löschen! Sind Sie sicher?'
                                       v-on:ajax:success="annotations.splice(i, 1)"
                                    >
                                        <i class='fas fa-trash'></i> Löschen
                                    </a>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </b-collapse>
                </div>
            </b-col>
            <b-col>
                <b-button class='float-right mr-4' size='sm' variant='outline-primary' @click="export_graph">
                    <i class='fas fa-file-pdf'></i>
                    PDF erzeugen
                </b-button>
            </b-col>
         </b-row>
    </div>
</template>

<script>
    import deepmerge from 'deepmerge'
    import ApexCharts from 'apexcharts'
    import jsPDF from 'jspdf'
    export default {
        props: {
            annotations: Array,
            configuration: Object,
            group: Number,
            results: Array,
            students: Array,
            test: Object
        },
        data: function () {
            return {
                annotation_end: null,
                annotation_start: null,
                annotation_text: '',
                apexchart: null,
                default_options: {
                    bar: {
                        chart: {
                            id: 'chart',
                            height: '500px',
                            type: 'bar',
                            toolbar: {show:false},
                            zoom: {enabled: false},
                        },
                        legend: {position: 'top'},
                        grid: {
                            padding: {
                                right: 15,
                                left: 15
                            }
                        },
                        xaxis: {
                            tooltip: {enabled: false},
                            type: 'categories',
                            categories: this.weeks,
                            tickPlacement: 'between'
                        },
                        tooltip: {shared: true}
                    },
                    line: {
                        chart: {
                            id: 'chart',
                            height: '500px',
                            type: 'line',
                            toolbar: {show:false},
                            zoom: {enabled: false},
                        },
                        legend: {position: 'top'},
                        stroke: {
                            curve: 'straight',
                            width: 1
                        },
                        grid: {
                            padding: {
                                right: 35,
                                left: 35,
                            }
                        },
                        tooltip: {
                            enabled: true,
                            x: {show: false}
                        },
                        markers: {
                            size: 4,
                            hover: {sizeOffset: 2}
                        },
                        xaxis: {
                            tooltip: {enabled: false},
                            type: 'numeric',
                            min: 0,
                            max: this.weeks.length-1,
                            tickAmount: this.weeks.length-1,
                            labels: {
                                minHeight: 20
                            },
                        }
                    }
                },
                student_selected: -1,
                view_selected: 0
            }
        },
        methods: {
            export_graph() {
                var dataURL = this.apexchart.dataURI().then((uri) => {
                    let pdf = new jsPDF({orientation: 'landscape'})
                        pdf.text(this.test.full_name, 10, 10)
                    if (this.student_selected == -1)
                        pdf.text('Ganze Klasse - ' + this.configuration.views[this.view_selected].label, 10, 20)
                    else
                        pdf.text(this.students[this.student_selected].name + ' - ' + this.configuration.views[this.view_selected].label, 10, 10)
                    pdf.addImage(uri, 'PNG', 10, 40, pdf.internal.pageSize.getWidth() - 15, pdf.internal.pageSize.getHeight() - 120)
                    pdf.save(this.test.shorthand + '.pdf')
                })
            },
            updateGraph() {
                //Options für die gewählte Ansicht mit den globalen Options vereinen

                //Optionen für Graph aus Default Werten und gewählten Werten bauen
                //Aktuell Unterscheidung bar/line wegen Bug in Apexcharts
                let opt = JSON.parse(JSON.stringify(
                    this.configuration.views[this.view_selected].options.chart.type === 'bar' ? this.default_options.bar : this.default_options.line
                ))
                opt = deepmerge(opt, JSON.parse(JSON.stringify(this.configuration.views[this.view_selected].options)))

                if (this.configuration.views[this.view_selected].options.chart.type === 'line') {
                    opt.xaxis.labels.formatter = function (value, timestamp, index) {
                        if (index >= this.weeks.length)
                            return ""
                        else
                            return this.print_date(this.weeks[index])
                    }.bind(this)
                }
                else
                    for (let i = 0; i < opt.xaxis.categories.length; ++i)
                        opt.xaxis.categories[i] = this.print_date(opt.xaxis.categories[i])

                //Kommentare einfügen
                opt['annotations'] = {
                    position: 'front',
                    xaxis: []
                }
                for (let i = 0; i < this.annotations.length; ++i)
                    if (this.annotations[i].view == this.view_selected &&
                        ((this.student_selected != -1 && this.students[this.student_selected].id == this.annotations[i].student_id) ||
                            (this.student_selected == -1 && this.annotations[i].group_id != null))) {
                        opt['annotations']['xaxis'].push({
                            x: this.weeks.indexOf(this.annotations[i].start),
                            x2: this.annotations[i].start == this.annotations[i].end ? null : this.weeks.indexOf(this.annotations[i].end),
                            strokeDashArray: 1,
                            borderColor: '#c2c2c2',
                            fillColor: '#c2c2c2',
                            opacity: 0.3,
                            label: {
                                borderColor: '#c2c2c2',
                                borderWidth: 1,
                                text: this.annotations[i].content,
                                textAnchor: 'middle',
                                position: 'top',
                                orientation: 'horizontal',
                                style: {
                                    background: '#fff',
                                    color: '#777',
                                    fontSize: '12px',
                                    cssClass: 'apexcharts-xaxis-annotation-label',
                                },
                            },
                        })
                    }
                let res = []
                const view = this.configuration.views[this.view_selected]
                //Ein "leeres" Objekt für alle Datenserien anlegen
                if (this.student_selected == -1) {
                    for (let s = 0; s < this.students.length; ++s)
                        res.push({
                            'name': this.student_name(this.students[s].id),
                            'data': []
                        })
                } else {
                    if (view.series == undefined) {
                        res.push({
                            'name': this.student_name(this.students[this.student_selected].id),
                            'data': []
                        })
                    } else
                        for (let s = 0; s < view.series.length; ++s)
                            res.push({
                                'name': view.series[s],
                                'data': []
                            })
                }

                //Unterscheidung zw. Bar & Line Graphen wegen Bug in Apexcharts
                if (view.options.chart.type === 'bar') {
                    for (let r = 0; r < res.length; ++r) {
                        res[r].data = JSON.parse(JSON.stringify(this.weeks))
                        res[r].data.fill(null)
                    }
                }

                //Leere Objekte füllen
                for (let i = 0; i < this.results.length; ++i) {
                    if (this.student_selected == -1 || view.series == undefined) {
                        let student = this.student_name(this.results[i].student_id)
                        for (let r = 0; r < res.length; ++r) {
                            if (res[r].name == student) {
                                //Unterscheidung zw. Bar & Line Graphen wegen Bug in Apexcharts
                                if (view.options.chart.type === 'bar')
                                    res[r].data[this.weeks.indexOf(this.results[i].test_week)] = this.results[i].results[view.label].toFixed(2) //Macht das Runden hier immer Sinn?
                                else
                                    res[r].data.push({
                                        x: this.weeks.indexOf(this.results[i].test_week),
                                        y: this.results[i].results[view.label].toFixed(2), //Macht das Runden hier immer Sinn?
                                    })
                                break
                            }
                        }
                    } else if (this.results[i].student_id == this.students[this.student_selected].id) {
                        for (let r = 0; r < view.series.length; ++r) {
                            //Unterscheidung zw. Bar & Line Graphen wegen Bug in Apexcharts
                            if (view.options.chart.type === 'bar')
                                res[r].data[this.weeks.indexOf(this.results[i].test_week)] = this.results[i].results[view.label][view.series[r]].toFixed(2) //Macht das Runden hier immer Sinn?
                            else
                                res[r].data.push({
                                    x: this.weeks.indexOf(this.results[i].test_week),
                                    y: this.results[i].results[view.label][view.series[r]].toFixed(2), //Macht das Runden hier immer Sinn?
                                })
                        }
                    }
                }
                if (this.apexchart != null)
                    this.apexchart.destroy()
                this.apexchart = new ApexCharts(document.querySelector('#chart'), deepmerge(opt, {series: res}))
                this.apexchart.render()

            },
            success(event) {  //Attributwerte aus AJAX Antwort übernehmen und View updaten
                this.annotations.splice(0, 0, event.detail[0])
                this.annotation_start = null
                this.annotation_end = null
                this.annotation_text = ''
                this.updateGraph()
            },
            week_labels(start) {
                let res = [{value: null, text: start ? 'Von...' : 'Bis...'}]
                for (let i = this.weeks.length-1; i >= 0; --i)
                    res.push({value: this.weeks[i], text: this.print_date(this.weeks[i])})
                return res
            },
        },
        mounted() {
            this.updateGraph()
        },
        inject: ['student_name', 'weeks', 'print_date', 'auto_scroll'],
        name: "graph-view.vue"
    }
</script>

<style scoped>
    /* Darstellung des Collapse durch CSS toggeln*/
    .collapsed > .when-opened,
    :not(.collapsed) > .when-closed {
        display: none;
    }
</style>