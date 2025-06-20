<template>
  <b-modal id="test-edit-dialog" ref="testEditDialog" title="Test bearbeiten" hide-footer>
    <div>
      <b-form>
        <b-form-group label="Test-Typ">
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
        <b-form-group>
          <b-form-checkbox id="quartileCheckbox" v-model="allowQuartiles" class="mb-2" switch>
            Quartilanzeige verfügbar?
          </b-form-checkbox>
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
  import { testDefinitions } from 'src/vue/test-editor/test-definitions'
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
      return {
        description: '',
        shortDescription: '',
        testId: undefined,
        selectedTestType: {},
        allowQuartiles: false,
        test: undefined,
      }
    },
    computed: {
      allTestTypes() {
        return this.globalStore.staticData.testTypes?.map(testType => ({
          id: testType.id,
          name: testType.name,
        }))
      },
      testConfig() {
        const generalConfig = this.test.configuration.options
        const testConfig = testDefinitions[this.test.configuration.item_type].options

        return [
          ...Object.entries(generalConfig).map(conf => {
            const tc = testConfig.find(tc => tc.id === conf[0])

            if (tc) {
              return {
                label: tc.label,
                value: Object.values(conf)[0],
                type: tc.type,
              }
            }
          }),
        ].filter(a => !!a)
      },
    },
    methods: {
      open({ test }) {
        this.description = test.description.full
        this.shortDescription = test.description.short
        this.testId = test.id
        this.selectedTestType =
          this.allTestTypes.find(tt => tt.id === test.testTypeId) || this.allTestTypes[0]
        this.allowQuartiles = test.allowQuartiles
        this.test = test

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
            allow_quartiles: this.allowQuartiles,
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
