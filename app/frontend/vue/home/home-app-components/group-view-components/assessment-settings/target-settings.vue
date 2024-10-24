<template>
  <div>
    <b-card>
      <strong>Zieleinstellungen</strong>
      <div>
        <table class="table striped">
          <thead>
            <tr>
              <td>Name</td>
              <td>Zielwert</td>
              <td>Erlaubte Abweichung</td>
              <td>Zeitraum bis</td>
            </tr>
          </thead>
          <tbody>
            <tr v-for="target in props.targets" :key="target.id">
              <td>{{ getStudentName(target.id) }}</td>
              <td>{{ target.value }}</td>
              <td>{{ target.deviation + '%' || '--' }}</td>
              <td>{{ target.date_until }}</td>
            </tr>
            <tr v-if="isNewOpen">
              <td>
                <b-form-select v-model="selectedStudent" :options="studentOptions" size="sm" />
              </td>
              <td>
                <b-form-input
                  id="target_input"
                  v-model="targetVal"
                  placeholder="Zielwert "
                  type="number"
                  min="0"
                  step="0.01"
                  lang="de"
                  size="sm" />
              </td>
              <td>
                <b-form-input
                  id="deviation_target_input"
                  v-model="deviation"
                  placeholder="Angabe in Prozent"
                  type="number"
                  min="0"
                  max="100"
                  step="1"
                  lang="de"
                  size="sm" />
              </td>
            </tr>
          </tbody>
        </table>

        <b-button size="sm" @click="handleAddTarget">Zielwert hinzufügen</b-button>
      </div>
    </b-card>
  </div>
</template>
<script setup>
  import { ref } from 'vue'
  const props = defineProps({ targets: Array, group: Object })

  const getStudentName = studentId =>
    props.group.students.find(student => student.id === studentId).name
  //{text: "Ganze Klasse", value: -1}
  const studentOptions = props.group.students.map(student => ({
    text: student.name,
    value: student.id,
  }))

  const selectedStudent = ref(undefined)
  const targetVal = ref(undefined)
  const deviation = ref(undefined)

  const isNewOpen = ref(false)
  const handleAddTarget = () => {
    isNewOpen.value = !isNewOpen.value
  }

  const targetFormatter = value => {
    if (value === '') {
      return ''
    }
    const num = Number(value)
    if (!Number.isFinite(num)) {
      return ''
    }
    const twoDigitString = num.toFixed(2)
    return twoDigitString === '' ? '' : Number(twoDigitString).toString()
  }

  const deviationFormatter = value => {
    if (value === '') {
      return ''
    }
    return Math.max(Math.min(Math.round(value), 100), 0).toString()
  }
</script>
