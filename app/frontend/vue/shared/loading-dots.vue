<template>
  <div :class="wrapperClassName">
    <div v-if="isLoading" :class="`spinner${className ? ' ' + className : ''}`">
      <div class="bounce1"></div>
      <div class="bounce2"></div>
      <div class="bounce3"></div>
    </div>
    <div v-if="!!message" class="text-center mt-4">{{ message }}</div>
  </div>
</template>

<script>
  export default {
    name: 'LoadingDots',
    props: {
      isLoading: Boolean,
      message: String,
      className: String,
      wrapperClassName: String,
    },
  }
</script>
