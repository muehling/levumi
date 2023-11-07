<template>
  <div class="row">
    <div class="col-6">Baumansicht</div>
    <div class="col-6">Detailansicht</div>
  </div>
</template>
<script>
  import { ajax } from '../../utils/ajax'
  import { useTestsStore } from '../../store/testsStore'
  import { useGlobalStore } from '../../store/store'
  export default {
    name: 'CreateAssessmentView',
    setup() {
      const globalStore = useGlobalStore()

      const testsStore = useTestsStore()
      return { globalStore, testsStore }
    },
    data: function () {
      console.log('meh', this.testsStore.tests)

      return {
        tests: this.testsStore.tests,
      }
    },
  }
</script>
