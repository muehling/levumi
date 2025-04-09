<template>
  <b-container fluid>
    <div class="input-group mb-2 p-0 col-lg-8 col-xl-6">
      <div class="input-group-prepend my-1">
        <span class="input-group-text"><i class="fa-solid fa-magnifying-glass me-2"></i></span>
      </div>
      <b-form-input
        v-model="searchTerm"
        class="input-field my-1"
        placeholder="Nach E-Mail-Adresse suchen..."
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
      <b-button
        class="btn-sm ms-2 my-1"
        variant="outline-secondary"
        @click="searchTermByHelpDesk = ''">
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
        v-model="startDateCreatedAt"
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
        v-model="endDateCreatedAt"
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
        @click="startDateCreatedAt = endDateCreatedAt = undefined">
        <i class="fas fa-trash"></i>
      </b-button>
    </div>
    <div class="input-group mb-2 col-lg-8 col-xl-6 p-0">
      <label for="start-date-login" class="date-label me-3 pt-2 pl-0 col-xs-6 col-sm-6 col-md-4">
        Zuletzt bearbeitet zwischen
      </label>
      <b-form-input
        id="start-date-login"
        v-model="startDateUpdatedAt"
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
        v-model="endDateUpdatedAt"
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
        @click="startDateUpdatedAt = endDateUpdatedAt = undefined">
        <i class="fas fa-trash"></i>
      </b-button>
    </div>
    <div>
      <b-table
        id="messagesTable"
        small
        striped
        hover
        class="text-small"
        :items="supportMessages"
        :fields="fields">
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
              class="edit-user btn btn-sm me-1"
              @click="showMessage(data.item)">
              <i class="fas fa-edit"></i>
              <span class="d-none d-lg-inline">Anzeigen</span>
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
          aria-controls="messagesTable">
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
        v-if="isLoginAsAllowed(selectedMessage)"
        variant="outline-secondary"
        class="delete-user btn btn-sm me-1"
        style="margin-top: 14px"
        @click="loginAs(selectedMessage)">
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
    handler: debounce(function () {
      this.fetch()
    }, 100),
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
        startDateCreatedAt: undefined,
        endDateCreatedAt: undefined,
        startDateUpdatedAt: undefined,
        endDateUpdatedAt: undefined,
        totalRows: undefined,
        supportUsers: [],
        supportMessages: [],
        selectedMessage: undefined,
        selectedStatus: undefined,
        comment: undefined,
      }
    },
    computed: {
      fields() {
        return [
          { key: 'created_at', label: 'Erstellt am' },
          { key: 'sender', label: 'Absender' },
          { key: 'subject', label: 'Betreff' },
          { key: 'message', label: 'Nachricht' },
          { key: 'comment', label: 'Kommentar' },
          { key: 'status', label: 'Status' },
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
      searchTermByHelpDesk: watchHandler,
      currentPage: watchHandler,
      startDateCreatedAt: watchHandler,
      endDateCreatedAt: watchHandler,
      startDateUpdatedAt: watchHandler,
      endDateUpdatedAt: watchHandler,
      perPage: watchHandler,
    },

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
          searchTermByHelpDesk:
            this.searchTermByHelpDesk.length > 3 ? this.searchTermByHelpDesk : '',
        }

        let urlParams = `?page_size=${this.perPage}&index=${this.currentPage}`
        if (params.searchTerm) {
          urlParams += `&search_term=${params.searchTerm}`
        }
        if (params.searchTermByHelpDesk) {
          urlParams += `&search_term_by_help_desk=${params.searchTermByHelpDesk}`
        }
        if (this.startDateCreatedAt && this.endDateCreatedAt) {
          urlParams += `&start_date_created_at=${this.startDateCreatedAt}&end_date_created_at=${this.endDateCreatedAt}`
        }
        if (this.startDateUpdatedAt && this.endDateUpdatedAt) {
          urlParams += `&start_date_updated_at=${this.startDateUpdatedAt}&end_date_updated_at=${this.endDateUpdatedAt}`
        }
        const res = await ajax({
          url: `support_messages/search${urlParams}`,
        })
        if (res.status === 200) {
          const data = res.data
          this.totalRows = data.total_support_messages
          this.supportMessages = data.support_messages
          this.supportUsers = data.users
        }
      },
      isLoginAsAllowed(message) {
        return hasCapability('user', this.store.login.capabilities) && !!message?.user_id
      },
      async loginAs(message) {
        const user_id = message?.user_id
        if (user_id) {
          window.location.replace(`/login?user=${user_id}`)
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
