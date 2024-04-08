<template>
  <table
    v-if="group.shares.length > 0"
    class="mt-4 table table-sm table-striped table-responsive-md text-small">
    <thead>
      <tr>
        <th>Geteilt mit</th>
        <th></th>
        <th></th>
      </tr>
    </thead>
    <tbody>
      <tr v-for="share in group.shares" :key="share.id + '/' + share.read_only">
        <td>
          {{ share.user + '/' + share.read_only }}
        </td>
        <td>
          <div v-if="share.is_anonymous" class="d-inline">
            <span class="mr-4">Klasse ist anonym geteilt.</span>
          </div>
          <b-button
            v-if="!share.is_anonymous"
            class="btn btn-sm mr-1"
            :variant="share.read_only ? 'primary' : 'outline-primary'"
            @click="changeAccessLevel(share.id, 1)">
            <i class="fas fa-glasses"></i>
            Nur Ansicht
          </b-button>
          <b-button
            v-if="!share.is_anonymous"
            class="btn btn-sm mr-1"
            :variant="!share.read_only ? 'primary' : 'outline-primary'"
            @click="changeAccessLevel(share.id, 0)">
            <i class="fas fa-edit"></i>
            Ansicht und verwenden
          </b-button>
          <b-button class="btn btn-sm mr-1" variant="outline-danger" @click="unshare(share.id)">
            <i class="fas fa-trash"></i>
            Nicht mehr teilen
          </b-button>
        </td>
        <td>
          <span v-if="!share.accepted && !share.is_anonymous">
            Der Zugangsschlüssel lautet
            <b>{{ shareKey }}</b>
            und wurde per Mail an {{ share.user }} gesendet.
          </span>
          <span v-else-if="!share.accepted && share.is_anonymous">
            {{ share.user }} wurde per Mail benachrichtigt.
          </span>
          <span v-else-if="share.accepted">{{ share.user }} hat die Anfrage angenommen.</span>
        </td>
      </tr>
    </tbody>
  </table>
</template>
<script>
  import { ajax } from '../../utils/ajax'
  import { decryptKey } from '../../utils/encryption'
  import { useGlobalStore } from '../../store/store'
  import Vue from 'vue'
  export default {
    name: 'SharesDisplay',
    props: { group: Object },
    setup() {
      const globalStore = useGlobalStore()
      return { globalStore }
    },
    computed: {
      shareKey() {
        return this.globalStore.shareKeys[this.group.id]
          ? decryptKey(this.globalStore.shareKeys[this.group.id])
          : null
      },
    },
    methods: {
      async changeAccessLevel(shareId, accessLevel) {
        const res = await ajax({
          url: `/groups/${this.group.id}/group_shares/${shareId}`,
          method: 'put',
          data: { group_share: { read_only: accessLevel } },
        })
        if (res.status === 200) {
          console.log(
            res.data,
            this.globalStore.groups.find(g => g.id === res.data.id)
          )
          const groups = [...this.globalStore.groups]
          const group = this.globalStore.groups.find(g => g.id === res.data.id)
          group.read_only = res.data.read_only
          Vue.set(this.globalStore, 'groups', groups)
          //TODO bestimmt irgendwas updaten
          // const data = res.data
          // this.$emit('update:groups', { index: this.index, object: data })
          // this.isShown = false
          // return data
        } else {
          // TODO global error setzen
          //const error = res.data
          //this.errorMessage = error.message
          //return null
        }
      },

      async unshare(shareId) {
        const res = await ajax({
          url: `/groups/${this.group.id}/group_shares/${shareId}`,
          method: 'delete',
        })
        if (res.status === 200) {
          Vue.set(this.globalStore, 'groups', res.data)
        }
      },
    },
  }
</script>
