<template>
  <b-modal id="users-mail-dialog" ref="usersMailDialog" title="Nutzer benachrichtigen" hide-footer>
    <div class="card card-body">
      <b-form>
        <div class="form-group">
          <label>Nachricht</label>
          <textarea v-model="text" class="form-control" rows="3" name="text"></textarea>
        </div>
        <div class="form-group">
          <label>Senden an alle</label>
          <div class="d-flex justify-content-between">
            <label>
              <input v-model="teachers" type="checkbox" name="teacher" />
              Lehrkräfte
            </label>
            <label>
              <input v-model="researchers" type="checkbox" name="researcher" />
              Forscher:innen
            </label>
            <label>
              <input v-model="privatePersons" type="checkbox" name="private" />
              Privatpersonen
            </label>
          </div>
        </div>
        <b-btn variant="primary" @click="sendMails">Abschicken</b-btn>
      </b-form>
    </div>
  </b-modal>
</template>
<script>
  import { ajax } from '../../../utils/ajax'
  import apiRoutes from '../../routes/api-routes'

  export default {
    name: 'UsersMailDialog',
    props: {
      users: Array,
    },
    data() {
      return { text: '', teachers: false, researchers: false, privatePersons: false }
    },
    methods: {
      open() {
        this.$refs.usersMailDialog.show()
      },
      async sendMails() {
        const data = {
          ...(this.teachers && { teacher: this.teachers }),
          ...(this.researchers && { researcher: this.researchers }),
          ...(this.privatePersons && { private: this.privatePersons }),
          text: this.text,
        }

        const res = await ajax({ ...apiRoutes.users.usersMail(this.$root.login.id), data })
        if (res.status === 200) {
          console.log('yay, sent')
        }
      },
    },
  }
</script>
