<template>
  <div>
    <b-navbar toggleable="md" class="nav-pills main-navbar">
      <b-navbar-brand to="/">
        <img :src="'/images/shared/Levumi-normal_small.png'" alt="Levumi" height="48" />
        Levumi
      </b-navbar-brand>
      <div class="d-md-none">
        <h1>{{ navigationDisplay }}</h1>
      </div>
      <b-navbar-toggle target="levumi-main-nav" />
      <b-collapse id="levumi-main-nav" is-nav class="mt-3">
        <b-navbar-nav class="d-flex w-100">
          <b-nav-item to="/diagnostik" :active="$route.path.startsWith('/diagnostik')">
            Diagnostik
          </b-nav-item>
          <b-nav-item to="/klassenbuch" :active="$route.path.startsWith('/klassenbuch')">
            <span>
              Klassenbuch
              <b-badge v-if="hasNewShares" variant="info" pill class="new-badge">Neu!</b-badge>
            </span>
          </b-nav-item>
          <b-nav-item to="/materialien" :active="$route.path.startsWith('/materialien')">
            Fördermaterialien
          </b-nav-item>
          <b-nav-item to="/testuebersicht" :active="$route.path.startsWith('/testuebersicht')">
            Testübersicht
          </b-nav-item>
          <b-nav-item-dropdown text="Weiteres" is-nav toggle-class="mt-1">
            <b-dropdown-item>
              <a
                class="dropdown-item"
                href="https://mailman.tu-dortmund.de/mailman/listinfo/levumi.news.fk13"
                target="_blank">
                Levumi Newsletter
              </a>
            </b-dropdown-item>
            <b-dropdown-item>
              <a
                class="dropdown-item"
                href="https://www.youtube.com/channel/UCy_3wk9N5Flhdy5bqDogzCg"
                target="_blank">
                Videos
              </a>
            </b-dropdown-item>
            <b-dropdown-item>
              <a class="dropdown-item" href="https://www.levumi-blog.uni-kiel.de/" target="_blank">
                Blog
              </a>
            </b-dropdown-item>
            <b-dropdown-divider />
            <b-dropdown-item>
              <h6 class="dropdown-header">Handbücher</h6>
              <a
                class="dropdown-item"
                href="/files/Testhandbuch_Empfinden_Verhalten.pdf"
                target="_blank">
                Handbuch Lernbereich Empfinden & Verhalten
              </a>
            </b-dropdown-item>
            <b-dropdown-item>
              <a class="dropdown-item" href="/files/Testhandbuch_Deutsch.pdf" target="_blank">
                Handbuch Lernbereich Deutsch
              </a>
            </b-dropdown-item>
            <b-dropdown-item>
              <a class="dropdown-item" href="/files/Foerderansaetze_Deutsch.pdf" target="_blank">
                Handbuch Fördermaterial Deutsch
              </a>
            </b-dropdown-item>
            <b-dropdown-divider />
            <b-dropdown-item>
              <h6 class="dropdown-header">Druckvorlagen</h6>
              <a class="dropdown-item" href="/files/A4_Levumi_normal.pdf" target="_blank">
                A4 Levumi normal
              </a>
            </b-dropdown-item>
            <b-dropdown-item>
              <a class="dropdown-item" href="/files/A4_Levumi_jubelt.pdf" target="_blank">
                A4 Levumi jubelt
              </a>
            </b-dropdown-item>
            <b-dropdown-item>
              <a class="dropdown-item" href="/files/A4_Levumi_liest.pdf" target="_blank">
                A4 Levumi liest
              </a>
            </b-dropdown-item>
            <b-dropdown-item>
              <a class="dropdown-item" href="/files/A3_Levumi_normal.pdf" target="_blank">
                A3 Levumi normal
              </a>
            </b-dropdown-item>
            <b-dropdown-item>
              <a class="dropdown-item" href="/files/A3_Levumi_jubelt.pdf" target="_blank">
                A3 Levumi jubelt
              </a>
            </b-dropdown-item>
            <b-dropdown-item>
              <a class="dropdown-item" href="/files/A3_Levumi_liest.pdf" target="_blank">
                A3 Levumi liest
              </a>
            </b-dropdown-item>
          </b-nav-item-dropdown>
          <b-alert v-if="!!systemMessage" class="ms-auto mb-0" :model-value="true" variant="danger">
            {{ systemMessage }}
          </b-alert>
          <div class="flex-grow-1"></div>
          <b-nav
            v-if="masquerade"
            href="#"
            class="nav-link btn btn-outline-secondary"
            @click="endMasquerade">
            Sitzung als {{ login?.email }} beenden
          </b-nav>

          <b-nav-item-dropdown ref="contactRef" class="mt-1" :text="'Support'" is-nav>
            <b-dropdown-form>
              <contact-form @close-contact-form="closeContactForm" />
            </b-dropdown-form>
          </b-nav-item-dropdown>
          <b-nav-item-dropdown text="System" is-nav toggle-class="mt-1">
            <b-dropdown-item v-if="checkCapability('support')" to="/support">
              Support
            </b-dropdown-item>
            <!--<b-dropdown-item v-if="checkCapability('stats')" to="/statistiken">
                Statistiken
              </b-dropdown-item>-->
            <span
              v-if="checkCapability('stats')"
              class="dropdown-item"
              style="opacity: 0.5; pointer-events: none; white-space: nowrap">
              Statistiken (aktuell außer Betrieb)
            </span>
            <b-dropdown-item v-if="checkCapability('user')" to="/nutzerverwaltung">
              Benutzerverwaltung
            </b-dropdown-item>
            <router-link
              v-if="
                checkCapability('test') ||
                checkCapability('test_admin') ||
                checkCapability('test_upload')
              "
              to="/testverwaltung"
              class="dropdown-item">
              Testverwaltung
            </router-link>
            <router-link
              v-if="checkCapability('test_editor')"
              to="/test-editor"
              class="dropdown-item">
              Test-Editor
            </router-link>
            <router-link
              v-if="checkCapability('material')"
              to="/materialverwaltung"
              class="dropdown-item">
              Materialverwaltung
            </router-link>
            <router-link v-if="checkCapability('export')" to="/testexport" class="dropdown-item">
              Export
            </router-link>
            <router-link v-if="checkCapability('admin')" to="/administration" class="dropdown-item">
              Allgemeine Einstellungen
            </router-link>
          </b-nav-item-dropdown>
          <b-nav-item-dropdown
            :text="`Meine Daten${$root.mode === 'production' ? '' : ' (' + login?.email + ')'}`"
            is-nav
            toggle-class="mt-1">
            <b-dropdown-item v-if="!masquerade" @click="editOwnProfile">
              Profildaten ändern
            </b-dropdown-item>
            <b-dropdown-item v-if="!masquerade" @click="editUserSettings">
              Einstellungen ändern
            </b-dropdown-item>
            <b-dropdown-item :href="`/users/${login.id}.text`" :disabled="!hasTestedStudents">
              Testungen exportieren
            </b-dropdown-item>
          </b-nav-item-dropdown>
          <b-nav-item-dropdown text="Rechtliches" class="mt-1">
            <b-dropdown-item href="/files/Vorlage_Elternbrief.pdf" target="_blank">
              Vorlage Einwilligungserklärung
            </b-dropdown-item>
            <b-dropdown-divider />
            <b-dropdown-item href="#" @click="openImprint">Impressum</b-dropdown-item>
            <b-dropdown-item href="#" @click="openPrivacy">Datenschutzerklärung</b-dropdown-item>
            <b-dropdown-item href="#" @click="openTerms">Nutzungsbedingungen</b-dropdown-item>
            <b-dropdown-item href="#" @click="openCookieHint">Cookie-Hinweis</b-dropdown-item>
          </b-nav-item-dropdown>
          <b-nav-item @click="handleLogout">Ausloggen</b-nav-item>
        </b-navbar-nav>
      </b-collapse>
    </b-navbar>

    <edit-user-dialog ref="editUserDialog" @refetch="updateUser" />
    <user-settings-dialog ref="userSettingsDialog" @refetch="updateUser" />
    <ImprintModal />
    <AboutModal />
    <PrivacyModal />
    <CookieInfo />
    <TermsModal />
  </div>
</template>
<script>
  import { ajax } from '../../utils/ajax'
  import { isRegularUser, hasCapability } from '../../utils/user'
  import { RouterLink } from 'vue-router'
  import { useAssessmentsStore } from '../../store/assessmentsStore'
  import { useGlobalStore } from '../../store/store'
  import AboutModal from 'src/vue/shared/modals/about-modal.vue'
  import apiRoutes from '../routes/api-routes'
  import ContactForm from './forms/contact-form.vue'
  import CookieInfo from 'src/vue/shared/modals/cookie-info.vue'
  import EditUserDialog from '../users/components/edit-user-dialog.vue'
  import ImprintModal from 'src/vue/shared/modals/imprint-modal.vue'
  import TermsModal from 'src/vue/shared/modals/terms-modal.vue'
  import PrivacyModal from 'src/vue/shared/modals/privacy-modal.vue'
  import router from '../routes/frontend-routes'
  import UserSettingsDialog from '../users/components/user-settings-dialog.vue'

  export default {
    name: 'NavBar',
    components: {
      ContactForm,
      EditUserDialog,
      RouterLink,
      UserSettingsDialog,
      AboutModal,
      CookieInfo,
      ImprintModal,
      PrivacyModal,
      TermsModal,
    },
    setup() {
      const assessmentsStore = useAssessmentsStore()
      const globalStore = useGlobalStore()
      return { globalStore, assessmentsStore }
    },
    data() {
      return { showLegal: false, showProfile: false, showAdminMenu: false }
    },
    computed: {
      navigationDisplay() {
        if (this.$route.path.startsWith('/diagnostik')) {
          return 'Diagnostik'
        } else if (this.$route.path.startsWith('/klassenbuch')) {
          return 'Klassenbuch'
        } else if (this.$route.path.startsWith('/materialien')) {
          return 'Fördermaterialien'
        } else if (this.$route.path.startsWith('/testuebersicht')) {
          return 'Testübersicht'
        } else {
          return ''
        }
      },
      systemMessage() {
        switch (this.$root.mode) {
          case 'staging':
            return 'TEST-SYSTEM'
          case 'development':
            return 'DEV'
          default:
            return ''
        }
      },

      login() {
        return this.globalStore.login
      },
      masquerade() {
        return this.globalStore.masquerade
      },
      hasNewShares() {
        return this.globalStore.groups.reduce(
          (acc, g) => acc || (g.key === null && !g.owner),
          false
        )
      },
      hasTestedStudents() {
        return this.globalStore.login.has_tested_students
      },
      isRegularUser() {
        return isRegularUser(this.login.capabilities)
      },
    },

    methods: {
      closeContactForm() {
        this.$refs.contactRef.hide()
      },
      openImprint() {
        this.globalStore.generalModals.isImprintOpen = true
      },
      openPrivacy() {
        this.globalStore.generalModals.isPrivacyOpen = true
      },
      openTerms() {
        this.globalStore.generalModals.isTermsOpen = true
      },
      openCookieHint() {
        this.globalStore.generalModals.isCookieHintOpen = true
      },
      async updateUser(res) {
        const data = res.data
        this.globalStore.setLogin({ ...this.globalStore.login, ...data })
      },
      checkCapability(capability) {
        return hasCapability(capability, this.globalStore.login.capabilities)
      },
      editOwnProfile() {
        this.$refs.editUserDialog.open({ user: this.globalStore.login, isNew: false })
      },
      editUserSettings() {
        this.$refs.userSettingsDialog.open({ user: this.globalStore.login })
      },
      async handleLogout() {
        const res = await ajax({ url: apiRoutes.users.logout, method: 'POST' })
        if (res.status === 200) {
          router.push('/')
          sessionStorage.removeItem('login')
          window.location.reload()
        }
      },
      async endMasquerade() {
        const res = await ajax({ url: apiRoutes.users.logout, method: 'GET' })
        if (res.status === 200) {
          this.globalStore.fetch(true)
          router.push('/nutzerverwaltung')
          this.assessmentsStore.reset()
        }
      },
    },
  }
</script>
<style>
  .nav-link {
    padding-left: 0.7em !important;
    padding-right: 0.7em !important;
  }
  .main-navbar {
    background: linear-gradient(to bottom, rgba(94, 86, 187, 0.12), rgba(255, 255, 255, 1));
  }
</style>
