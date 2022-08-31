<template>
  <b-container fluid>
    <b-row class="mt-3">
      <b-col md="12">
        <div v-if="single">
          <!-- nur eine Gruppe darstellen -->
          <group-view :groups="groups" :index="1" :single="true"></group-view>
        </div>

        <div v-else>
          <!-- reguläre Darstellung mit Klassenliste -->
          <b-tabs pills>
            <b-tab active>
              <template slot="title">
                <span id="intro_cb_1"
                  >Eigene Klassen ({{ count_regular }})</span
                >
              </template>

              <b-card no-body class="mt-3">
                <b-tabs pills card>
                  <!-- Neue Klasse anlegen -->
                  <b-tab>
                    <template slot="title">
                      <i
                        id="intro_cb_2"
                        class="fas fa-folder-plus fa-lg"
                        title="Neue Klasse anlegen"
                      ></i>
                    </template>
                    <!-- Group-Form mit index 0, da groups[0] ein leeres Objekt beinhaltet, für propagiertes Update die Rückgabe an Stelle 1 einfügen, Objekt an Stelle 0 bleibt erhalten.-->
                    <group-form
                      :group="groups[0]"
                      :index="0"
                      :active="firstOwnIndex == 0"
                      @update:groups="create"
                    ></group-form>
                  </b-tab>
                  <!-- Alle Klassen als Tabs anzeigen, index bei 1 beginnen und Archiv ausklammern -->
                  <!-- "title-link-class" ist workaround, damit ein Re-render nach Umbennenen getriggert wird. TODO: Überflüssig bei neuer Version von BootstrapVue? -->
                  <b-tab
                    v-for="(group, index) in groups"
                    v-if="(index > 0) & !group.archive && group.owner"
                    :key="group.id"
                    :active="index == firstOwnIndex"
                    :title-link-class="{ update_trigger_hack: group.label }"
                    class="m-3"
                  >
                    <!-- Beispielklasse kursiv darstellen -->
                    <template slot="title">
                      <i v-if="group.demo">{{ group.label }}</i>
                      <span v-else>{{ group.label }}</span>
                    </template>
                    <group-view
                      :groups="groups"
                      :index="index"
                      :single="false"
                      @update:groups="updateGroups"
                    ></group-view>
                  </b-tab>
                </b-tabs>
              </b-card>
            </b-tab>

            <!-- Geteilte Klassen -->
            <b-tab :disabled="count_shared == 0">
              <template slot="title">
                Mit mir geteilte Klassen
                <span v-if="new_shares" class="badge badge-info">Neu!</span
                ><span v-else>({{ count_shared }})</span>
              </template>

              <b-card no-body class="mt-3">
                <b-tabs pills card>
                  <b-tab
                    v-for="(group, index) in groups"
                    v-if="index > 0 && !group.owner"
                    :key="group.id"
                    :active="index == firstSharedIndex"
                    class="m-3"
                  >
                    <!-- Beispielklasse kursiv darstellen -->
                    <template slot="title">
                      <i v-if="group.demo">{{ group.label }}</i>
                      <span v-else>{{ group.label }}</span>
                      <span v-if="group.key == null" class="badge badge-info"
                        >Neu!</span
                      >
                    </template>
                    <group-view :groups="groups" :index="index"></group-view>
                  </b-tab>
                </b-tabs>
              </b-card>
            </b-tab>

            <!-- Klassenarchiv -->
            <b-tab :disabled="count_archive == 0">
              <template slot="title">
                Archivierte Klassen ({{ count_archive }})
              </template>

              <b-card no-body class="mt-3">
                <b-tabs pills card vertical>
                  <!-- Hinweistext falls keine Klasse vorhanden -->
                  <div slot="empty">
                    <div v-cloak class="text-center text-muted">
                      Keine Klassen im Archiv vorhanden.
                    </div>
                  </div>
                  <b-tab
                    v-for="(group, index) in groups"
                    v-if="index > 0 && group.archive"
                    :key="group.id"
                    class="m-3"
                  >
                    <!-- Beispielklasse kursiv darstellen -->
                    <template slot="title">
                      <i v-if="group.demo">{{ group.label }}</i>
                      <span v-else>{{ group.label }}</span>
                    </template>
                    <group-view
                      :groups="groups"
                      :index="index"
                      @update:groups="updateGroups"
                    ></group-view>
                  </b-tab>
                </b-tabs>
              </b-card>
            </b-tab>
          </b-tabs>
        </div>
      </b-col>
    </b-row>
  </b-container>
</template>

<script>
  import GroupForm from './group-form.vue'
  import GroupView from './group-view.vue'

  export default {
    name: 'ClassBookApp',
    components: {
      GroupView,
      GroupForm,
    },
    data() {
      return {
        groups: this.sort(this.$root.groups),
        single: this.$root.single,
      }
    },
    computed: {
      count_archive: function () {
        let c = 0
        for (let i = 1; i < this.groups.length; ++i)
          {if (this.groups[i].archive) {++c}}
        return c
      },
      count_regular: function () {
        let c = 0
        for (let i = 1; i < this.groups.length; ++i)
          {if (this.groups[i].owner && !this.groups[i].archive) {++c}}
        return c
      },
      count_shared: function () {
        let c = 0
        for (let i = 1; i < this.groups.length; ++i)
          {if (!this.groups[i].owner) {++c}}
        return c
      },
      firstOwnIndex: function () {
        //Liefert Demoklasse falls Intro gezeigt wird, ansonsten erste "eigene" Klasse.
        for (let i = 1; i < this.groups.length; ++i)
          {if (window.showIntro && this.groups[i].demo) {return i}
          else if (this.groups[i].owner && !this.groups[i].archive) {return i}}
        return 0
      },
      firstSharedIndex: function () {
        for (let i = 1; i < this.groups.length; ++i)
          {if (!this.groups[i].owner) {return i}}
        return 0
      },
      new_shares: function () {
        for (let i = 1; i < this.groups.length; ++i)
          {if (this.groups[i].key == null) {return true}}
        return false
      },
    },
    methods: {
      create(val) {
        this.groups.splice(1, 0, val.object)
        //Globale Daten aktualisieren
        //TODO: Classbook-App autark halten?
        keys[val.object.id] = val.object.key
        groups[val.object.id] = []
      },
      sort: function (groups) {
        let empty = groups.shift() //Erstes Element ist leere Gruppe für "new"
        groups.sort((a, b) => b.id - a.id) //Rest nach ID absteigend sortieren
        groups.unshift(empty)
        return groups
      },
      updateGroups(newGroups) {
        this.groups = newGroups
      },
    },
  }
</script>
