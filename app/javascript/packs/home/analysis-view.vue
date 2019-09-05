<template>
    <div>
        <b-row>
            <b-button-group class='ml-3' size='sm'>
                <b-button class='mr-2'
                          size='sm'
                          variant='outline-primary'
                          :pressed="student_selected == -1"
                          :disabled='!has_group_views'
                          @click="student_selected = -1, view_selected = 0, updateView()">Ganze Klasse</b-button>
                <b-dropdown right :text="student_selected == -1 ? 'Individualgraph' : students[student_selected].name"
                            :variant="student_selected > -1 ? 'primary' : 'outline-primary'"
                            :disabled='!has_student_views'
                            size='sm'
                >
                    <b-dropdown-item v-for="(student, index) in students"
                                     :key="student.id"
                                     @click="student_selected = index, updateView()"
                                     class='text-small'
                    >
                        {{student.name}}
                    </b-dropdown-item>
                </b-dropdown>
            </b-button-group>
        </b-row>
        <b-row class='mt-2'>
            <b-button-group class='ml-3'>
                <b-button
                        v-for="(view, index) in configuration.views"
                        v-if="(student_selected == -1 && view.group) || (student_selected > -1 && view.student)"
                        :key="index"
                        class='mr-2 shadow-none'
                        size='sm'
                        variant='outline-secondary'
                        :pressed="view_selected == index"
                        @click="view_selected = index, updateView()"
                >
                    {{ view.label }}
                </b-button>
            </b-button-group>
        </b-row>
        <b-row :hidden="!graph_visible">
            <div id='chart' style='min-width: 100%;'></div>
        </b-row>
        <b-row :hidden="!graph_visible">
            <b-col>
                <div class='ml-2'>
                    <b-button id='comment_btn' size='sm' variant='outline-secondary' v-b-toggle="'annotation_collapse'">
                        Anmerkungen
                        <i class='when-closed fas fa-caret-down'></i>
                        <i class='when-opened fas fa-caret-up'></i>
                    </b-button>
                    <b-collapse id='annotation_collapse' v-on:shown="auto_scroll('#annotation_collapse')">
                        <b-form class='mt-2'
                                :action="'/groups/' + group.id + '/assessments/' + test.id + '/annotations'"
                                accept-charset='UTF-8'
                                method='post'
                                data-remote='true'
                                @submit="encode_text()"
                                v-on:ajax:success="success"
                                v-if="!read_only"
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
                                           :value="group.id"
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
                                <th v-if="!read_only">Aktionen</th>
                            </tr>
                            </thead>
                            <tbody>
                            <tr v-for="(a, i) in annotations"
                                v-if="a.view == view_selected && ((student_selected != -1 && students[student_selected].id == a.student_id) || (student_selected == -1 && a.group_id != null))"
                                :key="a.id"
                            >
                                <td>{{print_date(a.start)}}</td>
                                <td>{{print_date(a.end)}}</td>
                                <td>{{decode_text(a.content)}}</td>
                                <td v-if="!read_only">
                                    <!-- rails-ujs Link -->
                                    <a class='btn btn-block btn-sm btn-outline-danger'
                                       :href="'/groups/' + group.id + '/assessments/' + test.id + '/annotations/' + a.id"
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
        <b-row :hidden="!table_visible">
            <div class='m-4' id='table' style='width: 100%;'>
                <table class='table table-sm table-striped table-borderless mt-1 text-small'>
                    <thead>
                    <tr>
                        <th>Woche ab dem</th>
                        <th v-for="col in columns">{{col}}</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr v-for="entry in table_data">
                        <td>{{print_date(entry.week)}}</td>
                        <td v-for="col in columns"><span v-html="entry[col]"></span></td>
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
    export default {
        props: {
            annotations: Array,
            configuration: Object,
            group: Object,
            results: Array,
            students: Array,
            test: Object
        },
        computed: {
            columns() {
                return this.configuration.views[this.view_selected].columns || []
            },
            graph_visible() {
                return this.configuration.views[this.view_selected].type === 'graph' || this.configuration.views[this.view_selected].type === 'graph_table'
            },
            has_group_views() {
                for (let i = 0; i < this.configuration.views.length; ++i)
                  if (this.configuration.views[i].group == true)
                      return true
                return false
            },
            has_student_views() {
                for (let i = 0; i < this.configuration.views.length; ++i)
                    if (this.configuration.views[i].student == true)
                        return true
                return false
            },
            table_visible() {
                return this.configuration.views[this.view_selected].type === 'table' || this.configuration.views[this.view_selected].type === 'graph_table'
            },
            table_data() {
                if (this.configuration.views[this.view_selected].type === 'graph')
                    return []
                let weeks = this.weeks.slice().reverse()
                let res = []
                for (let w = 0; w < weeks.length; ++w) {
                    let found = false
                    for (let r = 0; r < this.results.length; ++r)
                        if (this.results[r].student_id == this.students[this.student_selected].id && this.results[r].test_week === weeks[w]) {
                            let temp = {}
                            for (let i = 0; i < this.configuration.views[this.view_selected].column_keys.length; ++i) {
                                let key = this.configuration.views[this.view_selected].column_keys[i]
                                let name = this.configuration.views[this.view_selected].columns[i]
                                temp[name] = this.results[r].views[this.configuration.views[this.view_selected].key][key]
                                if (temp[name] === undefined)
                                    temp[name] = '-'
                            }
                            res.push(deepmerge({'week': weeks[w]}, temp))
                            found = true
                            break
                        }
                    if (!found) {
                        let temp = {}
                        for (let c = 0; c < this.columns.length; ++c)
                            temp[this.columns[c]] = '-'
                        res.push(deepmerge({'week': weeks[w]}, temp))
                    }
                }
                return res
            }
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
                            animations: {
                                animateGradually: {
                                    enabled: false,
                                },
                            },
                            id: 'chart',
                            height: '500px',
                            width: '100%',
                            type: 'bar',
                            toolbar: {show:false},
                            zoom: {enabled: false}
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
                            animations: {
                                animateGradually: {
                                    enabled: false,
                                },
                            },
                            id: 'chart',
                            height: '500px',
                            width: '100%',
                            type: 'line',
                            toolbar: {show:false},
                            zoom: {enabled: false}
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
                            title: {text: 'Testwoche'}
                        }
                    }
                },
                student_selected: -1,
                view_selected: 0
            }
        },
        methods: {
            decode_text(text) {
                const id = this.group.id
                return text.replace(/\{"iv[^\}]*\}/g, function(match, p1, p2, p3, offset, string) {
                        return decrypt(match, '{Name}', id)
                    })
            },
            encode_text() {
                const id = this.group.id
                for (let i = 0; i < this.student_name_parts.length; ++i) {
                    const re = new RegExp('[^a-zaöüß_](' + this.student_name_parts[i] + ')[^a-zaöüß_]|' +
                        '^(' + this.student_name_parts[i] + ')[^a-zaöüß_]|' +
                        '[^a-zaöüß_](' + this.student_name_parts[i] + ')$|' +
                        '^(' + this.student_name_parts[i] + ')$', 'gi')
                    const match = re.exec(this.annotation_text)
                    if (match != null)
                        for (let m = 0; m < match.length; ++m)
                            this.annotation_text = this.annotation_text.replace(re, function(match, p1, p2, p3, p4, offset, string) {
                                if (p1 != undefined)
                                    return match.replace(p1, encrypt(p1, id))
                                if (p2 != undefined)
                                    return match.replace(p2, encrypt(p2, id))
                                if (p3 != undefined)
                                    return match.replace(p3, encrypt(p3, id))
                                else
                                    return match.replace(p4, encrypt(p4, id))
                            })
                }
                return true;
            },
            export_graph() {
                var dataURL = this.apexchart.dataURI().then((uri) => {
                    let pdf = new jsPDF({orientation: 'landscape'})
                        pdf.text(this.test.full_name, 10, 10)
                    if (this.student_selected == -1) {
                        pdf.text('Ganze Klasse - ' + this.configuration.views[this.view_selected].label, 10, 20)
                        pdf.addImage(uri, 'PNG', 10, 40, pdf.internal.pageSize.getWidth() - 15, pdf.internal.pageSize.getHeight() - 120)
                        pdf.save(this.group.label + '_' + this.test.shorthand + this.test.level + '_' + 'Klassenansicht' +  '.pdf')
                    }
                    else{
                        pdf.text(this.students[this.student_selected].name + ' - ' + this.configuration.views[this.view_selected].label, 10, 20)
                        pdf.addImage(uri, 'PNG', 10, 40, pdf.internal.pageSize.getWidth() - 15, pdf.internal.pageSize.getHeight() - 120)
                        pdf.save(this.group.label + '_' + this.test.shorthand + this.test.level + '_' + 'Kindansicht' +  '.pdf')

                    }
                })
            },
            updateView() {
                if (this.configuration.views[this.view_selected].type === 'table')
                    return
                //Optionen für Graph aus Default Werten und gewählten Werten bauen
                //Aktuell Unterscheidung bar/line wegen Bug in Apexcharts
                let opt = JSON.parse(JSON.stringify(
                    this.configuration.views[this.view_selected].options.chart.type === 'bar' ? this.default_options.bar : this.default_options.line
                ))
                opt = deepmerge(opt, JSON.parse(JSON.stringify(this.configuration.views[this.view_selected].options)))
                const view = this.configuration.views[this.view_selected]

                if (view.options.chart.type === 'line') {
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

               let res = []
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

                let maxY = view.options.yaxis ? view.options.yaxis.max ? view.options.yaxis.max : 0 : 0 //Für Platzierung der Kommentare

                //Leere Objekte füllen
                for (let i = 0; i < this.results.length; ++i) {
                    if (this.student_selected == -1 || view.series == undefined) {
                        let student = this.student_name(this.results[i].student_id)
                        let yVal = this.results[i].views[view.key].toFixed(2) //Macht das Runden hier immer Sinn?
                        if (yVal > maxY)
                            maxY = yVal
                        for (let r = 0; r < res.length; ++r) {
                            if (res[r].name == student) {
                                //Unterscheidung zw. Bar & Line Graphen wegen Bug in Apexcharts
                                if (view.options.chart.type === 'bar')
                                    res[r].data[this.weeks.indexOf(this.results[i].test_week)] = yVal
                                else
                                    res[r].data.push({
                                        x: this.weeks.indexOf(this.results[i].test_week),
                                        y: yVal
                                    })
                                break
                            }
                        }
                    } else if (this.results[i].student_id == this.students[this.student_selected].id) {
                        for (let r = 0; r < view.series.length; ++r) {
                            let yVal = this.results[i].views[view.key][view.series_keys[r]].toFixed(2) //Macht das Runden hier immer Sinn?
                            if (yVal > maxY)
                                maxY = yVal
                            if (this.results[i].views[view.key][view.series_keys[r]] != undefined)
                                //Unterscheidung zw. Bar & Line Graphen wegen Bug in Apexcharts
                                if (view.options.chart.type === 'bar')
                                        res[r].data[this.weeks.indexOf(this.results[i].test_week)] = yVal
                                else
                                    res[r].data.push({
                                        x: this.weeks.indexOf(this.results[i].test_week),
                                        y: yVal
                                    })
                        }
                    }
                }

                //Kommentare einfügen
                opt['annotations'] = {
                    position: 'front',
                    xaxis: [],
                    points: []
                }
                for (let i = 0; i < this.annotations.length; ++i)
                    if (this.annotations[i].view == this.view_selected &&
                        ((this.student_selected != -1 && this.students[this.student_selected].id == this.annotations[i].student_id) ||
                            (this.student_selected == -1 && this.annotations[i].group_id != null))) {
                        if (this.annotations[i].start != this.annotations[i].end && view.options.chart.type === 'line')
                            opt['annotations']['xaxis'].push({         //Fall 1: Bereichsanmerkung (nur für Liniengraphen)
                                x: this.weeks.indexOf(this.annotations[i].start),
                                x2: this.weeks.indexOf(this.annotations[i].end),
                                strokeDashArray: 1,
                                borderColor: '#c2c2c2',
                                fillColor: '#c2c2c2',
                                opacity: 0.3,
                                label: {
                                    borderColor: '#c2c2c2',
                                    borderWidth: 1,
                                    text: this.decode_text(this.annotations[i].content),
                                    textAnchor: this.weeks.indexOf(this.annotations[i].start) < 2 ? 'right' : this.weeks.indexOf(this.annotations[i].start) > this.weeks.length-2 ? 'left' : 'middle',
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
                        else  //Fall 2: Wochenanmerkungen, umgesetzt als Punktanmerkung
                            opt['annotations']['points'].push({
                                x: view.options.chart.type === 'line' ? this.weeks.indexOf(this.annotations[i].start) : this.print_date(this.annotations[i].start),
                                y: 1.025*maxY,
                                strokeDashArray: 1,
                                borderColor: '#c2c2c2',
                                fillColor: '#c2c2c2',
                                opacity: 0.3,
                                label: {
                                    borderColor: '#c2c2c2',
                                    borderWidth: 1,
                                    text: this.decode_text(this.annotations[i].content),
                                    textAnchor: 'middle',
                                    position: 'top',
                                    orientation: 'horizontal',
                                    offsetY: 15,
                                    style: {
                                        background: '#fff',
                                        color: '#777',
                                        fontSize: '12px',
                                        cssClass: 'apexcharts-xaxis-annotation-label',
                                    },
                                },
                            })
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
                this.updateView()
            },
            week_labels(start) {
                let res = [{value: null, text: start ? 'Von...' : 'Bis...'}]
                for (let i = this.weeks.length-1; i >= 0; --i)
                    res.push({value: this.weeks[i], text: this.print_date(this.weeks[i])})
                return res
            },
        },
        mounted() {
            this.student_selected = this.has_group_views ? -1 : 0
            this.updateView()
        },
        inject: ['auto_scroll', 'print_date', 'read_only', 'student_name', 'weeks', 'student_name_parts'],
        name: "analysis-view.vue"
    }
</script>

<style scoped>
    /* Darstellung des Collapse durch CSS toggeln*/
    .collapsed > .when-opened,
    :not(.collapsed) > .when-closed {
        display: none;
    }
</style>