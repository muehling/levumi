<template>
  <b-popover
    v-if="isOpen"
    ref="introPopover"
    :key="currentIndex"
    :show="true"
    :target="targets[currentIndex]">
    <template #title>
      <div>
        Einführung
        <b-button
          v-b-popover.hover="'Diese Einführung beenden und nicht erneut anzeigen'"
          size="xs"
          class="cancel-tutorial float-end text-secondary"
          variant="outline-light"
          @click="cancelTutorial">
          <i class="fas fa-xmark"></i>
        </b-button>
      </div>
    </template>
    <p>{{ messages[currentIndex] }}</p>
    <div class="text-center mb-2">
      <b-button size="sm" class="ms-2" @click="next">
        {{ currentIndex === targets.length - 1 ? "Los geht's" : 'Weiter' }}
      </b-button>
    </div>
  </b-popover>
</template>

<script>
  export default {
    name: 'IntroPopover',

    data: () => ({
      messages: [],
      targets: [],
      currentIndex: undefined,
      isOpen: false,
      onFinish: undefined,
    }),

    methods: {
      show({ targets, messages, onFinish }) {
        this.targets = targets
        this.messages = messages
        this.isOpen = true
        this.currentIndex = 0
        this.onFinish = onFinish
      },
      cancelTutorial() {
        this.isOpen = false
        this.onFinish()
      },
      next() {
        if (this.currentIndex === this.targets.length - 1) {
          this.currentIndex = undefined
          this.isOpen = false
          this.onFinish()
        } else {
          this.currentIndex++
        }
      },
    },
  }
</script>
<style scoped>
  .cancel-tutorial {
    border-color: transparent !important;
    margin-top: -0.25em;
  }
</style>
