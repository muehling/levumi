<template>
  <div>
    <loading-dots
      v-if="!data.users"
      :is-loading="!data.users"
      message="Daten werden vorbereitet. Dies kann einen Moment dauern."
    />
    <div v-if="data.users" class="container-fluid mt-3">
      <h4>Nutzer gesamt</h4>
      <table class="table table-hover table-sm text-small">
        <thead class="thead-light">
          <tr>
            <th scope="col"></th>
            <th scope="col">Lehrkraft</th>
            <th scope="col">Forscher:in</th>
            <th scope="col">Privatperson</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td>Anzahl gesamt</td>
            <td v-for="(count, i) in data.users.count" :key="`total/${i}`">{{ count }}</td>
          </tr>
          <tr>
            <td>In den letzten 30 Tagen aktiv</td>
            <td v-for="(active, i) in data.users.active" :key="i">{{ active }}</td>
          </tr>
          <tr>
            <td>Mit echten Messungen (produktiv)</td>
            <td v-for="(productive, i) in data.users.productive" :key="i">
              {{ productive === 0 ? '-' : productive }}
            </td>
          </tr>
          <tr>
            <td>Anteil (nur produktiv)</td>
            <td v-for="(productive, i) in data.users.productive" :key="i">
              {{ sumProductive === 0 ? '-' : (productive / sumProductive).toFixed(2) }}
            </td>
          </tr>
        </tbody>
      </table>
      <h4>Produktive Nutzer nach Bundesland</h4>
      <table class="table table-hover table-sm text-small">
        <thead class="thead-light">
          <tr>
            <th scope="col">Bundesland</th>
            <th scope="col">Lehrkraft</th>
            <th scope="col">Forscher:in</th>
          </tr>
        </thead>

        <tbody>
          <tr v-for="state in activeUserDataByState" :key="state[0]">
            <td v-for="(a, i) in state" :key="i">
              {{ a }}
            </td>
          </tr>
        </tbody>
      </table>

      <h4>Verwendung der Tests (nur produktive Lehrkräfte)</h4>
      <table class="table table-hover table-sm text-small">
        <thead class="thead-light">
          <tr>
            <th scope="col">Test</th>
            <th scope="col">Messungen gesamt</th>
            <th scope="col">Anzahl Klassen</th>
            <th scope="col">Anzahl Lernverläufe</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(test, index) in data.tests" :key="`${test.label}/${index}`">
            <td>{{ test.label }}</td>
            <td>{{ test.count }}</td>
            <td>{{ test.groups }}</td>
            <td>{{ test.progressions }}</td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script>
  import { ajax } from '../../utils/ajax'
  import { useGlobalStore } from '../../store/store'
  import apiRoutes from '../routes/api-routes'
  import LoadingDots from '../shared/loading-dots.vue'
  export default {
    name: 'StatisticsApp',
    components: { LoadingDots },
    setup() {
      const globalStore = useGlobalStore()
      return { globalStore }
    },
    data() {
      return {
        data: { user: { state: {} } },
        states: this.globalStore.staticData.states,
      }
    },
    computed: {
      sumProductive() {
        return this.data.users.productive.reduce((acc, p) => acc + p, 0)
      },
      activeUserDataByState() {
        const stateKeys = Object.keys(this.data.users.state)
        const b = this.states.filter(state => stateKeys.find(key => key === state.id + ''))
        const c = b.map(state => {
          //TBD
          return [
            state.label,
            this.data.users.state[state.id][0],
            this.data.users.state[state.id][1],
          ]
          //return [state.label, ...this.data.users.state[state.id]]
        })
        return c
      },
    },
    mounted() {
      this.fetch()
    },
    methods: {
      async fetch() {
        const res = await ajax({ url: apiRoutes.users.statistics })
        const data = await res.json()
        this.data = data
      },
    },
  }
</script>
