<template>
  <BModal
    :model-value="store.generalModals.isCookieHintOpen"
    ok-only
    title="Cookie-Hinweis"
    @hidden="close">
    <p>
      Levumi nutzt ein sog. Session-Cookie, das für den Betrieb der Plattform technisch notwendig
      ist. Weitere Cookies werden nicht gesetzt.
    </p>
  </BModal>
</template>
<script>
  import { useGlobalStore } from 'src/store/store'

  export default {
    name: 'ImprintModal',
    setup() {
      const store = useGlobalStore()
      return { store }
    },

    methods: {
      close() {
        this.store.generalModals.isCookieHintOpen = false
      },
    },
  }
</script>
