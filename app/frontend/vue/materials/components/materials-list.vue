<template>
  <div>
    <b-table class="text-small" small striped hover :fields="fields" :items="materials">
      <template #cell(actions)="data">
        <b-btn
          class="btn-sm mr-1"
          variant="outline-primary"
          @click="showMaterialDetails(data.item.id)"
        >
          <i class="fas fa-search"></i>
          <span class="text-small d-none d-xl-inline pl-2">Beschreibung</span></b-btn
        >
        <b-btn class="btn-sm mr-1" variant="outline-danger" @click="deleteMaterial(data.item.id)">
          <i class="fas fa-trash"></i>
          <span class="text-small d-none d-xl-inline pl-2">Löschen</span></b-btn
        >
      </template>
    </b-table>
    <material-details-dialog ref="detailsDialog" />
    <confirm-dialog ref="confirmDialog" />
  </div>
</template>
<script>
  import { ajax } from '../../../utils/ajax'
  import apiRoutes from '../../routes/api-routes'
  import ConfirmDialog from '../../shared/confirm-dialog.vue'
  import MaterialDetailsDialog from './material-details-dialog.vue'

  export default {
    name: 'MaterialsList',
    components: {
      ConfirmDialog,
      MaterialDetailsDialog,
    },
    props: { fetchTrigger: Symbol },
    data() {
      return {
        materials: [],
        isLoading: false,
      }
    },
    computed: {
      fields() {
        return [
          { key: 'id', label: 'ID' },
          { key: 'name', label: 'Name' },
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
        const res = await ajax({ url: apiRoutes.materials.index })
        if (res.status === 200) {
          const data = res.data
          this.materials = data.materials.map(t => ({
            ...t,
            _rowVariant: t.archive ? 'outline-secondary' : '',
          }))
        }
      },
      showMaterialDetails(id) {
        this.$refs.detailsDialog.open({ material: this.materials.find(t => t.id === id) })
      },
      editMaterial(id) {
        const t = this.materials.find(material => material.id === id)
        this.$refs.editMaterialDialog.open({
          description: t.description.full,
          shortDescription: t.description.short,
          id,
        })
      },
      async deleteMaterial(id) {
        const ok = await this.$refs.confirmDialog.open({
          title: 'Material löschen',
          message: `Das ausgewählte Material wird gelöscht! Sind Sie sicher?`,
          okText: 'Material löschen',
        })
        if (ok) {
          const res = await ajax({
            url: `/materials/${id}`,
            method: 'DELETE',
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
