<template>
  <div v-if="permissions?.transferGroup">
    <h4>Eigentümerschaft übertragen</h4>
    <div v-if="hasTransferRequest">
      <span>
        Sie möchten diese Klasse an
        <b>{{ transferRequests }}</b>
        übertragen.
      </span>
      <b-button variant="outline-danger" size="sm" class="ms-2" @click="handleCancelTransfer">
        Anfrage abbrechen
      </b-button>
    </div>
    <b-form v-else inline class="text-small mt-4" @submit.prevent.stop="transferGroup">
      <label for="share-email">Klasse übertragen an&nbsp;&nbsp;</label>
      <div class="email-input-wrapper">
        <b-input
          id="email-email"
          v-model="transferEmail"
          class="me-2 position-relative"
          name="transferEmail"
          placeholder="E-Mail Adresse"
          size="sm"
          autocomplete="false"
          :state="errorMessage !== '' ? false : null"
          @focus="errorMessage = ''" />
        <b-form-invalid-feedback v-if="errorMessage" class="position-absolute">
          {{ errorMessage }}
        </b-form-invalid-feedback>
      </div>

      <b-button
        type="submit"
        variant="outline-success"
        class="me-2"
        size="sm"
        :disabled="isTransferDisabled">
        <span>
          <i class="fas fa-shuffle"></i>
          Klasse an andere Lehrkraft übertragen
        </span>
      </b-button>
      <context-help
        help-text="Mit dieser Aktion wird die Klasse an eine andere Person übertragen. Sie behalten dadurch Lese- und Schreibzugriff auf die Klasse, diese erscheint jedoch dann unter 'Mit mir geteilte Klassen'. Bis die neue Eigentümer:in die Anfrage angenommen hat, können Sie diese abbrechen."
        class-name="mt-2 ms-2" />
    </b-form>
    <confirm-dialog ref="confirmDialog" />
  </div>
</template>
<script>
  import { access } from 'src/utils/access'
  import { ajax } from 'src/utils/ajax'
  import ConfirmDialog from 'src/vue/shared/confirm-dialog.vue'
  import ContextHelp from 'src/vue/shared/context-help.vue'
  import { decryptKey } from 'src/utils/encryption'
  import { useGlobalStore } from 'src/store/store'

  export default {
    name: 'TransferGroup',
    components: { ContextHelp, ConfirmDialog },
    props: { group: Object },
    setup() {
      const globalStore = useGlobalStore()
      return { globalStore }
    },
    data() {
      return {
        transferEmail: '',
        errorMessage: '',
      }
    },
    computed: {
      permissions() {
        return access(this.group).classbook
      },
      isTransferDisabled() {
        return this.transferEmail.length <= 5 && !this.transferEmail.includes('@') // . + @ + TLD + at least one character = 5
      },
      shareKey() {
        return this.globalStore.shareKeys[this.group.id]
          ? decryptKey(this.globalStore.shareKeys[this.group.id])
          : null
      },
      hasTransferRequest() {
        return this.group.has_transfer_request_to !== ''
      },
      transferRequests() {
        console.log(':-(', this.group)

        return this.group.has_transfer_request_to
      },
    },
    methods: {
      async transferGroup() {
        const ok = await this.$refs.confirmDialog.open({
          message: `Soll die Klasse an ${this.transferEmail} übertragen werden?`,
          okText: 'Ja, übertragen',
          cancelText: 'Abbrechen',
          title: 'Klasse übertragen',
        })
        if (!ok) {
          return
        }
        const data = {
          email: this.transferEmail,
          group_share: {
            owner: true,
            read_only: false,
            is_anonymous: false,
            is_transfer: true,
            share_key: this.shareKey,
          },
        }
        const result = await ajax({
          url: `/groups/${this.group.id}/group_shares/`,
          method: 'post',
          data,
        })

        if (result.status === 200) {
          this.email = ''
          this.rightsSelected = 1
          this.globalStore.fetchGroups()
        }
      },

      async handleCancelTransfer() {
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
    },
  }
</script>
