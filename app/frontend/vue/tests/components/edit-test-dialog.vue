<template>
  <b-modal id="test-edit-dialog" ref="testEditDialog" title="Test bearbeiten" hide-footer>
    <div>
      <b-form>
        <b-form-group label="Test-Type">
          <b-dropdown
            id="testTypeSelect"
            :text="selectedTestType.name"
            class="m-md-2"
            variant="outline-secondary">
            <b-dropdown-item
              v-for="testType in allTestTypes"
              :key="'testType' + testType.id"
              @click="selectedTestType = testType">
              {{ testType.name }}
            </b-dropdown-item>
          </b-dropdown>
        </b-form-group>
        <b-form-group label="Beschreibung">
          <b-form-textarea
            id="textarea"
            v-model="description"
            class="mb-2"
            rows="3"
            max-rows="6"></b-form-textarea>
        </b-form-group>
        <b-form-group label="Kurzbeschreibung">
          <b-form-textarea
            id="textarea"
            v-model="shortDescription"
            class="mb-2"
            rows="3"
            max-rows="6"></b-form-textarea>
        </b-form-group>
        <div class="d-flex justify-content-end">
          <b-button class="m-1" variant="outline-primary" @click="cancel">Abbrechen</b-button>
          <b-button class="m-1" variant="outline-success" @click="saveChanges">
            Aktualisieren
          </b-button>
        </div>
      </b-form>
    </div>
  </b-modal>
</template>
<script>
  import { ajax } from '../../../utils/ajax'
  import apiRoutes from '../../routes/api-routes'

  import { useGlobalStore } from '../../../store/store'

  export default {
    name: 'EditTestDialog',
    props: {
      users: Array,
    },
    setup() {
      const globalStore = useGlobalStore()
      return { globalStore }
    },
    data() {
      return { description: '', shortDescription: '', testId: undefined, selectedTestType: {} }
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
      open({ description, shortDescription, id, testTypeId }) {
        this.description = description
        this.shortDescription = shortDescription
        this.testId = id
        this.selectedTestType =
          this.allTestTypes.find(tt => tt.id === testTypeId) || this.allTestTypes[0]

        this.$refs.testEditDialog.show()
      },
      _close() {
        this.description = ''
        this.shortDescription = ''
        this.$refs.testEditDialog.hide()
      },
      cancel() {
        this._close()
      },
      async saveChanges() {
        const data = {
          test: {
            description: { full: this.description, short: this.shortDescription },
            test_type_id: this.selectedTestType.id,
          },
        }
        const res = await ajax({ ...apiRoutes.tests.update(this.testId), data })

        if (res.status === 200) {
          this._close()
          this.$emit('update:test_success')
        } else {
          this.globalStore.setErrorMessage(
            'Etwas ist schiefgegangen. Bitte überprüfen Sie Ihre Eingaben.'
          )
        }
      },
    },
  }
</script>
