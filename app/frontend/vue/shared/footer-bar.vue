<template>
  <footer class="footer w-100 text-center fixed-bottom pt-4">
    <ul class="list-inline text-center">
      <li class="mx-4 list-inline-item">
        <a href="#" @click.stop.prevent="openImprint">Impressum</a>
      </li>
      <li class="mx-4 list-inline-item">
        <a href="#" @click.stop.prevent="openPrivacy">AGB / Datenschutzerklärung</a>
      </li>
      <li class="mx-4 list-inline-item">
        <a href="#" @click.stop.prevent="openCookieHint">Cookie-Hinweis</a>
      </li>
      <li class="mx-4 list-inline-item">
        <a href="#" @click.stop.prevent="openAbout">Über das Projekt</a>
      </li>
    </ul>
    <ImprintModal />
    <AboutModal />
    <PrivacyModal />
    <CookieInfo />
  </footer>
</template>
<script>
  import { useGlobalStore } from 'src/store/store'
  import ImprintModal from 'src/vue/shared/modals/imprint-modal.vue'
  import AboutModal from 'src/vue/shared/modals/about-modal.vue'

  import PrivacyModal from 'src/vue/shared/modals/privacy-modal.vue'
  import CookieInfo from 'src/vue/shared/modals/cookie-info.vue'
  export default {
    name: 'FooterBar',
    components: { ImprintModal, CookieInfo, AboutModal, PrivacyModal },
    setup() {
      const store = useGlobalStore()
      return { store }
    },
    methods: {
      openImprint() {
        this.store.generalModals.isImprintOpen = true
      },
      openPrivacy() {
        this.store.generalModals.isPrivacyOpen = true
      },
      openAbout() {
        this.store.generalModals.isAboutOpen = true
      },
      openCookieHint() {
        this.store.generalModals.isCookieHintOpen = true
      },
    },
  }
</script>
