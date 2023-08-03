<template>
  <b-modal id="edit-tests-meta-dialog" ref="editTestsMetaDialog" hide-footer @hidden="_close">
    <template #modal-title> Metadaten bearbeiten </template>

    <div>Test-Typ festlegen</div>
    <b-dropdown
      id="testTypeSelect"
      :text="selectedTestType.name"
      class="m-md-2"
      variant="outline-secondary"
    >
      <b-dropdown-item
        v-for="testType in allTestTypes"
        :key="'testType' + testType.id"
        @click="selectedTestType = testType"
      >
        {{ testType.name }}
      </b-dropdown-item>
    </b-dropdown>

    <div class="d-flex justify-content-end">
      <b-button variant="outline-secondary" class="m-1" @click="_close">Abbrechen</b-button>
      <b-button variant="outline-success" class="m-1" @click="_confirm">Speichern</b-button>
    </div>
  </b-modal>
</template>
<script>
  import { useGlobalStore } from '../../../store/store'
  export default {
    name: 'TestsMetaEdit',
    setup() {
      const globalStore = useGlobalStore()
      return { globalStore }
    },
    data() {
      return {
        selectedTestType: {},
      }
    },
    computed: {
      allTestTypes() {
        return this.globalStore.staticData.testTypes.map(testType => ({
          id: testType.id,
          name: testType.name,
        }))
      },
    },
    methods: {
      open(data = {}) {
        this.name = data.name
        this.description = data.description
        this.$refs.editTestsMetaDialog.show()
        this.selectedTestType =
          this.allTestTypes.find(tt => tt.id === data.test_type_id) || this.allTestTypes[0]

        return new Promise(resolve => {
          this.resolvePromise = resolve
        })
      },

      _close() {
        this.$refs.editTestsMetaDialog.hide()
        this.resolvePromise(undefined)
        this._reset()
      },
      _confirm() {
        this.$refs.editTestsMetaDialog.hide()
        this.resolvePromise(this.selectedTestType)
        this._reset()
      },
      _reset() {
        this.selectedTestType = {}
      },
    },
  }
</script>
