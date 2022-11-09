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
            >
              <!-- Beispielklasse kursiv darstellen -->
              <template slot="title">
                <i v-if="group.demo">{{ group.label }}</i>
                <span v-else>{{ group.label }}</span>
              </template>

              <!-- Zweite Ebene - gewählte Klasse -->
              <group-view
                :group="group"
                :index="index"
                :group-info="groupInfo[index]"
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

  export default {
    name: 'HomeApp',
    components: { GroupView, IntroPopover },
    setup() {
      const globalStore = useGlobalStore()
      return { globalStore }
    },
    data: function () {
      return {
        //groups: this.globalStore.groups.filter(group => group.id),
        //groupInfo: this.$root.group_info,
      }
    },
    computed: {
      ownActiveGroups() {
        return this.globalStore.groups.filter(
          (group, index) => index > 0 && group.owner && !group.archive
        )
      },
      groups() {
        return this.globalStore.groups.filter(group => group.id)
      },
      groupInfo() {
        return this.globalStore.groupInfo
      },
      showIntro() {
        return this.globalStore.login.intro_state < 4
      }
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
            'Hier können Sie Ihre Profildaten bearbeiten.'
          ],
          targets: ['#intro1', '#intro2', '#intro3', '#intro4', '#intro5', '#intro6'],
          onFinish: this.finishIntro
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

      markTestAsUsed(testId, groupInfoIndex) {
        //FIXME entirely too sideeffecty
        const test = this.groupInfo[groupInfoIndex].tests.find(test => test.info.id === testId)
        test.used = true
      }
    }
  }
</script>
