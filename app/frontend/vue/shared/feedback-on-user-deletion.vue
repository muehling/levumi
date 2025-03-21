<template>
  <b-modal
    id="feedback-on-user-deletion"
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
    <div class="contact-form" @click.stop="disableClick">
    <b-form class="m-2" @submit="onSendSupportMail">
      <p><b>Schade, dass Sie und verlassen wollen, wenn Sie möchten, dann geben Sie uns gerne Feedback</b></p>
      <b-form-group v-slot="{ ariaDescribedby }">
        <b-form-radio-group
          v-model="selectedTopic"
          :options="supportOptions"
          :aria-describedby="ariaDescribedby"
          name="support-options"
          stacked></b-form-radio-group>
      </b-form-group>
      <b-form-group label-for="contact-message">
        <b-form-textarea
          id="contact-message"
          v-model="contactMessage"
          placeholder="Bitte geben Sie Ihre Nachricht ein."
          rows="3"
          max-rows="6"
          class="mt-4"
          required></b-form-textarea>
      </b-form-group>
    </b-form>
  </div>
    <div class="d-flex justify-content-end">
      <b-button v-if="!hideCancelButton" variant="outline-secondary" class="m-1" @click="_close">
        {{ cancelText }}
      </b-button>
      <b-button :variant="okIntent" class="m-1" @click="onSendSupportMail">{{ okText }}</b-button>
    </div>
  </b-modal>
</template>

<script>
  import { ajax } from '../../utils/ajax.js'
  import { useGlobalStore } from '../../store/store'
  import apiRoutes from '../routes/api-routes'
  export default {
    name: 'FeedbackOnUserDeletion',
    setup() {
      const globalStore = useGlobalStore()
      return { globalStore }
    },
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
        contactMessage: '',
        selectedTopic: undefined,
      }
    },    
    computed: {
      supportOptions() {
        return [
          { text: 'Levumi hat mir nicht gefallen weil', value: 'Levumi hat mir nicht gefallen weil' },
          { text: 'Verbesserungsvorschläge', value: 'Verbesserungsvorschläge' },
          { text: 'Ich gehe in Rente', value: 'Ich gehe in Rente' },
          { text: 'Ich war sehr zufrienden', value: 'Ich war sehr zufrienden' },
          { text: 'Sonstiges', value: 'Sonstiges' },
        ]
      },
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
          this.contactMessage = ''
          this.selectedTopic = undefined
        }
        this._reset()
      },
      //in onSendSupportMail rein
     /* _confirm() {
        if (this.resolvePromise) {
          this.resolvePromise(true)
        }
        this._reset()
      },*/
      _reset() {
        this.$refs.confirmDialog.hide()
        this.message = ''
        this.title = ''
        this.okText = ''
        this.okIntent = ''
        this.hideCancelButton = false
        this.containsHtml = false
      },
      async onSendSupportMail(e) {
        e.preventDefault()
        e.stopPropagation()
        if (this.resolvePromise) {
          
          const data = {
          support_message: {
            sender: null,
            message: this.contactMessage,
            subject: this.selectedTopic,
            user_id: null,
            status: 1,
          },
        }
        await ajax(apiRoutes.supportMessages.create(data))

        this.resolvePromise(true)
        }

        this._reset()
      },
    },
  }
</script>
