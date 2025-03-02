<template>
  <b-container fluid>
    <b-card title="Testverwaltung">
      <b-button variant="primary" @click="createTest">Test hochladen</b-button>
      <b-button variant="danger" class="ms-2" @click="resetTestCache">Cache löschen</b-button>
      <tests-list :fetch-trigger="fetchTrigger" />
      <create-test-dialog ref="createTestDialog" @test-import:success="propagateFetch()" />
    </b-card>
  </b-container>
</template>

<script>
  import { ajax } from 'src/utils/ajax'
  import CreateTestDialog from './components/create-test-dialog.vue'
  import { useGlobalStore } from 'src/store/store'

  import TestsList from './components/tests-list.vue'
  export default {
    name: 'TestsAdmin',
    components: { CreateTestDialog, TestsList },
    setup() {
      const globalStore = useGlobalStore()
      return { globalStore }
    },
    data() {
      return { fetchTrigger: Symbol() }
    },
    methods: {
      createTest() {
        this.$refs.createTestDialog.open()
      },
      propagateFetch() {
        this.fetchTrigger = Symbol()
      },
      async resetTestCache() {
        await ajax({ url: '/tests/invalidate_cache' })
        this.globalStore.fetch()
      },
    },
  }
</script>
