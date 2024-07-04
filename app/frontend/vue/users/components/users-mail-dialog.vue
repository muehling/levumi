<template>
  <div>
    <b-button @click="open">Mail an Nutzer</b-button>
    <b-modal id="users-mail-dialog" title="Nutzer benachrichtigen" v-if="isOpen" hide-footer>
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
          <b-button variant="primary" @click="sendMails">Abschicken</b-button>
        </b-form>
      </div>
    </b-modal>
  </div>
</template>
<script>
  import { ajax } from '../../../utils/ajax'
  import { useGlobalStore } from '../../../store/store'
  import apiRoutes from '../../routes/api-routes'

  export default {
    name: 'UsersMailDialog',
    props: {
      users: Array,
    },
    setup() {
      const globalStore = useGlobalStore()
      return { globalStore }
    },
    data() {
      return { text: '', teachers: false, researchers: false, privatePersons: false, isOpen: false }
    },
    methods: {
      open() {
        // this.$refs.usersMailDialog.show()
        this.isOpen = true
      },
      async sendMails() {
        // this will add `[<key>]: true` to the data object if the corresponding checkbox is checked
        // to avoid sending unnecessary `[<key>]: false` entries.
        const data = {
          ...(this.teachers && { teacher: this.teachers }),
          ...(this.researchers && { researcher: this.researchers }),
          ...(this.privatePersons && { private: this.privatePersons }),
          text: this.text,
        }

        const res = await ajax({ ...apiRoutes.users.usersMail(this.globalStore.login.id), data })
        if (res.status === 200) {
          //TODO display message?
        }
        this.isOpen = false
      },
    },
  }
</script>
