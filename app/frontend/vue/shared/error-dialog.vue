<template>
  <b-modal id="error-dialog" ref="errorDialog" v-if="isOpen" title="Fehler" hide-footer>
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
    computed: {
      isOpen: {
        get: function () {
          return this.globalStore.errorMessage !== ''
        },
        set: function () {
          this.globalStore.setErrorMessage('')
        },
      },
    },
    methods: {
      _close() {
        this.globalStore.setErrorMessage('')
      },
    },
  }
</script>
<style>
  #error-dialog .error-message {
    white-space: pre-line;
  }
</style>
