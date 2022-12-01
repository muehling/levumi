<template>
  <!-- Eine Zeile der Schülerübersicht -->
  <tr id="intro_cb_5">
    <td>
      <!-- In-Place Editing durch "editMode", "empty" zeigt letzte Zeile an, die für neu anlegen verwendet wird -->
      <div v-if="!empty && !editMode">
        <b-link :href="'students/' + student.id + '#' + student.name" target="_blank">
          {{ student.name }}
        </b-link>
      </div>
      <div v-else-if="editMode">
        <!-- Form anzeigen -->
        <b-form-input v-model="name" type="text" class="form-control" size="sm" />
        <small class="form-text text-muted">Name des Kindes, wird verschlüsselt gespeichert!</small>
      </div>
      <div v-else>
        <!-- Anlegen Button anzeigen -->
        <b-btn variant="outline-secondary" size="sm" @click="editMode = true"
          ><i class="fas fa-user-plus"></i> Anlegen</b-btn
        >
      </div>
    </td>

    <td id="intro_cb_6">
      <div v-if="editMode">
        <small class="form-text text-muted">nicht änderbar</small>
      </div>
      <div v-else>
        {{ student.login }}
      </div>
    </td>

    <td>
      <div v-if="editMode">
        <b-form-select v-model="gender" size="sm" :options="options_gender" name="gender">
        </b-form-select>
      </div>
      <div v-else>
        <span v-if="student.gender != undefined">{{ options_gender[student.gender].text }}</span>
        <span v-else-if="!empty" class="text-muted">nicht erfasst</span>
      </div>
    </td>

    <td>
      <div v-if="editMode">
        <b-form-select v-model="month" size="sm">
          <option v-for="(m, i) in months" :key="`${m}/$${i}`" :value="i">
            {{ m }}
          </option>
        </b-form-select>
        <b-form-select v-model="year" size="sm">
          <option v-for="y in years()" :key="y" :value="y">{{ y }}</option>
        </b-form-select>
      </div>
      <div v-else>
        <span v-if="student.birthmonth != undefined">{{ months[month] }} {{ year }}</span>
        <span v-else-if="!empty" class="text-muted">nicht erfasst</span>
      </div>
    </td>

    <td>
      <div v-if="editMode">
        <b-form-select v-model="sen" :options="options_sen" size="sm" />
        <small class="form-text text-muted"
          >Diagnostizierter sonderpädagogischer Förderbedarf?</small
        >
      </div>
      <div v-else>
        <span v-if="student.sen != undefined">{{ options_sen[student.sen].text }}</span>
        <span v-else-if="!empty" class="text-muted">nicht erfasst</span>
      </div>
    </td>

    <td>
      <div v-if="editMode">
        <b-form-checkbox-group v-model="tags" :options="options_tags" name="tags" stacked>
        </b-form-checkbox-group>
        <small class="form-text text-muted">Bitte wählen Sie alle zutreffenden Merkmale</small>
      </div>
      <div v-else>
        <span v-for="(tag, i) in student.tags" :key="`${tag}/${i}`"
          >{{ i > 0 ? ', ' : '' }}{{ tag }}</span
        >
        <span v-if="student.tags?.length == 0 && !empty" class="text-muted">nichts erfasst</span>
      </div>
    </td>

    <td>
      <span v-if="!readOnly && !empty && !editMode">
        <b-button-toolbar>
          <b-button-group>
            <b-btn
              v-b-modal="'modal_settings_' + student.id"
              class="mr-1"
              variant="outline-secondary"
              size="sm"
              title="Schrifteinstellungen"
            >
              <i class="fas fa-text-height"></i>
            </b-btn>
            <b-btn
              variant="outline-secondary"
              size="sm"
              title="Bearbeiten"
              @click="editMode = true"
            >
              <i class="fas fa-user-edit"></i>
            </b-btn>
            <b-btn
              v-b-modal="'qr_code_' + student.id"
              variant="outline-secondary"
              size="sm"
              title="QRCode"
            >
              <i class="fas fa-qrcode"></i>
            </b-btn>
          </b-button-group>
        </b-button-toolbar>
        <b-modal
          :id="'qr_code_' + student.id"
          :title="'QRCode für ' + student.name"
          scrollable
          hide-footer
          static
        >
          <p>
            Code: {{ student.login }} <br />
            QR-Code:
          </p>
          <div class="text-center">
            <div :id="`qr-${student.id}`"></div>
          </div>
        </b-modal>
        <b-modal
          :id="'modal_settings_' + student.id"
          :title="'Schrifteinstellungen für ' + student.name"
          size="xl"
          scrollable
          hide-footer
          lazy
        >
          <p
            class="mt-5 mb-5 text-center"
            :style="'font-size:' + fontSize * 3 + 'em;font-family:\'' + fontFamily + '\''"
          >
            Das ist ein Beispieltext!
          </p>
          <b-button-toolbar justify>
            <b-button-group size="sm">
              <b-btn variant="outline-primary" :pressed="fontSize == 1" @click="fontSize = 1"
                >Normal
              </b-btn>
              <b-btn variant="outline-primary" :pressed="fontSize == 2" @click="fontSize = 2"
                >Vergrößert
              </b-btn>
              <b-btn variant="outline-primary" :pressed="fontSize == 3" @click="fontSize = 3"
                >Stark vergrößert</b-btn
              >
            </b-button-group>
            <b-button-group size="sm">
              <b-btn
                variant="outline-primary"
                :pressed="fontFamily == 'serif'"
                @click="fontFamily = 'serif'"
                >Rechnerschrift</b-btn
              >
              <b-btn
                variant="outline-primary"
                :pressed="fontFamily == 'Fibel Nord'"
                @click="fontFamily = 'Fibel Nord'"
                >Fibel Nord</b-btn
              >
              <b-btn
                variant="outline-primary"
                :pressed="fontFamily == 'Grundschrift'"
                @click="fontFamily = 'Grundschrift'"
                >Grundschulschrift</b-btn
              >
              <b-btn
                variant="outline-primary"
                :pressed="fontFamily == 'Grundschrift Grundlinie'"
                @click="fontFamily = 'Grundschrift Grundlinie'"
                >Grundschulschrift Grundlinie</b-btn
              >
            </b-button-group>
          </b-button-toolbar>

          <b-btn class="mt-3" variant="outline-success" @click="changeFontSettings">
            <i class="fas fa-check"></i> Speichern
          </b-btn>
        </b-modal>
      </span>
      <span v-else-if="!readOnly && editMode">
        <b-button-toolbar class="flex-nowrap">
          <b-button-group>
            <b-button
              id="intro_cb_7"
              class="btn btn-sm mr-1"
              variant="outline-success"
              title="Speichern"
              :disabled="name.length == 0"
              @click="createStudent"
            >
              <i class="fas fa-check"></i>
            </b-button>
          </b-button-group>
          <b-button-group>
            <b-link
              class="btn btn-sm btn-outline-secondary mr-2"
              href="#"
              title="Abbrechen"
              @click="editMode = false"
              ><i class="fas fa-times"></i
            ></b-link>
          </b-button-group>
          <b-button-group>
            <b-btn
              v-if="!empty"
              class="btn btn-block btn-sm"
              variant="outline-danger"
              @click="requestDelete"
            >
              <i class="fas fa-trash"></i> Löschen
            </b-btn>
          </b-button-group>
        </b-button-toolbar>
      </span>
    </td>

    <confirm-dialog ref="confirmDialog" />
  </tr>
</template>

<script>
  import { ajax } from '../../utils/ajax'
  import { encryptWithMasterKeyAndGroup } from '../../utils/encryption'
  import ConfirmDialog from '../shared/confirm-dialog.vue'
  import QRCodeStyling from 'qr-code-styling'

  export default {
    name: 'StudentRow',
    components: { ConfirmDialog },
    props: {
      empty: Boolean,
      groupId: Number,
      index: Number,
      open: Boolean,
      readOnly: Boolean,
      student: Object,
    },
    data: function () {
      return {
        editMode: this.empty && this.open,
        loading: false,
        name: this.student.name,
        results: undefined,
        years: function () {
          let years = []
          let cur = new Date().getFullYear()
          for (let i = cur - 3; i > cur - 30; --i) {
            years.push(i)
          }
          return years
        },

        //Defaultwerte für  Werte, die ggf. nicht existieren! TODO: Alle irgendwo sammeln?
        fontFamily:
          this.student.settings === undefined || this.student.settings['font_family'] === undefined
            ? 'Fibel Nord'
            : decodeURIComponent(this.student.settings['font_family']),
        fontSize:
          this.student.settings === undefined || this.student.settings['font_size'] === undefined
            ? '1'
            : this.student.settings['font_size'],
        gender: this.student.gender !== undefined ? this.student.gender : null,
        month:
          this.student.birthmonth !== undefined
            ? new Date(this.student.birthmonth).getMonth()
            : null,
        sen: this.student.sen !== undefined ? this.student.sen : null,
        tags: this.student.tags !== undefined ? this.student.tags : [],
        year:
          this.student.birthmonth !== undefined
            ? new Date(this.student.birthmonth).getFullYear()
            : null,
      }
    },
    beforeCreate() {
      // "Konstanten" definieren - werden für die Form-Elemente und zur Anzeige verwendet.
      this.options_gender = [
        { text: 'weiblich', value: '0', disabled: 0 },
        { text: 'männlich', value: '1', disabled: 0 },
        { text: 'divers', value: '2', disabled: 0 },
      ]

      this.months = [
        'Januar',
        'Februar',
        'März',
        'April',
        'Mai',
        'Juni',
        'Juli',
        'August',
        'September',
        'Oktober',
        'November',
        'Dezember',
      ]

      this.options_sen = [
        { text: 'Keiner', value: 0 },
        { text: 'Lernen', value: 1 },
        { text: 'Geistige Entwicklung', value: 2 },
        { text: 'Emotional-soziale Entwicklung', value: 3 },
        { text: 'Sprache', value: 4 },
        { text: 'Körperlich-motorische Entwicklung', value: 5 },
        { text: 'Sehen', value: 6 },
        { text: 'Hören', value: 7 },
        { text: 'Autismus', value: 8 },
      ]

      this.options_tags = [
        { text: 'AD(H)S', value: 'AD(H)S' },
        { text: 'Deutsch als Zweitsprache', value: 'Deutsch als Zweitsprache' },
        { text: 'Dyskalkulie', value: 'Dyskalkulie' },
        { text: 'Fluchtgeschichte', value: 'Fluchtgeschichte' },
        { text: 'Hochbegabung', value: 'Hochbegabung' },
        { text: 'Integrationskraft', value: 'Integrationskraft' },
        { text: 'LRS', value: 'LRS' },
        { text: 'Migrationshintergrund', value: 'Migrationshintergrund' },
      ]
    },
    mounted() {
      this.generateQRCode()
    },
    methods: {
      generateQRCode() {
        if (!this.student.login) {
          return
        }
        const qrCode = new QRCodeStyling({
          width: 400,
          height: 400,
          type: 'canvas',
          data: this.student.login,
          image: 'favicon.ico',
          dotsOptions: {
            color: '#000000',
          },

          imageOptions: {
            margin: 20,
            imageSize: 0.4,
          },
        })
        const el = document.getElementById('qr-' + this.student.id)
        qrCode.append(el)
      },
      async requestDelete() {
        const ok = await this.$refs.confirmDialog.open({
          title: 'Schüler löschen',
          message: `${this.student.name} mit allen Messergebnissen löschen! Sind Sie sicher?`,
          okText: 'Löschen',
        })
        if (ok) {
          const res = await ajax({
            url: `/students/${this.student.id}`,
            method: 'delete',
          })
          if (res.status === 200) {
            this.remove()
          }
        }
      },

      async changeFontSettings() {
        const data = {
          student: {
            settings: {
              font_family: encodeURIComponent(this.fontFamily),
              font_size: encodeURIComponent(this.fontSize),
            },
          },
        }
        const res = await ajax({
          url: `/students/${this.student.id}`,
          method: 'put',
          data,
        })
        if (res.status === 200) {
          const data = await res.json()
          this.update(data)
        }
      },

      collectData() {
        //Daten aus den Inputs codieren für AJAX Request
        const encodedName = encodeURIComponent(
          encryptWithMasterKeyAndGroup(this.name, this.groupId)
        ) //Namen vor dem Senden verschlüsseln
        let res = `group=${this.groupId}&student[name]=${encodedName}`

        //Restliche Attribute anfügen, falls vorhanden
        if (this.gender != null) {
          res += '&student[gender]=' + this.gender
        }
        if (this.year != null && this.month != null) {
          res += '&student[birthmonth]=' + this.year + '-' + (this.month + 1)
        }
        if (this.sen != null) {
          res += '&student[sen]=' + this.sen
        }
        if (this.tags != null) {
          const encodedTags = encodeURIComponent(JSON.stringify(this.tags))
          res += '&student[tags]=' + encodedTags
        }
        return res
      },
      //TODO wird nicht gebraucht?
      /*loadData(student) {
              this.loading = true;
              //AJAX-Request senden
              console.log('load');

              fetch('/students/' + student, {
                headers: {
                  Accept: 'text/javascript',
                  'X-Requested-With': 'XMLHttpRequest',
                  'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content'),
                },
                credentials: 'include',
              }).then((response) => {
                return response.text().then((text) => {
                  this.results = JSON.parse(text);
                  this.loading = false; //Spinner verstecken
                });
              });
            },*/
      remove() {
        this.$emit('update:students', { index: this.index, object: null })
      },

      async createStudent() {
        const res = await ajax({
          url: `/students${!this.empty ? '/' + this.student.id : ''}?${this.collectData()}`,
          method: this.empty ? 'post' : 'put',
        })
        const data = await res.json()
        if (data && res.status === 200) {
          this.update(data)
        }
      },

      update(data) {
        //Wird bei erfolgreichem Create/Update aufgerufen
        //Zu Elternkomponente propagieren, dort werden die Daten aktuell gehalten
        this.$emit('update:students', {
          index: this.index,
          object: data,
        })
        if (this.index >= 0) {
          this.editMode = false
        } else {
          //Beim Anlegen Form offen lassen und Input leeren, für mehrfaches Anlegen
          this.name = ''
          this.gender = null
          this.year = null
          this.month = null
          this.sen = null
          this.tags = []
        }
        //Falls Update aus Settings: Modal schließen
        this.$bvModal.hide('modal_settings_' + this.student.id)
      },
    },
  }
</script>
