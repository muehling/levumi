<template>
  <b-container v-cloak fluid>
    <b-row class="mt-3"> </b-row>
    <b-tabs card pills>
      <b-tab title="Testübersicht"></b-tab>
      <template #tabs-end>
        <b-nav-item role="presentation" @click="createTest"> Neues Material </b-nav-item>
      </template>
    </b-tabs>
    <materials-list :fetch-trigger="fetchTrigger" />
    <create-material-dialog
      ref="createMaterialDialog"
      @material-import:success="propagateFetch()"
    />
  </b-container>
</template>

<script>
  import CreateMaterialDialog from './components/create-material-dialog.vue'
  import MaterialsList from './components/materials-list.vue'
  export default {
    name: 'MaterialsAdmin',
    components: { CreateMaterialDialog, MaterialsList },
    data() {
      return { fetchTrigger: Symbol() }
    },
    methods: {
      createTest() {
        this.$refs.createMaterialDialog.open()
      },
      propagateFetch() {
        this.fetchTrigger = Symbol()
      },
    },
  }
</script>
