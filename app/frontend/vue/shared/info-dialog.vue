<template>
  <b-modal id="info-dialog" ref="infoDialog" hide-footer>
    <template #modal-title>
      {{ title }}
    </template>
    <div class="d-block text-center mb-4">
      {{ message }}
    </div>
    <div class="d-flex justify-content-end">
      <b-button class="m-1" @click="_close">Schließen</b-button>
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
    }),

    methods: {
      open(data = {}) {
        this.$refs.infoDialog.show()
        this.message = data.message
        this.title = data.title || ''
        this.okText = data.okText
      },

      _close() {
        this.$refs.infoDialog.hide()
        this.message = ''
        this.title = ''
      },
    },
  }
</script>
