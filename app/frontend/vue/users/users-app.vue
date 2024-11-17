<template>
  <b-container fluid>
    <edit-user-dialog ref="editUserDialog" @refetch="refetch" />
    <users-list
      :users="users"
      :total-rows="totalUsers"
      @refetch="refetch"
      @edit-user="editUser"
      @create-user="createUser" />
  </b-container>
</template>

<script>
  import { ajax } from '../../utils/ajax'
  import { hasCapability } from '../../utils/user'
  import { useGlobalStore } from '../../store/store'
  import EditUserDialog from './components/edit-user-dialog.vue'
  import UsersList from './components/users-list.vue'

  export default {
    name: 'UsersApp',
    components: { UsersList, EditUserDialog },
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
          const data = res.data
          this.totalUsers = data.total_users
          this.users = data.users
        }
      },
      createUser() {
        this.$refs.editUserDialog.open({ user: {}, isNew: true })
      },
      editUser(user) {
        this.$refs.editUserDialog.open({ user, isNew: false })
      },
      openMailDialog() {
        this.$refs.usersMailDialog.open({ isNew: true })
      },
    },
  }
</script>
