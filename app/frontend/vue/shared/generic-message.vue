<template>
  <b-modal
    id="error-dialog"
    :model-value="isOpen"
    :title="globalStore.genericMessage.title"
    hide-footer>
    <div class="d-block text-center mb-4">
      {{ globalStore.genericMessage.message }}
      <slot></slot>
    </div>
    <div class="d-flex justify-content-end">
      <b-button class="m-1" @click="_close">Schließen</b-button>
    </div>
  </b-modal>
</template>
<script>
  /************************************
   * Displays generic messages.
   *
   * Usage: in your component, simply set the message to be displayed into the globalStore via
   * `this.globalStore.setGenericMessage({message: "Some message", title: "Custom title"})`
   ***********************************/
  import { useGlobalStore } from '../../store/store'
  export default {
    name: 'GenericMessage',
    setup() {
      const globalStore = useGlobalStore()
      return { globalStore }
    },
    data() {
      return { isOpen: false }
    },
    watch: {
      'globalStore.genericMessage': {
        handler(data) {
          this.isOpen = !!data?.message
        },
      },
    },
    methods: {
      _close() {
        this.globalStore.resetGenericMessage()
        this.isOpen = false
      },
    },
  }
</script>
<style>
  #generic-dialog .generic-message {
    white-space: pre-line;
  }
</style>
