<template>
  <b-modal
    id="confirm-dialog"
    ref="genericConfirmDialog"
    hide-footer
    :no-close-on-backdrop="disableCloseOnBackdrop"
    @hidden="_close"
  >
    <template #modal-title>
      {{ title }}
    </template>
    <div v-if="!containsHtml" class="d-block text-center mb-4">
      {{ message }}
    </div>
    <div v-else v-html="message"></div>

    <div class="d-flex justify-content-end">
      <b-button v-if="!hideCancelButton" variant="outline-secondary" class="m-1" @click="_close">
        {{ cancelText }}
      </b-button>
      <b-button :variant="okIntent" class="m-1" @click="_confirm">{{ okText }}</b-button>
    </div>
  </b-modal>
</template>

<script>
  export default {
    name: 'ConfirmDialog',

    data() {
      return {
        cancelText: 'Schließen',
        containsHtml: false,
        disableCloseOnBackdrop: false,
        hideCancelButton: false,
        message: '',
        okIntent: '',
        okText: '',
        resolvePromise: undefined,
        title: '',
      }
    },

    methods: {
      open(data = {}) {
        this.$refs.genericConfirmDialog.show()
        this.cancelText = data.cancelText || 'Schließen'
        this.containsHtml = data.containsHtml || false
        this.disableCloseOnBackdrop = data.disableCloseOnBackdrop || false
        this.hideCancelButton = data.hideCancelButton || false
        this.message = data.message
        this.okIntent = data.okIntent || 'outline-danger'
        this.okText = data.okText
        this.title = data.title || ''
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
        this.containsHtml = false
      },
    },
  }
</script>
