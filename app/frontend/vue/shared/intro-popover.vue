<template>
  <b-popover
    v-if="isOpen"
    ref="introPopover"
    :key="currentIndex"
    :show="true"
    :target="targets[currentIndex]"
  >
    <p>{{ currentMessage }}</p>
    <b-btn @click="next">
      {{ currentIndex === targets.length - 1 ? "Los geht's" : 'Weiter' }}
    </b-btn>
  </b-popover>
</template>

<script>
  export default {
    name: 'IntroPopover',

    data: () => ({
      messages: [],
      targets: [],
      currentIndex: undefined,
      currentMessage: '',
      isOpen: false,
      onFinish: undefined,
    }),

    methods: {
      show({ targets, messages, onFinish }) {
        this.targets = targets
        this.messages = messages
        this.isOpen = true
        this.currentIndex = 0
        this.currentMessage = this.messages[0]
        this.onFinish = onFinish
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
