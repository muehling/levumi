<template>
  <b-modal
    id="'font-settings-modal'"
    :title="'Schrifteinstellungen für ' + student.name"
    size="xl"
    scrollable
    hide-footer
    lazy
    :visible="!!student"
    @hidden="hideModal"
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
</template>
<script>
  import { ajax } from '../../../utils/ajax'
  import { useGlobalStore } from '../../../store/store'

  export default {
    name: 'FontSettingsModal',
    props: {
      student: Object,
    },
    setup() {
      const globalStore = useGlobalStore()
      return { globalStore }
    },
    data: function () {
      console.log('miau', this.student)

      return {
        fontFamily:
          this.student.settings === undefined || this.student.settings['font_family'] === undefined
            ? 'Fibel Nord'
            : decodeURIComponent(this.student.settings['font_family']),
        fontSize:
          this.student.settings === undefined || this.student.settings['font_size'] === undefined
            ? '1'
            : this.student.settings['font_size'],
      }
    },
    methods: {
      hideModal() {
        this.$emit('hide-student-row-modal')
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

          let index = this.globalStore.studentsInGroups[this.student.group_id].findIndex(
            s => s.id === this.student.id
          )
          this.$emit('update', { object: data, index })
          this.hideModal()
        }
      },
    },
  }
</script>
