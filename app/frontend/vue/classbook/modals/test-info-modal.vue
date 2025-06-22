<template>
  <b-modal
    id="'test-info-modal'"
    v-model="isVisible"
    title="Aktive Tests"
    scrollable
    hide-footer
    static
    size="lg"
    @hidden="hideModal">
    <loading-dots v-if="isLoadingAssessments" />
    <div v-else-if="activeAssessments.length">
      <p>
        Folgende Tests sind aktuell für {{ student.name }} aktiviert. Tests in Grün wurden diese
        Woche schon bearbeitet.
      </p>
      <ul v-if="!!activeAssessments">
        <li v-for="line in activeAssessments" :key="line.text">
          <router-link
            :class="line.isOpen ? 'text-secondary' : 'text-success'"
            :to="`/diagnostik/${line.groupId}/testdetails/${line.testId}`">
            {{ line.text }}
          </router-link>
        </li>
      </ul>
    </div>
    <div v-else>Im Moment sind keine aktiven Tests für diese Schüler*in vorhanden.</div>
  </b-modal>
</template>
<script>
  import { ajax } from '../../../utils/ajax'
  import { RouterLink } from 'vue-router'
  import apiRoutes from '../../routes/api-routes'
  import LoadingDots from '../../shared/loading-dots.vue'

  export default {
    name: 'TestInfoModal',
    components: { LoadingDots, RouterLink },
    props: {
      student: Object,
    },
    data: function () {
      return {
        activeAssessments: [],
        isLoadingAssessments: false,
        isVisible: !!this.student,
      }
    },
    watch: {
      'student.id': {
        immediate: true,
        async handler() {
          await this.loadData()
        },
      },
    },
    methods: {
      hideModal() {
        this.$emit('hide-student-row-modal')
      },
      async loadData() {
        this.isLoadingAssessments = true
        const response = await ajax(apiRoutes.students.activeAssessments(this.student.id))
        if (response.status === 200) {
          const data = response.data

          this.activeAssessments = data.map(a => ({
            isOpen: a.open,
            text: `${a.test_info.area} - ${a.test_info.competence} - ${a.test_info.family} - ${
              a.test_info.level
            } ${a.test_info.student_test ? '' : '(Lehrkräfte-Übung)'}`,
            testId: a.test_info.id,
            groupId: this.student.group_id,
          }))

          this.isLoadingAssessments = false
        }
      },
    },
  }
</script>
