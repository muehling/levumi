<template>
  <info-dialog ref="materialDetails">
    <div class="text-left text-small">
      <p class="text-light bg-secondary ps-1">Kurzbeschreibung</p>
      <p v-html="material.description.short"></p>
      <p class="text-light bg-secondary ps-1">Ausführliche Beschreibung</p>
      <p v-html="material.description.full"></p>
      <p class="text-light bg-secondary ps-1">Benutzungshinweise</p>
      <p v-html="material.description.usage"></p>
    </div>
  </info-dialog>
</template>
<script>
  import InfoDialog from '../../shared/info-dialog.vue'
  export default {
    name: 'MaterialDetailsDialog',
    components: { InfoDialog },
    data() {
      return { material: { description: {}, items: [] } }
    },

    methods: {
      open({ material }) {
        this.material = material
        this.$refs.materialDetails.open({ title: 'Materialbeschreibung' })
      },
    },
  }
</script>
