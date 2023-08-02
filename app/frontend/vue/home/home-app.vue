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
              v-for="(group, index) in ownActiveGroups"
              :key="group.id"
              :active="$root.pre_select && $root.pre_select.group == group.id"
              lazy
              @click="getTestsForGroup(group.id)"
            >
              <!-- Beispielklasse kursiv darstellen -->
              <template slot="title">
                <i v-if="group.demo && group.owner">{{ group.label }}</i>
                <span v-else-if="!group.owner" :id="`tooltip-target-${index}`">
                  {{ group.label }}
                  <span class="small"> &nbsp;<i class="fas fa-share-nodes"></i> </span>
                  <b-tooltip
                    :target="`tooltip-target-${index}`"
                    triggers="hover"
                    offset="20"
                    variant="secondary"
                    delay="300"
                  >
                    Geteilt von {{ group.belongs_to }}
                  </b-tooltip>
                </span>
                <span v-else>{{ group.label }}</span>
              </template>

              <!-- Zweite Ebene - gewählte Klasse -->
              <div v-if="!group.key">
                <b-card bg-variant="light" class="col-lg-8 col-xl-6 mt-3">
                  <p>
                    Sie müssen zuerst den Sicherheitscode zur Freischaltung der geteilten Klasse im
                    Klassenbuch eingeben. Den Sicherheitscode erhalten Sie bzw. können Sie bei der
                    Person erfragen, die die Klasse mit Ihnen geteilt hat.
                  </p>
                </b-card>
              </div>
              <group-view
                v-else
                :group="group"
                :index="index"
                :group-info="groupInfo.find(gi => gi.group_id === group.id)"
                @test-used="markTestAsUsed"
              />
            </b-tab>
          </b-tabs>

          <!-- Ansonsten Klasse vorauswählen -->
          <group-view
            v-else-if="groups.length > 0"
            :group="groups[0]"
            :group-info="groupInfo[0]"
            :index="0"
            @test-used="markTestAsUsed"
          >
          </group-view>

          <div v-else class="text-center text-muted">
            Keine Klassen vorhanden! Legen Sie eine Klasse an um testen zu können oder verschieben
            Sie eine Klasse aus dem Archiv.
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
  import GroupView from './group-view.vue'
  import IntroPopover from '../shared/intro-popover.vue'
  import routes from '../routes/api-routes'
  import { useAssessmentsStore } from '../../store/assessmentsStore'

  export default {
    name: 'HomeApp',
    components: { GroupView, IntroPopover },
    setup() {
      const globalStore = useGlobalStore()
      const assessmentsStore = useAssessmentsStore()
      return { globalStore, assessmentsStore }
    },
    computed: {
      ownActiveGroups() {
        return this.globalStore.groups
          .filter((group, index) => index > 0 && !group.archive)
          .sort((a, b) => (a.label < b.label ? -1 : 1))
      },
      groups() {
        return this.globalStore.groups.filter(group => group.id)
      },
      groupInfo() {
        return this.globalStore.groupInfo
      },
      showIntro() {
        return this.globalStore.login.intro_state < 4
      },
    },
    mounted() {
      if (this.showIntro) {
        this.$refs.introPopover.show({
          messages: [
            'Diese Ansicht sehen Sie zukünftig nach dem Einloggen. Dort können Sie die Testergebnisse ansehen und neue Testungen durchführen.',
            'Hier verwalten Sie die Schülerinnen und Schüler. Sie müssen diese vor dem ersten Testen anlegen.',
            'Hier finden Sie Fördermaterial passend zu den Tests.',
            'Informieren Sie sich über die Tests, die zur Verfügung stehen.',
            'Unter diesem Punkt finden Sie weiteres Material, Hilfestellungen und den Blog mit Neuigkeiten.',
            'Hier können Sie Ihre Profildaten bearbeiten.',
          ],
          targets: ['#intro1', '#intro2', '#intro3', '#intro4', '#intro5', '#intro6'],
          onFinish: this.finishIntro,
        })
      }
    },
    updated() {
      this.$root.pre_select = undefined
    },
    methods: {
      async finishIntro() {
        await ajax({ url: routes.home.finishIntro, method: 'PATCH' })
      },

      markTestAsUsed(testId, groupId) {
        this.groupInfo.find(group => group.group_id === groupId).used_test_ids.push(testId)
      },
      getTestsForGroup(groupId) {
        const group = this.globalStore.groups.find(group => group.id === groupId)
        if (group.key) {
          this.assessmentsStore.fetch(groupId)
        }
      },
    },
  }
</script>
