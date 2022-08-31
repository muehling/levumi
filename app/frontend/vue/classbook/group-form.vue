<template>
  <div>
    <!-- eigene Klasse => Klasse umbenennen / Ins Archiv verschieben-->
    <div v-if="index > 0" class="mb-2">
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
    <!-- Ausklappbare Edit-Form - falls index == 0, direkt anzeigen -->
    <b-collapse
      v-if="!group.demo"
      :id="'collapse_edit_' + group.id"
      :visible="index == 0"
    >
      <b-form
        id="group-form"
        inline
        accept-charset="UTF-8"
        class="mb-4"
        @submit="handleSubmit"
      >
        <!-- Hidden Field für Rails/Update, damit POST/PUT unterschieden wird -->
        <input v-if="index > 0" type="hidden" value="put" name="_method" />
        <!-- Hidden Field mit generiertem Key für die Klasse -->
        <input
          v-if="index == 0"
          type="hidden"
          :value="generate_key()"
          name="group[key]"
        />
        <!-- Hidden Field mit generiertem Auth_Token für die Klasse -->
        <input
          v-if="index == 0"
          type="hidden"
          :value="generate_token()"
          name="group[auth_token]"
        />
        <label class="sr-only" for="label">Klassenbezeichnung</label>
        <b-form-input
          id="label"
          v-model="label"
          class="mr-2"
          name="group[label]"
          placeholder="Klassenbezeichnung"
          size="sm"
        />
        <div v-if="index === 0">
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
      index: Number,
    },
    data: function () {
      return {
        label: this.index === 0 ? '' : this.group.label,
        key: this.index === 0 ? this.new_key() : '',
      }
    },
    methods: {
      async handleSubmit(e) {
        e.preventDefault()
        e.stopPropagation()

        let res
        if (this.index === 0) {
          const data = {
            group: {
              label: this.label,
              key: $("input[name='group[key]']").val(),
              auth_token: $("input[name='group[auth_token]']").val(),
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
        this.$emit('update:groups', { index: this.index, object: event })
        if (this.index === 0) {
          this.key = this.new_key()
        }
      },
      new_key() {
        return Math.random()
          .toString(36)
          .replace(/[^a-z]+/g, '')
          .substr(0, 6)
      },
      generate_key() {
        return encrypt_key(this.key)
      },
      generate_token() {
        return sjcl.encrypt(this.key, this.key)
      },
    },
  }
</script>
