<template>
  <div>
    <!-- eigene Klasse => Klasse umbenennen / Ins Archiv verschieben-->
    <div v-if="group.id" class="mb-2">
      <b-btn
        v-if="!group.demo"
        v-b-toggle="'collapse_edit_' + group.id"
        variant="outline-secondary"
        size="sm"
        ><i class="fas fa-edit"></i> Klasse umbenennen</b-btn
      >

      <b-button
        id="intro_cb_3"
        class="btn btn-sm float-right"
        variant="outline-secondary"
        @click="moveToArchive"
      >
        <i class="fas fa-file-export"></i> Klasse in Archiv verschieben
      </b-button>
    </div>
    <!-- Ausklappbare Edit-Form - falls neue Klasse, direkt anzeigen -->
    <b-collapse v-if="!group.demo" :id="'collapse_edit_' + group.id" :visible="!group.id">
      <b-form id="group-form" inline accept-charset="UTF-8" class="mb-4" @submit="handleSubmit">
        <label class="sr-only" for="label">Klassenbezeichnung</label>
        <b-form-input
          id="label"
          v-model="label"
          class="mr-2"
          name="group[label]"
          placeholder="Klassenbezeichnung"
          size="sm"
        />
        <div v-if="!group.id">
          <!-- Button für neue Klasse, Validierung Name nicht leer -->
          <b-button
            type="submit"
            variant="outline-success"
            size="sm"
            :disabled="label.trim().length === 0"
          >
            <i class="fas fa-plus"></i> Anlegen
          </b-button>
        </div>
        <div v-else>
          <!-- Button für existierende Klasse Validierung Name nicht leer  -->
          <b-button
            v-b-toggle="'collapse_edit_' + group.id"
            type="submit"
            variant="outline-success"
            size="sm"
            title="Speichern"
            :disabled="label.trim().length === 0"
          >
            <i class="fas fa-check"></i>
          </b-button>
          <b-button
            v-b-toggle="'collapse_edit_' + group.id"
            variant="outline-secondary"
            size="sm"
            title="Abbrechen"
            ><i class="fas fa-times"></i
          ></b-button>
        </div>
      </b-form>
    </b-collapse>
  </div>
</template>

<script>
  import { ajax } from '../../utils/ajax'

  export default {
    name: 'GroupForm',
    props: {
      group: Object,
    },
    data: function () {
      return {
        label: !this.group.id ? '' : this.group.label,
        key: !this.group.id ? this.newKey() : '',
      }
    },
    methods: {
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
          res = await ajax({ url: '/groups', method: 'post', data: data })
        } else {
          res = await ajax({
            url: '/groups/' + this.group.id,
            method: 'put',
            data: { group: { label: this.label } },
          })
        }

        if (res.status === 200) {
          const parsed = await res.json()
          this.success(parsed)
          this.label = ''
        }
      },
      async moveToArchive() {
        const res = await ajax({
          url: '/groups/' + this.group.id + '?group[archive]=1',
          method: 'put',
        })
        const data = await res.json()
        if (data && res.status === 200) {
          this.success(data)
        }
      },
      success(event) {
        // propagate new data from ajax call to parent component
        this.$emit('update:groups', { object: event })
        if (!this.group.id) {
          this.key = this.newKey()
        }
      },
      newKey() {
        return Math.random()
          .toString(36)
          .replace(/[^a-z]+/g, '')
          .substr(0, 6)
      },
      generate_key() {
        return encrypt_key(this.key)
      },
      generate_token() {
        const key = this.key ? this.key : this.newKey()
        return sjcl.encrypt(key, key)
      },
    },
  }
</script>
