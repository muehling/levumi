<template>
  <div>
    <div class="input-group mb-2 p-0 col-lg-8 col-xl-6">
      <div class="input-group-prepend my-1">
        <span class="input-group-text"><i class="fa-solid fa-magnifying-glass me-2"></i></span>
      </div>
      <b-form-input
        v-model="searchTerm"
        class="input-field my-1"
        placeholder="Nach Email-Adresse suchen..."
        debounce="500" />
      <b-button class="btn-sm ms-2 my-1" variant="outline-secondary" @click="searchTerm = ''">
        <i class="fas fa-trash"></i>
      </b-button>
    </div>
    <div class="input-group mb-2 col-lg-8 col-xl-6 p-0">
      <label
        for="start-date-registration"
        class="date-label me-3 pt-2 pl-0 col-xs-6 col-sm-6 col-md-4">
        Registriert zwischen
      </label>
      <b-form-datepicker
        id="start-date-registration"
        v-model="startDateRegistration"
        class="my-1 me-3 date-input col-xs-6 col-sm-4 col-md-4"
        placeholder="Startdatum"
        locale="de-DE"
        size="sm"
        :date-format-options="{
          year: 'numeric',
          month: 'numeric',
          day: 'numeric',
        }"></b-form-datepicker>
      <b-form-datepicker
        id="end-date-registration"
        v-model="endDateRegistration"
        class="my-1 date-input col-xs-6 col-sm-4 col-md-4"
        placeholder="Enddatum"
        locale="de-DE"
        size="sm"
        :date-format-options="{
          year: 'numeric',
          month: 'numeric',
          day: 'numeric',
        }"></b-form-datepicker>
      <b-button
        class="btn-sm ms-2 my-1"
        variant="outline-secondary"
        @click="startDateRegistration = endDateRegistration = undefined">
        <i class="fas fa-trash"></i>
      </b-button>
    </div>
    <div class="input-group mb-2 col-lg-8 col-xl-6 p-0">
      <label for="start-date-login" class="date-label me-3 pt-2 pl-0 col-xs-6 col-sm-6 col-md-4">
        Zuletzt angemeldet zwischen
      </label>
      <b-form-datepicker
        id="start-date-login"
        v-model="startDateLogin"
        class="my-1 me-3 date-input col-xs-6 col-sm-4 col-md-4"
        placeholder="Startdatum"
        locale="de-DE"
        size="sm"
        :date-format-options="{
          year: 'numeric',
          month: 'numeric',
          day: 'numeric',
        }"></b-form-datepicker>
      <b-form-datepicker
        id="end-date-login"
        v-model="endDateLogin"
        class="my-1 date-input col-xs-6 col-sm-4 col-md-4"
        placeholder="Enddatum"
        locale="de-DE"
        size="sm"
        :date-format-options="{
          year: 'numeric',
          month: 'numeric',
          day: 'numeric',
        }"></b-form-datepicker>
      <b-button
        class="btn-sm ms-2 my-1"
        variant="outline-secondary"
        @click="startDateLogin = endDateLogin = undefined">
        <i class="fas fa-trash"></i>
      </b-button>
    </div>

    <div class="input-container d-inline"></div>
    <b-table small striped hover class="text-small" :items="users" :fields="fields">
      <template #cell(accountType)="d">
        <span>
          {{ accountTypes.find(accountType => d.item.account_type === accountType.id).label }}
        </span>
      </template>
      <template #cell(capabilities)="d">
        <span class="text-capitalize">{{ d.item.capabilities }}</span>
      </template>
      <template #cell(created_at)="d">
        <span>{{ new Date(d.item.created_at).toLocaleString('de-DE') }}</span>
      </template>
      <template #cell(last_login)="d">
        <span>
          {{ d.item.last_login ? new Date(d.item.last_login).toLocaleString('de-DE') : '-' }}
        </span>
      </template>
      <template #cell(actions)="data">
        <div class="text-nowrap">
          <b-button
            variant="outline-success"
            class="edit-user btn btn-sm me-1"
            @click="editUser(data.item.id)">
            <i class="fas fa-edit"></i>
            <span class="d-none d-lg-inline">Bearbeiten</span>
          </b-button>
          <b-button
            v-if="canDeleteUser(data.item)"
            variant="outline-danger"
            class="delete-user btn btn-sm me-1"
            @click="requestDeleteUser(data.item.id)">
            <i class="fas fa-trash"></i>
            <span class="d-none d-lg-inline">Löschen</span>
          </b-button>
          <b-button
            v-if="isLoginAsAllowed(data.item)"
            variant="outline-secondary"
            class="delete-user btn btn-sm me-1"
            @click="loginAs(data.item.id)">
            <i class="fas fa-user-md"></i>
            <span class="d-none d-lg-inline">Einloggen als</span>
          </b-button>
        </div>
      </template>
    </b-table>
    <div class="d-flex">
      <b-pagination
        v-model="currentPage"
        :total-rows="totalRows"
        :per-page="perPage"
        first-number
        last-number
        active-class="bg-primary"
        aria-controls="usersTable">
        <template #page="{ page, active }">
          <b v-if="active" class="bg-primary">{{ page }}</b>
          <span v-else>{{ page }}</span>
        </template>
      </b-pagination>
      <div class="ms-3 p-1">
        <b-dropdown size="sm" variant="outline-primary" :text="`${perPage} Einträge pro Seite`">
          <b-dropdown-item @click="perPage = 10">10 Einträge</b-dropdown-item>
          <b-dropdown-item @click="perPage = 20">20 Einträge</b-dropdown-item>
          <b-dropdown-item @click="perPage = 40">40 Einträge</b-dropdown-item>
          <b-dropdown-item @click="perPage = 100">100 Einträge</b-dropdown-item>
          <b-dropdown-item @click="perPage = 200">200 Einträge</b-dropdown-item>
        </b-dropdown>
      </div>
    </div>
    <confirm-dialog ref="confirmDialog" />
    <edit-user-dialog ref="editUserDialog" @refetch="delegateRefetch" />
  </div>
</template>

<script>
  import { ajax } from 'src/utils/ajax'
  import { hasCapability } from 'src/utils/user'
  import { isRegistrationComplete } from 'src/utils/user'
  import { useGlobalStore } from 'src/store/store'
  import ConfirmDialog from 'src/vue/shared/confirm-dialog.vue'
  import differenceInDays from 'date-fns/differenceInDays'
  import EditUserDialog from './edit-user-dialog.vue'
  import debounce from 'lodash/debounce'

  const watchHandler = {
    immediate: true,
    handler: debounce(function () {
      this.delegateRefetch()
    }, 100),
  }

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
      return {
        currentPage: 1,
        perPage: 20,
        searchTerm: '',
        startDateRegistration: undefined,
        endDateRegistration: undefined,
        startDateLogin: undefined,
        endDateLogin: undefined,
      }
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
      searchTerm: watchHandler,
      currentPage: watchHandler,
      startDateRegistration: watchHandler,
      endDateRegistration: watchHandler,
      startDateLogin: watchHandler,
      endDateLogin: watchHandler,
      perPage: watchHandler,
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
            this.delegateRefetch()
          }
        }
      },
      delegateRefetch() {
        this.$emit('refetch', {
          searchTerm: this.searchTerm.length > 3 ? this.searchTerm : '',
          pageSize: this.perPage,
          currentPage: this.currentPage,
          startDateLogin: this.startDateLogin,
          endDateLogin: this.endDateLogin,
          startDateRegistration: this.startDateRegistration,
          endDateRegistration: this.endDateRegistration,
        })
      },
      editUser(id) {
        this.$refs.editUserDialog.open({ user: this.users.find(u => u.id === id) })
      },
      loginAs(id) {
        window.location.replace(`/login?user=${id}`)
      },
      checkRegistration(user) {
        return isRegistrationComplete(user)
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
          isRegistrationComplete(user) &&
          !user.capabilities?.includes('admin')
        )
      },
      canDeleteUser(user) {
        return (
          hasCapability('user', this.globalStore.login.capabilities) &&
          !user.capabilities?.includes('admin')
        )
      },
    },
  }
</script>
<style>
  .date-label {
    white-space: nowrap;
  }
</style>
