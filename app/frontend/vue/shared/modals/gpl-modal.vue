<template>
  <BModal
    :model-value="store.generalModals.isGPLOpen"
    scrollable
    ok-only
    size="md"
    title="Software-Lizenz"
    @hidden="close">
    <p>
      Unsere Software ist unter der AGPL (GNU Affero General Public License) veröffentlicht. Den
      vollständigen Quellcode finden Sie bei
      <a
        href="https://github.com/muehling/levumi"
        target="_blank"
        class="text-decoration-underline">
        Github
      </a>
      .
    </p>
  </BModal>
</template>
<script>
  import { useGlobalStore } from 'src/store/store'

  export default {
    name: 'AboutModal',
    setup() {
      const store = useGlobalStore()
      return { store }
    },

    methods: {
      close() {
        this.store.generalModals.isGPLOpen = false
      },
    },
  }
</script>
