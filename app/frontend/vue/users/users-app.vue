<template>
  <b-container v-cloak fluid>
    <b-row class="mt-3"> </b-row>
    <b-tabs card pills>
      <b-tab title="Nutzerliste">
        <users-list :users="users" :total-rows="totalUsers" @refetch="refetch"></users-list>
      </b-tab>
      <template #tabs-end>
        <b-nav-item role="presentation" @click="createUser"> Neuen Nutzer anlegen </b-nav-item>
        <b-nav-item role="presentation" @click="openMailDialog">Nachricht an Nutzer</b-nav-item>
      </template>
    </b-tabs>
    <users-mail-dialog ref="usersMailDialog" />
    <edit-user-dialog ref="editUserDialog" @refetch="refetch" />
  </b-container>
</template>

<script>
  import { ajax } from '../../utils/ajax'
  import { hasCapability } from '../../utils/user'
  import { useGlobalStore } from '../../store/store'
  import UsersList from './components/users-list.vue'
  import EditUserDialog from './components/edit-user-dialog.vue'
  import UsersMailDialog from './components/users-mail-dialog.vue'
  import Vue from 'vue'
  export default {
    name: 'UsersApp',
    components: { UsersList, UsersMailDialog, EditUserDialog },
    setup() {
      const globalStore = useGlobalStore()
      return { globalStore }
    },
    data: function () {
      return {
        users: [],
        totalUsers: undefined,
        states: this.globalStore.staticData.states,
        focusTypes: this.globalStore.staticData.focusTypes,
        schoolTypes: this.globalStore.staticData.schoolTypes,
        isLoading: false,
      }
    },
    computed: {
      canViewUsersList() {
        return hasCapability('user', this.globalStore.login?.capabilities)
      },
    },
    mounted() {
      this.refetch({ searchTerm: '', pageSize: 20, currentPage: 1 })
    },
    methods: {
      async refetch(params) {
        if (!this.canViewUsersList) {
          return
        }

        let urlParams = `?page_size=${params.pageSize}&index=${params.currentPage}`
        if (params.searchTerm) {
          urlParams += `&search_term=${params.searchTerm}`
        }
        if (params.startDateRegistration && params.endDateRegistration) {
          urlParams += `&start_date_registration=${params.startDateRegistration}&end_date_registration=${params.endDateRegistration}`
        }
        if (params.startDateLogin && params.endDateLogin) {
          urlParams += `&start_date_login=${params.startDateLogin}&end_date_login=${params.endDateLogin}`
        }

        const res = await ajax({
          url: `users/search${urlParams}`,
        })

        if (res.status === 200) {
          const data = await res.json()
          this.totalUsers = data.total_users
          Vue.set(this, 'users', data.users)
        } else {
          //TODO output error
        }
      },
      createUser() {
        this.$refs.editUserDialog.open({ user: {}, isNew: true })
      },
      openMailDialog() {
        this.$refs.usersMailDialog.open({ isNew: true })
      },
    },
  }
</script>
