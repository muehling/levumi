<template>
  <div>
    <div v-for="o in options" :key="o.id">
      <b-form-group
        v-if="o.type === 'boolean'"
        :label="o.label"
        :label-for="`${o.id}label`"
        label-cols="3"
        class="property-input-group">
        <b-form-checkbox
          :id="`${o.id}label`"
          :value="true"
          :unchecked-value="false"
          inline
          @update:model-value="e => setOption({ [o.id]: e })" />

        <context-help v-if="!!o.description" :help-text="o.description" />
      </b-form-group>
      <b-form-group
        v-if="o.type === 'text'"
        :label="o.label"
        :label-for="`${o.id}label`"
        label-cols="3"
        class="property-input-group">
        <b-form-input
          :id="`${o.id}label`"
          class="d-inline me-2"
          @input="e => setOption({ [o.id]: e.target.value })"></b-form-input>

        <context-help v-if="!!o.description" :help-text="o.description" />
      </b-form-group>
    </div>
  </div>
</template>
<script setup>
  import contextHelp from './context-help.vue'

  const { options } = defineProps({ options: Object })

  const emit = defineEmits(['changeProp'])

  const setOption = val => {
    emit('changeProp', val)
  }
</script>
