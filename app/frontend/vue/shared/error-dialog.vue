<template>
  <b-modal id="info-dialog" ref="infoDialog" v-model="isOpen" hide-footer>
    <template #modal-title> Fehler </template>

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
      isOpen() {
        return this.globalStore.errorMessage !== ''
      },
    },
    methods: {
      _close() {
        this.globalStore.setErrorMessage('')
      },
    },
  }
</script>
