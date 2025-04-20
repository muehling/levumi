<template>
  <div class="text-center mt-4">
    <img :src="levumiImg" alt="Levumi" width="50%" height="50%" />
    <p class="mt-3" style="font-weight: bold; font-size: 2em">
      Levumi wird gerade gewartet.
      <br />
      Wir sind in Kürze wieder für sie da!
    </p>
  </div>
</template>

<script setup>
  import { computed } from 'vue'
  import levumiSrc from '../../../../assets/images/shared/Levumi-normal.jpg'

  const levumiImg = computed(() => levumiSrc)
</script>
