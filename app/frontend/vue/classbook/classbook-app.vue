<template>
  <b-container fluid>
    <div v-if="isLoading"><loading-dots :is-loading="isLoading" /></div>
    <div v-else>
      <b-row class="mt-3">
        <b-col md="12">
          <div v-if="single">
            <!-- nur eine Gruppe darstellen -->
            <group-view :groups="groups" :group="groups[1]" :single="true"></group-view>
          </div>

          <div v-else>
            <!-- reguläre Darstellung mit Klassenliste -->
            <b-tabs pills>
              <b-tab active lazy>
                <template slot="title">
                  <span id="intro_cb_1">Eigene Klassen ({{ ownActiveGroups.length }})</span>
                </template>

                <b-card no-body class="mt-3">
                  <b-tabs pills card>
                    <!-- Neue Klasse anlegen -->
                    <b-tab :key="firstOwnIndex" :active="false">
                      <template slot="title">
                        <i
                          id="intro_cb_2"
                          class="fas fa-folder-plus fa-lg"
                          title="Neue Klasse anlegen"
                        ></i>
                      </template>
                      <!-- Group-Form mit index 0, da groups[0] ein leeres Objekt beinhaltet, für propagiertes Update die Rückgabe an Stelle 1 einfügen, Objekt an Stelle 0 bleibt erhalten.-->
                      <group-form :group="groups[0]"> </group-form>
                    </b-tab>
                    <!-- Alle Klassen als Tabs anzeigen, index bei 1 beginnen und Archiv ausklammern -->
                    <b-tab
                      v-for="(group, index) in ownActiveGroups"
                      :key="`${group.id}/${group.label}`"
                      :active="index === firstOwnIndex"
                      class="m-3"
                      lazy
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
              <b-tab :disabled="sharedGroups.length === 0" lazy>
                <template slot="title">
                  Mit mir geteilte Klassen
                  <span v-if="new_shares" class="badge badge-info">Neu!</span
                  ><span v-else>({{ sharedGroups.length }})</span>
                </template>

                <b-card no-body class="mt-3">
                  <b-tabs pills card>
                    <b-tab v-for="(group, index) in sharedGroups" :key="group.id" class="m-3" lazy>
                      <!-- Beispielklasse kursiv darstellen -->
                      <template slot="title">
                        <i v-if="group.demo">{{ group.label }}</i>
                        <span v-else>{{ group.label }}</span>
                        <span v-if="group.key == null" class="badge badge-info ml-2">Neu!</span>
                      </template>
                      <group-view :groups="sharedGroups" :group="group"></group-view>
                    </b-tab>
                  </b-tabs>
                </b-card>
              </b-tab>

              <!-- Klassenarchiv -->
              <b-tab :disabled="archivedGroups.length === 0" lazy>
                <template slot="title">
                  Archivierte Klassen ({{ archivedGroups.length }})
                </template>

                <b-card no-body class="mt-3">
                  <b-tabs pills card vertical>
                    <!-- Hinweistext falls keine Klasse vorhanden -->
                    <div slot="empty">
                      <div v-cloak class="text-center text-muted">
                        Keine Klassen im Archiv vorhanden.
                      </div>
                    </div>
                    <b-tab v-for="group in archivedGroups" :key="group.id" class="m-3" lazy>
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
    </div>
    <intro-popover v-if="showIntro" ref="introPopover" />
  </b-container>
</template>

<script>
  import { ajax } from '../../utils/ajax'
  import { useGlobalStore } from '../../store/store'
  import GroupForm from './group-form.vue'
  import GroupView from './group-view.vue'
  import IntroPopover from '../shared/intro-popover.vue'
  import routes from '../routes/api-routes'
  import isEmpty from 'lodash/isEmpty'
  import LoadingDots from '../shared/loading-dots.vue'

  export default {
    name: 'ClassBookApp',
    components: {
      GroupView,
      GroupForm,
      IntroPopover,
      LoadingDots,
    },
    setup() {
      const globalStore = useGlobalStore()
      return { globalStore }
    },
    computed: {
      isLoading() {
        return this.globalStore.isLoading
      },
      single() {
        return this.globalStore.login.account_type === 2
      },
      groups() {
        if (isEmpty(this.globalStore.groups)) {
          return []
        }
        const sorted = [...this.globalStore.groups]

        let empty = sorted.shift() //Erstes Element ist leere Gruppe für "new"
        sorted.sort((a, b) => b.id - a.id) //Rest nach ID absteigend sortieren
        sorted.unshift(empty)
        return sorted
      },

      ownActiveGroups() {
        return this.groups
          .filter((group, index) => index > 0 && group.owner && !group.archive)
          .sort((a, b) => (a.label < b.label ? -1 : 1))
      },
      sharedGroups() {
        return this.groups
          .filter((group, index) => index > 0 && !group.owner && !group.archive)
          .sort((a, b) => (a.label < b.label ? -1 : 1))
      },
      archivedGroups() {
        return this.groups
          .filter((group, index) => index > 0 && group.archive && group.owner)
          .sort((a, b) => (a.label < b.label ? -1 : 1))
      },

      firstOwnIndex: function () {
        //Liefert Demoklasse falls Intro gezeigt wird, ansonsten erste "eigene" Klasse.
        let a

        if (this.showIntro) {
          a = this.ownActiveGroups?.findIndex(g => g.demo)
        } else {
          a = this.ownActiveGroups?.findIndex(g => g.owner && !g.archive && g.id) || 0
        }
        return a
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
        return this.globalStore.login.intro_state < 5
      },
    },
    mounted() {
      if (this.showIntro) {
        this.$refs.introPopover.show({
          messages: [
            'Hier sehen Sie Ihre eigenen Klassen, Klassen die mit Ihnen geteilt wurden und Klassen, die Sie in ihr Archiv verschoben haben. Aktuell gibt es bereits die Beispielklasse, mit der Sie alle Funktionen von Levumi testen können. Diese Beispielklasse dient dem intuitiven Kennenlernen der Levumi.de Plattform, den Tests und allen Funktionen. Daher werden keine Daten gespeichert. Für Testungen von realen Schüler*innen legen Sie bitte eine neue Klasse an. ',
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
      updateGroups(newGroups) {
        this.globalStore.setGroups(newGroups)
      },
      async finishIntro() {
        await ajax({ url: routes.classbook.finishIntro, method: 'PATCH' })
      },
    },
  }
</script>
