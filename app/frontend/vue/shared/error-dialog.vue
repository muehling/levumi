<template>
  <b-modal id="error-dialog" ref="errorDialog" :model-value="isOpen" title="Fehler" hide-footer>
    <div class="d-block text-center mb-4">
      {{ globalStore.errorMessage }}
      <slot></slot>
    </div>
    <div class="d-flex justify-content-end">
      <b-button class="m-1" @click="_close">Schließen</b-button>
    </div>
  </b-modal>
</template>
<script>
  /************************************
   * Displays generic error messages.
   *
   * Usage: in your component, simply set the message to be displayed into the globalStore via
   * `this.globalStore.setErrorMessage("Something went wrong.")
   ***********************************/
  import { useGlobalStore } from '../../store/store'
  export default {
    name: 'ErrorDialog',
    setup() {
      const globalStore = useGlobalStore()
      return { globalStore }
    },
    data() {
      return {
        isOpen: false,
      }
    },
    watch: {
      'globalStore.errorMessage': {
        handler(data) {
          this.isOpen = !!data
        },
      },
    },
    methods: {
      _close() {
        this.globalStore.setErrorMessage('')
        this.isOpen = false
      },
    },
  }
</script>
<style>
  #error-dialog .error-message {
    white-space: pre-line;
  }
</style>
