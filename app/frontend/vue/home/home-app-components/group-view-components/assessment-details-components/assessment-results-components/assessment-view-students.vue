<template>
  <div v-if="!studentTest">
    <b-button
      v-b-toggle.assessmentViewStudentsExplanation
      variant="outline-secondary"
      class="mb-3 btn-sm">
      Erläuterungen
      <i class="fas fa-caret-down ms-2"></i>
    </b-button>
    <b-collapse id="assessmentViewStudentsExplanation">
      <b-card class="mb-4">
        <p class="text-light bg-secondary">&nbsp;Lehrkräfte-Übung</p>
        <p class="text-small">
          Dieser Test ist für die Durchführung durch Lehrkräfte gedacht und kann daher nicht
          aktiviert oder pausiert werden.
        </p>
        <p v-if="test.description?.usage" class="text-light bg-secondary">&nbsp;Durchführung</p>
        <p v-if="test.description?.usage" class="text-small">{{ test.description.usage }}</p>
        <p class="text-light bg-secondary">&nbsp;Hinweise</p>
        <p>
          Klicken Sie auf einen Namen um den Test sofort zu starten. Am Ende des Tests werden Sie
          auf diese Seite zurückgeleitet.
          <br />
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
        class="me-2 mb-2"
        :variant="getResult(student.id) > 0 ? 'success' : 'outline-success'"
        :disabled="getResult(student.id) > 0 || !isAllowed"
        :title="getResult(student.id) > 0 ? 'Bereits getestet' : 'Jetzt testen'"
        :href="'/students/' + student.id + '/results/new?test_id=' + test.id + '#' + student.name">
        {{ student.name }}
      </b-button>
    </div>
  </div>
  <div v-else>
    <div class="d-flex">
      <b-button
        v-if="isAllowed"
        class="btn btn-sm"
        :variant="isActive ? ' btn-danger' : ' btn-success'"
        :disabled="isUpdating"
        @click="toggleAssessment()">
        <i v-if="!isUpdating" :class="isActive ? 'fas fa-pause' : 'fas fa-play'"></i>
        <i v-else class="fas fa-spinner fa-spin"></i>
        {{ isActive ? 'Wöchentliche Testung pausieren' : 'Wöchentliche Testung aktivieren' }}
      </b-button>

      <b-dropdown
        v-if="isAllowed"
        size="sm"
        class="ms-1"
        variant="outline-secondary"
        no-caret
        auto-close="outside">
        <template #button-content>
          Schüler:innen ein-/ausschließen
          <i class="fas fa-caret-down ms-2"></i>
        </template>
        <b-dropdown-form class="d-flex">
          <b-button class="text-small me-1" variant="outline-danger" @click="toggleAllOff">
            Alle ausschließen
          </b-button>
          <b-button class="text-small ms-1" variant="outline-success" @click="toggleAllOn">
            Alle einschließen
          </b-button>
        </b-dropdown-form>
        <b-dropdown-form>
          <b-form-checkbox
            v-for="student in students"
            :key="student.id"
            input-class="custom-toggle"
            switch
            reverse
            :model-value="!excludeList.includes(student.id)"
            @click="toggleStudent(student.id)">
            {{ student.name }}
          </b-form-checkbox>
        </b-dropdown-form>
      </b-dropdown>
      <b-button variant="outline-secondary" class="ms-1 btn btn-sm" @click="refetch">
        <i class="fas fa-refresh me-2"></i>
        Aktualisieren
      </b-button>
      <b-button
        v-b-toggle.assessmentViewStudentsExplanation
        variant="outline-secondary"
        class="ms-1 btn btn-sm">
        Erläuterungen
        <i class="fas fa-caret-down ms-2"></i>
      </b-button>
    </div>

    <b-collapse id="assessmentViewStudentsExplanation">
      <b-card class="mb-4">
        <p v-if="test.description?.usage" class="text-light bg-secondary">&nbsp;Durchführung</p>
        <p v-if="test.description?.usage">{{ test.description.usage }}</p>
        <p class="text-light bg-secondary">&nbsp;Hinweise</p>
        <p>
          Diesen Test müssen die Schüler:innen mit ihrem Logincode in ihrem
          <a href="/testen" target="_blank">eigenen Zugang</a>
          durchführen! Ein Klick auf den Namen öffnet den Zugang dieser Schüler:in. Wenn Sie für
          eine Schüler:in einen Test durchführen, können Sie die Ergebnisse mit dem Button
          <strong>Aktualisieren</strong>
          erneut abrufen.
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
          <th v-if="includedStudents.length" scope="col" class="pe-4 custom-th">
            Teilnehmende Schüler:innen
          </th>
          <th v-if="excludedStudents.length" scope="col" class="custom-th">
            Ausgeschlossene Schüler:innen
          </th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td v-if="includedStudents.length" class="pe-4 custom-td">
            <div size="sm" class="flex-wrap d-flex h-100">
              <!-- Button erscheint grün, falls schon ein Ergebnis vorhanden ist. -->
              <form
                v-for="student in includedStudents"
                :key="student.id"
                method="post"
                class="me-2 mb-2"
                target="_blank"
                :action="'/testen_login?login=' + student.login">
                <input name="authenticity_token" type="hidden" :value="getCSRFToken()" />
                <b-button
                  :key="student.id"
                  :variant="getResult(student.id) > 0 ? 'success' : 'outline-secondary'"
                  :disabled="!isActive || !isAllowed"
                  type="submit">
                  {{ student.name }}
                  <br />
                  {{ student.login }}
                </b-button>
              </form>
            </div>
          </td>
          <td v-if="excludedStudents.length" class="custom-td">
            <div size="sm" class="flex-wrap d-flex h-100">
              <b-button
                v-for="student in excludedStudents"
                :key="student.id"
                :disabled="true"
                :variant="getResult(student.id) > 0 ? 'success' : 'outline-secondary'"
                class="me-2 mb-2">
                {{ student.name }}
                <br />
                {{ student.login }}
              </b-button>
            </div>
          </td>
        </tr>
      </tbody>
    </table>
    <hr />
  </div>
</template>

<script>
  import { useAssessmentsStore } from 'src/store/assessmentsStore'
  import { useGlobalStore } from 'src/store/store'
  import { ajax } from 'src/utils/ajax'
  import apiRoutes from 'src/vue/routes/api-routes'
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
      isActive() {
        return this.assessmentsStore.currentAssessment.active
      },
      isAllowed() {
        return this.globalStore.login.is_masquerading === null && !this.group.read_only
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
            assessment: { active: this.isActive ? 0 : 1 },
          })
        )
        if (res.status === 200) {
          this.assessmentsStore.currentAssessment.active =
            !this.assessmentsStore.currentAssessment.active
        }
        this.isUpdating = false
      },
      async toggleStudent(studentId) {
        if (this.excludeList.includes(studentId)) {
          this.excludeList = this.excludeList.filter(item => item !== studentId)
          await ajax(apiRoutes.assessments.includeStudent(this.group.id, this.test.id, studentId))
        } else {
          this.excludeList.push(studentId)
          await ajax(apiRoutes.assessments.excludeStudent(this.group.id, this.test.id, studentId))
        }
      },
      async toggleAllOff() {
        this.excludeList = this.students.map(s => s.id)
        await ajax(
          apiRoutes.assessments.excludeStudent(
            this.group.id,
            this.test.id,
            JSON.stringify(this.excludeList)
          )
        )
      },
      async toggleAllOn() {
        this.excludeList = []
        await ajax(
          apiRoutes.assessments.includeStudent(
            this.group.id,
            this.test.id,
            JSON.stringify(this.students.map(s => s.id))
          )
        )
      },
    },
  }
</script>
<style>
  .custom-td {
    vertical-align: top;
  }
  .custom-th {
    vertical-align: top;
    padding-bottom: 0.5em;
  }
  .custom-toggle {
    margin-left: 1.5em !important;
  }
  .form-check.form-switch {
    text-align: left;
  }
  .form-check.form-switch > input:hover,
  label:hover {
    cursor: pointer;
  }
  .form-check.form-switch > input:checked {
    background-color: green;
  }
</style>
