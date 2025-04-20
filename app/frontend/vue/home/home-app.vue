<template>
  <b-container fluid>
    <loading-dots v-if="isLoading" :is-loading="true" />
    <div v-else>
      <b-row>
        <b-col md="12" class="mt-3">
          <b-card
            v-if="ownActiveGroups.length === 0"
            bg-variant="white"
            class="col-lg-8 col-xl-6 mt-3">
            Keine aktiven Klassen vorhanden! Legen Sie eine Klasse an um testen zu können, oder
            reaktivieren Sie eine Klasse aus dem Archiv.
          </b-card>
          <div v-else>
            <div class="mb-3">
              <b-tabs pills card no-fade>
                <b-tab
                  v-for="(group, index) in ownActiveGroups"
                  :key="'home' + group.id"
                  :active="selectedGroupId === group.id"
                  lazy
                  @click="getTestsForGroup(group.id)">
                  <template #title>
                    <i v-if="group.demo && group.owner">{{ group.label }}</i>
                    <span v-else-if="!group.owner" :id="`tooltip-target-${index}`">
                      {{ group.label }}
                      <span class="small">
                        <i class="fas fa-share-nodes"></i>
                      </span>
                    </span>
                    <span v-else>{{ group.label }}</span>
                  </template>

                  <p v-if="!currentGroup?.owner" class="mt-3">
                    Diese Klasse wurde geteilt von {{ currentGroup?.belongs_to }}.
                  </p>
                  <div v-if="!currentGroup?.key && currentGroup?.id">
                    <b-card bg-variant="white" class="col-lg-8 col-xl-6 mt-3">
                      <p>
                        Sie müssen diese Klasse zunächst im
                        <router-link
                          :to="{
                            name: 'ClassbookSharedGroup',
                            params: { groupId: currentGroup?.id },
                          }">
                          Klassenbuch
                        </router-link>
                        freischalten. Den ggf. erforderlichen Sicherheitscode erhalten Sie bzw.
                        können Sie bei der Person erfragen, die die Klasse mit Ihnen geteilt hat.
                      </p>
                    </b-card>
                  </div>
                  <group-view v-else-if="selectedGroupId" :selected-group-id="selectedGroupId" />
                </b-tab>
              </b-tabs>
            </div>
          </div>
        </b-col>
      </b-row>
    </div>
    <intro-popover v-if="showIntro" ref="introPopover" />
  </b-container>
</template>

<script>
  import { ajax } from 'src/utils/ajax'
  import { useAssessmentsStore } from 'src/store/assessmentsStore'
  import { useTestsStore } from 'src/store/testsStore'
  import { useGlobalStore } from 'src/store/store'
  import GroupView from './home-app-components/group-view.vue'
  import IntroPopover from '../shared/intro-popover.vue'
  import LoadingDots from 'src/vue/shared/loading-dots.vue'
  import routes from '../routes/api-routes'

  export default {
    name: 'HomeApp',
    components: { GroupView, IntroPopover, LoadingDots },
    setup() {
      const globalStore = useGlobalStore()
      const assessmentsStore = useAssessmentsStore()
      const testsStore = useTestsStore()
      return { globalStore, assessmentsStore, testsStore }
    },
    data() {
      return {
        selectedGroupId: undefined,
        isLoading: false,
      }
    },
    computed: {
      ownActiveGroups() {
        return this.globalStore.groups
          .filter(group => !group.archive)
          .sort((a, b) => (a.label < b.label ? -1 : 1))
      },
      groups() {
        // the first element is only intended as a placeholder for new groups and is not needed here
        // TODO check if still necessary, globalStore.groups shouldn't contain a placeholder anymore
        return this.globalStore.groups.filter(group => group.id)
      },
      showIntro() {
        return this.globalStore.login.intro_state < 4 && this.globalStore.login.intro_state > 1
      },
      currentGroup() {
        return this.ownActiveGroups.find(group => group.id === this.selectedGroupId)
      },
    },

    watch: {
      '$route.params': {
        immediate: true,
        async handler(data) {
          if (data.forceUpdate) {
            this.assessmentsStore.setCurrentAssessment(undefined)
          }
          if (data.groupId) {
            const group = this.ownActiveGroups.find(
              group => group.id === parseInt(data.groupId, 10)
            )

            if (group) {
              this.selectedGroupId = parseInt(data.groupId, 10)
            } else {
              this.selectedGroupId = this.ownActiveGroups[0]?.id
            }
          } else {
            this.selectedGroupId = this.ownActiveGroups[0]?.id
          }
        },
      },
      selectedGroupId: {
        immediate: true,
        async handler(newId) {
          await this.assessmentsStore.fetch(newId)
          const newGroup = this.globalStore.groups.find(group => group.id === newId)
          // not accepted shares will be undefined, resulting in an error
          if (newGroup && !!newGroup.key) {
            await this.testsStore.fetchUsedTestsForGroup(newId)
          }
        },
      },
    },
    async mounted() {
      if (this.showIntro) {
        this.$refs.introPopover.show({
          messages: [
            'Diese Ansicht sehen Sie zukünftig nach dem Einloggen. Dort können Sie die Testergebnisse ansehen und neue Testungen durchführen.',
            'Hier verwalten Sie die Schülerinnen und Schüler. Sie müssen diese vor dem ersten Testen anlegen.',
            'Hier finden Sie Fördermaterial passend zu den Tests.',
            'Informieren Sie sich über die Tests, die zur Verfügung stehen.',
            'Unter diesem Punkt finden Sie weiteres Material, Hilfestellungen und den Blog mit Neuigkeiten.',
            'Sollten Sie Hilfe benötigen, eine Anregung, Kritik oder ein Lob loswerden wollen, können Sie dem Levumi-Team hier eine Nachricht schreiben.',
            'Hier können Sie Ihre Profildaten und Einstellungen bearbeiten.',
          ],
          targets: ['#intro1', '#intro2', '#intro3', '#intro4', '#intro5', '#intro6', '#intro7'],
          onFinish: this.finishIntro,
        })
      }
    },
    methods: {
      async finishIntro() {
        await ajax({ url: routes.home.finishIntro, method: 'PATCH' })
        this.globalStore.login.intro_state = 4
      },
      getTestsForGroup(groupId) {
        this.selectedGroupId = groupId
        this.assessmentsStore.setCurrentAssessment(undefined)
        if (window.location.pathname !== `/diagnostik/${groupId}`) {
          this.$router.push({ path: `/diagnostik/${groupId}` })
        }
      },
    },
  }
</script>
