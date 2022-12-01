<template>
  <div v-if="isLoading" class="spinner">
    <div class="bounce1"></div>
    <div class="bounce2"></div>
    <div class="bounce3"></div>
  </div>
</template>

<script>
  export default {
    name: 'LoadingDots',
    props: {
      isLoading: Boolean,
    },
  }
</script>
