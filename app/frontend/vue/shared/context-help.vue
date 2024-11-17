<template>
  <BPopover :close-on-hide="true" :delay="{ show: 0, hide: 0 }">
    <template #target>
      <span style="font-size: 1rem" :class="className">
        <i class="fas fa-circle-question"></i>
      </span>
    </template>
    <div v-html="helpText"></div>
  </BPopover>
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
