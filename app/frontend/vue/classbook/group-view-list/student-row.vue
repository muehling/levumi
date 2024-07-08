<template>
  <tr v-if="!editMode" id="intro_cb_5" class="student-row student-row-display">
    <td class="pl-0">
      <div v-if="!empty" class="ps-1">
        {{ student.name }}
      </div>
      <div v-else class="d-inline">
        <b-button
          variant="outline-secondary"
          class="text-nowrap mt-2"
          size="sm"
          @click="editMode = true">
          <i class="fas fa-user-plus"></i>
          Anlegen
        </b-button>
      </div>
    </td>

    <td id="intro_cb_6">
      <div>
        {{ student.login }}
      </div>
    </td>

    <td>
      <div>
        <span v-if="student.gender != undefined">{{ options_gender[student.gender].text }}</span>
        <span v-else-if="!empty" class="text-muted">nicht erfasst</span>
      </div>
    </td>

    <td>
      <div>
        <span v-if="student.birthmonth != undefined">{{ months[month] }} {{ year }}</span>
        <span v-else-if="!empty" class="text-muted">nicht erfasst</span>
      </div>
    </td>
    <td>
      <div>
        <span v-if="student.sen != undefined">{{ options_sen[student.sen].text }}</span>
        <span v-else-if="!empty" class="text-muted">nicht erfasst</span>
      </div>
    </td>

    <td>
      <div>
        <span>
          {{ studentTags }}
        </span>
        <span v-if="student.tags?.length == 0 && !empty" class="text-muted">nichts erfasst</span>
      </div>
    </td>
    <td>
      <span v-if="!empty" :class="`${hasFontSettings ? 'font-weight-bold' : ''}`">
        {{ fontSettingsText }}
      </span>
    </td>
    <td>
      <span>
        <b-button-group :class="!empty && !editMode ? '' : 'd-none'">
          <b-button
            v-if="!readOnly"
            v-b-modal="'modal_settings_' + student.id"
            v-b-popover.hover.topright="'Schrifteinstellungen'"
            class="me-1"
            variant="outline-secondary"
            size="sm"
            @click="handleClickAction(student, 'font-settings')">
            <i class="fas fa-text-height"></i>
          </b-button>
          <b-button
            v-if="!readOnly"
            v-b-popover.hover.topright="'Bearbeiten'"
            variant="outline-secondary"
            class="me-1"
            size="sm"
            @click="editMode = true">
            <i class="fas fa-user-edit"></i>
          </b-button>
          <b-button
            v-if="!readOnly"
            v-b-popover.hover.topright="'QR-Code'"
            variant="outline-secondary"
            class="me-1"
            size="sm"
            @click="handleClickAction(student, 'qr-code')">
            <i class="fas fa-qrcode"></i>
          </b-button>
          <b-button
            v-if="!!student.id"
            v-b-popover.hover.topright="'Test-Info'"
            variant="outline-secondary"
            class="me-1"
            size="sm"
            @click="handleClickAction(student, 'test-info')">
            <i class="fas fa-circle-info"></i>
          </b-button>
        </b-button-group>
      </span>
    </td>
  </tr>
  <tr v-else id="intro_cb_5" class="student-row student-row-edit">
    <td class="pl-0">
      <div class="ps-1">
        <b-form-input v-model="name" name="name" type="text" class="form-control" size="sm" />
        <small class="form-text text-muted">Name des Kindes, wird verschlüsselt gespeichert!</small>
      </div>
    </td>

    <td id="intro_cb_6">
      <div>
        <small class="form-text text-muted">nicht änderbar</small>
      </div>
    </td>

    <td>
      <div>
        <b-form-select
          v-model="gender"
          size="sm"
          :options="options_gender"
          name="gender"></b-form-select>
      </div>
    </td>

    <td>
      <div>
        <b-form-select v-model="month" size="sm" @change="changeMonth">
          <option v-for="(m, i) in months" :key="`${m}/$${i}/${student.id}`" :value="i">
            {{ m }}
          </option>
        </b-form-select>
        <b-form-select v-model="year" class="mt-2" size="sm" @change="changeYear">
          <option v-for="y in years" :key="y" :value="y">{{ y }}</option>
        </b-form-select>
        <b-button
          v-if="month && year"
          class="btn btn-block btn-sm mt-2"
          variant="outline-danger"
          @click="clearDateInputs">
          Datum löschen
        </b-button>
      </div>
    </td>

    <td>
      <div>
        <b-form-select v-model="sen" :options="options_sen" size="sm" />
        <small class="form-text text-muted">
          Diagnostizierter sonderpädagogischer Förderbedarf?
        </small>
      </div>
    </td>

    <td>
      <div>
        <b-form-checkbox-group
          v-model="tags"
          :options="options_tags"
          name="tags"
          stacked></b-form-checkbox-group>
        <div class="d-flex">
          <b-form @submit.prevent.stop="addTag">
            <b-form-input
              v-model="newTag"
              placeholder="Weiteres Merkmal"
              class="d-inline new-tag-input text-small py-0"></b-form-input>
            <b-button
              size="sm"
              :disabled="newTag === ''"
              variant="outline-success"
              class="pb-0 pt-1 ms-2 new-tag-submit"
              @click="addTag">
              <i class="fas fa-check"></i>
            </b-button>

            <context-help
              help-text="Bitte wählen Sie alle zutreffenden Merkmale oder geben Sie ein neues ein. Bitte beachten: der eingegebene Text wird unverschlüsselt gespeichert!"
              class-name="mt-3 ms-2" />
          </b-form>
        </div>
      </div>
    </td>
    <td>
      <span v-if="!hasFontSettings && !empty">Standard</span>
      <span :class="`${hasFontSettings ? 'font-weight-bold' : ''}`">
        {{ empty ? '' : fontSettingsText }}
      </span>
    </td>
    <td>
      <span>
        <b-button-group :class="!empty && !editMode ? '' : 'd-none'">
          <b-button
            v-if="!readOnly"
            v-b-modal="'modal_settings_' + student.id"
            v-b-popover.hover.topright="'Schrifteinstellungen'"
            class="me-1"
            variant="outline-secondary"
            size="sm"
            @click="handleClickAction(student, 'font-settings')">
            <i class="fas fa-text-height"></i>
          </b-button>
          <b-button
            v-if="!readOnly"
            v-b-popover.hover.topright="'Bearbeiten'"
            variant="outline-secondary"
            class="me-1"
            size="sm"
            @click="editMode = true">
            <i class="fas fa-user-edit"></i>
          </b-button>
          <b-button
            v-if="!readOnly"
            v-b-popover.hover.topright="'QR-Code'"
            variant="outline-secondary"
            class="me-1"
            size="sm"
            @click="handleClickAction(student, 'qr-code')">
            <i class="fas fa-qrcode"></i>
          </b-button>
          <b-button
            v-if="!!student.id"
            v-b-popover.hover.topright="'Test-Info'"
            variant="outline-secondary"
            class="me-1"
            size="sm"
            @click="handleClickAction(student, 'test-info')">
            <i class="fas fa-circle-info"></i>
          </b-button>
        </b-button-group>
      </span>
      <span>
        <b-button-toolbar class="flex-nowrap">
          <b-button-group>
            <b-button
              id="intro_cb_7"
              class="btn btn-sm me-1"
              variant="outline-success"
              title="Speichern"
              :disabled="name.length == 0"
              @click="handleSubmit">
              <i class="fas fa-check"></i>
            </b-button>
          </b-button-group>
          <b-button-group>
            <b-button
              class="btn btn-sm me-1"
              variant="outline-secondary"
              title="Abbrechen"
              @click="handleCancel">
              <i class="fas fa-times"></i>
            </b-button>
          </b-button-group>
          <b-button-group>
            <b-button
              v-if="!empty"
              class="btn btn-block btn-sm"
              variant="outline-danger"
              @click="requestDelete">
              <i class="fas fa-trash"></i>
              Löschen
            </b-button>
          </b-button-group>
        </b-button-toolbar>
      </span>
    </td>

    <confirm-dialog ref="confirmDialog" />
  </tr>
</template>

<script>
  import { access } from 'src/utils/access'
  import { ajax } from 'src/utils/ajax'
  import { encryptWithMasterKeyAndGroup } from 'src/utils/encryption'
  import { getFontSettingsDescription } from 'src/utils/helpers'
  import ConfirmDialog from 'src/vue/shared/confirm-dialog.vue'
  import ContextHelp from 'src/vue/shared/context-help.vue'
  import isArray from 'lodash/isArray'
  import isEmpty from 'lodash/isEmpty'
  import { defaultFont } from 'src/utils/constants'

  export default {
    name: 'StudentRow',
    components: { ConfirmDialog, ContextHelp },
    props: {
      empty: Boolean,
      group: Object,
      index: Number,
      open: Boolean,
      student: Object,
    },
    data: function () {
      let allTags = [
        'AD(H)S',
        'Deutsch als Zweitsprache',
        'Dyskalkulie',
        'Fluchtgeschichte',
        'Hochbegabung',
        'Integrationskraft',
        'LRS',
        'Migrationshintergrund',
      ]
      if (this.student) {
        allTags = allTags.concat(this.student.tags)
      }

      return {
        editMode: this.empty && this.open,
        isLoadingAssessments: false,
        name: this.student.name,
        activeAssessments: undefined,
        newTag: '',

        //Defaultwerte für  Werte, die ggf. nicht existieren! TODO: Alle irgendwo sammeln?

        gender: this.student.gender !== undefined ? this.student.gender : null,
        month:
          this.student.birthmonth !== undefined
            ? new Date(this.student.birthmonth).getMonth()
            : null,
        sen: this.student.sen !== undefined ? this.student.sen : null,
        tags: this.student.tags !== undefined ? [...this.student.tags] : [],
        year:
          this.student.birthmonth !== undefined
            ? new Date(this.student.birthmonth).getFullYear()
            : null,

        options_tags: [...new Set(allTags)].map(tag => ({ text: tag, value: tag })),
      }
    },
    computed: {
      years() {
        const today = new Date().getFullYear() - 3
        return Array.from({ length: 30 }, (_, k) => today - k)
      },
      readOnly() {
        return isEmpty(this.permissions)
      },
      permissions() {
        return access(this.group).classbook
      },
      hasFontSettings() {
        if (this.empty) {
          return false
        } else {
          return !!(this.student.settings.font_family && this.student.settings.font_size)
        }
      },
      fontSettingsText() {
        if (this.student.settings.font_size && this.student.settings.font_family) {
          return getFontSettingsDescription(this.student.settings, this.group.settings)
        } else if (this.group.settings.font_size && this.group.settings.font_family) {
          return getFontSettingsDescription(this.group.settings, null)
        } else {
          return getFontSettingsDescription(this.group.settings, this.group.settings)
        }
      },
      defaultFontSettings() {
        return getFontSettingsDescription(
          { font_family: defaultFont.fontFamily, font_size: defaultFont.fontSize },
          null
        )
      },
      studentTags() {
        return isArray(this.student.tags) ? this.student.tags.join(', ') : ''
      },
    },
    beforeCreate() {
      // "Konstanten" definieren - werden für die Form-Elemente und zur Anzeige verwendet.
      this.options_gender = [
        { text: 'weiblich', value: '0' },
        { text: 'männlich', value: '1' },
        { text: 'divers', value: '2' },
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
    },

    methods: {
      addTag() {
        this.options_tags.push({ text: this.newTag, value: this.newTag })
        this.tags.push(this.newTag)
        this.newTag = ''
      },
      handleClickAction(student, action) {
        this.$emit('click-student-action', student, action)
      },
      changeMonth() {
        if (this.year === null) {
          this.year = this.years[0]
        }
      },
      changeYear() {
        if (this.month === null) {
          this.month = 0
        }
      },
      clearDateInputs() {
        this.month = null
        this.year = null
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
            this.$emit('delete-student', { id: this.student.id })
          }
        }
      },

      collectData() {
        //Daten aus den Inputs codieren für AJAX Request
        const encodedName = encodeURIComponent(
          encryptWithMasterKeyAndGroup(this.name, this.group.id)
        ) //Namen vor dem Senden verschlüsseln
        let res = `group=${this.group.id}&student[name]=${encodedName}`

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

      async handleSubmit() {
        const res = await ajax({
          url: `/students${!this.empty ? '/' + this.student.id : ''}?${this.collectData()}`,
          method: this.empty ? 'POST' : 'PUT',
        })
        const data = res.data
        if (data && res.status === 200) {
          this.update(data)
        }
      },
      handleCancel() {
        this.editMode = false
        this.tags = this.student.tags
      },

      update(data) {
        //Wird bei erfolgreichem Create/Update aufgerufen
        //Zu Elternkomponente propagieren, dort werden die Daten aktuell gehalten
        this.$emit('update-student', data)
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
      },
    },
  }
</script>
<style>
  .new-tag-input {
    max-width: 70%;
    height: 2em !important;
  }
  .new-tag-submit {
    height: 2em;
  }
  .student-row.student-row-display td {
    vertical-align: middle !important;
  }
</style>
