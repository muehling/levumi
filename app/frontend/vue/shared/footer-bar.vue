<template>
  <footer class="footer w-100 text-center">
    <ul class="list-inline text-center">
      <li class="list-inline-item">
        <a href="#" data-toggle="modal" data-target="#imprint">Impressum</a>
      </li>
      <li class="list-inline-item">
        <a href="#" data-toggle="modal" data-target="#t_and_c">Datenschutzerklärung</a>
      </li>
      <li class="list-inline-item">
        <a
          id="dsgvo-hint"
          class="link-primary dsgvo-hint"
          href="#dsgvo-hint"
          tabindex="0"
          data-trigger="focus"
          data-toggle="popover"
          data-placement="top"
          data-content="Levumi nutzt ein sog. Session-Cookie, das für den Betrieb der Plattform technisch notwendig ist. Weitere Cookies werden nicht gesetzt."
          data-original-title=""
          title="Cookie-Hinweis"
          >Cookie-Hinweis</a
        >
      </li>
      <li class="list-inline-item">
        <a href="#" data-toggle="modal" data-target="#projects">Über das Projekt</a>
      </li>
    </ul>
  </footer>
</template>
<script>
  export default {
    name: 'FooterBar',
  }
</script>

<style>
  .footer {
    position: absolute;
    bottom: 0;
  }
</style>
