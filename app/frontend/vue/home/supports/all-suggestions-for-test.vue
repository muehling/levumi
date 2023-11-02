<template>
  <div>
    <!-- Spinner für die AJAX-Requests zum Laden eines gewählten Assessments-->

    <div>
      <b-tabs pills>
        <!-- Hinweistext falls kein Material vorhanden -->
        <div slot="empty">
          <div class="text-center text-muted">
            Leider ist zur Zeit kein passendes Fördermaterial vorhanden.
          </div>
        </div>

        <b-tabs pills card vertical class="mt-2">
          <b-tab v-for="material in materials" :key="material.id" :title="material.name">
            <material-view :material="material" :full="false"></material-view>
          </b-tab>
        </b-tabs>
      </b-tabs>
    </div>
  </div>
</template>

<script>
  import MaterialView from '../../materials/material-view.vue'

  import { useMaterialsStore } from '../../../store/materialsStore'
  import uniqBy from 'lodash/uniqBy'

  export default {
    name: 'AllSuggestionsForTest',
    components: { MaterialView },
    props: {
      groupId: Number,
      testId: Number,
    },
    setup() {
      const materialsStore = useMaterialsStore()
      return { materialsStore }
    },
    data: function () {
      return {
        loading: true,
        suggestions: [],
      }
    },
    computed: {
      materials() {
        const materialIds = uniqBy(
          this.materialsStore.materials.supports?.filter(
            support => support.test_id === this.testId
          ),
          'material_id'
        )

        const materials = materialIds.map(support =>
          this.materialsStore.materials.materials.find(
            material => material.id === support.material_id
          )
        )
        return materials
      },
    },
    async created() {
      await this.materialsStore.fetch()
    },
    methods: {},
  }
</script>
