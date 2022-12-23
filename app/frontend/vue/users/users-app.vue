<template>
  <b-container v-cloak fluid>
    <b-row class="mt-3"> </b-row>
    <b-tabs v-model="tabIndex" card pills>
      <b-tab title="Nutzerliste">
        <loading-dots v-if="isLoading" :is-loading="isLoading" />
        <users-list v-else-if="canViewUsersList" :users="users" @refetch="refetch"></users-list>
      </b-tab>
      <template #tabs-end>
        <b-nav-item role="presentation" @click="createUser"> Neuen Nutzer anlegen </b-nav-item>
        <b-nav-item role="presentation" @click="openMailDialog">Nachricht an Nutzer</b-nav-item>
      </template>
    </b-tabs>
    <users-mail-dialog ref="usersMailDialog" />
  </b-container>
</template>

<script>
  import { ajax } from '../../utils/ajax'
  import { hasCapability } from '../../utils/user'
  import { useGlobalStore } from '../../store/store'
  import UsersList from './components/users-list.vue'
  import UsersMailDialog from './components/users-mail-dialog.vue'
  import LoadingDots from '../shared/loading-dots.vue'
  export default {
    name: 'UsersApp',
    components: { UsersList, UsersMailDialog, LoadingDots },
    setup() {
      const globalStore = useGlobalStore()
      return { globalStore }
    },
    data: function () {
      return {
        users: [],
        states: this.globalStore.staticData.states,
        focusTypes: this.globalStore.staticData.focusTypes,
        schoolTypes: this.globalStore.staticData.schoolTypes,
        tabIndex: 0,
        isLoading: false,
      }
    },
    computed: {
      canViewUsersList() {
        return hasCapability('user', this.globalStore.login?.capabilities)
      },
    },
    mounted() {
      this.refetch()
    },
    methods: {
      async refetch() {
        if (!this.canViewUsersList) {
          return
        }

        this.isLoading = true
        const res = await ajax({ url: '/users' })
        if (res.status === 200) {
          const data = await res.json()
          this.users = data.users
        } else {
          //TODO output error
        }
        this.isLoading = false
      },
      createUser() {
        this.tabIndex = 0
        this.$refs.editUserDialog.open({ user: {}, isNew: true })
      },
      openMailDialog() {
        this.$refs.usersMailDialog.open()
      },
    },
  }
</script>
