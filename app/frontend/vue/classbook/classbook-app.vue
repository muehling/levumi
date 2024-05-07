<template>
  <b-container fluid>
    <div v-if="isLoading"><loading-dots :is-loading="isLoading" /></div>
    <div v-else>
      <b-row class="mt-3">
        <b-col md="12">
          <div>
            <!-- reguläre Darstellung mit Klassenliste -->
            <b-tabs :key="forceUpdate" pills>
              <b-tab lazy :active="activeTab === 1" @click="handleNavigate('eigene_klassen')">
                <template slot="title">
                  <span id="intro_cb_1">Eigene Klassen ({{ ownActiveGroups.length }})</span>
                </template>

                <b-card no-body class="mt-3">
                  <b-tabs :key="ownActiveGroups.length" pills card>
                    <!-- Neue Klasse anlegen -->
                    <b-tab
                      v-if="permissions.createGroup"
                      key="new_group"
                      :active="activeGroupTab === -2"
                      lazy
                      @click="handleNavigate('neu')">
                      <template slot="title">
                        <i
                          id="intro_cb_2"
                          class="fas fa-folder-plus fa-lg"
                          title="Neue Klasse anlegen"></i>
                      </template>
                      <group-form :group="{}"></group-form>
                    </b-tab>
                    <b-tab
                      v-for="(group, index) in ownActiveGroups"
                      :key="`${group.id}/${group.label}/${index}`"
                      :active="
                        group.id === activeGroupTab || (index === 0 && activeGroupTab === -1)
                      "
                      lazy
                      @click="handleNavigate(`eigene_klassen/${group.id}/liste`)">
                      <!-- Beispielklasse kursiv darstellen -->
                      <template slot="title">
                        <i v-if="group.demo">{{ group.label }}</i>
                        <span v-else>
                          {{ group.label + '/' + group.id }}
                        </span>
                      </template>
                      <group-view
                        :groups="globalStore.groups"
                        :group="group"
                        @update:groups="updateGroups"></group-view>
                    </b-tab>
                  </b-tabs>
                </b-card>
              </b-tab>

              <!-- Geteilte Klassen -->
              <b-tab
                v-if="displaySharesTab"
                :disabled="sharedGroups.length === 0"
                lazy
                :active="activeTab === 2"
                @click="handleNavigate('geteilte_klassen')">
                <template slot="title">
                  Mit mir geteilte Klassen
                  <span v-if="hasNewShares" class="badge badge-info">Neu!</span>
                  <span v-else>({{ sharedGroups.length }})</span>
                </template>

                <b-card no-body class="mt-3">
                  <b-tabs pills card>
                    <b-tab
                      v-for="group in sharedGroups"
                      :key="group.id"
                      :active="group.id === selectedGroupId"
                      class="m-3"
                      lazy
                      @click="handleNavigate(`geteilte_klassen/${group.id}/liste`)">
                      <!-- Beispielklasse kursiv darstellen -->
                      <template slot="title">
                        <i v-if="group.demo">{{ group.label }}</i>
                        <span v-else>{{ group.label + '/' + group.id }}</span>
                        <span v-if="group.key == null" class="badge badge-info ml-2">Neu!</span>
                      </template>
                      <group-view :groups="sharedGroups" :group="group"></group-view>
                    </b-tab>
                  </b-tabs>
                </b-card>
              </b-tab>

              <!-- Klassenarchiv -->
              <b-tab
                v-if="displayArchiveTab"
                :disabled="archivedGroups.length === 0"
                lazy
                :active="activeTab === 3"
                @click="handleNavigate('archiv')">
                <template slot="title">Archivierte Klassen ({{ archivedGroups.length }})</template>

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
                      <group-view :groups="groups" :group="group" @update:groups="updateGroups" />
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
  import { access } from 'src/utils/access'
  import { ajax } from '../../utils/ajax'
  import { isSingleUser } from 'src/utils/user'
  import { useGlobalStore } from '../../store/store'
  import GroupForm from './group-view-actions/group-form.vue'
  import GroupView from './group-view.vue'
  import IntroPopover from '../shared/intro-popover.vue'
  import isEmpty from 'lodash/isEmpty'
  import LoadingDots from '../shared/loading-dots.vue'
  import routes from '../routes/api-routes'
  import Vue from 'vue'

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
    data() {
      return { selectedGroupId: undefined, forceUpdate: undefined }
    },
    computed: {
      currentRoute() {
        return this.$route.path
      },
      activeTab() {
        if (this.currentRoute.startsWith('/klassenbuch/archiv')) {
          return 3
        } else if (this.currentRoute.startsWith('/klassenbuch/geteilt')) {
          return 2
        } else {
          return 1
        }
      },
      activeGroupTab() {
        if (!this.selectedGroupId && this.currentRoute.endsWith('neu')) {
          return -2
        } else if (!this.selectedGroupId) {
          return -1
        } else {
          return this.selectedGroupId
        }
      },
      displaySharesTab() {
        return (isSingleUser() && this.sharedGroups.length) || !isSingleUser()
      },
      displayArchiveTab() {
        return !isSingleUser()
      },
      isLoading() {
        return this.globalStore.isLoading
      },
      isSingleUser() {
        return isSingleUser()
      },
      groups() {
        if (isEmpty(this.globalStore.groups)) {
          return []
        } else {
          return this.globalStore.groups
        }
      },
      ownActiveGroups() {
        return this.getTabGroups(true, false)
      },
      sharedGroups() {
        return this.getTabGroups(false, false)
      },
      archivedGroups() {
        return this.getTabGroups(true, true)
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

      hasNewShares() {
        return this.globalStore.groups.reduce((acc, g) => acc || g.key === null, false)
      },
      permissions() {
        return access().classbook
      },
      showIntro: function () {
        return this.globalStore.login.intro_state < 5
      },
    },
    watch: {
      '$route.params': {
        immediate: true,
        async handler(data) {
          this.selectedGroupId = data.groupId ? parseInt(data.groupId, 10) : undefined
          this.forceUpdate = Symbol()
        },
      },
    },

    async mounted() {
      await this.globalStore.fetchGroups()
      this.forceUpdate = Symbol()

      let messages, targets
      if (this.isSingleUser) {
        messages = [
          'Hier sehen Sie Ihre Beispielklasse, die dem intuitiven Kennenlernen der Levumi.de Plattform, den Tests und allen Funktionen dient. Hier können Sie alle Funktionen von Levumi testen.',
          'Hier können Sie Schüler:innen für Ihre Klasse anlegen. Sie müssen einen Namen eingeben, die anderen Daten sind optional, helfen uns aber bei der Forschung. Auch das können Sie gleich für die Beispielklasse ausprobieren!',
          'Der Logincode wird vom System vergeben, Sie sehen ihn nach dem Speichern der Schüler:in. Mit diesem Code kann sich ein Kind im Zugang für Schüler:innen einloggen.',
          'Hier können Sie die Schüler:in speichern.',
        ]
        targets = ['#intro_cb_1', '#intro_cb_5', '#intro_cb_6', '#intro_cb_7']
      } else {
        messages = [
          'Hier sehen Sie Ihre eigenen Klassen, Klassen die mit Ihnen geteilt wurden und Klassen, die Sie in ihr Archiv verschoben haben. Aktuell gibt es bereits die Beispielklasse, mit der Sie alle Funktionen von Levumi testen können. Diese Beispielklasse dient dem intuitiven Kennenlernen der Levumi.de Plattform, den Tests und allen Funktionen. Daher werden keine Daten gespeichert. Für Testungen von realen Schüler*innen legen Sie bitte eine neue Klasse an. ',
          'Wenn Sie hier klicken, können Sie eine neue Klasse anlegen. Vergeben Sie für die Klasse einen beliebigen Namen.',
          'Hier finden Sie klassenspezifische Einstellungen und Aktionen, wie das Umbennen der Klasse, das Generieren von QR-Codes, das Teilen der Klasse mit Kollegen, oder das Verschieben von Schüler:innen in eine andere Klasse.',
          'Hier können Sie Schüler:innen für Ihre Klasse anlegen. Sie müssen einen Namen eingeben, die anderen Daten sind optional, helfen uns aber bei der Forschung. Auch das können Sie gleich für die Beispielklasse ausprobieren!',
          'Der Logincode wird vom System vergeben, Sie sehen ihn nach dem Speichern der Schüler:in. Mit diesem Code kann sich ein Kind im Zugang für Schüler:innen einloggen.',
          'Hier können Sie die Schüler:in speichern.',
        ]
        targets = [
          '#intro_cb_1',
          '#intro_cb_2',
          '#intro_cb_3',
          '#intro_cb_5',
          '#intro_cb_6',
          '#intro_cb_7',
        ]
      }

      if (this.showIntro) {
        this.$refs.introPopover.show({
          messages,
          targets,
          onFinish: this.finishIntro,
        })
      }
    },
    methods: {
      getTabGroups(isOwner, isArchive) {
        if (isEmpty(this.globalStore.groups)) {
          return []
        }

        return this.globalStore.groups
          .filter(group => group.owner === isOwner && group.archive === isArchive)
          .sort((a, b) => (a.label < b.label ? -1 : 1))
      },
      updateGroups(newGroups) {
        this.globalStore.setGroups(newGroups)
      },
      async finishIntro() {
        await ajax({ url: routes.classbook.finishIntro, method: 'PATCH' })
        Vue.set(this.globalStore.login, 'intro_state', 5)
      },
      handleNavigate(path) {
        this.$router.push(`/klassenbuch/${path}`)
      },
    },
  }
</script>
