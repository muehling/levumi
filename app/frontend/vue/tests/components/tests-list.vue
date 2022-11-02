<template>
  <div>
    <b-table class="text-small" small striped hover :fields="fields" :items="tests">
      <template #cell(actions)="data">
        <b-btn class="btn-sm mr-1" variant="outline-primary" @click="showTestDetails(data.item.id)">
          <i class="fas fa-glasses"></i>
          <span class="text-small d-none d-xl-inline pl-2">Details</span></b-btn
        >
        <b-btn class="btn-sm mr-1" variant="outline-success" @click="editTest(data.item.id)">
          <i class="fas fa-edit"></i>
          <span class="text-small d-none d-xl-inline pl-2">Bearbeiten</span></b-btn
        >
        <b-btn class="btn-sm mr-1" variant="outline-danger" @click="deleteTest(data.item.id)">
          <i class="fas fa-trash"></i>
          <span class="text-small d-none d-xl-inline pl-2">Löschen</span></b-btn
        >
      </template>
    </b-table>
    <test-details-dialog ref="detailsDialog" />
    <edit-test-dialog ref="editTestDialog" @update:test_success="refetch()" />
    <confirm-dialog ref="confirmDialog" />
  </div>
</template>
<script>
  import { ajax } from '../../../utils/ajax'
  import apiRoutes from '../../routes/api-routes'
  import ConfirmDialog from '../../shared/confirm-dialog.vue'
  import EditTestDialog from './edit-test-dialog.vue'
  import TestDetailsDialog from './test-details-dialog.vue'

  export default {
    name: 'TestsList',
    components: {
      ConfirmDialog,
      EditTestDialog,
      TestDetailsDialog,
    },
    props: { fetchTrigger: Symbol },
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
    watch: {
      fetchTrigger() {
        this.refetch()
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
          this.tests = data.tests.map(t => ({
            ...t,
            _rowVariant: t.archive ? 'outline-secondary' : '',
          }))
        }
      },
      showTestDetails(id) {
        this.$refs.detailsDialog.open({ test: this.tests.find(t => t.id === id) })
      },
      editTest(id) {
        const t = this.tests.find(test => test.id === id)
        this.$refs.editTestDialog.open({
          description: t.description.full,
          shortDescription: t.description.short,
          id,
        })
      },
      async deleteTest(id) {
        const ok = await this.$refs.confirmDialog.open({
          title: 'Test löschen',
          message: `Der Test wird mit allen durchgeführten Messungen gelöscht! Sind Sie sicher?`,
          okText: 'Test löschen',
        })
        if (ok) {
          const res = await ajax({
            url: `/tests/${id}`,
            method: 'delete',
          })

          if (res.status === 200) {
            this.refetch()
          }
        }
      },
    },
  }
</script>

<style>
  .table-outline-secondary {
    color: grey;
  }
</style>
