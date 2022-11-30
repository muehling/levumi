<template>
  <div v-if="sortedlist.length == 0">
    <p class="m-5 text-center text-muted">
      Keine aktiven Tests mit Messungen vorhanden! <br />
      Legen Sie zunächst über die Auswahl unten einen Test für diese Klasse an.
    </p>
  </div>
  <div v-else>
    <table class="table table-sm table-striped table-responsive-md text-small">
      <thead>
        <tr>
          <th>Test</th>
          <th>Anzahl Testungen</th>
          <th>Letzter Test am</th>
          <th>Wöchentliche Testung</th>
          <th></th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="test in sortedlist" :key="test.id">
          <td>{{ test.name }}</td>
          <td>{{ test.result_count }}</td>
          <td>{{ test.last_test }}</td>
          <td>
            <b-btn
              v-if="test.student_test"
              class="btn-sm"
              :variant="test.active ? 'outline-danger' : 'outline-success'"
              @click="toggleAssessment(test)"
            >
              <i :class="`fas fa-${test.active ? 'pause' : 'play'}`"></i>
              {{ test.active ? 'Pausieren' : 'Aktivieren' }}
            </b-btn>
          </td>
          <td>
            <b-btn
              :id="`delete-button-${test.test}`"
              class="btn-sm"
              :variant="test.result_count ? 'outline-secondary' : 'outline-danger'"
              @click="deleteAssessment(test)"
              ><i class="fas fa-trash"></i
            ></b-btn>
            <b-popover
              v-if="!!test.result_count"
              :target="`delete-button-${test.test}`"
              triggers="hover"
            >
              <p>
                Testungen mit Messungen können nicht gelöscht werden. Bitte löschen Sie zunächst die
                Messungen.
              </p>
            </b-popover>
          </td>
        </tr>
      </tbody>
    </table>
    <confirm-dialog ref="confirmDialog" />
  </div>
</template>

<script>
  import { ajax } from '../../utils/ajax'
  import { useAssessmentsStore } from '../../store/assessmentsStore'
  import ConfirmDialog from '../shared/confirm-dialog.vue'
  import apiRoutes from '../routes/api-routes'

  export default {
    name: 'ListView',
    components: { ConfirmDialog },
    props: {
      group: Object,
    },
    setup() {
      const assessmentsStore = useAssessmentsStore()
      return { assessmentsStore }
    },
    computed: {
      sortedlist() {
        return [...this.assessmentsStore.assessments].sort((a, b) => a.name.localeCompare(b.name))
      },
    },
    mounted() {
      this.updateList()
    },
    methods: {
      async toggleAssessment(test) {
        const res = await ajax({
          url: `/groups/${this.group.id}/assessments/${test.test}`,
          method: 'put',
          data: { assessment: { active: test.active ? 0 : 1 } },
        })
        if (res.status === 200) {
          this.updateList()
        }
      },
      async deleteAssessment(test) {
        if (test.result_count) {
          return
        }
        const ok = await this.$refs.confirmDialog.open({
          title: 'Testung löschen',
          message: 'Möchten Sie diesen Test von der Klasse entfernen?',
          okText: 'Testung löschen',
          okIntent: 'outline-danger',
        })

        if (ok) {
          const res = await ajax(apiRoutes.assessments.delete(this.group.id, test.test))
          if (res.status === 200) {
            this.updateList()
          }
        }
      },
      async updateList() {
        this.assessmentsStore.fetch(this.group.id)
      },
    },
  }
</script>
