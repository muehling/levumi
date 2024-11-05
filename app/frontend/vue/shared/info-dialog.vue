<template>
  <b-modal
    id="info-dialog"
    ref="infoDialog"
    :model-value="isOpen"
    :title="title"
    hide-footer
    @hidden="_close">
    <div class="d-block text-center mb-4">
      {{ message }}
    </div>
    <slot></slot>
    <div class="d-flex justify-content-end">
      <b-button variant="outline-secondary" class="m-1" @click="_close">Schließen</b-button>
    </div>
  </b-modal>
</template>

<script>
  export default {
    name: 'InfoDialog',

    data: () => ({
      message: '',
      title: '',
      okText: '',
      isOpen: false,
    }),

    methods: {
      open(data = {}) {
        this.isOpen = true
        this.message = data.message
        this.title = data.title || ''
        this.okText = data.okText
      },

      _close() {
        this.isOpen = false
        this.message = ''
        this.title = ''
      },
    },
  }
</script>
