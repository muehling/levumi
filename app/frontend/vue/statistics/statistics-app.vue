<template>
  <div>
    <div v-if="data.users" class="container mt-3">
      <h4>Nutzer gesamt</h4>
      <table class="table table-hover table-sm text-small">
        <thead class="thead-light">
          <tr>
            <th scope="col"></th>
            <th scope="col">Lehrkraft</th>
            <th scope="col">Forscher*in</th>
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
            <th scope="col">Forscher*in</th>
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
    </div>
    <div v-if="data.tests" class="container mt-3">
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
    <div v-if="registeredUsersByMonth" class="container mt-3">
      <h4>Registrations by month</h4>
      <apexchart
        ref="registeredUsersByMonth"
        type="line"
        height="400px"
        width="70%"
        :options="chartOptions"
        :series="registeredUsersByMonth" />
    </div>
    <div v-if="registrationsByMonthAndState" class="container mt-3">
      <h4>Registrations by month and state</h4>
      <apexchart
        ref="registeredUsersByMonthAndState"
        type="line"
        height="500px"
        width="70%"
        :options="chartOptions"
        :series="registrationsByMonthAndState" />
    </div>
    <div v-if="activeUsersByMonth" class="container mt-3">
      <h4>Active users by month</h4>
      <apexchart
        ref="activeUsersByMonth"
        type="line"
        height="400px"
        width="70%"
        :options="monthlyOptions"
        :series="activeUsersByMonth" />
    </div>

    <div v-if="monthlyResults" class="container mt-3">
      <h4>Total monthly results</h4>
      <apexchart
        ref="monthlyResults"
        type="line"
        height="400px"
        width="70%"
        :options="chartOptions"
        :series="monthlyResults" />
    </div>

    <div v-if="monthlyByArea" class="container mt-3">
      <h4>Monthly Results by Area</h4>
      <apexchart
        ref="monthlyByArea"
        height="400px"
        width="70%"
        :options="chartOptions"
        :series="monthlyByArea" />
    </div>
  </div>
</template>

<script>
  import { ajax } from '../../utils/ajax'
  import { useGlobalStore } from '../../store/store'
  import apiRoutes from '../routes/api-routes'
  import LoadingDots from '../shared/loading-dots.vue'
  import { apexChartOptions } from '../home/analysis/apexChartHelpers'
  import isArray from 'lodash/isArray'
  import format from 'date-fns/format'
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
        registeredUsersByMonth: undefined,
        activeUsersByTypeAndMonth: undefined,
        activeUsersByMonth: undefined,

        monthlyResults: undefined,
        monthlyByArea: undefined,
        registrationsByMonthAndState: undefined,
      }
    },
    computed: {
      chartOptions() {
        const o = apexChartOptions([]).line
        return o
      },
      monthlyOptions() {
        const labels = [
          'Jan',
          'Feb',
          'Mar',
          'Apr',
          'May',
          'Jun',
          'Jul',
          'Aug',
          'Sep',
          'Oct',
          'Nov',
          'Dec',
        ]
        const o = apexChartOptions([]).line
        o.xaxis.type = 'category'
        o.xaxis.labels.formatter = o => labels[parseInt(o) - 1]
        return o
      },
      lineCategoryOptions() {
        const o = apexChartOptions([]).line
        o.xaxis.type = 'category'
        //o.chart.type = 'area'
        //o.chart.stacked = true

        return o
      },
      twoYOptions() {
        const o = apexChartOptions([]).line
        o.yaxis = [
          {
            min: 0,
            forceNiceScale: true,
            labels: {
              formatter: val => (typeof val === 'number' ? val?.toFixed(2) : val),
            },
          },
          {
            opposite: true,
            min: 0,
            forceNiceScale: true,
            labels: {
              formatter: val => (typeof val === 'number' ? val?.toFixed(2) : val),
            },
          },
        ]
        return o
      },

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
        })
        return c
      },
    },
    mounted() {
      this.fetch()
    },
    methods: {
      createRegistrationsByMonthAndState(data) {
        //done
        if (!data.registrations_by_month_and_state) {
          return
        }

        const states = [
          '',
          'Baden-Württemberg',
          'Bayern',
          'Berlin',
          'Brandenburg',
          'Bremen',
          'Hamburg',
          'Hessen',
          'Mecklenburg-Vorpommern',
          'Niedersachsen',
          'Nordrhein-Westfalen',
          'Rheinland-Pfalz',
          'Saarland',
          'Sachsen',
          'Sachsen-Anhalt',
          'Schleswig-Holstein',
          'Thüringen',
          'Österreich',
          'Schweiz',
          'Anderes Land',
        ]

        const dataArray = Object.entries(data.registrations_by_month_and_state).map(state => {
          const data = Object.entries(state[1]).map(d => {
            return { x: d[0], y: d[1] }
          })
          return { name: states[state[0]], data }
        })

        return dataArray
      },

      createActiveUsersByMonth(data) {
        //done
        if (!data.active_users_by_month) {
          return undefined
        }
        const d = Object.entries(data.active_users_by_month).reduce((acc, d) => {
          const [year, month] = d[0].split('/')
          const current = acc.find(a => a.name === year) || { name: year, data: [] }
          const n = { x: month, y: d[1] }
          current.data.push(n)
          if (acc.find(a => a.name === year)) {
            acc.find(a => a.name === year).data = current.data
          } else {
            acc.push(current)
          }
          return acc
        }, [])

        return d
      },

      createRegisteredUsersByMonth(data) {
        let registeredUsers = []
        if (data.all_registrations_by_type_and_month) {
          const allRegisteredUsers = Object.entries(
            data.all_registrations_by_type_and_month?.users
          )?.map(v => {
            return { x: v[0], y: v[1].length }
          })
          const allRegisteredScientists = Object.entries(
            data.all_registrations_by_type_and_month?.scientists
          ).map(v => {
            return { x: v[0], y: v[1].length }
          })
          const allRegisteredTeachers = Object.entries(
            data.all_registrations_by_type_and_month?.teachers
          )?.map(v => {
            return { x: v[0], y: v[1].length }
          })
          const allRegisteredOthers = Object.entries(
            data.all_registrations_by_type_and_month?.others
          )?.map(v => {
            return { x: v[0], y: v[1].length }
          })

          registeredUsers = [
            { data: allRegisteredUsers, name: 'Users total' },
            { data: allRegisteredTeachers, name: 'Teachers' },
            {
              data: allRegisteredScientists,
              name: 'Scientists',
            },
            { data: allRegisteredOthers, name: 'Others' },
          ]
        } else {
          /*registeredUsers = [
            { data: [], name: 'Users total' },
            { data: [], name: 'Teachers' },
            {
              data: [],
              name: 'Scientists',
            },
            { data: [], name: 'Others' },
          ]*/
          return undefined
        }
        return registeredUsers
      },
      createMonthlyResults(data) {
        let monthlyResults = []
        let monthlyByArea = []
        console.log('data', data.monthly_results)

        if (data.monthly_results) {
          monthlyResults = Object.entries(data.monthly_results?.results_by_month)
            .map(v => {
              return { x: v[0], y: v[1] }
            })
            .sort((a, b) => new Date(a.x) - new Date(b.x))

          this.monthlyResults = [{ data: monthlyResults, name: 'Results/Month' }]

          monthlyByArea = Object.entries(
            this.data.monthly_results?.results_by_area_and_month
          ).reduce((acc, v) => {
            const dimensions = v[0].split('/')
            acc[dimensions[2]] = acc[dimensions[2]] || {
              name: dimensions[2],

              data: [],
            }
            acc[dimensions[2]].data.push({ x: dimensions[0] + '/' + dimensions[1], y: v[1] })
            return acc
          }, {})

          monthlyByArea = Object.values(monthlyByArea)
        }

        return monthlyByArea
      },
      async fetch() {
        //  const data = localStorage.getItem('statistics')

        //  if (!JSON.parse(data)) {
        const data = await ajax({ url: apiRoutes.users.statistics })
        //const data = await res.json()
        localStorage.setItem('statistics', JSON.stringify(data))
        this.data = data.data

        /*  } else {
          try {
            this.data = JSON.parse(data)
          } catch (e) {
            console.log(e)
          }
        }*/

        this.registeredUsersByMonth = this.createRegisteredUsersByMonth(this.data)
        this.monthlyByArea = this.createMonthlyResults(this.data)
        this.activeUsersByTypeAndMonth = this.createActiveUsersByMonth(this.data)
        this.activeUsersByMonth = this.createActiveUsersByMonth(this.data)
        this.registrationsByMonthAndState = this.createRegistrationsByMonthAndState(this.data)
      },
    },
  }
</script>
