<template>
  <b-modal id="confirm-dialog" ref="genericConfirmDialog" hide-footer>
    <template #modal-title>
      {{ title }}
    </template>
    <div class="d-block text-center mb-4">
      {{ message }}
    </div>
    <div class="d-flex justify-content-end">
      <b-button variant="outline-secondary" class="m-1" @click="_close">Schließen</b-button>
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
      resolvePromise: undefined,
      rejectPromise: undefined,
    }),

    methods: {
      open(data = {}) {
        this.$refs.genericConfirmDialog.show()
        this.message = data.message
        this.title = data.title || ''
        this.okText = data.okText
        this.okIntent = data.okIntent || 'outline-danger'
        return new Promise((resolve, reject) => {
          this.resolvePromise = resolve
          this.rejectPromise = reject
        })
      },

      _close() {
        this.$refs.genericConfirmDialog.hide()
        this.message = ''
        this.title = ''
        this.resolvePromise(false)
      },
      _confirm() {
        this.$refs.genericConfirmDialog.hide()
        this.message = ''
        this.title = ''
        this.resolvePromise(true)
      },
    },
  }
</script>
