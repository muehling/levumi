<template>
  <div>
    <div>
      <div class="assessment-settings my-3">
        <b-button size="sm" variant="outline-secondary" class="py-1 my-3" @click="handleBack">
          <i class="fas fa-backward-step me-1"></i>
          Zurück zum Test
        </b-button>
      </div>
      <b-card class="mt-3 pb-0 mb-1"></b-card>
    </div>
  </div>
</template>
<script setup>
  import { useRoute, useRouter } from 'vue-router'

  //import { useAssessmentsStore } from 'src/store/assessmentsStore'
  //import { storeToRefs } from 'pinia'

  const props = defineProps({ group: Object })
  const router = useRouter()
  const route = useRoute()

  //const assessmentsStore = useAssessmentsStore()
  //  const { currentAssessment } = storeToRefs(assessmentsStore)

  const handleBack = () => {
    router.push(`/diagnostik/${route.params.groupId}/testdetails/${route.params.testId}`)
  }
</script>
