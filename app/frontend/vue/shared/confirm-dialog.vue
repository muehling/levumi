<template>
  <b-modal
    id="confirm-dialog"
    ref="confirmDialog"
    hide-footer
    :size="size"
    :no-close-on-backdrop="disableCloseOnBackdrop"
    :title="title"
    @hidden="_close">
    <div v-if="!containsHtml" class="d-block text-center mb-4 text-break">
      {{ message }}
    </div>
    <div v-else class="text-break" v-html="message"></div>
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
        size: '',
        title: '',
      }
    },
    methods: {
      open(data = {}) {
        this.cancelText = data.cancelText || 'Schließen'
        this.containsHtml = data.containsHtml || false
        this.disableCloseOnBackdrop = data.disableCloseOnBackdrop || false
        this.hideCancelButton = data.hideCancelButton || false
        this.message = data.message
        this.okIntent = data.okIntent || 'outline-danger'
        this.okText = data.okText || 'Ok'
        this.title = data.title || ''
        this.size = data.size || ''
        this.$refs.confirmDialog.show()
        return new Promise(resolve => {
          this.resolvePromise = resolve
        })
      },

      _close() {
        if (this.resolvePromise) {
          this.resolvePromise(false)
        }
        this._reset()
      },
      _confirm() {
        if (this.resolvePromise) {
          this.resolvePromise(true)
        }
        this._reset()
      },
      _reset() {
        this.$refs.confirmDialog.hide()
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
