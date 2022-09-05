<template>
  <b-container fluid>
    <b-row class="mt-3">
      <b-col md="12">
        <div v-if="single">
          <!-- nur eine Gruppe darstellen -->
          <group-view :groups="groups" :single="true"></group-view>
        </div>

        <div v-else>
          <!-- reguläre Darstellung mit Klassenliste -->
          <b-tabs pills>
            <b-tab active>
              <template slot="title">
                <span id="intro_cb_1">Eigene Klassen ({{ ownActiveGroups.length }})</span>
              </template>

              <b-card no-body class="mt-3">
                <b-tabs pills card>
                  <!-- Neue Klasse anlegen -->
                  <b-tab :active="firstOwnIndex === 0">
                    <template slot="title">
                      <i
                        id="intro_cb_2"
                        class="fas fa-folder-plus fa-lg"
                        title="Neue Klasse anlegen"
                      ></i>
                    </template>
                    <!-- Group-Form mit index 0, da groups[0] ein leeres Objekt beinhaltet, für propagiertes Update die Rückgabe an Stelle 1 einfügen, Objekt an Stelle 0 bleibt erhalten.-->
                    <group-form :group="groups[0]" @update:groups="create"> </group-form>
                  </b-tab>
                  <!-- Alle Klassen als Tabs anzeigen, index bei 1 beginnen und Archiv ausklammern -->
                  <!-- "title-link-class" ist workaround, damit ein Re-render nach Umbennenen getriggert wird. TODO: Überflüssig bei neuer Version von BootstrapVue? -->
                  <b-tab
                    v-for="(group, index) in ownActiveGroups"
                    :key="group.id"
                    :active="index + 1 === firstOwnIndex"
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
                      :group="group"
                      :single="false"
                      @update:groups="updateGroups"
                    >
                    </group-view>
                  </b-tab>
                </b-tabs>
              </b-card>
            </b-tab>

            <!-- Geteilte Klassen -->
            <b-tab :disabled="sharedGroups.length === 0">
              <template slot="title">
                Mit mir geteilte Klassen
                <span v-if="new_shares" class="badge badge-info">Neu!</span
                ><span v-else>({{ sharedGroups.length }})</span>
              </template>

              <b-card no-body class="mt-3">
                <b-tabs pills card>
                  <b-tab
                    v-for="(group, index) in sharedGroups"
                    :key="group.id"
                    :active="index === firstSharedIndex"
                    class="m-3"
                  >
                    <!-- Beispielklasse kursiv darstellen -->
                    <template slot="title">
                      <i v-if="group.demo">{{ group.label }}</i>
                      <span v-else>{{ group.label }}</span>
                      <span v-if="group.key == null" class="badge badge-info">Neu!</span>
                    </template>
                    <group-view :groups="groups" :group="group"></group-view>
                  </b-tab>
                </b-tabs>
              </b-card>
            </b-tab>

            <!-- Klassenarchiv -->
            <b-tab :disabled="archivedGroups.length === 0">
              <template slot="title"> Archivierte Klassen ({{ archivedGroups.length }}) </template>

              <b-card no-body class="mt-3">
                <b-tabs pills card vertical>
                  <!-- Hinweistext falls keine Klasse vorhanden -->
                  <div slot="empty">
                    <div v-cloak class="text-center text-muted">
                      Keine Klassen im Archiv vorhanden.
                    </div>
                  </div>
                  <b-tab v-for="group in archivedGroups" :key="group.id" class="m-3">
                    <!-- Beispielklasse kursiv darstellen -->
                    <template slot="title">
                      <i v-if="group.demo">{{ group.label }}</i>
                      <span v-else>{{ group.label }}</span>
                    </template>
                    <group-view
                      :groups="groups"
                      :group="group"
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
    <intro-popover v-if="showIntro" ref="introPopover" />
  </b-container>
</template>

<script>
  import { ajax } from '../../utils/ajax'
  import GroupForm from './group-form.vue'
  import GroupView from './group-view.vue'
  import IntroPopover from '../shared/intro-popover.vue'
  import routes from '../../utils/routes'

  export default {
    name: 'ClassBookApp',
    components: {
      GroupView,
      GroupForm,
      IntroPopover,
    },
    data() {
      return {
        groups: this.sort(this.$root.groups),
        single: this.$root.single,
      }
    },
    computed: {
      ownActiveGroups() {
        return this.groups.filter((group, index) => index > 0 && group.owner && !group.archive)
      },
      sharedGroups() {
        return this.groups.filter((group, index) => index > 0 && !group.owner)
      },
      archivedGroups() {
        return this.groups.filter((group, index) => index > 0 && group.archive)
      },

      firstOwnIndex: function () {
        //Liefert Demoklasse falls Intro gezeigt wird, ansonsten erste "eigene" Klasse.
        if (this.showIntro) {
          return this.groups.findIndex(g => g.demo)
        } else {
          return this.groups.findIndex(g => g.owner && !g.archive) || 0
        }
      },
      firstSharedIndex: function () {
        for (let i = 1; i < this.groups.length; ++i) {
          if (!this.groups[i].owner) {
            return i
          }
        }
        return 0
      },
      new_shares: function () {
        for (let i = 1; i < this.groups.length; ++i) {
          if (this.groups[i].key == null) {
            return true
          }
        }
        return false
      },
      showIntro: function () {
        return this.$root.login.intro_state < 5
      },
    },
    mounted() {
      if (this.showIntro) {
        this.$refs.introPopover.show({
          messages: [
            'Hier sehen Sie Ihre eigenen Klassen, Klassen die mit Ihnen geteilt wurden und Klassen, die Sie in ihr Archiv verschoben haben. Aktuell gibt es bereits die Beispielklasse, mit der Sie alle Funktionen von Levumi testen können.',
            'Wenn Sie hier klicken, können Sie eine neue Klasse anlegen. Vergeben Sie für die Klasse einen beliebigen Namen.',
            'Wenn Sie mit Klassen nicht mehr länger aktiv arbeiten, können Sie sie in ihr Archiv verschieben. Die Klasse wird nicht mehr unter Diagnostik angezeigt. Sie können Klassen auch wieder aus dem Archiv zurückholen. Probieren Sie das gerne mit Ihrer Beispielklasse aus!',
            'Sie können Ihre Klasse mit anderen Nutzer*innen von Levumi teilen. Sie können dabei festlegen, ob die andere Person auch mit der Klasse arbeiten oder diese nur anschauen darf.',
            'Hier können Sie Schüler:innen für Ihre Klasse anlegen. Sie müssen einen Namen eingeben, die anderen Daten sind optional, helfen uns aber bei der Forschung. Auch das können Sie gleich für die Beispielklasse ausprobieren!',
            'Der Logincode wird vom System vergeben, Sie sehen ihn nach dem Speichern der Schüler:in. Mit diesem Code kann sich ein Kind im Zugang für Schüler:innen einloggen.',
            'Hier können Sie die Schüler:in speichern.',
          ],
          targets: [
            '#intro_cb_1',
            '#intro_cb_2',
            '#intro_cb_3',
            '#intro_cb_4',
            '#intro_cb_5',
            '#intro_cb_6',
            '#intro_cb_7',
          ],
          onFinish: this.finishIntro,
        })
      }
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
      async finishIntro() {
        await ajax({ url: routes.classbook.finishIntro, method: 'PATCH' })
      },
    },
  }
</script>
