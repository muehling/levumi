<template>
  <nav class="navbar sticky-top navbar-light bg-light justify-content-between d-block d-sm-flex">
    <a class="navbar-brand d-block d-xs-inline" href="#"
      ><img
        src="/images/shared/Levumi-normal_small.png"
        alt="Levumi - Startseite"
        width="48"
        height="48"
      />Levumi</a
    >
    <a href="/testen" class="btn btn-outline-secondary">Zugang für Schülerinnen und Schüler</a>
    <div class="mt-2 mt-md-0">
      <div v-if="login">
        <a class="btn btn-outline-secondary" href="/diagnostik">TODO Nutzername</a>
      </div>
      <div v-else :class="`dropdown${retry ? ' show' : ''}`">
        <a
          id="navbarDropdown"
          class="btn btn-outline-secondary dropdown-toggle"
          href="#"
          role="button"
          data-toggle="dropdown"
          aria-haspopup="true"
        >
          Einloggen
        </a>
        <div :class="`dropdown-menu dropdown-menu-sm-right ${retry ? ' show' : ''}`">
          <b-form
            class="px-4 py-3 mx-3 mx-md-0 mw-100"
            @submit="sessionStorage['login'] = $('#password').val()"
          >
            <div class="form-group">
              <input
                id="login-email"
                type="email"
                name="email"
                aria-label="Email-Adresse eingeben"
                placeholder="E-Mail Adresse"
                :class="`form-control${retry ? 'is-invalid' : ''}`"
              />
            </div>
            <div class="form-group">
              <input
                id="password"
                type="password"
                name="password"
                aria-label="Passwort eingeben"
                placeholder="Passwort"
                :class="`form-control${retry ? 'is-invalid' : ''}`"
              />
              <div class="invalid-feedback">Benutzername oder Passwort ist falsch!</div>
            </div>
            <b-button type="submit">Einloggen</b-button>
            <div v-if="retry">
              <a href="/passwort" class="dropdown-item">Passwort vergessen? Hier klicken!</a>
            </div>
          </b-form>
        </div>

        <div class="dropdown-divider"></div>
        <a class="dropdown-item" href="#" @click="$('#modal').modal('show')"
          >Noch keinen Zugang? Hier kostenlos registrieren!</a
        >
      </div>
    </div>
  </nav>
</template>

<script>
  export default {
    name: 'StartpageApp',
    components: {},

    data() {
      return {
        login: undefined,
        retry: false,
        password: '',
        userName: '',
      }
    },
    computed: {},
    watch: {},
    mounted() {},
    methods: {},
  }
</script>
