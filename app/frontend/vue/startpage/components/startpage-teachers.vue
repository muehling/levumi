<template>
  <div>
    <div class="position-relative">
      <div class="img_container grownups-img position-absolute"></div>
      <div class="fadeout" />
    </div>
    <div class="spacer" />
    <div class="mb-4 container info-text position-relative">
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
        <h3 class="">
          Individualisiertes Lernen ermöglichen: Entdecken Sie die Möglichkeiten unserer Plattform
          für Lernverlaufsdiagnostik
        </h3>
      </div>
      <div class="mb-4">
        <b-row>
          <b-col>
            <b-card class="shadow" body-class="info-card">
              <b-img
                class="img-bg mr-4 mb-4 float-left shadow"
                :src="frontpage3"
                fluid
                alt="Schüler und Lehrerin vor einem Monitor" />
              <p>
                Unsere Plattform ermöglicht es Ihnen, kostenfrei den Lernfortschritt jeder Klasse
                und jedes einzelnen Schülers transparent zu verfolgen. Mit unbegrenzter Klassen- und
                Schülerzahl sowie der Möglichkeit, Klassen mit Kolleginnen und Kollegen zu teilen,
                bieten wir Ihnen die Möglichkeit, effizient mir Ihren Kolleg:innen
                zusammenzuarbeiten.
              </p>
            </b-card>
          </b-col>
        </b-row>
      </div>
      <div class="mb-4">
        <b-row>
          <b-col>
            <b-card class="shadow" body-class="info-card">
              <b-img
                class="img-bg ml-4 mb-4 float-right shadow"
                :src="frontpage4"
                fluid
                alt="Schüler:innen arbeiten an Laptops" />
              <h4><u>Leichter Zugang und Datenschutz</u></h4>
              <p>
                Für Schülerinnen und Schüler ist die Nutzung unserer Plattform denkbar einfach: sie
                können sich per QR-Codes einloggen und haben dann Zugriff auf die für sie
                freigeschalteten Tests. Darüber hinaus bieten wir umfassendes Fördermaterial, das es
                Ihnen ermöglicht, individuell auf die Bedürfnisse Ihrer Schülerinnen und Schüler
                einzugehen und ihren Lernprozess gezielt zu unterstützen.
              </p>
              <p>
                Ein wichtiger Aspekt, dem wir besondere Aufmerksamkeit widmen, ist der Datenschutz:
                Die Verschlüsselung der Schülernamen gewährleistet höchste Sicherheit und
                Vertraulichkeit. Sie können sich darauf verlassen, dass die Daten Ihrer Schülerinnen
                und Schüler bei uns in sicheren Händen sind.
              </p>
            </b-card>
          </b-col>
        </b-row>
      </div>

      <div v-if="!isLoggedIn" class="mb-4">
        <register-form />
      </div>
    </div>
  </div>
</template>
<script>
  import StartpageNav from './startpage-nav.vue'
  import RegisterForm from './register-form.vue'
  import levumiSmallSrc from '../../../../assets/images/shared/Levumi-normal_small.png'
  import frontpage3Src from '../../../../assets/images/frontpage/frontpage_3.webp'
  import frontpage4Src from '../../../../assets/images/frontpage/frontpage_4.webp'
  export default {
    name: 'StartageTeachers',
    components: { StartpageNav, RegisterForm },
    props: { isLoggedIn: Boolean },
    computed: {
      levumiSmall() {
        return levumiSmallSrc
      },
      frontpage3() {
        return frontpage3Src
      },
      frontpage4() {
        return frontpage4Src
      },
    },
  }
</script>
