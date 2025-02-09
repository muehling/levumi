<template>
  <div class="container">
    <b-card title="Lernbereiche" class="mt-3">
      <b-table small striped hover :items="areas" :fields="fields" @row-clicked="selectArea">
        <template #cell(actions)="d">
          <tests-meta-actions
            :data="d"
            :delete-item="deleteItem"
            type="areas"
            :rename-item="renameItem" />
        </template>
        <template #cell(name)="d">
          <span>{{ d.item.name }}</span>
        </template>
      </b-table>
    </b-card>
    <b-card
      v-if="areaId && competences.length"
      :title="`Kompetenzbereiche für '${selectedArea?.name}'`"
      class="mt-3">
      <b-table
        small
        striped
        hover
        :items="competences"
        :fields="fields"
        @row-clicked="selectCompetence">
        <template #cell(actions)="d">
          <tests-meta-actions
            :data="d"
            :delete-item="deleteItem"
            type="competences"
            :rename-item="renameItem" />
        </template>
      </b-table>
    </b-card>
    <b-card
      v-if="competenceId && testFamilies.length"
      :title="`Testfamilien für '${selectedCompetence?.name}'`"
      class="mt-3 test-meta">
      <b-table
        small
        striped
        hover
        :items="testFamilies"
        :fields="fields"
        @row-clicked="selectTestFamily">
        <template #cell(actions)="d">
          <tests-meta-actions
            :data="d"
            :delete-item="deleteItem"
            type="testFamilies"
            :rename-item="renameItem" />
        </template>
      </b-table>
    </b-card>
    <b-card
      v-if="testFamilyId && tests.length"
      :title="`Tests für '${selectedTestFamily?.name}'`"
      class="mt-3">
      <b-table
        small
        striped
        hover
        :items="tests"
        :fields="testFields"
        @row-clicked="editTestMeta"></b-table>
    </b-card>
    <confirm-dialog ref="confirmDialog" />
    <tests-meta-edit ref="testsMetaEdit" />
  </div>
</template>
<script>
  import { ajax } from '../../../utils/ajax'
  import { useGlobalStore } from '../../../store/store'
  import apiRoutes from '../../routes/api-routes'
  import ConfirmDialog from '../../shared/confirm-dialog.vue'
  import TestsMetaActions from './tests-meta-actions.vue'
  import TestsMetaEdit from './tests-meta-edit.vue'
  export default {
    name: 'TestsMeta',
    components: { TestsMetaActions, ConfirmDialog, TestsMetaEdit },
    setup() {
      const globalStore = useGlobalStore()
      return { globalStore }
    },
    data() {
      return {
        data: {},
        areaId: undefined,
        competenceId: undefined,
        testFamilyId: undefined,
      }
    },
    computed: {
      fields() {
        return [
          { key: 'id', label: 'ID' },
          { key: 'name', label: 'Name' },
          { key: 'testCount', label: 'Anzahl Tests' },
          { key: 'actions', label: '' },
        ]
      },
      testFields() {
        return [
          { key: 'id', label: 'ID' },
          { key: 'name', label: 'Name' },
          { key: 'testTypeId', label: 'Test-Typ' },
          { key: 'actions', label: '' },
        ]
      },

      selectedArea() {
        return this.data.areas?.find(area => area.id === this.areaId)
      },
      selectedCompetence() {
        return this.data.competences?.find(competence => competence.id === this.competenceId)
      },
      selectedTestFamily() {
        return this.data.test_families?.find(testFamily => testFamily.id === this.testFamilyId)
      },
      areas() {
        return this.data.areas?.map(area => ({
          id: area.id,
          name: area.name,
          testCount: area.test_count,
        }))
      },
      competences() {
        return this.data.competences
          ?.filter(competence => competence.area_id === this.selectedArea.id)
          .map(competence => ({
            id: competence.id,
            name: competence.name,
            testCount: competence.test_count,
          }))
      },
      testFamilies() {
        return this.data.test_families
          ?.filter(testFamily => testFamily.competence_id === this.selectedCompetence.id)
          .map(testFamily => ({
            id: testFamily.id,
            name: testFamily.name,
            testCount: testFamily.test_count,
          }))
      },
      tests() {
        return this.data.tests
          ?.filter(test => test.test_family_id === this.testFamilyId)
          .map(test => ({
            id: test.id,
            name: test.shorthand + ' / ' + test.level + ' / ' + test.label,
            testTypeId: test.test_type_id,
          }))
      },
    },
    async mounted() {
      await this.refetch()
    },
    methods: {
      async refetch() {
        await this.globalStore.fetchTestMetaData()
        this.data = this.globalStore.staticData.testMetaData
      },
      async deleteItem(type, id) {
        const answer = await this.$refs.confirmDialog.open({
          cancelText: 'Abbrechen',
          disableCloseOnBackdrop: true,
          message: 'Eintrag wirklich löschen? Dieser Vorgang kann nicht rückgängig gemacht werden!',
          okIntent: 'outline-danger',
          okText: 'Ok',
          title: 'Eintrag löschen',
        })

        if (answer) {
          await ajax(apiRoutes.administration[type].delete(id))
          await this.refetch()
        }
      },
      async editTestMeta(testRow) {
        const test = this.data.tests.find(test => test.id === testRow.id)

        const dialogInput = await this.$refs.testsMetaEdit.open(test)
        if (dialogInput) {
          await ajax({
            ...apiRoutes.tests.update(testRow.id),
            data: { test_type_id: dialogInput.id },
          })
        }
      },
      async renameItem(type, id, newName) {
        await ajax({
          ...apiRoutes.administration[type].update(id),
          data: { name: newName },
        })
        await this.refetch()
      },
      selectArea(area) {
        this.areaId = area.id
        this.competenceId = undefined
        this.testFamilyId = undefined
      },
      selectCompetence(competence) {
        this.competenceId = competence.id
        this.testFamilyId = undefined
      },
      selectTestFamily(testFamily) {
        this.testFamilyId = testFamily.id
      },
    },
  }
</script>
