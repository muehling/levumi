<template>
  <div>
    <div class="input-group mb-3">
      <div class="input-group-prepend">
        <span class="input-group-text"><i class="fa-solid fa-magnifying-glass mr-2"></i></span>
      </div>
      <b-form-input
        v-model="searchTerm"
        class="input-field"
        placeholder="Nach Email-Adresse suchen..."
        debounce="500"
      />
    </div>

    <div class="input-container d-inline"></div>
    <b-table small striped hover class="text-small" :items="users" :fields="fields">
      <template #cell(accountType)="d">
        <span>{{
          accountTypes.find(accountType => d.item.account_type === accountType.id).label
        }}</span>
      </template>
      <template #cell(capabilities)="d">
        <span class="text-capitalize">{{ d.item.capabilities }}</span>
      </template>
      <template #cell(created_at)="d">
        <span>{{ new Date(d.item.created_at).toLocaleString('de-DE') }}</span>
      </template>
      <template #cell(last_login)="d">
        <span>{{
          d.item.last_login ? new Date(d.item.last_login).toLocaleString('de-DE') : '-'
        }}</span>
      </template>
      <template #cell(actions)="data">
        <b-btn
          variant="outline-success"
          class="edit-user btn btn-sm mr-1"
          @click="editUser(data.item.id)"
          ><i class="fas fa-edit"></i> Bearbeiten</b-btn
        >
        <b-btn
          v-if="canDeleteUser(data.item)"
          variant="outline-danger"
          class="delete-user btn btn-sm mr-1"
          @click="requestDeleteUser(data.item.id)"
          ><i class="fas fa-trash"></i> Löschen</b-btn
        >
        <b-btn
          v-if="isLoginAsAllowed(data.item)"
          variant="outline-secondary"
          class="delete-user btn btn-sm mr-1"
          @click="loginAs(data.item.id)"
          ><i class="fas fa-user-md"></i> Einloggen als</b-btn
        >
      </template>
    </b-table>
    <b-pagination
      v-if="searchTerm.length < 3"
      v-model="currentPage"
      :total-rows="totalRows"
      :per-page="perPage"
      aria-controls="usersTable"
      @change="delegateRefetch"
    ></b-pagination>
    <confirm-dialog ref="confirmDialog" />
    <edit-user-dialog ref="editUserDialog" @refetch="delegateRefetch" />
  </div>
</template>

<script>
  import { ajax } from '../../../utils/ajax'
  import { hasCapability, isAdmin } from '../../../utils/user'
  import { isRegistered } from '../../../utils/user'
  import { useGlobalStore } from '../../../store/store'
  import ConfirmDialog from '../../shared/confirm-dialog.vue'
  import differenceInDays from 'date-fns/differenceInDays'
  import EditUserDialog from './edit-user-dialog.vue'

  export default {
    name: 'UsersList',
    components: { ConfirmDialog, EditUserDialog },
    props: {
      users: Array,
      totalRows: Number,
    },
    setup() {
      const globalStore = useGlobalStore()
      return { globalStore }
    },
    data: function () {
      return { currentPage: 1, perPage: 20, searchTerm: '' }
    },
    computed: {
      states() {
        return this.globalStore.staticData.states
      },
      focusTypes() {
        return this.globalStore.staticData.focusTypes
      },
      schoolTypes() {
        return this.globalStore.staticData.schoolTypes
      },
      accountTypes() {
        return this.globalStore.staticData.accountTypes
      },
      fields() {
        return [
          { key: 'id', label: 'ID' },
          { key: 'email', label: 'Name' },
          { key: 'accountType', label: 'Account-Typ' },
          { key: 'capabilities', label: 'Rollen' },
          { key: 'created_at', label: 'Erstellt' },
          { key: 'last_login', label: 'Zuletzt eingeloggt' },
          { key: 'actions', label: 'Aktionen' },
        ]
      },
    },
    watch: {
      searchTerm: {
        immediate: true,
        async handler() {
          if (this.searchTerm.length > 3) {
            this.$emit('refetch', { searchTerm: this.searchTerm })
          } else if (this.searchTerm === '') {
            this.$emit('refetch', { currentPage: this.currentPage })
          }
        },
      },
    },
    methods: {
      async requestDeleteUser(id) {
        const user = this.users.find(user => user.id === id)
        if (!user) {
          this.globalStore.setErrorMessage(`Es konnte kein Benutzer zur ID ${id} gefunden werden.`)
          return
        }
        const ok = await this.$refs.confirmDialog.open({
          message: `Der Benutzer <strong>${user.email}</strong> wird mit allen Daten gelöscht. Sind Sie sicher?`,
          cancelText: 'Nein, abbrechen',
          containsHtml: true,
          okText: 'Ja, Benutzer löschen',
          title: 'Benutzer löschen',
        })
        if (ok) {
          const res = await ajax({
            url: `/users/${id}`,
            method: 'delete',
          })

          if (res.status === 200) {
            this.delegateRefetch({ currentPage: 1 })
          }
        }
      },
      delegateRefetch(currentPage) {
        this.$emit('refetch', { currentPage })
      },
      editUser(id) {
        this.$refs.editUserDialog.open({ user: this.users.find(u => u.id === id) })
      },
      loginAs(id) {
        window.location.replace(`/login?user=${id}`)
      },
      checkRegistration(user) {
        return isRegistered(user)
      },
      getUserBackgroundColor(user) {
        if (!user.last_login && differenceInDays(new Date(), new Date(user.created_at)) > 30) {
          return 'table-warning'
        }
        return ''
      },
      isLoginAsAllowed(user) {
        return (
          this.globalStore.login.id !== user.id &&
          user.tc_accepted &&
          isRegistered(user) &&
          !isAdmin(user.capabilities)
        )
      },
      canDeleteUser(user) {
        return (
          hasCapability('user', this.globalStore.login.capabilities) && !isAdmin(user.capabilities)
        )
      },
    },
  }
</script>
