<template>
  <b-navbar toggleable="lg">
    <b-navbar-toggle target="nav-collapse" />
    <b-collapse id="nav-collapse" is-nav>
      <b-navbar-nav class="mx-auto">
        <b-nav-item><router-link to="/lehrkraefte">Für Lehrkräfte</router-link></b-nav-item>
        <b-nav-item><router-link to="/forschung">Für Forschende</router-link></b-nav-item>
        <b-nav-item><router-link to="/testinventar">Testinventar</router-link></b-nav-item>
        <b-nav-item><router-link to="/faq">FAQ</router-link></b-nav-item>
      </b-navbar-nav>
    </b-collapse>
  </b-navbar>
</template>
<script>
  export default {
    name: 'StartpageNav',
  }
</script>
