<template>
  <div v-if="list.length == 0">
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
          <th>Wöchentliche Testung</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="test in sorted_list" :key="test.id">
          <td>{{ test.name }}</td>
          <td>
            <b-btn
              v-if="test.student_test"
              class="btn-sm"
              :variant="test.active ? 'danger' : 'success'"
              @click="toggleAssessment(test)"
            >
              <i :class="`fas fa-${test.active ? 'pause' : 'play'}`"></i>
              {{ test.active ? 'Pausieren!' : 'Aktivieren!' }}
            </b-btn>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script>
  import { ajax } from '../../utils/ajax'

  export default {
    name: 'ListView',
    props: {
      group: Object,
      list: Array,
    },

    computed: {
      sorted_list() {
        return [...this.list].sort((a, b) => a.name.localeCompare(b.name))
      },
    },
    methods: {
      async toggleAssessment(test) {
        const res = await ajax({
          url: `/groups/${this.group.id}/assessments/${test.test}`,
          method: 'put',
          data: { assessment: { active: test.active ? 0 : 1 } },
        })
        if (res.status === 200) {
          this.$emit('update:list')
        }
      },
    },
  }
</script>
