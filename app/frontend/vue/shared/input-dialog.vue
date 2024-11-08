<template>
  <b-modal
    id="input-dialog"
    ref="genericInputDialog"
    :no-close-on-backdrop="disableClose"
    :no-close-on-esc="disableClose"
    :hide-header-close="disableClose"
    :title="title"
    hide-footer
    :model-value="isOpen"
    @shown="$refs.inputField.focus()">
    <div class="d-block mb-4">
      <p>{{ message }}</p>
      <b-form @submit="_confirm">
        <div class="row">
          <div :class="type === 'password' ? 'col-11' : 'col-12'">
            <b-form-input
              ref="inputField"
              v-model="inputValue"
              :placeholder="placeHolder"
              :type="inputType" />
          </div>
          <div v-if="type === 'password'" class="col-1 pl-0 mt-2">
            <i :class="passwordIcon" @click="showPassword = !showPassword"></i>
          </div>
        </div>
      </b-form>
    </div>
    <slot name="extraContent"></slot>
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
      showPassword: false,
      isOpen: false,
    }),
    computed: {
      inputType() {
        switch (this.type) {
          case 'password':
            if (this.showPassword) {
              return 'text'
            } else {
              return 'password'
            }
          default:
            return this.type
        }
      },
      passwordIcon() {
        return this.showPassword ? 'fa fa-eye-slash' : 'fa fa-eye'
      },
    },

    methods: {
      open(data = {}) {
        this.message = data.message
        this.title = data.title || ''
        this.okText = data.okText
        this.okIntent = data.okIntent || 'outline-success'
        this.placeHolder = data.placeHolder || ''
        this.type = data.type || 'text'
        this.disableClose = data.disableClose || false
        this.isOpen = true
        return new Promise((resolve, reject) => {
          this.resolvePromise = resolve
          this.rejectPromise = reject
        })
      },

      _close() {
        this.isOpen = false
        this.message = ''
        this.title = ''
        this.resolvePromise(false)
      },
      _confirm(e) {
        e.preventDefault()
        e.stopPropagation()
        this.isOpen = false
        this.message = ''
        this.title = ''
        this.resolvePromise(this.inputValue)
      },
    },
  }
</script>
