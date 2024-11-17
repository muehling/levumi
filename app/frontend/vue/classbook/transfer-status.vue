<template>
  <div>
    <div v-if="group.has_transfer_request_to" class="mb-4">
      Sie haben
      <b>{{ transferTargetUser }}</b>
      eine Anfrage zur Übertragung dieser Klasse gesendet.
      <b-button variant="outline-danger" size="sm" class="ms-3" @click="cancelTransfer">
        <i class="fas fa-cancel"></i>
        Anfrage beenden
      </b-button>
    </div>
    <div v-else-if="group.key === null">
      <span class="me-4">{{ group.belongs_to }} möchte Ihnen diese Klasse übertragen.</span>

      <b-form class="mt-3" inline :validated="checkKey()" @submit.prevent.stop="acceptShare">
        <b-input
          v-if="!group.is_anonymous"
          v-model="keyInput"
          class="me-2"
          placeholder="Code"
          size="sm" />
        <b-button type="submit" variant="outline-success" size="sm">
          <i class="fas fa-check"></i>
          Jetzt übertragen
        </b-button>
        <b-button variant="outline-danger" size="sm" class="ms-3" @click="requestUnshare">
          <i class="fas fa-cancel"></i>
          Klasse entfernen
        </b-button>
      </b-form>
    </div>
    <confirm-dialog ref="confirmDialog" />
  </div>
</template>

<script>
  import { ajax } from '../../utils/ajax'
  import ConfirmDialog from '../shared/confirm-dialog.vue'
  import { useGlobalStore } from '../../store/store'
  import { encryptKey, decryptWithKey } from '../../utils/encryption'
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
    computed: {
      transferTargetUser() {
        return this.group.has_transfer_request_to
      },
    },

    methods: {
      async cancelTransfer() {
        const ok = await this.$refs.confirmDialog.open({
          message: `Damit beenden Sie die Übernahme dieser Klasse. Sind Sie sicher?`,
          okText: 'Übernahme beenden',
          title: 'Übernahme beenden',
        })
        if (ok) {
          const transferId = this.group.shares.find(share => share.owner === true)?.id
          const res = await ajax({
            url: `/groups/${this.group.id}/group_shares/${transferId}`,
            method: 'delete',
          })

          if (res.status === 200) {
            this.globalStore.fetchGroups()
          }
        }
      },
      async requestUnshare() {
        const ok = await this.$refs.confirmDialog.open({
          message: `Damit lehnen Sie die Übernahme dieser Klasse ab. Sind Sie sicher?`,
          okText: 'Übernahme ablehnen',
          title: 'Übernahme ablehnen',
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
          group_share: { key: this.prepareKey(), is_transfer: true },
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
        return encryptKey(this.keyInput)
      },
    },
  }
</script>
