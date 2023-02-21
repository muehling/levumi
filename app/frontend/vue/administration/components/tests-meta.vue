<template>
  <div>
    <b-card title="Lernbereiche">
      <div v-for="area in data.areas" :key="area.id" @click="selectArea(area.id)">
        {{ `${area.name} (${area.test_count})` }}
      </div>
    </b-card>
    <b-card v-if="areaId" :title="`Kompetenzbereiche für '${selectedArea?.name}'`">
      <div
        v-for="competence in competences"
        :key="competence.id"
        @click="selectCompetence(competence.id)"
      >
        {{ `${competence.name} (${competence.test_count})` }}
      </div>
    </b-card>
    <b-card v-if="competenceId" :title="`Testfamilien für '${selectedCompetence?.name}'`">
      <div v-for="testFamily in testFamilies" :key="testFamily.id">
        {{ `${testFamily.name} (${testFamily.test_count})` }}
      </div>
    </b-card>
  </div>
</template>
<script>
  import { ajax } from '../../../utils/ajax'
  export default {
    name: 'TestsMeta',
    data() {
      return {
        data: {},
        areaId: undefined,
        competenceId: undefined,

        testFamilyId: undefined,
      }
    },
    computed: {
      selectedArea() {
        return this.data.areas.find(area => area.id === this.areaId)
      },
      selectedCompetence() {
        return this.data.competences.find(competence => competence.id === this.competenceId)
      },
      competences() {
        return this.data.competences.filter(
          competence => competence.area_id === this.selectedArea.id
        )
      },
      testFamilies() {
        return this.data.test_families.filter(
          testFamily => testFamily.competence_id === this.selectedCompetence.id
        )
      },
    },
    async mounted() {
      const res = await ajax({ url: '/tests_meta' })
      const data = await res.json()
      this.data = data
    },
    methods: {
      selectArea(areaId) {
        this.areaId = areaId
        this.competenceId = undefined
        this.testFamilyId = undefined
      },
      selectCompetence(competenceId) {
        this.competenceId = competenceId
        this.testFamilyId = undefined
      },
      selectTestFamily(testFamilyId) {
        this.testFamilyId = testFamilyId
      },
    },
  }
</script>
