<template>
  <b-modal
    id="input-dialog"
    ref="genericInputDialog"
    :no-close-on-backdrop="disableClose"
    :no-close-on-esc="disableClose"
    :hide-header-close="disableClose"
    hide-footer
    @shown="$refs.inputField.focus()"
  >
    <template #modal-title>
      {{ title }}
    </template>
    <div class="d-block text-center mb-4">
      {{ message }}
      <b-form @submit="_confirm">
        <b-form-input
          ref="inputField"
          v-model="inputValue"
          :placeholder="placeHolder"
          :type="type"
        ></b-form-input>
      </b-form>
    </div>
    <div class="d-flex justify-content-end">
      <b-button :variant="okIntent" class="m-1" @click="_confirm">{{ okText }}</b-button>
    </div>
  </b-modal>
</template>

<script>
  export default {
    name: 'InputDialog',

    data: () => ({
      message: '',
      title: '',
      okText: '',
      okIntent: '',
      resolvePromise: undefined,
      rejectPromise: undefined,
      inputValue: '',
      placeHolder: '',
      type: 'text',
      disableClose: false,
    }),

    methods: {
      open(data = {}) {
        this.$refs.genericInputDialog.show()
        this.message = data.message
        this.title = data.title || ''
        this.okText = data.okText
        this.okIntent = data.okIntent || 'outline-success'
        this.placeHolder = data.placeHolder || ''
        this.type = data.type || 'text'
        this.disableClose = data.disableClose || false
        return new Promise((resolve, reject) => {
          this.resolvePromise = resolve
          this.rejectPromise = reject
        })
      },

      _close() {
        this.$refs.genericInputDialog.hide()
        this.message = ''
        this.title = ''
        this.resolvePromise(false)
      },
      _confirm(e) {
        e.preventDefault()
        e.stopPropagation()
        this.$refs.genericInputDialog.hide()
        this.message = ''
        this.title = ''
        this.resolvePromise(this.inputValue)
      },
    },
  }
</script>
