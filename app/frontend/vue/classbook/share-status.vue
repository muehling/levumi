<template>
  <div>
    <span class="me-4">Diese Klasse wurde geteilt von: {{ group.belongs_to }}</span>
    <div v-if="!group.key">
      <b-form class="mt-3" inline :validated="checkKey()" @submit.prevent.stop="acceptShare">
        <b-input
          v-if="!group.is_anonymous"
          v-model="keyInput"
          class="me-2"
          placeholder="Code"
          size="sm" />
        <b-button type="submit" variant="outline-primary" size="sm" :disabled="!checkKey()">
          Jetzt freischalten
        </b-button>
        <b-button variant="outline-primary" size="sm" class="ms-3" @click="requestUnshare">
          Klassen entfernen
        </b-button>
      </b-form>
    </div>
    <div v-else class="mb-3">
      <p>
        <span v-if="group.is_anonymous">Die Klasse wurde anonym geteilt;</span>
        Sie können die Klasse
        {{ group.read_only ? ' nur ansehen.' : ' ansehen und verwenden.' }}
      </p>
      <b-btn class="btn btn-sm" variant="outline-danger" @click="requestUnshare">
        <i class="fas fa-cancel"></i>
        Teilen beenden
      </b-btn>
    </div>
    <confirm-dialog ref="confirmDialog" />
  </div>
</template>

<script>
  import { ajax } from '../../utils/ajax'
  import ConfirmDialog from '../shared/confirm-dialog.vue'
  import { useGlobalStore } from '../../store/store'
  import { encryptKey, decryptWithKey, decryptStudentNames } from '../../utils/encryption'
  export default {
    name: 'ShareStatus',
    components: { ConfirmDialog },
    props: { group: Object },
    setup() {
      const globalStore = useGlobalStore()
      return { globalStore }
    },
    data() {
      return { keyInput: '' }
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
      async acceptShare() {
        const data = {
          group_share: { key: this.prepareKey() },
        }
        const result = await ajax({
          url: `/groups/${this.group.id}/group_shares/${this.group.share_id}`,
          method: 'put',
          data,
        })

        if (result) {
          this.globalStore.fetchGroups()
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
