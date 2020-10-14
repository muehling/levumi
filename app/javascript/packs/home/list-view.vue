<template>

    <div v-if="list.length == 0">
      <p class='m-5 text-center text-muted'>
        Noch keine aktiven Tests vorhanden! <br/>
        Legen Sie zunächst über die Auswahl unten einen Test für diese Klasse an.
      </p>
    </div>
    <div v-else>
      <table class='table table-sm table-striped table-responsive-md text-small'>
        <thead>
        <tr>
          <th>Test</th>
          <th>Wöchentliche Testung</th>
        </tr>
        </thead>
        <tbody>
          <tr v-for="test in sorted_list">
            <td>{{ test.name }}</td>
            <td>
              <!-- rails-ujs Link beinhaltet Auth_Token-->
              <a v-if="test.active && test.student_test"
                 class='btn btn-sm btn-danger'
                 :href="'/groups/' + group.id + '/assessments/' + test.test"
                 data-method='put'
                 data-remote='true'
                 data-params='assessment[active]=0'
                 v-on:ajax:success="$emit('update:list')"
              >
                <i class='fas fa-pause'></i> Pausieren
              </a>
              <a v-else-if="test.student_test"
                 class='btn btn-sm btn-success'
                 :href="'/groups/' + group.id + '/assessments/' + test.test"
                 data-method='put'
                 data-remote='true'
                 data-params='assessment[active]=1'
                 v-on:ajax:success="$emit('update:list')"
              >
                <i class='fas fa-play'></i> Aktivieren
              </a>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

</template>

<script>
    export default {
        props: {
            group: Object,
            list: Array
        },
        computed: {
            sorted_list() {
              return this.list.sort((a, b) => a.name.localeCompare(b.name))
            }
        },
        name: 'list-view'
    }
</script>
