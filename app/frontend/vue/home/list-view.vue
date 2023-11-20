<template>
  <div class="d-inline">
    <b-btn v-b-toggle="'test-list-sidebar'" variant="outline-secondary" size="sm" class="d-inline">
      <i class="fas fa-list"></i> Testübersicht</b-btn
    >
    <b-sidebar
      id="test-list-sidebar"
      class="mt-2 mb-4"
      shadow
      no-header
      width="100%"
      bg-variant="white"
    >
      <b-card>
        <b-button variant="primary" class="mb-4"
          >Testübersicht für Klasse {{ group.label }}</b-button
        >
        <group-assessments :group="group" />
        <div class="d-flex justify-content-end">
          <b-btn v-b-toggle="'test-list-sidebar'" variant="danger" class="d-inline mt-4">
            Abbrechen
          </b-btn>
        </div>
      </b-card>
    </b-sidebar>
  </div>
</template>

<script>
  import GroupAssessments from './group-assessments.vue'

  export default {
    name: 'ListView',
    components: { GroupAssessments },
    props: {
      group: Object,
    },
  }
</script>

<style>
  .assessment-list .assessment-line:hover {
    cursor: pointer;
  }

  .assessment-list fieldset.form-group > div {
    display: flex;
    align-items: center;
  }
  #test-list-sidebar {
    margin-top: 4em;
  }
</style>
