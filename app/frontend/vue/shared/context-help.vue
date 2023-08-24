<template>
  <span v-b-popover="popoverOptions" style="font-size: 1rem" :class="className">
    <i class="fas fa-circle-question"></i>
  </span>
</template>
<script>
  export default {
    name: 'ContextHelp',
    props: {
      helpText: {
        type: String,
        required: true,
      },
      position: String,
      className: String,
    },
    computed: {
      popoverOptions() {
        return {
          content: this.helpText,
          trigger: 'hover',
          placement: this.position || 'topright',
        }
      },
    },
  }
</script>
