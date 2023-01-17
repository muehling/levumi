<template>
  <b-modal id="confirm-dialog" ref="genericConfirmDialog" hide-footer>
    <template #modal-title>
      {{ title }}
    </template>
    <div class="d-block text-center mb-4">
      {{ message }}
    </div>
    <div class="d-flex justify-content-end">
      <b-button v-if="!hideCancelButton" variant="outline-secondary" class="m-1" @click="_close"
        >Schließen</b-button
      >
      <b-button :variant="okIntent" class="m-1" @click="_confirm">{{ okText }}</b-button>
    </div>
  </b-modal>
</template>

<script>
  export default {
    name: 'ConfirmDialog',

    data: () => ({
      message: '',
      title: '',
      okText: '',
      okIntent: '',
      hideCancelButton: false,
      resolvePromise: undefined,
    }),

    methods: {
      open(data = {}) {
        this.$refs.genericConfirmDialog.show()
        this.message = data.message
        this.title = data.title || ''
        this.okText = data.okText
        this.okIntent = data.okIntent || 'outline-danger'
        this.hideCancelButton = data.hideCancelButton || false
        return new Promise(resolve => {
          this.resolvePromise = resolve
        })
      },

      _close() {
        this.$refs.genericConfirmDialog.hide()
        this.resolvePromise(false)
        this._reset()
      },
      _confirm() {
        this.$refs.genericConfirmDialog.hide()
        this.resolvePromise(true)
        this._reset()
      },
      _reset() {
        this.message = ''
        this.title = ''
        this.okText = ''
        this.okIntent = ''
        this.hideCancelButton = false
      },
    },
  }
</script>
