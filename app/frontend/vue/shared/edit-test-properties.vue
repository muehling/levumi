<template>
  <div>
    <div v-for="o in options" :key="o.id">
      <b-form-group v-if="o.type === 'boolean'" :label="o.label" label-cols="3">
        <b-form-radio @click="setOption({ [o.id]: true })">Aktiv</b-form-radio>
        <b-form-radio @click="setOption({ [o.id]: false })">Inaktiv</b-form-radio>
        <context-help :help-text="o.description" />
      </b-form-group>
      <b-form-group v-if="o.type === 'text'" :label="o.label" label-cols="3">
        <b-form-input @input="e => setOption({ [o.id]: e.target.value })"></b-form-input>

        <context-help :help-text="o.description" />
      </b-form-group>
    </div>
  </div>
</template>
<script setup>
  import { ref, onMounted } from 'vue'
  import contextHelp from './context-help.vue'

  const { options } = defineProps({ options: Object })

  const emit = defineEmits(['changeProp'])

  const selectedOptions = ref(undefined)

  onMounted(() => {
    selectedOptions.value = options
  })
  const setOption = val => {
    selectedOptions.value = { ...this.selectedOptions, ...val }
    emit('changeProp', selectedOptions)
  }
</script>
