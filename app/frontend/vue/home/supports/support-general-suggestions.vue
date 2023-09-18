<template>
  <div>
    <!-- Spinner für die AJAX-Requests zum Laden eines gewählten Assessments-->
    <div v-if="loading" class="spinner" style="padding-bottom: 75px">
      <div class="bounce1"></div>
      <div class="bounce2"></div>
      <div class="bounce3"></div>
    </div>
    <div v-else>
      <b-tabs pills>
        <!-- Hinweistext falls kein Material vorhanden -->
        <div slot="empty">
          <div class="text-center text-muted">
            Leider ist zur Zeit kein passendes Fördermaterial vorhanden.
          </div>
        </div>
        <b-tab
          v-for="entry in suggestions"
          :key="entry.student.id"
          :title="getStudentName(entry.student)"
        >
          <b-tabs pills card vertical class="mt-2">
            <b-tab
              v-if="specific(entry).length > 0"
              title="Spezifische Vorschläge"
              disabled
            ></b-tab>
            <b-tab v-for="material in specific(entry)" :key="material.id" :title="material.name">
              <material-view :material="material" :full="false"></material-view>
            </b-tab>
            <b-tab v-if="generic(entry).length > 0" title="Allgemeine Vorschläge" disabled></b-tab>
            <b-tab v-for="material in generic(entry)" :key="material.id" :title="material.name">
              <material-view :material="material" :full="false"></material-view>
            </b-tab>
          </b-tabs>
        </b-tab>
      </b-tabs>
    </div>
  </div>
</template>

<script>
  import { getCSRFToken } from '../../../utils/ajax'
  import { getStudent } from '../../../utils/helpers'
  import MaterialView from '../../materials/material-view.vue'

  export default {
    name: 'SupportGeneralSuggestions',
    components: { MaterialView },
    props: {
      groupId: Number,
      test: Number,
    },
    data: function () {
      return {
        loading: true,
        suggestions: [],
      }
    },
    created() {
      fetch('/materials?test=' + this.test + '&group=' + this.groupId, {
        headers: {
          Accept: 'text/javascript',
          'X-Requested-With': 'XMLHttpRequest',
          'X-CSRF-Token': getCSRFToken(),
        },
        credentials: 'include',
      }).then(response => {
        return response.text().then(text => {
          this.suggestions = JSON.parse(text)
          this.loading = false //Spinner verstecken
        })
      })
    },
    methods: {
      getStudentName(id) {
        //Student-Objekt aus globaler Variable holen
        return getStudent(this.groupId, id).name
      },
      generic(entry) {
        if (entry.materials.length == 0) {
          return []
        } else {
          let res = []
          for (let i = 0; i < entry.materials.length; ++i) {
            if (!entry.materials[i].specific) {
              res.push(entry.materials[i].material)
            }
          }
          return res
        }
      },
      specific(entry) {
        if (entry.materials.length == 0) {
          return []
        } else {
          let res = []
          for (let i = 0; i < entry.materials.length; ++i) {
            if (entry.materials[i].specific) {
              res.push(entry.materials[i].material)
            }
          }
          return res
        }
      },
    },
  }
</script>
