<template>
  <div>
    <nav class="navbar navbar-expand-lg navbar-light bg-light">
      <a class="navbar-brand" href="/">
        <img :src="'/images/shared/Levumi-normal_small.png'" alt="Levumi" height="48" />
        Levumi
      </a>

      <button
        class="navbar-toggler"
        type="button"
        data-toggle="collapse"
        data-target="#navbarContent"
        aria-controls="navbarContent"
        aria-expanded="false"
        aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
      </button>

      <div id="navbarContent" class="collapse navbar-collapse">
        <ul class="navbar-nav ms-3">
          <li id="intro1" class="nav-item">
            <router-link
              class="nav-link rounded"
              :to="{ name: 'Diagnostik', state: { forceUpdate: true } }">
              Diagnostik
            </router-link>
          </li>
          <li id="intro2" class="nav-item">
            <router-link class="nav-link rounded" to="/klassenbuch">
              Klassenbuch
              <span v-if="hasNewShares" class="badge badge-info">Neu!</span>
            </router-link>
          </li>
          <li id="intro3" class="nav-item">
            <router-link class="nav-link rounded" to="/materialien">Fördermaterialien</router-link>
          </li>
          <li id="intro4" class="nav-item">
            <router-link to="/testuebersicht" class="nav-link rounded">Testübersicht</router-link>
          </li>
          <li id="intro5" class="nav-item dropdown">
            <BDropdown :text="'Weiteres'" variant="navbar-light">
              <BDropdownItem>
                <a
                  class="dropdown-item"
                  href="https://mailman.tu-dortmund.de/mailman/listinfo/levumi.news.fk13"
                  target="_blank">
                  Levumi Newsletter
                </a>
              </BDropdownItem>
              <BDropdownItem>
                <a
                  class="dropdown-item"
                  href="https://www.youtube.com/channel/UCy_3wk9N5Flhdy5bqDogzCg"
                  target="_blank">
                  Videos
                </a>
              </BDropdownItem>
              <BDropdownItem>
                <a
                  class="dropdown-item"
                  href="https://www.levumi-blog.uni-kiel.de/"
                  target="_blank">
                  Blog
                </a>
              </BDropdownItem>
              <BDropdownDivider />
              <BDropdownItem>
                <h6 class="dropdown-header">Handbücher</h6>
                <a class="dropdown-item" href="/files/Testhandbuch_Empfinden_Verhalten.pdf">
                  Handbuch Lernbereich Empfinden & Verhalten
                </a>
              </BDropdownItem>
              <BDropdownItem>
                <a class="dropdown-item" href="/files/Testhandbuch_Deutsch.pdf">
                  Handbuch Lernbereich Deutsch
                </a>
              </BDropdownItem>
              <BDropdownItem>
                <a class="dropdown-item" href="/files/Foerderansaetze_Deutsch.pdf">
                  Handbuch Fördermaterial Deutsch
                </a>
              </BDropdownItem>
              <BDropdownDivider />
              <BDropdownItem>
                <h6 class="dropdown-header">Druckvorlagen</h6>
                <a class="dropdown-item" href="/files/A4_Levumi_normal.pdf" target="_blank">
                  A4 Levumi normal
                </a>
              </BDropdownItem>
              <BDropdownItem>
                <a class="dropdown-item" href="/files/A4_Levumi_jubelt.pdf" target="_blank">
                  A4 Levumi jubelt
                </a>
              </BDropdownItem>
              <BDropdownItem>
                <a class="dropdown-item" href="/files/A4_Levumi_liest.pdf" target="_blank">
                  A4 Levumi liest
                </a>
              </BDropdownItem>
              <BDropdownItem>
                <a class="dropdown-item" href="/files/A3_Levumi_normal.pdf" target="_blank">
                  A3 Levumi normal
                </a>
              </BDropdownItem>
              <BDropdownItem>
                <a class="dropdown-item" href="/files/A3_Levumi_jubelt.pdf" target="_blank">
                  A3 Levumi jubelt
                </a>
              </BDropdownItem>
              <BDropdownItem>
                <a class="dropdown-item" href="/files/A3_Levumi_liest.pdf" target="_blank">
                  A3 Levumi liest
                </a>
              </BDropdownItem>
            </BDropdown>
          </li>
          <!--######################################################################-->
        </ul>
        <b-alert v-if="!!systemMessage" class="ml-auto mb-0" show variant="danger">
          {{ systemMessage }}
        </b-alert>

        <ul class="navbar-nav ml-auto">
          <li v-if="masquerade" class="nav-item">
            <a href="#" class="nav-link btn btn-outline-secondary" @click="endMasquerade">
              Sitzung als {{ login?.email }} beenden
            </a>
          </li>

          <!--######################################################################-->
          <!--Support Button-->
          <li v-if="!masquerade" class="nav-item dropdown">
            <BDropdown :text="'Support'" variant="">
              <BDropdownItem><contact-form /></BDropdownItem>
            </BDropdown>
          </li>
          <!--######################################################################-->

          <!--######################################################################-->
          <!--System Button-->
          <li v-if="!isRegularUser && !masquerade" class="nav-item">
            <BDropdown v-model="showAdminMenu" text="System" variant="">
              <BDropdownItem v-if="checkCapability('stats')" to="/statistiken">
                Statistik
              </BDropdownItem>
              <BDropdownItem v-if="checkCapability('user')" to="/nutzerverwaltung">
                Benutzendenverwaltung
              </BDropdownItem>
            </BDropdown>
          </li>
          <!--######################################################################-->

          <!--######################################################################-->
          <!--Start Meine daten Button-->
          <div class="d-none">
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
          </div>
          <li v-if="!masquerade" id="intro6" class="nav-item">
            <!--Meine Daten Button-->
            <BDropdown
              v-model="showProfile"
              :text="`Meine Daten${$root.mode === 'production' ? '' : ' (' + login?.email + ')'}`"
              variant="">
              <BDropdownItem @click="editOwnProfile">Profildaten ändern</BDropdownItem>
              <BDropdownItem @click="editUserSettings">Einstellungen ändern ändern</BDropdownItem>
              <BDropdownItem :href="`/users/${login.id}.text`" :disabled="!hasTestedStudents">
                Testungen exportieren
              </BDropdownItem>
            </BDropdown>
          </li>
          <li v-if="!masquerade" class="nav-item">
            <BDropdown v-model="showLegal" text="Rechtliches" variant="outline-primary">
              <BDropdownItem href="/files/Vorlage_Elternbrief.pdf" target="_blank">
                Vorlage Einwilligungserklärung
              </BDropdownItem>
              <BDropdownDivider />
              <BDropdownItem href="#" @click="openImprint">Impressum</BDropdownItem>
              <BDropdownItem href="#" @click="openPrivacy">Datenschutzerklärung</BDropdownItem>
              <BDropdownItem href="#" @click="openTerms">Nutzungsbedingungen</BDropdownItem>
              <BDropdownItem href="#" @click="openCookieHint">Cookie-Hinweis</BDropdownItem>
            </BDropdown>
          </li>
          <li v-if="!masquerade" class="nav-item">
            <form action="/logout" method="post" onsubmit="sessionStorage.removeItem('login')">
              <input name="authenticity_token" type="hidden" :value="getCSRFToken()" />
              <button type="submit" class="nav-link border-0 bg-transparent" href="/logout">
                Ausloggen
              </button>
            </form>
          </li>
        </ul>
      </div>
    </nav>
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
  import { ajax, getCSRFToken } from '../../utils/ajax'
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
      getCSRFToken,
      editOwnProfile() {
        this.$refs.editUserDialog.open({ user: this.globalStore.login, isNew: false })
      },
      editUserSettings() {
        this.$refs.userSettingsDialog.open({ user: this.globalStore.login })
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
