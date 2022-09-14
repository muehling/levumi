<template>
  <div>
    <div v-if="accountType === 1">
      <b-form-group
        label-cols="3"
        description="An welcher Forschungseinrichtung sind Sie tätig?"
        label="Institution"
      >
        <b-form-input
          v-model="institution"
          @input="$emit('change-institution', $event)"
        ></b-form-input>
      </b-form-group>
    </div>
    <div v-if="accountType === 0">
      <b-form-group label-cols="3" description="Wo befindet sich Ihre Schule?" label="Ort">
        <b-form-input v-model="town" @input="$emit('change-town', $event)"></b-form-input>
      </b-form-group>
      <b-form-group label-cols="3" label="Schulart">
        <b-dropdown
          variant="outline-secondary"
          block
          toggle-class="d-flex justify-content-between align-items-center w-100"
        >
          <template #button-content>
            {{ schoolType || '&nbsp;' }}
          </template>
          <b-dropdown-item
            v-for="st in schoolTypes"
            :key="st.label"
            @click="
              schoolType = st.label
              $emit('change-school-type', st.id)
            "
            >{{ st.label }}
          </b-dropdown-item>
        </b-dropdown>
      </b-form-group>
      <b-form-group
        label-cols="3"
        description="Was ist Ihre überwiegende Tätigkeit?"
        label="Tätigkeit"
      >
        <b-dropdown
          variant="outline-secondary"
          block
          toggle-class="d-flex justify-content-between align-items-center w-100"
        >
          <template #button-content>
            {{ focusType || '&nbsp;' }}
          </template>
          <b-dropdown-item
            v-for="ft in focusTypes"
            :key="ft.label"
            @click="
              focusType = ft.label
              $emit('change-focus-type', ft.id)
            "
            >{{ ft.label }}</b-dropdown-item
          >
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
    },
    setup() {
      const globalStore = useGlobalStore()
      return { globalStore }
    },
    data() {
      return {
        institution: '',
        town: '',
        schoolType: '',
        focusType: '',
      }
    },
    computed: {
      schoolTypes() {
        return this.globalStore.staticData.schoolTypes
      },
      focusTypes() {
        return this.globalStore.staticData.focusTypes
      },
    },
  }
</script>
