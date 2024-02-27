<template>
  <div v-if="!studentTest">
    <b-button
      v-b-toggle.assessmentViewStudentsExplanation
      variant="outline-secondary"
      class="mb-3 btn-sm"
      >Erläuterungen<i class="fas fa-caret-down ml-2"></i
    ></b-button>
    <b-collapse id="assessmentViewStudentsExplanation">
      <b-card class="mb-4">
        <p class="text-light bg-secondary">&nbsp;Lehrkräfte-Übung</p>
        <p>
          Dieser Test ist für die Durchführung durch Lehrkräfte gedacht und kann daher nicht
          aktiviert oder pausiert werden.
        </p>
        <p v-if="test.description?.usage" class="text-light bg-secondary">&nbsp;Durchführung</p>
        <p v-if="test.description?.usage" class="text-small">{{ test.description.usage }}</p>
        <p class="text-light bg-secondary">&nbsp;Hinweise</p>
        <p>
          Klicken Sie auf einen Namen um den Test sofort zu starten. Am Ende des Tests werden Sie
          auf diese Seite zurückgeleitet.<br />
          Grün hinterlegte Namen wurden in dieser Woche bereits getestet. Wenn Sie erneut testen
          möchten, löschen Sie bitte zuerst die vorherige Messung unten aus der Liste!
        </p>
      </b-card>
    </b-collapse>

    <!-- Schüler anzeigen um Messung zu starten. -->
    <br />
    <strong>Teilnehmende Schüler:innen</strong>
    <div size="sm" class="d-flex flex-wrap">
      <!-- Button erscheint grün, falls schon ein Ergebnis in der aktuellen Woche vorhanden-->
      <b-button
        v-for="student in students"
        :key="student.id"
        class="mr-2 mb-2"
        :variant="getResult(student.id) > 0 ? 'success' : 'outline-success'"
        :disabled="getResult(student.id) > 0 || !isAllowed"
        :title="getResult(student.id) > 0 ? 'Bereits getestet' : 'Jetzt testen'"
        :href="'/students/' + student.id + '/results/new?test_id=' + test.id + '#' + student.name"
      >
        {{ student.name }}
      </b-button>
    </div>
  </div>
  <div v-else>
    <div class="">
      <b-button
        v-if="isAllowed"
        class="btn btn-sm"
        :variant="isactive ? ' btn-danger' : ' btn-success'"
        :disabled="isUpdating"
        @click="toggleAssessment()"
      >
        <i v-if="!isUpdating" :class="isactive ? 'fas fa-pause' : 'fas fa-play'"></i>
        <i v-else class="fas fa-spinner fa-spin"></i>
        {{ isactive ? 'Wöchentliche Testung pausieren' : 'Wöchentliche Testung aktivieren' }}
      </b-button>

      <b-dropdown v-if="isAllowed" size="sm" class="ml-1" variant="outline-secondary" no-caret
        ><template #button-content>
          Schüler:innen ein-/ausschließen<i class="fas fa-caret-down ml-2"></i
        ></template>
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
      <b-button variant="outline-secondary" class="ml-1 btn btn-sm" @click="refetch"
        ><i class="fas fa-refresh mr-2"></i>Aktualisieren
      </b-button>
      <b-button
        v-b-toggle.assessmentViewStudentsExplanation
        variant="outline-secondary"
        class="ml-1 btn btn-sm"
        >Erläuterungen<i class="fas fa-caret-down ml-2"></i>
      </b-button>
    </div>

    <b-collapse id="assessmentViewStudentsExplanation">
      <b-card class="mb-4">
        <p v-if="test.description?.usage" class="text-light bg-secondary">&nbsp;Durchführung</p>
        <p v-if="test.description?.usage">{{ test.description.usage }}</p>
        <p class="text-light bg-secondary">&nbsp;Hinweise</p>
        <p>
          Diesen Test müssen die Schüler:innen mit ihrem Logincode in ihrem
          <a href="/testen" target="_blank">eigenen Zugang</a> durchführen! Ein Klick auf den Namen
          öffnet den Zugang dieser Schüler:in. Wenn Sie für eine Schüler:in einen Test durchführen,
          können Sie die Ergebnisse mit dem Button <strong>Aktualisieren</strong> erneut abrufen.
        </p>
        <p>Der Test ist jede Woche automatisch verfügbar, außer Sie pausieren die Testung.</p>
        <p>
          Sie können sehen, welche Schüler:innen den Test in dieser Woche bereits durchgeführt haben
          - ihre Namen sind grün hinterlegt.
        </p>
        <p>
          Über den Button "Schüler:innen ein-/ausschließen" können Sie festlegen, welche
          Schüler:innen am Test teilnehmen sollen.
        </p>
      </b-card>
    </b-collapse>
    <hr />
    <table>
      <thead>
        <tr>
          <th v-if="includedStudents.length" scope="col" class="pr-4">
            Teilnehmende Schüler:innen
          </th>
          <th v-if="excludedStudents.length" scope="col">Ausgeschlossene Schüler:innen</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td v-if="includedStudents.length" class="pr-4">
            <div size="sm" class="flex-wrap d-flex h-100">
              <!-- Button erscheint grün, falls schon ein Ergebnis vorhanden ist. -->
              <form
                v-for="student in includedStudents"
                :key="student.id"
                method="post"
                class="mr-2 mb-2"
                target="_blank"
                :action="'/testen_login?login=' + student.login"
              >
                <input name="authenticity_token" type="hidden" :value="getCSRFToken()" />
                <b-button
                  :key="student.id"
                  :variant="getResult(student.id) > 0 ? 'success' : 'outline-secondary'"
                  :disabled="!isactive || !isAllowed"
                  type="submit"
                >
                  {{ student.name }}<br />{{ student.login }}
                </b-button>
              </form>
            </div>
          </td>
          <td v-if="excludedStudents.length">
            <div size="sm" class="flex-wrap d-flex h-100">
              <b-button
                v-for="student in excludedStudents"
                :key="student.id"
                :disabled="true"
                :variant="getResult(student.id) > 0 ? 'success' : 'outline-secondary'"
                class="mr-2 mb-2"
                >{{ student.name }}<br />{{ student.login }}</b-button
              >
            </div>
          </td>
        </tr>
      </tbody>
    </table>
    <hr />
  </div>
</template>

<script>
  import { useAssessmentsStore } from '../../store/assessmentsStore'
  import { useGlobalStore } from '../../store/store'
  import { ajax } from '../../utils/ajax'
  import apiRoutes from '../routes/api-routes'
  import { isAdmin } from '../../utils/user'
  export default {
    name: 'AssessmentViewStudents',
    props: {
      excludes: Array,
      group: Object,
      results: Array,
      test: Object,
    },
    setup() {
      const globalStore = useGlobalStore()
      const assessmentsStore = useAssessmentsStore()
      return { globalStore, assessmentsStore }
    },
    data: function () {
      return {
        excludeList: this.excludes || [],
        isUpdating: false,
      }
    },
    computed: {
      students() {
        return this.globalStore.studentsInGroups[this.group.id] || []
      },
      studentTest() {
        return this.test.student_test
      },
      includedStudents() {
        return this.students.filter(student => !this.excludeList.includes(student.id))
      },
      excludedStudents() {
        return this.students.filter(student => this.excludeList.includes(student.id))
      },
      isactive() {
        const assessments = this.assessmentsStore.assessments[this.group.id]

        return assessments?.find(a => a.test_id === this.test.id)?.active
      },
      isAllowed() {
        return (
          (this.globalStore.login.is_masquerading === null && !this.group.read_only) ||
          isAdmin(this.globalStore.login.capabilities)
        )
      },
    },
    methods: {
      async refetch() {
        await this.assessmentsStore.fetchCurrentAssessment(this.group.id, this.test.id)
      },
      getResult(studentId) {
        //Prüft ob es für "heute" schon ein Ergebnis gibt.
        let d = new Date()
        let bow = new Date(d.setDate(d.getDate() - d.getDay() + (d.getDay() === 0 ? -6 : 1)))
        const res = this.results.find(
          result =>
            result.student_id === studentId &&
            new Date(result.test_week).toDateString() === bow.toDateString()
        )
        return res?.id || 0
      },
      getCSRFToken() {
        return document.getElementsByName('csrf-token')[0].getAttribute('content')
      },
      async toggleAssessment() {
        this.isUpdating = true
        const res = await ajax(
          apiRoutes.assessments.toggleAssessment(this.group.id, this.test.id, {
            assessment: { active: this.isactive ? 0 : 1 },
          })
        )
        if (res.status === 200) {
          await this.assessmentsStore.fetch(this.group.id)
        }
        this.isUpdating = false
      },
      async include(studentId) {
        //AJAX-Request senden

        const res = await ajax(
          apiRoutes.assessments.includeStudent(this.group.id, this.test.id, studentId)
        )
        if (res.status === 200) {
          this.excludeList = this.excludeList.filter(item => item !== studentId)
        }
      },
      async exclude(studentId) {
        //AJAX-Request senden

        const res = await ajax(
          apiRoutes.assessments.excludeStudent(this.group.id, this.test.id, studentId)
        )
        if (res.status === 200) {
          this.excludeList.push(studentId)
        }
      },
    },
  }
</script>
<style scoped>
  td {
    vertical-align: top;
  }
  th {
    vertical-align: top;
    padding-bottom: 0.5em;
  }
</style>
