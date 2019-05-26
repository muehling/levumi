<template>
    <div>
        <b-row>
            <b-button-group class='ml-3'>
                <b-button class='mr-2'
                          size='sm'
                          variant='outline-primary'
                          :pressed="student_selected == -1"
                          @click="student_selected = -1; view_selected = 0;">Ganze Klasse</b-button>
                <b-button v-for="(student, index) in students"
                          :key="student.id"
                          class='mr-2'
                          size='sm'
                          variant='outline-primary'
                          :pressed="student_selected == index"
                          @click="student_selected = index"
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
                        @click="view_selected = index"
                >
                    {{ view.label }}
                </b-button>
            </b-button-group>
        </b-row>
        <b-row>
            <div id='chart_area'>
                <apexchart ref='chart' width='100%' height='500px' :options="options" :series="series"></apexchart>
            </div>
        </b-row>
        <b-row>
            <div class='ml-3'>
                <b-button size='sm' variant='outline-secondary' v-b-toggle="'annotation_collapse'">
                    Kommentare
                    <i class='when-closed fas fa-caret-down'></i>
                    <i class='when-opened fas fa-caret-up'></i>
                </b-button>
                <b-collapse id='annotation_collapse' v-on:shown="$parent.auto_scroll('#annotation_collapse')">
                    <b-form class='mt-2'
                            :action="'/groups/' + $parent.group + '/assessments/' + $parent.test + '/annotations'"
                            accept-charset='UTF-8'
                            method='post'
                            data-remote='true'
                            v-on:ajax:success="success"
                    >
                        <b-form-row>
                            <b-col>
                                <label>Anzeigebereich</label>
                            </b-col>
                            <b-col>
                                <b-form-select name='annotation[start]' v-model="annotation_start" :options="weeks(true)" size='sm'></b-form-select>
                            </b-col>
                            <b-col>
                                <b-form-select name='annotation[end]' v-model="annotation_end" :options="weeks(false)" size='sm'></b-form-select>
                            </b-col>
                        </b-form-row>
                        <b-form-row class='mt-1'>
                            <b-col>
                                <!-- Hidden Field mit user bzw group id -->
                                <input v-if="student_selected == -1"
                                       type='hidden'
                                       :value="$parent.group"
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
                    <table class='table table-sm table-striped table-borderless mt-1'>
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
                            <td>{{a.start}}</td>
                            <td>{{a.end}}</td>
                            <td>{{a.content}}</td>
                            <td>
                                <!-- rails-ujs Link -->
                                <a class='btn btn-block btn-sm btn-outline-danger'
                                   :href="'/groups/' + $parent.group + '/assessments/' + $parent.test + '/annotations/' + a.id"
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
        </b-row>
    </div>
</template>

<script>
    import cloner from 'cloner';
    export default {
        props: {
            students: Array,
            results: Array,
            annotations: Array,
            configuration: Object,
        },
        data: function () {
            return {
                annotation_end: null,
                annotation_start: null,
                annotation_text: '',
                default_options: {
                    chart: {
                        id: 'chart',
                        toolbar: {
                            show: false,
                        },
                    },
                    grid: {
                        padding: {
                            right: 15,
                            left: 15
                        }
                    },
                    xaxis: {
                        type: 'category',
                        categories: []
                    },
                    markers: {
                        size: 4,
                        hover: {
                            sizeOffset: 2
                        }
                    },
                    stroke: {
                        width: 1
                    },
                    tooltip: {
                        shared: true
                    }
                },
                student_selected: -1,
                view_selected: 0,
            }
        },
        computed: {
            options: function () { //Options für die gewählte Ansicht mit den globalen Options vereinen
                let weeks = []
                for (let i = 0; i < this.results.length; ++i)
                    if (this.results[i].test_week != null)
                        weeks.push(this.results[i].test_week)
                weeks = weeks.filter((v, i, a) => a.indexOf(v) === i)
                let opt = JSON.parse(JSON.stringify(this.default_options))
                opt.xaxis.categories = cloner.shallow.copy(weeks)
                opt = cloner.deep.merge(opt, JSON.parse(JSON.stringify(this.configuration.views[this.view_selected].options)))
                return opt
            },
            series: function () {  //Bereitet die Results-Daten so auf, dass sie im Chart dargestellt werden können.
                let res = []
                const view = this.configuration.views[this.view_selected]
                //Ein "leeres" Objekt für alle Datenserien anlegen
                if (this.student_selected == -1) {
                    for (let s = 0; s < this.students.length; ++s)
                        res.push({
                            'name': this.$parent.student_name(this.students[s].id),
                            'data': []
                        })
                } else {
                    if (view.series == undefined) {
                        res.push({
                            'name': this.$parent.student_name(this.students[this.student_selected].id),
                            'data': []
                        })
                    } else
                        for (let s = 0; s < view.series.length; ++s)
                            res.push({
                                'name': view.series[s],
                                'data': []
                            })
                }
                //Leere Objekte füllen
                for (let i = 0; i < this.results.length; ++i) {
                    if (this.student_selected == -1 || view.series == undefined) {
                        let student = this.$parent.student_name(this.results[i].student_id)
                        let week = this.results[i].test_week
                        for (let r = 0; r < res.length; ++r) {
                            if (res[r].name == student) {
                                res[r].data.push({
                                    x: this.results[i].test_week,
                                    y: this.results[i].results[view.label].toFixed(2), //Macht das Runden hier immer Sinn?
                                })
                                break
                            }
                        }
                    } else if (this.results[i].student_id == this.students[this.student_selected].id) {
                        for (let r = 0; r < view.series.length; ++r) {
                            res[r].data.push({
                                x: this.results[i].test_week,
                                y: this.results[i].results[view.label][view.series[r]].toFixed(2), //Macht das Runden hier immer Sinn?
                            })
                        }
                    }
                }
                return res;
            }
        },
        methods: {
            add_annotation() {
                let x1 = new Date(this.results[Math.floor(Math.random() * this.results.length)].test_week).getTime()
                let x2 = x1
                if (Math.random() > 0.5)
                    x2 = new Date(this.results[Math.floor(Math.random() * this.results.length)].test_week).getTime()
                if (x1 > x2) {
                    let t = x1
                    x1 = x2
                    x2 = t
                }
                this.$refs.chart.addXaxisAnnotation({
                    x: x1,
                    x2: x2,
                    strokeDashArray: 0,
                    borderColor: '#775DD0',
                    label: {
                        text: 'Lorem Ipsum'
                    },
                }, true)
            },
            success(event) {  //Attributwerte aus AJAX Antwort übernehmen und View updaten
                this.annotations.splice(0, 0, event.detail[0])
                this.annotation_start = null
                this.annotation_end = null
                this.annotation_text = ''
            },
            weeks(start) {
                let res = [{value: null, text: start ? 'Von...' : 'Bis...'}]
                for (let i = 0; i < this.$parent.weeks.length; ++i)
                    res.push({value: this.$parent.weeks[i], text: this.$parent.weeks[i]})
                return res
            },
        },
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