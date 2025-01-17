<template>
  <b-container fluid>
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
    <div class="input-group mb-2 p-0 col-lg-8 col-xl-6">
      <div class="input-group-prepend my-1">
        <span class="input-group-text"><i class="fa-solid fa-magnifying-glass me-2"></i></span>
      </div>
      <b-form-input
        v-model="searchTermByHelpDesk"
        class="input-field my-1"
        placeholder="Nach letzten Bearbeitenden suchen..."
        debounce="500" />
      <b-button class="btn-sm ms-2 my-1" variant="outline-secondary" @click="searchTermByHelpDesk = ''">
        <i class="fas fa-trash"></i>
      </b-button>
    </div>
    <div class="input-group mb-2 col-lg-8 col-xl-6 p-0">
      <label
        for="start-date-registration"
        class="date-label me-3 pt-2 pl-0 col-xs-6 col-sm-6 col-md-4">
        Erstellt zwischen
      </label>
      <b-form-input
        id="start-date-registration"
        v-model="startDateRegistration"
        type="date"
        class="my-1 me-3 date-input col-xs-6 col-sm-4 col-md-4"
        placeholder="Startdatum"
        locale="de-DE"
        size="sm"
        :date-format-options="{
          year: 'numeric',
          month: 'numeric',
          day: 'numeric',
        }" />
      <b-form-input
        id="end-date-registration"
        v-model="endDateRegistration"
        type="date"
        class="my-1 date-input col-xs-6 col-sm-4 col-md-4"
        placeholder="Enddatum"
        locale="de-DE"
        size="sm"
        :date-format-options="{
          year: 'numeric',
          month: 'numeric',
          day: 'numeric',
        }" />
      <b-button
        class="btn-sm ms-2 my-1"
        variant="outline-secondary"
        @click="startDateRegistration = endDateRegistration = undefined">
        <i class="fas fa-trash"></i>
      </b-button>
    </div>
    <div class="input-group mb-2 col-lg-8 col-xl-6 p-0">
      <label for="start-date-login" class="date-label me-3 pt-2 pl-0 col-xs-6 col-sm-6 col-md-4">
        Zuletzt bearbeitet zwischen
      </label>
      <b-form-input
        id="start-date-login"
        v-model="startUpdatedAtDate"
        type="date"
        class="my-1 me-3 date-input col-xs-6 col-sm-4 col-md-4"
        placeholder="Startdatum"
        locale="de-DE"
        size="sm"
        :date-format-options="{
          year: 'numeric',
          month: 'numeric',
          day: 'numeric',
        }" />
      <b-form-input
        id="end-date-login"
        v-model="endUpdatedAtDate"
        type="date"
        class="my-1 date-input col-xs-6 col-sm-4 col-md-4"
        placeholder="Enddatum"
        locale="de-DE"
        size="sm"
        :date-format-options="{
          year: 'numeric',
          month: 'numeric',
          day: 'numeric',
        }" />
      <b-button
        class="btn-sm ms-2 my-1"
        variant="outline-secondary"
        @click="startUpdatedAtDate = endUpdatedAtDate = undefined">
        <i class="fas fa-trash"></i>
      </b-button>
    </div>
    <div>
      <b-table small striped hover class="text-small" :items="supportMessages" :fields="fields">
        <template #cell(created_at)="d">
          <span>{{ new Date(d.item.created_at).toLocaleString('de-DE') }}</span>
        </template>
        <template #cell(status)="d">
          <span :class="getStatusClass(d.item.status)">
            {{ status.find(s => s.id == d.item.status)?.label }}
          </span>
        </template>
        <template #cell(message)="d">
          <span class="abbreviate">{{ d.item.message }}</span>
        </template>
        <template #cell(actions)="data">
          <div class="text-nowrap">
            <b-button
              variant="outline-success"
              class="edit-user btn btn-sm mr-1"
              @click="showMessage(data.item)">
              <i class="fas fa-edit"></i>
              <span class="d-none d-lg-inline">Anzeigen</span>
            </b-button>
            <!-- <b-button
              variant="outline-danger"
              class="delete-user btn btn-sm mr-1"
              @click="changeStatus(data.item.id)">
              <i class="fas fa-trash"></i>
              <span class="d-none d-lg-inline">Status ändern</span>
            </b-button>
             <b-button
              variant="outline-danger"
              class="delete-user btn btn-sm mr-1"
              @click="assignUser(data.item.id)">
              <i class="fas fa-trash"></i>
              <span class="d-none d-lg-inline">Bearbeiter zuweisen</span>
            </b-button>-->
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
    </div>
    <b-modal :model-value="!!selectedMessage" @hidden="hideMessage" @ok="updateMessage">
      <p>
        <a :href="mailto">Antworten an {{ selectedMessage?.sender }}</a>
      </p>
      <hr />
      <p>
        <b>{{ selectedMessage?.subject }}</b>
      </p>
      <p class="mailbody">
        {{ selectedMessage?.message }}
      </p>
      <hr />
      <b-form-radio-group
        v-model="selectedStatus"
        :options="status"
        class="mb-3"
        value-field="id"
        text-field="label" />
      <b-form-input v-model="comment" placeholder="Kommentar" />
      <b-button
            v-if="isLoginAsAllowed()"
            variant="outline-secondary"
            class="delete-user btn btn-sm me-1"
            style="margin-top: 14px;"
            @click="loginAs(selectedMessage?.sender)"
            >
            <i class="fas fa-user-md"></i>
            <span class="d-none d-lg-inline">Einloggen als ...</span>
          </b-button>
    </b-modal>
  </b-container>
</template>
<script>
  import apiRoutes from 'src/vue/routes/api-routes'
  import { ajax } from 'src/utils/ajax'
  import { useGlobalStore } from 'src/store/store'
  import debounce from 'lodash/debounce'
  import { hasCapability } from 'src/utils/user'

  const watchHandler = {
    immediate: true,
    handler: debounce(function (){
      this.fetch()
    },100)
    ,
  }

  export default {
    name: 'SupportApp',
    setup() {
      const store = useGlobalStore()
      return { store }
    },
    data() {
      return {
        currentPage: 1,
        perPage: 20,
        searchTerm: '',
        searchTermByHelpDesk: '',
        startDateRegistration: undefined,
        endDateRegistration: undefined,
        startUpdatedAtDate: undefined,
        endUpdatedAtDate: undefined,
        totalRows: undefined,
        supportUsers: [],
        supportMessages: [],
        selectedMessage: undefined,
        selectedStatus: undefined,
        comment: undefined,
      }
    }
    ,
    computed: {

      fields() {
        return [
          { key: 'created_at', label: 'Erstellt am' },
          { key: 'sender', label: 'Absender' },
          { key: 'subject', label: 'Betreff' },
          { key: 'message', label: 'Nachricht' },
          { key: 'comment', label: 'Kommentar' },
          { key: 'status', label: 'Status', sortable: true},
          { key: 'updated_by', label: 'Bearbeitet von' },
          { key: 'actions', label: 'Aktionen' },
        ]
      },
      status() {
        return [
          { id: 1, label: 'Offen' },
          { id: 2, label: 'In Arbeit' },
          { id: 3, label: 'Info fehlt' },
          { id: 4, label: 'Abgeschlossen' },
        ]
      },
      mailto() {
        const cc = this.supportUsers.filter(email => email !== this.store.login.email).join(',')
        return `mailto:${this.selectedMessage?.sender}?subject=${`Re: Ihre Anfrage bei Levumi ${
          this.selectedMessage?.subject ? ' - ' + this.selectedMessage.subject : ''
        }`}&cc=${cc}&body=${encodeURIComponent(
          '\n\n-----Ursprüngliche Nachricht-----\n\n' + this.selectedMessage?.message
        )}`
      },

    },
    watch: {     
        searchTerm: {
        immediate: true,
        handler() {
          this.currentPage = 1
          this.fetch()
        },
      },
      searchTermByHelpDesk:watchHandler,
      currentPage: watchHandler,
      startDateRegistration: watchHandler,
      endDateRegistration: watchHandler,
      startUpdatedAtDate: watchHandler,
      endUpdatedAtDate: watchHandler,
      perPage: watchHandler,
      },
      /** 
    async created() {
      const res = await ajax(apiRoutes.supportMessages)

      this.supportMessages = res.data.messages
      this.supportUsers = res.data.users
    },
*/
    methods: {
      showMessage(message) {
        this.selectedStatus = this.status.find(s => s.id === message.status)?.id
        this.selectedMessage = message
        this.comment = message.comment
      },
      hideMessage() {
        this.selectedStatus = undefined
        this.selectedMessage = undefined
        this.comment = undefined
      },
      async updateMessage() {
        const data = {
          support_message: {
            status: this.selectedStatus,
            updated_by: this.store.login.email,
            comment: this.comment,
          },
        }
        const res = await ajax(apiRoutes.supportMessages.update(this.selectedMessage.id, data))
        if (res.status === 200) {
          const m = [...this.supportMessages]
          const index = m.findIndex(i => i.id === res.data.message.id)
          m[index] = res.data.message
          this.supportMessages = m
        }
      },
      assignUser(message) {},
      getStatusClass(status) {
        switch (status) {
          case 1:
            return 'text-danger'
          case 4:
            return 'text-success'
          default:
            return 'text-dark'
        }
      },
      async fetch() {
        const params = {
          searchTerm: this.searchTerm.length > 3 ? this.searchTerm : '',
          searchTermByHelpDesk: this.searchTermByHelpDesk.length > 3 ? this.searchTermByHelpDesk: '',
          pageSize: this.perPage,
          currentPage: this.currentPage,
          startUpdatedAtDate: this.startUpdatedAtDate,
          endUpdatedAtDate: this.endUpdatedAtDate,
          startDateRegistration: this.startDateRegistration,
          endDateRegistration: this.endDateRegistration,
        };

        let urlParams = `?page_size=${params.pageSize}&index=${params.currentPage}`
        if (params.searchTerm) {
          urlParams += `&search_term=${params.searchTerm}`
        }
        if (params.searchTermByHelpDesk) {
          urlParams += `&search_term_by_help_desk=${params.searchTermByHelpDesk}`
        }
        if (params.startDateRegistration && params.endDateRegistration) {
          urlParams += `&start_date_registration=${params.startDateRegistration}&end_date_registration=${params.endDateRegistration}`
        }
        if (params.startUpdatedAtDate && params.endUpdatedAtDate) {
          urlParams += `&start_date_login=${params.startUpdatedAtDate}&end_date_login=${params.endUpdatedAtDate}`
        }
        const res = await ajax({
          url: `support_messages/search${urlParams}`,
        })
        if (res.status === 200) {
          const data = res.data
          this.totalRows = data.total_messages
          this.supportMessages = data.support_messages
        }
      },
      isLoginAsAllowed() {
        return (
          hasCapability('user', this.store.login.capabilities)
        )
      },
      async loginAs(sender){
        const params={          
          searchTerm:sender,
        };
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
          if (res.data.users.length < 1) {
            alert('Der User existiert nicht mehr oder hat vermutlich einen andere Mailadresse')
          }else{
            window.location.replace(`/login?user=${res.data.users[0].id}`)
          }
          
        }
        
      },
    },
  }
</script>
<style>
  .mailbody {
    white-space: pre-wrap;
  }
  .abbreviate {
    display: inline-block;
    max-width: 50ch;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }
</style>
