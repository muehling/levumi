<template>
  <b-card no-body class="mt-3 pb-0 mb-1">
    <b-tabs pills card>
      <b-tab :active="deep_link" class="m-3">
        <div slot="title">
          Messungen
          <span v-if="!is_active" class="badge badge-danger"><i class="fas fa-pause"></i></span>
        </div>
        <!-- Neue Messungen -->
        <div class="alert alert-secondary">
          <div v-if="readOnly">
            <p>
              Diese Klasse ist mit Ihnen zur Ansicht geteilt, daher können Sie keine eigenen
              Messungen durchführen.
            </p>
          </div>
          <div v-else-if="test.archive">
            <p>
              Dieser Test wurde vom Levumi-Team überarbeitet (z.B. Korrektur einer Aufgabe, Änderung
              in der Ergebnisdarstellung). Unter dem Button "Aktuell" finden Sie die neuste
              Testversion, in der Sie ab jetzt die Testungen durchführen können.
            </p>
          </div>
          <div v-else-if="students.length == 0">
            <p>
              Es sind in dieser Klasse noch keine Schüler:innen angelegt. Um in dieser Klasse Testen
              zu können, legen Sie bitte neue Schüler:innen im Klassenbuch an.
            </p>
          </div>
          <div v-else-if="!studentTest">
            <p class="text-light bg-secondary">&nbsp;Durchführung</p>
            <p class="text-small">{{ test.description.usage }}</p>
            <p class="text-light bg-secondary">&nbsp;Hinweise</p>
            <p class="text-small">
              Klicken Sie auf einen Namen um den Test sofort zu starten. Am Ende des Tests werden
              Sie auf diese Seite zurückgeleitet.<br />
              Grün hinterlegte Namen wurden in dieser Woche bereits getestet. Wenn Sie erneut testen
              möchten, löschen Sie bitte zuerst die vorherige Messung unten aus der Liste!
            </p>
            <!-- Schüler anzeigen um Messung zu starten. -->
            <b-button-group size="sm" class="flex-wrap">
              <!-- Button erscheint grün, falls schon ein Ergebnis in der aktuellen Woche vorhanden-->
              <b-button
                v-for="student in students"
                :key="student.id"
                :variant="get_result(student.id) > 0 ? 'success' : 'outline-success'"
                :disabled="get_result(student.id) > 0"
                :title="get_result(student.id) > 0 ? 'Bereits getestet' : 'Jetzt testen'"
                :href="
                  '/students/' + student.id + '/results/new?test_id=' + test.id + '#' + student.name
                "
              >
                {{ student.name }}
              </b-button>
            </b-button-group>
          </div>
          <div v-else>
            <p class="text-light bg-secondary">&nbsp;Durchführung</p>
            <p>{{ test.description.usage }}</p>
            <p class="text-light bg-secondary">&nbsp;Hinweise</p>
            <p>
              Diesen Test müssen die Schüler:innen mit ihrem Logincode in ihrem
              <a href="/testen" target="_blank">eigenen Zugang</a> durchführen! Ein Klick auf den
              Namen öffnet den Zugang dieser Schüler:in.
            </p>
            <p>Der Test ist jede Woche automatisch verfügbar, außer Sie pausieren die Testung.</p>
            <p>
              Sie können sehen, welche Schüler:innen den Test in dieser Woche bereits durchgeführt
              haben - ihre Namen sind grün hinterlegt.
            </p>
            <!-- Schüler nur als Info anzeigen -->
            <b-button-group size="sm" class="flex-wrap">
              <!-- Button erscheint grün, falls schon ein Ergebnis vorhanden ist. -->
              <form
                v-for="student in students"
                :key="student.id"
                method="post"
                class="mr-1 mb-3"
                target="_blank"
                :action="'testen_login?login=' + student.login"
              >
                <input name="authenticity_token" type="hidden" :value="getCSRFToken()" />
                <b-button
                  v-if="!excludeList.includes(student.id)"
                  :key="student.id"
                  :variant="get_result(student.id) > 0 ? 'success' : 'outline-secondary'"
                  type="submit"
                >
                  {{ student.name }}<br />{{ student.login }}
                </b-button>
              </form>
            </b-button-group>
            <br />
            <div>
              <b-button
                :class="'btn btn-sm mt-3' + is_active ? 'btn-danger' : 'btn_success'"
                @click="toggleAssessment()"
              >
                <i :class="is_active ? 'fas fa-pause' : 'fas fa-play'"></i>
                {{
                  is_active ? 'Wöchentliche Testung pausieren' : 'Wöchentliche Testung aktivieren'
                }}
              </b-button>

              <b-dropdown size="sm" text="Schüler:innen zuweisen" class="ml-1">
                <b-dropdown-group id="dropdown-group-1" header="Vom Test ausschließen">
                  <b-dropdown-item
                    v-for="student in includedStudents"
                    :key="student.id"
                    @click="exclude(student.id)"
                  >
                    {{ student.name }}
                  </b-dropdown-item>
                </b-dropdown-group>
                <b-dropdown-group id="dropdown-group-2" header="In Test einschließen">
                  <b-dropdown-item
                    v-for="student in excludedStudents"
                    :key="student.id"
                    @click="include(student.id)"
                  >
                    {{ student.name }}
                  </b-dropdown-item>
                </b-dropdown-group>
              </b-dropdown>
            </div>
          </div>
        </div>
        <!-- Liste der alten Messungen -->
        <div v-if="weeks.length > 0">
          <!-- Tabellen durch Rows nachbauen, wegen Collapse -->
          <!-- Header -->
          <b-row>
            <b-col><b>Woche ab dem</b></b-col>
            <b-col><b>Anzahl Ergebnisse</b></b-col>
            <b-col><b>Details</b></b-col>
          </b-row>
          <!-- Nach Wochen gruppierte Einträge -->
          <div v-for="(date, index) in weeks.slice().reverse()" :key="index" class="mt-2">
            <b-row>
              <b-col>{{ print_date(date) }}</b-col>
              <b-col>{{ grouped_results[date].length }}</b-col>
              <b-col>
                <b-btn v-b-toggle="'collapse_' + index" size="sm" variant="outline-secondary">
                  <i class="when-closed fas fa-caret-down"></i>
                  <i class="when-opened fas fa-caret-up"></i>
                </b-btn>
              </b-col>
            </b-row>
            <!-- Aufklappbare Details -->
            <b-collapse :id="'collapse_' + index" @shown="auto_scroll('#collapse_' + index)">
              <b-card class="mt-2">
                <table class="table table-striped table-sm table-borderless">
                  <thead>
                    <th>Datum</th>
                    <th>Schüler:in</th>
                    <th>Positiv</th>
                    <th>Negativ</th>
                    <th>Trend</th>
                    <th v-if="!readOnly">Aktionen</th>
                  </thead>
                  <tbody>
                    <tr v-for="(result, resultIndex) in grouped_results[date]" :key="result.id">
                      <td>{{ print_date(result.data.test_date) }}</td>
                      <td>{{ studentName(result.data.student_id) }}</td>
                      <td>
                        <span v-for="(item, n) in result.data.report.positive" :key="item">{{
                          (n > 0 ? ', ' : '') + getItemName(item, test.items[item])
                        }}</span>
                      </td>
                      <td>
                        <span v-for="(item, m) in result.data.report.negative" :key="item">{{
                          (m > 0 ? ', ' : '') + getItemName(item, test.items[item])
                        }}</span>
                      </td>
                      <td>
                        <i
                          v-if="result.data.report.trend > 0"
                          class="fas fa-arrow-up"
                          style="color: var(--success-color)"
                        ></i>
                        <i
                          v-else-if="result.data.report.trend == 0"
                          class="fas fa-arrow-right"
                          style="color: var(--secondary-color)"
                        ></i>
                        <i v-else class="fas fa-arrow-down" style="color: var(--danger-color)"></i>
                      </td>
                      <td v-if="!readOnly">
                        <b-btn
                          small
                          variant="outline-danger"
                          title="Diese Messung löschen"
                          @click="deleteResult(result, resultIndex)"
                        >
                          <i class="fas fa-trash"></i>
                        </b-btn>
                      </td>
                    </tr>
                  </tbody>
                </table>
              </b-card>
            </b-collapse>
          </div>
          <confirm-dialog ref="confirmDialog" />
        </div>
      </b-tab>

      <!-- Auswertungstab mit Graph -->
      <b-tab
        title="Auswertung"
        :active="!deep_link"
        class="m-3"
        :disabled="weeks.length == 0 || configuration.views.length == 0"
        @click="auto_scroll('#comment_btn')"
      >
        <analysis-view
          :key="test.id"
          :annotations="annotations"
          :configuration="configuration"
          :group="group"
          :results="results"
          :students="students"
          :test="test"
        ></analysis-view>
      </b-tab>

      <!-- Vorschläge für Fördermaterial -->
      <b-tab title="Fördern">
        <support-view :group="group.id" :test="test.id"> </support-view>
      </b-tab>

      <!-- Testinfos darstellen -->
      <b-tab title="Testinfos">
        <div v-html="test.description.full"></div>
      </b-tab>
    </b-tabs>
  </b-card>
</template>

<script>
  import { ajax } from '../../utils/ajax'
  import { getStudent } from '../../utils/helpers'
  import AnalysisView from './analysis-view.vue'
  import compact from 'lodash/compact'
  import ConfirmDialog from '../shared/confirm-dialog.vue'
  import isObject from 'lodash/isObject'
  import SupportView from './support-view.vue'
  import uniq from 'lodash/uniq'

  export default {
    name: 'AssessmentView',
    components: { AnalysisView, SupportView, ConfirmDialog },
    provide: function () {
      return {
        autoScroll: this.auto_scroll,
        printDate: this.print_date,
        readOnly: this.readOnly,
        studentName: this.studentName,
        weeks: this.weeks,
      }
    },
    props: {
      active: Boolean,
      annotations: Array,
      configuration: Object,
      excludes: Array,
      group: Object,
      readOnly: Boolean,
      results: Array,
      studentTest: Boolean,
      test: Object,
    },
    data: function () {
      return {
        is_active: this.active, //Als Datum, damit es geändert werden kann
        excludeList: this.excludes || [],
        deep_link: this.$root.pre_select && this.$root.pre_select.test == this.test.id, //Wurde eine Anfrage für ein/dieses Assessment gestartet?
        students: this.$root.store.studentsInGroups[this.group.id] || [],
      }
    },
    computed: {
      grouped_results() {
        //Results nach Wochen gruppieren, für die Ergebnisliste
        let res = {}
        for (let i = 0; i < this.results.length; ++i) {
          if (res[this.results[i].test_week] === undefined) {
            res[this.results[i].test_week] = [{ index: i, data: this.results[i] }]
          } else {
            res[this.results[i].test_week].push({ index: i, data: this.results[i] })
          }
        }
        return res
      },
      includedStudents() {
        return this.students.filter(student => !this.excludeList.includes(student.id))
      },
      excludedStudents() {
        return this.students.filter(student => this.excludeList.includes(student.id))
      },
      weeks: function () {
        return compact(uniq(this.results.map(w => w.test_week)))
      },
    },
    methods: {
      auto_scroll(element) {
        //Scrollt Seite, bis übergebenes Element sichtbar ist.
        this.jQuery(element)[0].scrollIntoView(false)
      },
      async exclude(student) {
        //AJAX-Request senden

        const res = await ajax({
          url: `/groups/${this.group.id}/assessments/${this.test.id}/?assessment[exclude]=${student}`,
          method: 'put',
        })
        if (res.status === 200) {
          this.excludeList.push(student)
        }
      },
      get_result(student) {
        //Prüft ob es für "heute" schon ein Ergebnis gibt.
        let d = new Date()
        let bow = new Date(d.setDate(d.getDate() - d.getDay() + (d.getDay() === 0 ? -6 : 1)))
        for (let i = 0; i < this.results.length; ++i) {
          if (
            this.results[i].student_id == student &&
            new Date(this.results[i].test_week).toDateString() == bow.toDateString()
          ) {
            return this.results[i].id
          }
        }
        return 0
      },
      getCSRFToken() {
        return document.getElementsByName('csrf-token')[0].getAttribute('content')
      },
      async include(student) {
        //AJAX-Request senden

        const res = await ajax({
          url: `/groups/${this.group.id}/assessments/${this.test.id}/?assessment[include]=${student}`,
          method: 'put',
        })
        if (res.status === 200) {
          this.excludeList = this.excludeList.filter(item => item !== student)
        }
      },
      print_date(date) {
        //Datumsanzeige formatieren
        let d = new Date(date)
        return d.toLocaleDateString('de-DE')
      },
      async deleteResult(result, index) {
        const ok = await this.$refs.confirmDialog.open({
          title: 'Messung löschen',
          message: `Diese Messung unwiderruflich löschen! Sind Sie sicher?`,
          okText: 'Ja, löschen',
        })
        if (ok) {
          const res = await ajax({
            url: `/students/${result.data.student_id}/results/${result.data.id}`,
            method: 'delete',
          })
          if (res.status === 200) {
            this.remove(result.index, index)
          }
        }
      },
      remove(index, collapseIndex) {
        //Löscht einen Eintrag aus der Ergebnisliste
        let last = true
        for (let i = 0; i < this.results.length; ++i) {
          if (i != index && this.results[i].test_week == this.results[index].test_week) {
            last = false
            break
          }
        }
        if (last) {
          //Letzter Eintrag der Woche wird gelöscht => Collapse erst schließen
          this.$root.$emit('bv::toggle::collapse', 'collapse_' + collapseIndex)
        }
        this.$emit('remove-entry', index)
      },
      studentName(id) {
        //Student-Objekt aus globaler Variable holen
        return getStudent(this.group.id, id).name
      },
      async toggleAssessment() {
        const res = await ajax({
          url: `/groups/${this.group.id}/assessments/${this.test.id}`,
          method: 'put',
          data: { assessment: { active: this.is_active ? 0 : 1 } },
        })
        if (res.status === 200) {
          this.is_active = !this.is_active
        }
      },
      getItemName(item, fallback) {
        if (isObject(this.test.items[0])) {
          return this.test.items.find(n => n.id === item).label
        } else {
          return fallback
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
