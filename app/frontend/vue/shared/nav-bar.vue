<template>
  <nav class="navbar navbar-expand-lg navbar-light bg-light">
    <a class="navbar-brand" href="/start"
      ><img src="/favicon.ico" alt="Levumi" width="48" height="48" />Levumi</a
    >

    <button
      class="navbar-toggler"
      type="button"
      data-toggle="collapse"
      data-target="#navbarContent"
      aria-controls="navbarContent"
      aria-expanded="false"
      aria-label="Toggle navigation"
    >
      <span class="navbar-toggler-icon"></span>
    </button>

    <div id="navbarContent" class="collapse navbar-collapse">
      <ul class="navbar-nav ml-3">
        <li id="intro1" class="nav-item active">
          <router-link class="nav-link" to="/start">Diagnostik</router-link>
        </li>
        <li id="intro2" class="nav-item">
          <router-link class="nav-link" to="/klassenbuch"
            >Klassenbuch
            <span v-if="hasNewShares" class="badge badge-info">Neu!</span>
          </router-link>
        </li>
        <li id="intro3" class="nav-item">
          <router-link class="nav-link" to="/materialien">Fördermaterialien</router-link>
        </li>
        <li id="intro4" class="nav-item">
          <router-link to="/testuebersicht" class="nav-link">Testübersicht</router-link>
        </li>
        <li id="intro5" class="nav-item dropdown">
          <a
            id="navbarHelp"
            class="nav-link dropdown-toggle"
            href="#"
            role="button"
            data-toggle="dropdown"
            aria-haspopup="true"
            aria-expanded="false"
          >
            Weiteres
            <!-- TODO: Badge wieder entfernen -->
            <span class="badge badge-info">Neu!</span>
          </a>
          <div class="dropdown-menu" aria-labelledby="navbarHelp">
            <!-- TODO: Badge wieder entfernen -->
            <a
              class="dropdown-item"
              href="https://www-mailman.uni-regensburg.de/mailman/listinfo/news-levumi"
              target="_blank"
              >Levumi Newsletter <span class="badge badge-info">Neu!</span></a
            >
            <a
              class="dropdown-item"
              href="https://www.youtube.com/channel/UCy_3wk9N5Flhdy5bqDogzCg"
              target="_blank"
              >Videos</a
            >
            <a class="dropdown-item" href="https://www.levumi-blog.uni-kiel.de/" target="_blank"
              >Blog</a
            >
            <div class="dropdown-divider"></div>
            <h6 class="dropdown-header">Handbücher</h6>
            <a class="dropdown-item" href="/files/Testhandbuch_Empfinden_Verhalten.pdf"
              >Handbuch Lernbereich Empfinden & Verhalten</a
            >
            <a class="dropdown-item" href="/files/Testhandbuch_Deutsch.pdf"
              >Handbuch Lernbereich Deutsch</a
            >
            <a class="dropdown-item" href="/files/Foerderansaetze_Deutsch.pdf"
              >Handbuch Fördermaterial Deutsch</a
            >
            <div class="dropdown-divider"></div>
            <h6 class="dropdown-header">Druckvorlagen</h6>
            <a class="dropdown-item" href="/files/A4_Levumi_normal.pdf" target="_blank"
              >A4 Levumi normal</a
            >
            <a class="dropdown-item" href="/files/A4_Levumi_jubelt.pdf" target="_blank"
              >A4 Levumi jubelt</a
            >
            <a class="dropdown-item" href="/files/A4_Levumi_liest.pdf" target="_blank"
              >A4 Levumi liest</a
            >
            <a class="dropdown-item" href="/files/A3_Levumi_normal.pdf" target="_blank"
              >A3 Levumi normal</a
            >
            <a class="dropdown-item" href="/files/A3_Levumi_jubelt.pdf" target="_blank"
              >A3 Levumi jubelt</a
            >
            <a class="dropdown-item" href="/files/A3_Levumi_liest.pdf" target="_blank"
              >A3 Levumi liest</a
            >
          </div>
        </li>
      </ul>

      <ul class="navbar-nav ml-auto">
        <li v-if="masquerade" class="nav-item">
          <a href="#" class="nav-link btn btn-outline-secondary" @click="endMasquerade"
            >Sitzung als {{ login?.email }} beenden</a
          >
        </li>
        <li v-if="!isRegularUser" class="nav-item dropdown">
          <a
            id="navbarSystem"
            class="nav-link dropdown-toggle"
            href="#"
            role="button"
            data-toggle="dropdown"
            aria-haspopup="true"
            aria-expanded="false"
          >
            System
          </a>
          <div class="dropdown-menu dropdown-menu" aria-labelledby="navbarSystem">
            <a href="/users?stats=true" class="dropdown-item">Statistik</a>
            <router-link to="/nutzerverwaltung" class="dropdown-item">
              Benutzerverwaltung
            </router-link>
            <router-link v-if="checkCapability('test')" to="/testverwaltung" class="dropdown-item">
              Testverwaltung
            </router-link>
            <router-link
              v-if="checkCapability('materials')"
              to="/materialverwaltung"
              class="dropdown-item"
              >MaterialVerwaltung</router-link
            >
            <a v-if="checkCapability('export')" href="/tests?export=true" class="dropdown-item"
              >Export</a
            >
          </div>
        </li>
        <li id="intro6" class="nav-item dropdown">
          <a
            id="navbarMyData"
            class="nav-link dropdown-toggle"
            href="#"
            role="button"
            data-toggle="dropdown"
            aria-haspopup="true"
            aria-expanded="false"
          >
            Meine Daten ({{ login?.email }})
          </a>
          <div class="dropdown-menu" aria-labelledby="navbarMyData">
            <!--TODO Userdialog öffnen, nicht die Route ändern-->
            <a href="#" class="dropdown-item" @click="editOwnProfile">Profildaten ändern</a>
            <a href="/users?edit_profile" class="dropdown-item">TODO Testungen exportieren</a>
          </div>
        </li>
        <li class="nav-item dropdown">
          <a
            id="navbarLegal"
            class="nav-link dropdown-toggle"
            href="#"
            role="button"
            data-toggle="dropdown"
            aria-haspopup="true"
            aria-expanded="false"
          >
            Rechtliches
          </a>
          <div class="dropdown-menu dropdown-menu-right" aria-labelledby="navbarLegal">
            <a class="dropdown-item" href="/files/Vorlage_Elternbrief.doc"
              >Vorlage Einwilligungserklärung</a
            >
            <div class="dropdown-divider"></div>
            <a class="dropdown-item" href="#" onclick="$('#imprint').modal('show')">Impressum</a>
            <a class="dropdown-item" href="#" onclick="$('#privacy').modal('show')"
              >Datenschutzerklärung</a
            >
            <a class="dropdown-item" href="#" onclick="$('#tc').modal('show')"
              >Nutzungsbedingungen</a
            >
          </div>
        </li>
        <li class="nav-item">
          <form action="/logout" method="post">
            <input name="authenticity_token" type="hidden" :value="getCSRFToken()" />
            <button type="submit" class="nav-link border-0 bg-transparent" href="/logout">
              Ausloggen
            </button>
          </form>
        </li>
      </ul>
    </div>
    <!-- some modal with terms and conditions -->
    <edit-user-dialog ref="editUserDialog" />
  </nav>
</template>
<script>
  import { ajax, getCSRFToken } from '../../utils/ajax'
  import { isRegularUser, hasCapability } from '../../utils/user'
  import { RouterLink } from 'vue-router'
  import { useGlobalStore } from '../../store/store'
  import apiRoutes from '../routes/api-routes'
  import EditUserDialog from '../users/components/edit-user-dialog.vue'
  import router from '../routes/frontend-routes'

  export default {
    name: 'NavBar',
    components: {
      RouterLink,
      EditUserDialog,
    },
    setup() {
      const globalStore = useGlobalStore()
      return { globalStore }
    },

    computed: {
      login() {
        return this.globalStore.login
      },
      masquerade() {
        return this.globalStore.masquerade
      },
      hasNewShares: function () {
        return this.globalStore.groups.reduce((acc, g) => acc || g.key === null, false)
      },
      isRegularUser() {
        return isRegularUser(this.login.capabilities)
      },
    },

    methods: {
      checkCapability(capability) {
        return hasCapability(capability, this.globalStore.login.capabilities)
      },
      getCSRFToken,
      editOwnProfile() {
        this.$refs.editUserDialog.open({ user: this.globalStore.login, isNew: false })
      },
      async endMasquerade() {
        const res = await ajax({ url: apiRoutes.users.logout, method: 'GET' })
        if (res.status === 200) {
          this.globalStore.fetch()
          router.push('/nutzerverwaltung')
        }
      },
    },
  }
</script>
