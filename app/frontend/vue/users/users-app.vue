<template>
  <b-container v-cloak fluid>
    <b-row class="mt-3"> </b-row>
    <b-tabs v-model="tabIndex" card pills>
      <b-tab title="Nutzerliste">
        <users-list v-if="canViewUsersList" :users="users" @refetch="refetch"></users-list>
      </b-tab>
      <template #tabs-end>
        <b-nav-item role="presentation" @click="createUser"> Neuen Nutzer anlegen </b-nav-item>
        <b-nav-item role="presentation" @click="openMailDialog">Nachricht an Nutzer</b-nav-item>
      </template>
    </b-tabs>
    <edit-user-dialog ref="editUserDialog" @refetch="refetch" />
    <users-mail-dialog ref="usersMailDialog" />
  </b-container>
</template>

<script>
  import { ajax } from '../../utils/ajax'
  import UsersList from './components/users-list.vue'
  import EditUserDialog from './components/edit-user-dialog.vue'
  import UsersMailDialog from './components/users-mail-dialog.vue'
  import { hasCapability } from '../../utils/user'
  import { store } from '../../utils/store'
  export default {
    name: 'UsersApp',
    components: { UsersList, EditUserDialog, UsersMailDialog },
    data: function () {
      return {
        users: [],
        states: store.staticData.states,
        focusTypes: store.staticData.focusTypes,
        schoolTypes: store.staticData.schoolTypes,
        tabIndex: 0,
      }
    },
    computed: {
      canViewUsersList() {
        return hasCapability('user', store.login?.capabilities)
      },
    },
    mounted() {
      this.refetch()
      if (window.location.search.includes('edit_profile')) {
        this.$refs.editUserDialog.open({ user: store.login, isNew: false })
      }
    },
    methods: {
      async refetch() {
        const res = await ajax({ url: '/users' })
        if (res.status === 200) {
          const data = await res.json()
          this.users = data.users
        }
        //TODO this is only necessary because the "Edit own Profile" button currently does not reside inside this Vue app
        //TODO this will be superfluous once the admin area is fully Vue.
        if (window.location.search.includes('edit_profile')) {
          let url = new URL(window.location.href)
          let params = new URLSearchParams(url.search)
          params.delete('edit_profile')
          history.replaceState(null, '', '?' + params + location.hash)
        }
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
