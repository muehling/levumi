<template>
  <div>
    <div class="position-relative">
      <div class="img_container alphabet-img position-absolute"></div>
    </div>
    <div class="spacer" />
    <div class="mb-4 container position-relative info-text">
      <div class="mb-4 info-header shadow rounded">
        <h1 class="main-header my-4 text-center">
          Herzlich Willkommen bei
          <span class="text-nowrap">
            Levumi!
            <img :src="levumiSmall" class="mb-3 ml-3" alt="Levumi" width="48" height="48" />
          </span>
        </h1>
      </div>
      <startpage-nav />
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
        <register-form />
      </div>
    </div>
  </div>
</template>
<script>
  import RegisterForm from './register-form.vue'
  import StartpageNav from './startpage-nav.vue'
  import TestsApp from '../../tests/tests-app.vue'
  import levumiSmallSrc from '../../../../assets/images/shared/Levumi-normal_small.png'
  export default {
    name: 'StartpageTests',
    components: { TestsApp, StartpageNav, RegisterForm },
    props: { isLoggedIn: Boolean },
    computed: {
      levumiSmall() {
        return levumiSmallSrc
      },
    },
  }
</script>
