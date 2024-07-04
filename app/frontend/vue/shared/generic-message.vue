<template>
  <BModal id="error-dialog" v-if="isOpen" :title="globalStore.genericMessage.title" hide-footer>
    <div class="d-block text-center mb-4">
      {{ globalStore.genericMessage.message }}
      <slot></slot>
      miau
    </div>
    <div class="d-flex justify-content-end">
      <b-button class="m-1" @click="_close">Schließen</b-button>
    </div>
  </BModal>
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
          console.log('genericMessage get', !!this.globalStore.genericMessage.message)

          return !!this.globalStore.genericMessage.message
        },
        set: function () {
          console.log('genericMessage set', this.globalStore.genericMessage.message)

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
