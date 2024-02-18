<template>
  <b-container fluid>
    <div>
      <b-row>
        <b-col md="12" class="mt-3">
          <b-card v-if="groups.length === 0" bg-variant="white" class="col-lg-8 col-xl-6 mt-3">
            Keine Klassen vorhanden! Legen Sie eine Klasse an um testen zu können oder verschieben
            Sie eine Klasse aus dem Archiv.
          </b-card>
          <div v-else>
            <b-nav pills>
              <b-nav-item
                v-for="(group, index) in ownActiveGroups"
                :key="group.id"
                :active="selectedGroupId === group.id"
                lazy
                @click="getTestsForGroup(group.id)"
              >
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
              </b-nav-item>
            </b-nav>

            <div v-if="!currentGroup?.key">
              <b-card bg-variant="white" class="col-lg-8 col-xl-6 mt-3">
                <p>
                  Sie müssen diese Klasse zunächst im Klassenbuch freischalten. Den ggf.
                  erforderlichen Sicherheitscode erhalten Sie bzw. können Sie bei der Person
                  erfragen, die die Klasse mit Ihnen geteilt hat.
                </p>
              </b-card>
            </div>
            <group-view v-else :key="selectedGroupId" :selected-group-id="selectedGroupId" />
          </div>
        </b-col>
      </b-row>
    </div>
    <intro-popover v-if="showIntro" ref="introPopover" />
  </b-container>
</template>

<script>
  import { ajax } from '../../utils/ajax'
  import { useAssessmentsStore } from '../../store/assessmentsStore'
  import { useGlobalStore } from '../../store/store'
  import GroupView from './group-view.vue'
  import IntroPopover from '../shared/intro-popover.vue'
  import routes from '../routes/api-routes'
  import Vue from 'vue'
  import isEmpty from 'lodash/isEmpty'

  export default {
    name: 'HomeApp',
    components: { GroupView, IntroPopover },
    setup() {
      const globalStore = useGlobalStore()
      const assessmentsStore = useAssessmentsStore()
      return { globalStore, assessmentsStore }
    },
    data() {
      return {
        selectedGroupId: undefined,
      }
    },
    computed: {
      ownActiveGroups() {
        return this.globalStore.groups
          .filter((group, index) => index > 0 && !group.archive)
          .sort((a, b) => (a.label < b.label ? -1 : 1))
      },
      groups() {
        // the first element is only intended as a placeholder for new groups and is not needed here
        return this.globalStore.groups.filter(group => group.id)
      },
      showIntro() {
        return this.globalStore.login.intro_state < 4
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
            this.selectedGroupId = parseInt(data.groupId, 10)
          }
          await this.$nextTick()
        },
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
      let selectedGroupId
      if (this.$route.params.groupId) {
        selectedGroupId = parseInt(this.$route.params.groupId, 10)
      } else {
        const firstActiveGroup = this.ownActiveGroups[0]
        selectedGroupId = firstActiveGroup.id
      }
      this.selectedGroupId = selectedGroupId
      if (isEmpty(this.assessmentsStore.assessments) && this.currentGroup.key) {
        this.assessmentsStore.fetch(selectedGroupId)
      }
    },
    methods: {
      async finishIntro() {
        await ajax({ url: routes.home.finishIntro, method: 'PATCH' })
        Vue.set(this.globalStore.login, 'intro_state', 4)
      },
      getTestsForGroup(groupId) {
        this.selectedGroupId = groupId
        this.assessmentsStore.setCurrentAssessment(undefined)
        this.$router.push({
          path: `/diagnostik/${groupId}`,
        })
      },
    },
  }
</script>
