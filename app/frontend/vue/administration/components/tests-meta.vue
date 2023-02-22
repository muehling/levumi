<template>
  <div class="col-md-8 col-xl-6">
    <b-card title="Lernbereiche">
      <b-table small striped hover :items="areas" :fields="fields" @row-clicked="selectArea">
        <template #cell(actions)="d"
          ><tests-meta-actions
            :data="d"
            :delete-item="deleteItem"
            type="area"
            :rename-item="renameItem"
        /></template>
      </b-table>
    </b-card>
    <b-card v-if="areaId" :title="`Kompetenzbereiche für '${selectedArea?.name}'`">
      <b-table
        small
        striped
        hover
        :items="competences"
        :fields="fields"
        @row-clicked="selectCompetence"
      >
        <template #cell(actions)="d"
          ><tests-meta-actions
            :data="d"
            :delete-item="deleteItem"
            type="competence"
            :rename-item="renameItem"
        /></template>
      </b-table>
    </b-card>
    <b-card v-if="competenceId" :title="`Testfamilien für '${selectedCompetence?.name}'`">
      <b-table
        small
        striped
        hover
        :items="testFamilies"
        :fields="fields"
        @row-clicked="selectTestFamily"
      >
        <template #cell(actions)="d"
          ><tests-meta-actions
            :data="d"
            :delete-item="deleteItem"
            type="testFamily"
            :rename-item="renameItem"
        /></template>
      </b-table>
    </b-card>
    <b-card v-if="testFamilyId" :title="`Tests für '${selectedTestFamily?.name}'`">
      <b-table small striped hover :items="tests" :fields="fields"> </b-table>
    </b-card>
  </div>
</template>
<script>
  import { ajax } from '../../../utils/ajax'
  import TestsMetaActions from './tests-meta-actions.vue'
  export default {
    name: 'TestsMeta',
    components: { TestsMetaActions },
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
          { key: 'actions', label: '' },
        ]
      },

      selectedArea() {
        return this.data.areas.find(area => area.id === this.areaId)
      },
      selectedCompetence() {
        return this.data.competences.find(competence => competence.id === this.competenceId)
      },
      selectedTestFamily() {
        return this.data.test_families.find(testFamily => testFamily.id === this.testFamilyId)
      },
      areas() {
        return this.data.areas?.map(area => ({
          id: area.id,
          name: `${area.name} (${area.test_count})`,
        }))
      },
      competences() {
        return this.data.competences
          .filter(competence => competence.area_id === this.selectedArea.id)
          .map(competence => ({
            id: competence.id,
            name: `${competence.name} (${competence.test_count})`,
          }))
      },
      testFamilies() {
        return this.data.test_families
          .filter(testFamily => testFamily.competence_id === this.selectedCompetence.id)
          .map(testFamily => ({
            id: testFamily.id,
            name: `${testFamily.name} (${testFamily.test_count})`,
          }))
      },
      tests() {
        return this.data.tests
          .filter(test => test.test_family_id === this.testFamilyId)
          .map(test => ({
            id: test.id,
            name: test.shorthand + ' / ' + test.level + ' / ' + test.label,
          }))
      },
    },
    async mounted() {
      const res = await ajax({ url: '/tests_meta' })
      const data = await res.json()
      this.data = data
    },
    methods: {
      deleteItem(type, id) {
        console.log('delete', type, id)
      },
      renameItem(type, id) {
        console.log('rename', type, id)
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
