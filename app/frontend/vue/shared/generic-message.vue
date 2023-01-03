<template>
  <b-modal id="error-dialog" ref="errorDialog" v-model="isOpen" hide-footer>
    <template #modal-title> {{ globalStore.genericMessage.title }} </template>

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
    computed: {
      isOpen: {
        get: function () {
          return this.globalStore.genericMessage.message !== ''
        },
        set: function () {
          this.globalStore.resetGenericMessage()
        },
      },
    },
    methods: {
      _close() {
        this.globalStore.resetGenericMessage()
      },
    },
  }
</script>
