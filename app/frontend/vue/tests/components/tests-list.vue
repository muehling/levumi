<template>
  <div>
    <div v-if="isLoading" class="spinner">
      <div class="bounce1"></div>
      <div class="bounce2"></div>
      <div class="bounce3"></div>
    </div>
    <b-table
      v-else
      class="tests-list text-small"
      small
      striped
      hover
      :fields="fields"
      :items="tests">
      <template #cell(updated_at)="data">
        <span>{{ formatDate(data.item.updated_at) }}</span>
      </template>
      <template #cell(student_test)="data">
        <div class="text-center">{{ data.item.student_test ? 'x' : '-' }}</div>
      </template>
      <template #cell(test_type_id)="data">
        <div class="">{{ getTestTypeLabel(data.item.test_type_id) }}</div>
      </template>
      <template #cell(updated_by)="data">
        <span>{{ data.item.updated_by || '--' }}</span>
      </template>
      <template #cell(actions)="data">
        <b-btn
          v-if="!showExport"
          class="btn-sm me-1"
          variant="outline-primary"
          @click="showTestDetails(data.item.id)">
          <i class="fas fa-glasses"></i>
          <span class="text-small d-none d-xl-inline ps-2">Details</span>
        </b-btn>
        <b-btn
          v-if="!showExport && isEditAndDeleteAllowed"
          class="btn-sm me-1"
          variant="outline-success"
          :disabled="data.item.archive === 'Ja'"
          @click="editTest(data.item.id)">
          <i class="fas fa-edit"></i>
          <span class="text-small d-none d-xl-inline ps-2">Bearbeiten</span>
        </b-btn>
        <b-btn
          v-if="!showExport && isEditAndDeleteAllowed"
          class="btn-sm me-1"
          variant="outline-danger"
          @click="deleteTest(data.item.id)">
          <i class="fas fa-trash"></i>
          <span class="text-small d-none d-xl-inline ps-2">Löschen</span>
        </b-btn>
        <b-link
          v-if="showExport"
          class="btn btn-sm btn-outline-primary"
          variant="outline-secondary"
          :disabled="!data.item.has_results"
          :href="`/tests/${data.item.id}`">
          <i class="fas fa-save"></i>
          <span class="text-small d-none d-xl-inline ps-2">Export</span>
        </b-link>
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
  import format from 'date-fns/format'
  import { useGlobalStore } from '../../../store/store'
  import { hasCapability } from '../../../utils/user'

  export default {
    name: 'TestsList',
    components: {
      ConfirmDialog,
      EditTestDialog,
      TestDetailsDialog,
    },
    props: { fetchTrigger: Symbol, showExport: Boolean },
    setup() {
      const store = useGlobalStore()
      return { store }
    },
    data() {
      return {
        tests: [],
        isLoading: false,
      }
    },
    computed: {
      fields() {
        return [
          { key: 'student_test', label: 'Schülertest' },
          { key: 'id', label: 'ID' },
          { key: 'shorthand', label: 'Kurzbezeichnung' },
          { key: 'area', label: 'Bereich' },
          { key: 'competence', label: 'Kompetenz' },
          { key: 'test_family', label: 'Testfamilie' },
          { key: 'level', label: 'Niveaustufe' },
          { key: 'test_type_id', label: 'Test-Typ' },
          !this.showExport && { key: 'version', label: 'Version' },
          !this.showExport && { key: 'archive', label: 'Archiv' },
          { key: 'updated_at', label: 'Letzes Update' },
          { key: 'updated_by', label: 'Update durch' },
          { key: 'responsible', label: 'Kontakt' },
          { key: 'actions', label: 'Aktionen' },
        ]
      },
      isEditAndDeleteAllowed() {
        return this.checkCapability('test') || this.checkCapability('test_admin')
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
      checkCapability(capability) {
        return hasCapability(capability, this.store.login.capabilities)
      },
      getTestTypeLabel(testTypeId) {
        const testType = this.store.staticData.testTypes.find(
          testType => testType.id === (testTypeId || 1)
        )
        return testType?.name || 'unbekannt'
      },
      formatDate(date) {
        return date ? format(new Date(date), 'dd.MM.yyyy') : '-'
      },
      async refetch() {
        this.isLoading = true
        const res = await ajax({
          url: `${apiRoutes.tests.index}${this.showExport ? '?show_export=true' : ''}`,
        })
        if (res.status === 200) {
          const data = res.data
          this.tests = data.tests.map((t, i) => ({
            ...t,
            index: i + 1,
            _rowVariant: (this.showExport ? !t.has_results : t.archive) ? 'outline-secondary' : '',
          }))
        }
        this.isLoading = false
      },
      showTestDetails(id) {
        this.$refs.detailsDialog.open({ test: this.tests.find(t => t.id === id) })
      },
      editTest(id) {
        const t = this.tests.find(test => test.id === id)
        this.$refs.editTestDialog.open({
          description: t.description.full,
          shortDescription: t.description.short,
          testTypeId: t.test_type_id,
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
  .tests-list .table-outline-secondary {
    color: grey;
  }
  .tests-list td:last-child {
    white-space: nowrap;
  }
</style>
