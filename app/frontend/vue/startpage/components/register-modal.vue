<template>
  <div class="d-inline">
    <b-button v-b-modal.register-modal class="mr-2" variant="outline-secondary">
      Registrieren
    </b-button>

    <b-modal id="register-modal" title="Registrierung" hide-footer no-close-on-backdrop>
      <register-form />
    </b-modal>
  </div>
</template>
<script>
  import RegisterForm from './register-form.vue'
  export default {
    name: 'RegisterModal',
    components: { RegisterForm },
  }
</script>
