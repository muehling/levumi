<template>
  <b-navbar toggleable="lg" type="dark" variant="primary">
    <b-navbar-toggle target="nav-collapse" />
    <b-collapse id="nav-collapse" is-nav>
      <b-navbar-nav pills class="mx-auto">
        <b-nav-item exact to="/">Startseite</b-nav-item>
        <b-nav-item exact to="/lehrkraefte">Für Lehrkräfte</b-nav-item>
        <b-nav-item exact to="/forschung">Für Forschende</b-nav-item>
        <b-nav-item exact to="/testinventar">Testinventar</b-nav-item>
      </b-navbar-nav>
    </b-collapse>
  </b-navbar>
</template>
<script>
  export default {
    name: 'StartpageNav',
  }
</script>
