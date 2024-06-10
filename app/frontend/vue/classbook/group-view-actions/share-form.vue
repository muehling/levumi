<template>
  <div>
    <!-- eigene Klasse => Infos anzeigen und teilen erlauben-->
    <div v-if="group.owner">
      <b-form inline class="text-small mt-4" @submit="submitNewShare">
        <label for="share-email">Teilen mit&nbsp;&nbsp;</label>
        <div class="email-input-wrapper">
          <b-input
            id="share-email"
            v-model="email"
            class="mr-2 position-relative"
            name="email"
            placeholder="E-Mail Adresse"
            size="sm"
            autocomplete="false"
            :state="errorMessage !== '' ? false : null"
            @focus="errorMessage = ''" />
          <b-form-invalid-feedback v-if="errorMessage" class="position-absolute">
            {{ errorMessage }}
          </b-form-invalid-feedback>
          <context-help
            help-text="Geben Sie hier die Email-Adresse der Person ein, mit der Sie
            die Klasse teilen möchten. Die Person wird dann per Mail informiert. Bei nicht-anonymem
            Teilen enthält die Mail auch den Zugangsschlüssel zum Ansehen der Schüler:innen-Namen.
            Sie können die Berechtigung der Person jederzeit ändern und das Teilen der Klasse auch wieder 
            beenden. Wenn Sie die Klasse in das Archiv verschieben, wird das Teilen automatisch beendet."
            class-name="mt-2" />
        </div>
        <b-form-radio-group v-model="rightsSelected" class="ml-4" name="group_share[read_only]">
          <b-form-radio
            v-for="option in permissionOptions"
            :key="option.text"
            :value="option.value">
            <span>{{ option.text }}</span>
            <context-help :help-text="option.helpText" class-name="ml-1 mr-3" />
          </b-form-radio>
        </b-form-radio-group>
        <b-button type="submit" variant="outline-success" size="sm" :disabled="email.trim() === ''">
          <i class="fas fa-check"></i>
          Teilen
        </b-button>
      </b-form>

      <span v-if="errorMessage !== ''">&nbsp;</span>
    </div>
  </div>
</template>

<script>
  import { access } from 'src/utils/access'
  import { ajax } from 'src/utils/ajax'
  import { decryptKey } from 'src/utils/encryption'
  import { useGlobalStore } from 'src/store/store'
  import ContextHelp from 'src/vue/shared/context-help.vue'

  export default {
    name: 'ShareForm',
    components: { ContextHelp },
    props: {
      group: Object,
      index: Number,
    },
    setup() {
      const globalStore = useGlobalStore()
      return { globalStore }
    },
    data() {
      return {
        rightsSelected: 1,
        keyInput: '',
        email: '',
        isShown: false,
        errorMessage: '',
        transferEmail: '',
      }
    },
    computed: {
      permissions() {
        return access(this.group).classbook
      },
      shareKey() {
        return this.globalStore.shareKeys[this.group.id]
          ? decryptKey(this.globalStore.shareKeys[this.group.id])
          : null
      },
      permissionOptions() {
        return [
          {
            text: 'Nur Ansicht',
            value: 1,
            disabled: 0,
            helpText:
              'Die Person darf die Klasse nicht bearbeiten, kann jedoch Messungen und Namen der Schüler:innen sehen.',
          },
          {
            text: 'Ansicht und verwenden',
            value: 0,
            disabled: 0,
            helpText:
              'Die Person darf die Klasse bearbeiten und Messungen durchführen. Einige Aktionen, wie das Verschieben von Schülern oder das Archivieren der Klasse sind nicht verfügbar.',
          },
          {
            text: 'Anonym teilen',
            value: 2,
            disabled: 0,
            helpText:
              'Die Person darf die Klasse nicht bearbeiten; Namen der Schüler:innen sind anonymisiert. Bei anonym geteilten Klassen kann die Berechtigungsstufe im Nachhinein nicht geändert werden.',
          },
        ]
      },
    },

    methods: {
      async submitData(params) {
        const res = await ajax(params)
        if (res.status === 200) {
          const data = res.data
          this.$emit('update:groups', { index: this.index, object: data })
          this.isShown = false
          return data
        } else {
          const error = res
          this.errorMessage = error.data.message
          return null
        }
      },

      submitNewShare(e) {
        e.preventDefault()
        e.stopPropagation()

        this.errorMessage = ''
        const isReadOnly = this.rightsSelected === 0 ? false : true
        const isAnonymous = this.rightsSelected === 2 ? true : false
        const data = {
          email: this.email,
          group_share: {
            read_only: isReadOnly,
            is_anonymous: isAnonymous,
            share_key: this.shareKey,
          },
        }
        const result = this.submitData({
          url: `/groups/${this.group.id}/group_shares/`,
          method: 'post',
          data,
        })

        if (result) {
          this.email = ''
          this.rightsSelected = 1
        }
      },

      newKey() {
        return Math.random()
          .toString(36)
          .replace(/[^a-z]+/g, '')
          .substr(0, 6)
      },
    },
  }
</script>

<style>
  .email-input-wrapper {
    max-width: 20em;
  }
</style>
