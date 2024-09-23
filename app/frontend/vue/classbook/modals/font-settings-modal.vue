<template>
  <b-modal
    id="'font-settings-modal'"
    v-model="isVisible"
    :title="`Schrifteinstellungen für ${
      studentOrGroup.name ? studentOrGroup.name : studentOrGroup.label
    }`"
    size="xl"
    scrollable
    hide-footer
    lazy
    @hidden="hideModal">
    <p
      class="mt-5 mb-5 text-center"
      :style="'font-size:' + fontSize * 3 + 'em;font-family:\'' + fontFamily + '\''">
      Das ist ein Beispieltext!
    </p>
    <b-button-toolbar justify>
      <b-button-group size="sm">
        <b-button variant="outline-primary" :pressed="fontSize === '1'" @click="fontSize = '1'">
          Normal
        </b-button>
        <b-button variant="outline-primary" :pressed="fontSize === '2'" @click="fontSize = '2'">
          Vergrößert
        </b-button>
        <b-button variant="outline-primary" :pressed="fontSize === '3'" @click="fontSize = '3'">
          Stark vergrößert
        </b-button>
      </b-button-group>
      <b-button-group size="sm">
        <b-button
          variant="outline-primary"
          :pressed="fontFamily == 'serif'"
          @click="fontFamily = 'serif'">
          Rechnerschrift
        </b-button>
        <b-button
          variant="outline-primary"
          :pressed="fontFamily == 'Fibel Nord'"
          @click="fontFamily = 'Fibel Nord'">
          Fibel Nord
        </b-button>
        <b-button
          variant="outline-primary"
          :pressed="fontFamily == 'Grundschrift'"
          @click="fontFamily = 'Grundschrift'">
          Grundschulschrift
        </b-button>
        <b-button
          variant="outline-primary"
          :pressed="fontFamily == 'Grundschrift Grundlinie'"
          @click="fontFamily = 'Grundschrift Grundlinie'">
          Grundschulschrift Grundlinie
        </b-button>
      </b-button-group>
    </b-button-toolbar>

    <b-button class="mt-3" variant="outline-success" @click="changeFontSettings">
      <i class="fas fa-check"></i>
      Speichern
    </b-button>
    <b-button class="mt-3 ms-2" variant="outline-secondary" @click="clearSettings">
      Zurücksetzen
    </b-button>
    <b-button class="mt-3 ms-2" variant="outline-danger" @click="hideModal">Abbrechen</b-button>
  </b-modal>
</template>
<script>
  import { ajax } from 'src/utils/ajax'
  import { useGlobalStore } from 'src/store/store'
  import { defaultFont } from 'src/utils/constants'
  import isEmpty from 'lodash/isEmpty'

  export default {
    name: 'FontSettingsModal',
    props: {
      studentOrGroup: Object,
      defaultSettings: Object,
      path: String,
      isOpen: Boolean,
    },
    setup() {
      const globalStore = useGlobalStore()
      return { globalStore }
    },
    data: function () {
      const s = !isEmpty(this.studentOrGroup.settings)
        ? this.studentOrGroup.settings
        : this.defaultSettings

      return {
        fontFamily:
          s === undefined || s['font_family'] === undefined
            ? defaultFont.fontFamily
            : decodeURIComponent(s['font_family']),
        fontSize:
          s === undefined || s['font_size'] === undefined ? defaultFont.fontSize : s['font_size'],
        isVisible: !!this.studentOrGroup,
      }
    },
    methods: {
      clearSettings() {
        this.fontFamily = undefined
        this.fontSize = undefined
        this.changeFontSettings()
      },
      hideModal() {
        this.$emit('hide-student-row-modal')
        this.$emit('hide-fonts-modal')
      },
      async changeFontSettings() {
        const data = {
          [this.path]: {
            settings: {
              ...(this.fontFamily && { font_family: encodeURIComponent(this.fontFamily) }),
              ...(this.fontSize && { font_size: encodeURIComponent(this.fontSize) }),
            },
          },
        }
        const res = await ajax({
          url: `/${this.path + 's'}/${this.studentOrGroup.id}`,
          method: 'put',
          data,
        })
        if (res.status === 200) {
          this.$emit('update-font-settings', { ...res.data })
          this.hideModal()
        }
      },
    },
  }
</script>
