<template>
  <b-modal
    id="feedback-on-user-deletion"
    ref="confirmDialog"
    hide-footer
    :no-close-on-backdrop="true"
    title="Profil löschen"
    @hidden="_close">
    <div class="d-block text-center mb-4 text-break">
      Mit dieser Aktion werden alle Daten des angemeldeten Benutzers gelöscht. Dies betrifft sowohl
      das Benutzerprofil wie auch alle bisher erfassten Schüler, Klassen und Messungen. Dieser
      Vorgang kann nicht rückgängig gemacht werden.
    </div>
    <div class="contact-form" @click.stop="disableClick">
      <b-form class="m-2" @submit="deleteUser">
        <p>
          <b>
            Schade, dass Sie und verlassen wollen. Wenn Sie möchten, dann geben Sie uns gerne
            Feedback!
          </b>
        </p>
        <b-form-group v-slot="{ ariaDescribedby }">
          <b-form-radio-group
            v-model="selectedTopic"
            :options="supportOptions"
            :aria-describedby="ariaDescribedby"
            name="support-options"
            stacked />
        </b-form-group>
        <b-form-group label-for="delete-contact-message">
          <b-form-textarea
            id="delete-contact-message"
            v-model="contactMessage"
            placeholder="Bitte geben Sie Ihre Nachricht ein."
            rows="3"
            max-rows="6"
            class="mt-4"
            required />
        </b-form-group>
      </b-form>
    </div>
    <div class="d-flex justify-content-end">
      <b-button variant="outline-secondary" class="m-1" @click="_close">Abbrechen</b-button>
      <b-button variant="outline-danger" class="m-1" @click="deleteUser">
        Profil jetzt löschen
      </b-button>
    </div>
  </b-modal>
</template>

<script>
  import { useGlobalStore } from '../../store/store'

  export default {
    name: 'FeedbackOnUserDeletion',
    setup() {
      const globalStore = useGlobalStore()
      return { globalStore }
    },
    data() {
      return {
        resolvePromise: undefined,
        contactMessage: '',
        selectedTopic: undefined,
      }
    },
    computed: {
      supportOptions() {
        return [
          {
            text: 'Ich wollte Levumi nur ausprobieren.',
            value: 'Ich wollte Levumi nur ausprobieren.',
          },
          {
            text: 'Ich habe an einer Studie teilgenommen, die jetzt beendet ist.',
            value: 'Ich habe an einer Studie teilgenommen, die jetzt beendet ist.',
          },
          {
            text: 'Das Testinventar ist für meinen Unterricht nicht geeignet.',
            value: 'Das Testinventar ist für meinen Unterricht nicht geeignet.',
          },
          {
            text: 'Ich bin mit der Benutzerführung unzufrieden.',
            value: 'Ich bin mit der Benutzerführung unzufrieden.',
          },
          { text: 'Sonstiges', value: 'Sonstiges' },
        ]
      },
    },
    methods: {
      open() {
        this.$refs.confirmDialog.show()
        return new Promise(resolve => {
          this.resolvePromise = resolve
        })
      },

      _close() {
        if (this.resolvePromise) {
          this.resolvePromise(undefined)
        }
        this._reset()
      },
      _reset() {
        this.contactMessage = ''
        this.selectedTopic = undefined
        this.$refs.confirmDialog.hide()
      },
      async deleteUser(e) {
        e.preventDefault()
        e.stopPropagation()
        if (this.resolvePromise) {
          this.resolvePromise({
            support_message: {
              message: this.selectedTopic + '\n\n' + this.contactMessage,
            },
          })
        }

        this._reset()
      },
    },
  }
</script>
