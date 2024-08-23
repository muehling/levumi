<template>
  <div>
    <p id="licence-headline" class="text-light bg-secondary pl-2 text-small">Lizenz</p>
    <p class="text-small">
      {{ `${forMaterial ? 'Diese Fördermaterialien sind' : 'Dieser Test ist'} lizensiert unter` }}
      <a href="https://creativecommons.org/licenses/by-nc-sa/4.0/deed.de" target="_blank">
        CC BY-NC-SA 4.0
        <img
          class="cc-image"
          src="https://mirrors.creativecommons.org/presskit/icons/cc.svg"
          alt="Creative Commons Icon" />
        <img
          class="cc-image"
          src="https://mirrors.creativecommons.org/presskit/icons/by.svg"
          alt="Creative Commons Icon" />
        <img
          class="cc-image"
          src="https://mirrors.creativecommons.org/presskit/icons/nc.svg"
          alt="Creative Commons Icon" />
        <img
          class="cc-image"
          src="https://mirrors.creativecommons.org/presskit/icons/sa.svg"
          alt="Creative Commons Icon" />
      </a>
    </p>
  </div>
</template>
<script>
  export default {
    name: 'LicenceDisplay',
    props: { forMaterial: Boolean },
  }
</script>
