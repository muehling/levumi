<template>
  <b-container fluid>
    <div v-cloak>
      <b-row>
        <b-col md="12" class="mt-3">
          <!-- Klassenauswahl nur bei mehreren Klassen anzeigen (=> Privatpersonen...) -->
          <!-- TODO: Besser! -->
          <b-tabs v-if="groups.length > 1" pills>
            <div slot="empty">
              <div class="text-center text-muted">Keine aktuellen Klassen vorhanden.</div>
            </div>

            <!-- Oberste Ebene - aktuelle Klassen, falls pre_select gesetzt, direkt auswählen -->
            <b-tab
              v-for="(group, index) in groups"
              :key="group.id"
              :active="$root.pre_select && $root.pre_select.group == group.id"
            >
              <!-- Beispielklasse kursiv darstellen -->
              <template slot="title">
                <i v-if="group.demo">{{ group.label }}</i>
                <span v-else>{{ group.label }}</span>
              </template>

              <!-- Zweite Ebene - gewählte Klasse -->
              <group-view :group="group" :group-info="group_info[index]"> </group-view>
            </b-tab>
          </b-tabs>

          <!-- Ansonsten Klasse vorauswählen -->
          <group-view v-else-if="groups.length > 0" :group="groups[0]" :group-info="group_info[0]"> </group-view>

          <div v-else class="text-center text-muted">
            Keine Klassen vorhanden! Legen Sie eine Klasse an um testen zu können oder verschieben Sie eine Klasse aus
            dem Archiv.
          </div>
        </b-col>
      </b-row>
    </div>
  </b-container>
</template>

<script>
  import GroupView from './group-view.vue'
  export default {
    name: 'HomeApp',
    components: { GroupView },
    data: function () {
      return {
        groups: this.$root.groups,
        group_info: this.$root.group_info,
      }
    },
    updated() {
      this.$root.pre_select = undefined
    },
  }
</script>
