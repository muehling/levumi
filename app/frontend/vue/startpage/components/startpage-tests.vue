<template>
  <div>
    <div class="position-relative">
      <div class="img_container alphabet-img position-absolute"></div>
    </div>
    <div class="spacer" />
    <startpage-nav class-name="container" />
    <div class="mb-4 container position-relative">
      <div class="mb-4 info-header shadow rounded">
        <h3>Das Levumi-Testinventar</h3>
      </div>
      <div class="mb-4 d-flex flex-row">
        <b-row>
          <b-col>
            <b-card class="shadow info-text" body-class="info-card">
              <p>
                Unsere Tests bieten Ihnen detaillierte Einblicke in den Wissensstand, die
                Fähigkeiten und den individuellen Lernfortschritt Ihrer Schülerinnen und Schüler.
                Von grundlegenden Kompetenztests bis hin zu spezialisierten Assessments - unsere
                Plattform ermöglicht es Ihnen, den Lernprozess gezielt zu unterstützen und die
                besten Bildungspraktiken zu fördern. Entdecken Sie jetzt die Möglichkeiten und
                bringen Sie Ihren Unterricht auf ein neues Level der Effektivität und
                Individualisierung.
              </p>
            </b-card>
          </b-col>
        </b-row>
      </div>
      <div>
        <b-card class="shadow">
          <tests-app />
        </b-card>
      </div>
      <div v-if="!isLoggedIn" class="my-4">
        <b-card class="shadow" body-class="info-card">
          <p class="text-bold text-left">
            Interessiert? Dann einfach einen
            <strong>kostenfreien Zugang anlegen!</strong>
          </p>
          <hr />
          <register-form />
        </b-card>
      </div>
    </div>
  </div>
</template>
<script>
  import RegisterForm from './register-form.vue'
  import StartpageNav from './startpage-nav.vue'
  import TestsApp from '../../tests/tests-app.vue'
  export default {
    name: 'StartpageTests',
    components: { TestsApp, StartpageNav, RegisterForm },
    props: { isLoggedIn: Boolean },
  }
</script>
