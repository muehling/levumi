<template>
  <div>
    <div v-if="accountType === 1">
      <b-form-group
        label-cols="3"
        description="An welcher Forschungseinrichtung sind Sie tätig?"
        label="Institution">
        <b-form-input
          :model-value="institution"
          @input="$emit('change-institution', $event.target.value)"></b-form-input>
      </b-form-group>
    </div>
    <div v-if="accountType === 0">
      <b-form-group label-cols="3" description="Wo befindet sich Ihre Schule?" label="Ort">
        <b-form-input
          :model-value="town"
          @input="$emit('change-town', $event.target.value)"></b-form-input>
      </b-form-group>
      <b-form-group label-cols="3" label="Schulart">
        <b-dropdown
          variant="outline-secondary"
          block
          toggle-class="d-flex justify-content-between align-items-center w-100">
          <template #button-content>
            {{ schoolTypeDisplay || '&nbsp;' }}
          </template>
          <b-dropdown-item
            v-for="st in schoolTypes"
            :key="st.label"
            @click="$emit('change-school-type', st.id)">
            {{ st.label }}
          </b-dropdown-item>
        </b-dropdown>
      </b-form-group>
      <b-form-group
        label-cols="3"
        description="Was ist Ihre überwiegende Tätigkeit?"
        label="Tätigkeit">
        <b-dropdown
          variant="outline-secondary"
          block
          toggle-class="d-flex justify-content-between align-items-center w-100">
          <template #button-content>
            {{ focusTypeDisplay || '&nbsp;' }}
          </template>
          <b-dropdown-item
            v-for="ft in focusTypes"
            :key="ft.label"
            @click="$emit('change-focus-type', ft.id)">
            {{ ft.label }}
          </b-dropdown-item>
        </b-dropdown>
      </b-form-group>
    </div>
  </div>
</template>
<script>
  import { useGlobalStore } from '../../../store/store'
  export default {
    name: 'ExtraData',
    props: {
      accountType: Number,
      institution: String,
      focusType: Number,
      schoolType: Number,
      town: String,
    },
    setup() {
      const globalStore = useGlobalStore()
      return { globalStore }
    },

    computed: {
      schoolTypes() {
        return this.globalStore.staticData.schoolTypes
      },
      schoolTypeDisplay() {
        return this.globalStore.staticData.schoolTypes.find(st => st.id === this.schoolType)?.label
      },
      focusTypes() {
        return this.globalStore.staticData.focusTypes
      },
      focusTypeDisplay() {
        return this.globalStore.staticData.focusTypes.find(ft => ft.id === this.focusType)?.label
      },
    },
  }
</script>
