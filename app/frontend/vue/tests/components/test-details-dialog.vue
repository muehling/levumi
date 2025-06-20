<template>
  <info-dialog ref="testDetails">
    <div class="text-left text-small">
      <p class="text-light bg-secondary ps-1">Kurzbeschreibung</p>
      <p v-html="test.description.short"></p>
      <p class="text-light bg-secondary ps-1">Ausführliche Beschreibung</p>
      <table class="table table-striped table-sm text-left">
        <tbody>
          <tr>
            <td>Anzahl Items</td>
            <td>{{ Object.keys(test.items).length }}</td>
          </tr>
          <tr>
            <td>Durchführung</td>
            <td>
              {{
                test.student_test ? 'Selbstständig durch die Schüler*innen' : 'Durch die Lehrkraft'
              }}
            </td>
          </tr>
          <tr>
            <td>Zeitbeschränkung</td>
            <td>{{ test.description.time_limit || '--' }}</td>
          </tr>
          <tr>
            <td>Durchführung</td>
            <td>{{ test.description.usage }}</td>
          </tr>
          <tr>
            <td>Items</td>
            <td>{{ items }}</td>
          </tr>
        </tbody>
      </table>
      <p class="text-light bg-secondary ps-1">Beschreibung</p>
      <p v-html="test.description.full"></p>
    </div>
  </info-dialog>
</template>
<script>
  import { stripHtml } from 'src/utils/helpers'
  import InfoDialog from '../../shared/info-dialog.vue'
  export default {
    name: 'TestDetailsDialog',
    components: { InfoDialog },
    data() {
      return { test: { description: {}, items: [] } }
    },
    computed: {
      items() {
        if (!this.test) {
          return ''
        }
        return Object.values(this.test.items)
          .map(i => {
            return stripHtml(i.question ? i.question : i)
          })
          .join(', ')
      },
    },
    methods: {
      open({ test }) {
        this.test = test
        this.$refs.testDetails.open({ title: 'Testbeschreibung' })
      },
    },
  }
</script>
