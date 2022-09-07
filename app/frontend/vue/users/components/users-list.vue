<template>
  <div>
    <table class="table table-hover table-sm text-small">
      <thead class="thead-light">
        <tr>
          <th scope="col">ID</th>
          <th scope="col">E-Mail Adresse</th>
          <th scope="col">Account-Typ</th>
          <th scope="col">Bundesland</th>
          <th scope="col">Zuletzt eingeloggt</th>
          <th scope="col">Aktionen</th>
        </tr>
      </thead>
      <tbody>
        <tr
          v-for="user in users"
          :id="`row_${user.id}`"
          :key="user.id"
          :class="!user.last_login ? 'table-warning' : ''"
        >
          <td>{{ user.id }}</td>
          <td>{{ user.email }}</td>
          <td>
            {{ accountTypes.find(accountType => user.account_type === accountType.id).label }}
          </td>
          <td>{{ states.find(state => state.id === user.state).label }}</td>
          <td>
            {{ !user.last_login ? 'Nie' : new Date(user.last_login).toLocaleString('de-DE') }}
          </td>
          <td>
            <b-btn
              variant="outline-success"
              class="edit-user btn btn-sm mr-1"
              @click="editUser(user.id)"
              ><i class="fas fa-edit"></i> Bearbeiten</b-btn
            >
            <b-btn
              variant="outline-danger"
              class="delete-user btn btn-sm mr-1"
              @click="requestDeleteUser(user.id)"
              ><i class="fas fa-trash"></i> Löschen</b-btn
            >
            <b-btn
              v-if="$root.login.id !== user.id && user.tc_accepted && checkRegistration(user)"
              variant="outline-secondary"
              class="delete-user btn btn-sm mr-1"
              @click="loginAs(user.id)"
              ><i class="fas fa-user-md"></i> Einloggen als</b-btn
            >
          </td>
        </tr>
      </tbody>
    </table>
    <confirm-dialog ref="confirmDialog" />
    <edit-user-dialog ref="editUserDialog" @refetch="delegateRefetch" />
  </div>
</template>

<script>
  import ConfirmDialog from '../../shared/confirm-dialog.vue'
  import EditUserDialog from './edit-user-dialog.vue'
  import { ajax } from '../../../utils/ajax'
  import { isRegistered } from '../../../utils/user'

  export default {
    name: 'UsersList',
    components: { ConfirmDialog, EditUserDialog },
    props: {
      users: Array
    },
    data() {
      return {
        states: this.$root.states,
        focusTypes: this.$root.focusTypes,
        schoolTypes: this.$root.schoolTypes,
        accountTypes: this.$root.accountTypes
      }
    },

    methods: {
      async requestDeleteUser(id) {
        const ok = await this.$refs.confirmDialog.open({
          message: `Der Benutzer wird mit allen Daten gelöscht. Sind Sie sicher?`,
          okText: 'Ja, Benutzer löschen',
          title: 'Benutzer löschen'
        })
        if (ok) {
          const res = await ajax({
            url: `/users/${id}`,
            method: 'delete'
          })

          if (res.status === 200) {
            this.$emit('refetch')
          }
        }
      },
      delegateRefetch() {
        this.$emit('refetch')
      },
      editUser(id) {
        this.$refs.editUserDialog.open({ user: this.users.find(u => u.id === id) })
      },
      loginAs(id) {
        window.location.replace(`/login?user=${id}`)
      },
      checkRegistration(user) {
        return isRegistered(user)
      }
    }
  }
</script>
