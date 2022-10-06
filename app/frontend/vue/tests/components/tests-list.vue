<template>
  <div>
    <b-table small striped hover :fields="fields" :items="tests">
      <template #cell(actions)="data">
        <b-btn class="mr-1" variant="outline-primary" @click="showTestDetails(data.item.id)"
          >Details</b-btn
        >
        <b-btn class="mr-1" variant="outline-success" @click="editTest(data.item.id)"
          >Bearbeiten</b-btn
        >
        <b-btn class="mr-1" variant="outline-danger" @click="deleteTest(data.item.id)"
          >Löschen</b-btn
        >
      </template>
    </b-table>
    <test-details-dialog ref="detailsDialog" />
    <edit-test-dialog ref="editTestDialog" />
  </div>
</template>
<script>
  import { ajax } from '../../../utils/ajax'

  import apiRoutes from '../../routes/api-routes'
  import TestDetailsDialog from './test-details-dialog.vue'
  import EditTestDialog from './edit-test-dialog.vue'

  export default {
    name: 'TestsList',
    components: { TestDetailsDialog, EditTestDialog },

    data() {
      return {
        tests: [],
        isLoading: false,
      }
    },
    computed: {
      fields() {
        return [
          { key: 'id', label: 'ID' },
          { key: 'shorthand', label: 'Kurzbezeichnung' },
          { key: 'area', label: 'Bereich' },
          { key: 'competence', label: 'Kompetenz' },
          { key: 'test_family', label: 'Testfamilie' },
          { key: 'level', label: 'Niveaustufe' },
          { key: 'version', label: 'Version' },
          { key: 'archive', label: 'Archiv' },
          { key: 'actions', label: 'Aktionen' },
        ]
      },
    },
    mounted() {
      this.refetch()
    },

    methods: {
      async refetch() {
        const res = await ajax({ url: apiRoutes.tests.index })
        if (res.status === 200) {
          const data = await res.json()
          this.tests = data.tests
          console.log('miau', data.tests)
        }
      },
      showTestDetails(id) {
        console.log('details', id)
        this.$refs.detailsDialog.open({ test: this.tests.find(t => t.id === id) })
      },
      editTest(id) {
        console.log('edit', id)
        const t = this.tests.find(test => test.id === id)
        this.$refs.editTestDialog.open({
          description: t.description.full,
          shortDescription: t.description.short,
          id,
        })
      },
      deleteTest(id) {
        console.log('delete', id)
      },
    },
  }
</script>
