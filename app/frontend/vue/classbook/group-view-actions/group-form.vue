<template>
  <div>
    <b-form accept-charset="UTF-8" class="mt-3 text-nowrap" @submit="handleSubmit">
      <label for="label-input">Klassenbezeichnung {{ group.id ? 'ändern:' : 'eingeben:' }}</label>
      <b-form-input
        id="label-input"
        v-model="label"
        class="my-3"
        maxlength="50"
        name="group[label]"
        placeholder="Klassenbezeichnung"
        size="sm" />
      <div v-if="!group.id">
        <!-- Button für neue Klasse, Validierung Name nicht leer -->
        <b-button
          type="submit"
          variant="outline-success"
          size="sm"
          :disabled="label.trim().length === 0">
          <i class="fas fa-plus"></i>
          Anlegen
        </b-button>
      </div>
      <div v-else class="mt-3">
        <!-- Button für existierende Klasse Validierung Name nicht leer  -->
        <b-button
          type="submit"
          variant="outline-success"
          class="me-2"
          size="sm"
          :disabled="isGroupLabelSaveDisabled">
          <span>
            <i class="fas fa-check" />
            <span class="d-none d-lg-inline ms-2">Speichern</span>
          </span>
        </b-button>
        <b-button
          variant="outline-secondary"
          size="sm"
          :disabled="label === group.label"
          @click="handleCancel">
          <i class="fas fa-times" />
          <span class="d-none d-lg-inline ms-2">Abbrechen</span>
        </b-button>
      </div>
    </b-form>
  </div>
</template>

<script>
  import { ajax } from 'src/utils/ajax'
  import { encryptKey, encryptWithKey } from 'src/utils/encryption'
  import { useGlobalStore } from 'src/store/store'
  //import Vue from 'vue'

  export default {
    name: 'GroupForm',
    props: {
      group: Object,
    },
    setup() {
      const globalStore = useGlobalStore()
      return { globalStore }
    },
    data: function () {
      return {
        label: !this.group?.id ? '' : this.group.label,
        key: !this.group?.id ? this.newKey() : '',
      }
    },
    computed: {
      students() {
        return this.globalStore.studentsInGroups[this.group.id] || []
      },
      isGroupLabelSaveDisabled() {
        return this.label.trim().length === 0 || (this.group.id && this.label === this.group.label)
      },
    },
    methods: {
      handleCancel() {
        this.label = this.group.label
      },
      async handleSubmit(e) {
        e.preventDefault()
        e.stopPropagation()

        let res
        if (!this.group.id) {
          const data = {
            group: {
              label: this.label,
              key: this.generate_key(),
              auth_token: this.generate_token(),
            },
          }
          res = await ajax({ url: '/groups', method: 'POST', data: data })
        } else {
          res = await ajax({
            url: '/groups/' + this.group.id,
            method: 'PUT',
            data: { group: { label: this.label } },
          })
        }

        if (res.status === 200) {
          this.globalStore.setGenericMessage({
            title: 'Speichern erfolgreich',
            message: 'Die Änderungen wurden gespeichert!',
          })

          const newIds = res.data.groups
            .filter(group => !this.globalStore.groups.find(g => g.id === group.id))
            .map(a => a.id)
          this.globalStore.groups = res.data.groups
          this.globalStore.shareKeys = res.data.share_keys

          if (!this.group.id) {
            this.label = ''
            if (newIds[0]) {
              await this.$nextTick()
              this.$router.push(`/klassenbuch/eigene_klassen/${newIds[0]}`)
            }
          }
        } else {
          this.globalStore.setErrorMessage(res.data.message)
        }
      },

      newKey() {
        return Math.random()
          .toString(36)
          .replace(/[^a-z]+/g, '')
          .substr(0, 6)
      },
      generate_key() {
        return encryptKey(this.key)
      },
      generate_token() {
        const key = this.key ? this.key : this.newKey()
        return encryptWithKey(key, key)
      },
    },
  }
</script>
