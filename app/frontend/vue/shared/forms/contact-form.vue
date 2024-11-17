<template>
  <div class="contact-form" @click.stop="disableClick">
    <b-form class="m-2" @submit="onSendSupportMail">
      <p><b>Sie haben eine Frage oder möchten uns etwas mitteilen?</b></p>
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
        <b-button class="mt-4 mx-auto" type="submit" variant="outline-success">
          <span>Absenden</span>
        </b-button>
        <b-button class="mt-4 ms-3 mx-auto" variant="outline-danger" @click="handleClose">
          <span>Abbrechen</span>
        </b-button>
      </b-form-group>
    </b-form>
  </div>
</template>

<script>
  import { ajax } from '../../../utils/ajax'
  import { useGlobalStore } from '../../../store/store'
  import apiRoutes from '../../routes/api-routes'
  export default {
    name: 'ContactForm',
    setup() {
      const globalStore = useGlobalStore()
      return { globalStore }
    },
    data() {
      return {
        contactMessage: '',
        selectedTopic: undefined,
      }
    },
    computed: {
      supportOptions() {
        return [
          { text: 'Anregungen aus der Praxis', value: 'Anregungen aus der Praxis' },
          { text: 'Verbesserungsvorschläge', value: 'Verbesserungsvorschläge' },
          { text: 'Hilfe notwendig', value: 'Hilfe notwendig' },
          { text: 'Fehlermeldung', value: 'Fehlermeldung' },
          { text: 'Sonstiges', value: 'Sonstiges' },
        ]
      },
    },
    methods: {
      disableClick() {
        // nothing to do, event.stopPropagation() is already handled by the .stop modifier
      },
      handleClose() {
        this.contactMessage = ''
        this.selectedTopic = undefined
        this.$emit('close-contact-form')
      },
      async onSendSupportMail(e) {
        e.preventDefault()
        e.stopPropagation()
        const data = {
          support_message: {
            sender: this.globalStore.login.email,
            message: this.contactMessage,
            subject: this.selectedTopic,
            status: 1,
          },
        }

        await ajax(apiRoutes.supportMessages.create(data))

        this.globalStore.setGenericMessage({
          title: 'Email gesendet',
          message:
            'Vielen Dank für Ihre Anfrage. Wir werden uns sobald wie möglich bei Ihnen melden.',
        })

        this.handleClose()
      },
    },
  }
</script>
<style>
  .contact-form {
    min-width: 25em;
  }
</style>
