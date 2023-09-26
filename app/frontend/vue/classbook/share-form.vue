<template>
  <div>
    <!-- eigene Klasse => Infos anzeigen und teilen erlauben-->
    <div v-if="group.owner">
      <table
        v-if="group.shares.length > 0"
        class="table table-sm table-striped table-responsive-md text-small"
      >
        <thead>
          <tr>
            <th>Geteilt mit</th>
            <th></th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="share in group.shares" :key="share.id">
            <td>
              {{ share.user }}
            </td>
            <td>
              <div v-if="share.is_anonymous" class="d-inline">
                <span class="mr-4">Klasse ist anonym geteilt.</span>
              </div>
              <b-button
                v-if="!share.is_anonymous"
                class="btn btn-sm mr-1"
                :variant="share.read_only ? 'primary' : 'outline-primary'"
                @click="changeAccessLevel(share.id, 1)"
              >
                <i class="fas fa-glasses"></i> Nur Ansicht
              </b-button>
              <b-button
                v-if="!share.is_anonymous"
                class="btn btn-sm mr-1"
                :variant="!share.read_only ? 'primary' : 'outline-primary'"
                @click="changeAccessLevel(share.id, 0)"
              >
                <i class="fas fa-edit"></i> Ansicht und verwenden
              </b-button>
              <b-button class="btn btn-sm mr-1" variant="outline-danger" @click="unshare(share.id)">
                <i class="fas fa-trash"></i> Nicht mehr teilen
              </b-button>
            </td>
            <td>
              <span v-if="!share.accepted && !share.is_anonymous">
                Der Zugangsschlüssel lautet <b>{{ shareKey }}</b> und wurde per Mail an
                {{ share.user }} gesendet.
              </span>
              <span v-else-if="!share.accepted && share.is_anonymous"
                >{{ share.user }} wurde per Mail benachrichtigt.</span
              >
              <span v-else-if="share.accepted">{{ share.user }} hat die Anfrage angenommen.</span>
            </td>
          </tr>
        </tbody>
      </table>

      <b-btn
        id="intro_cb_4"
        :aria-expanded="isShown"
        aria-controls="'collapse_share_' + group.id"
        variant="outline-secondary"
        size="sm"
        @click="toggleForm"
        ><i class="fas fa-handshake"></i> Klasse teilen
      </b-btn>
      <b-collapse :id="'collapse_share_' + group.id" class="mt-2 mb-4" :visible="isShown">
        <b-form inline class="text-small" @submit="submitNewShare">
          <label for="email">Teilen mit&nbsp;&nbsp;</label>
          <div class="email-input-wrapper">
            <b-input
              v-model="email"
              class="mr-2 position-relative"
              name="email"
              placeholder="E-Mail Adresse"
              size="sm"
              :state="errorMessage !== '' ? false : null"
            />
            <b-form-invalid-feedback v-if="errorMessage" class="position-absolute">
              {{ errorMessage }}
            </b-form-invalid-feedback>
            <context-help
              help-text="Geben Sie hier die Email-Adresse der Person ein, mit der Sie
            die Klasse teilen möchten. Die Person wird dann per Mail informiert. Bei nicht-anonymem
            Teilen enthält die Mail auch den Zugangsschlüssel zum Ansehen der Schüler:innen-Namen.
            Sie können die Berechtigung der Person jederzeit ändern und das Teilen der Klasse auch wieder 
            beenden. Wenn Sie die Klasse in das Archiv verschieben, wird das Teilen automatisch beendet."
              class-name="mt-2"
            />
          </div>
          <b-form-radio-group v-model="rightsSelected" class="ml-4" name="group_share[read_only]">
            <b-form-radio
              v-for="option in permissionOptions"
              :key="option.text"
              :value="option.value"
            >
              <span>{{ option.text }}</span>
              <context-help :help-text="option.helpText" class-name="ml-1 mr-3" />
            </b-form-radio>
          </b-form-radio-group>
          <b-button type="submit" variant="outline-success" size="sm">
            <i class="fas fa-check"></i> Teilen
          </b-button>
        </b-form>
      </b-collapse>
      <span v-if="errorMessage !== ''">&nbsp;</span>
    </div>
    <!-- geteilte Klasse => Teilung beenden -->
    <div v-else>
      <span class="mr-4">Klasse wurde geteilt von: {{ group.belongs_to }}</span>
      <div v-if="!group.key">
        <b-form inline :validated="checkKey()" @submit="acceptShare">
          <b-input
            v-if="!group.is_anonymous"
            v-model="keyInput"
            class="ml-4 mr-2"
            placeholder="Code"
            size="sm"
          />
          <b-button type="submit" variant="outline-primary" size="sm" :disabled="!checkKey()">
            Jetzt freischalten
          </b-button>
          <b-button variant="outline-primary" size="sm" class="ml-3" @click="requestUnshare">
            Klassen entfernen
          </b-button>
        </b-form>
      </div>
      <div v-else>
        <p>
          Sie können die Klasse
          {{ group.read_only ? ' nur ansehen.' : ' ansehen und verwenden.' }}
        </p>
        <b-btn class="btn btn-sm" variant="outline-danger" @click="requestUnshare">
          <i class="fas fa-trash"></i> Teilen beenden
        </b-btn>
      </div>
    </div>
    <confirm-dialog ref="confirmDialog" />
  </div>
</template>

<script>
  import { ajax } from '../../utils/ajax'
  import {
    encryptKey,
    decryptKey,
    decryptWithKey,
    decryptStudentNames,
  } from '../../utils/encryption'
  import { useGlobalStore } from '../../store/store'
  import ConfirmDialog from '../shared/confirm-dialog.vue'
  import ContextHelp from '../shared/context-help.vue'

  export default {
    name: 'ShareForm',
    components: { ConfirmDialog, ContextHelp },
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
      }
    },
    computed: {
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
            helpText: 'Die Person darf die Klasse bearbeiten und Messungen durchführen.',
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
      async requestUnshare() {
        const ok = await this.$refs.confirmDialog.open({
          message: `Damit können Sie nicht weiter auf die Klasse und ihre Messergebnisse zugreifen! Sind Sie sicher?`,
          okText: 'Teilen beenden',
          title: 'Teilen beenden',
        })
        if (ok) {
          const res = await ajax({
            url: `/groups/${this.group.id}/group_shares/${this.group.share_id}`,
            method: 'delete',
          })
          if (res.status === 200) {
            const newGroups = this.globalStore.groups.filter(g => g.id !== this.group.id)
            this.globalStore.setGroups(newGroups)
          }
        }
      },

      toggleForm() {
        this.isShown = !this.isShown
      },
      async submitData(params) {
        const res = await ajax(params)
        if (res.status === 200) {
          const data = await res.json()

          this.$emit('update:groups', { index: this.index, object: data })
          this.isShown = false
          return data
        } else {
          const error = await res.json()
          this.errorMessage = error.message
          return null
        }
      },
      async acceptShare(e) {
        e.preventDefault()
        e.stopPropagation()
        const data = {
          group_share: { key: this.prepareKey() },
        }
        const result = await this.submitData({
          url: `/groups/${this.group.id}/group_shares/${this.group.share_id}`,
          method: 'put',
          data,
        })

        if (result) {
          const newGroups = this.globalStore.groups.filter(group => group.id !== result.id)
          newGroups.push(result)
          this.globalStore.setGroups(newGroups)
          const decryptedGroup = decryptStudentNames(result)
          this.globalStore.setStudentsInGroup({
            groupId: result.id,
            students: decryptedGroup,
          })
          this.globalStore.fetch()
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
          group_share: { read_only: isReadOnly, is_anonymous: isAnonymous },
          share_key: this.shareKey,
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
      changeAccessLevel(shareId, accessLevel) {
        this.submitData({
          url: `/groups/${this.group.id}/group_shares/${shareId}`,
          method: 'put',
          data: { group_share: { read_only: accessLevel } },
        })
      },
      unshare(shareId) {
        this.submitData({
          url: `/groups/${this.group.id}/group_shares/${shareId}`,
          method: 'delete',
        })
      },
      checkKey() {
        if (this.group.is_anonymous) {
          return true
        }
        if (this.keyInput) {
          // The Accept button will remain disabled until the key can be successfully decrypted with the auth_token
          const decrypted = decryptWithKey(this.group.auth_token, this.keyInput)
          return decrypted ? true : false
        } else {
          return false
        }
      },

      prepareKey() {
        if (this.group.is_anonymous) {
          return 'anonymous'
        } else {
          return encryptKey(this.keyInput)
        }
      },
    },
  }
</script>

<style>
  .email-input-wrapper {
    max-width: 20em;
  }
</style>
