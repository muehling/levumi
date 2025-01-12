<template>
  <b-container fluid>
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
              class="edit-user btn btn-sm me-1"
              @click="showMessage(data.item)">
              <i class="fas fa-edit"></i>
              <span class="d-none d-lg-inline">Anzeigen</span>
            </b-button>
            <!-- <b-button
              variant="outline-danger"
              class="delete-user btn btn-sm me-1"
              @click="changeStatus(data.item.id)">
              <i class="fas fa-trash"></i>
              <span class="d-none d-lg-inline">Status ändern</span>
            </b-button>
             <b-button
              variant="outline-danger"
              class="delete-user btn btn-sm me-1"
              @click="assignUser(data.item.id)">
              <i class="fas fa-trash"></i>
              <span class="d-none d-lg-inline">Bearbeiter zuweisen</span>
            </b-button>-->
          </div>
        </template>
      </b-table>
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
    </b-modal>
  </b-container>
</template>
<script>
  import apiRoutes from 'src/vue/routes/api-routes'
  import { ajax } from 'src/utils/ajax'
  import { useGlobalStore } from 'src/store/store'
  export default {
    name: 'SupportApp',
    setup() {
      const store = useGlobalStore()
      return { store }
    },
    data() {
      return {
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
    async created() {
      const res = await ajax(apiRoutes.supportMessages.index)

      this.supportMessages = res.data.messages
      this.supportUsers = res.data.users
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
