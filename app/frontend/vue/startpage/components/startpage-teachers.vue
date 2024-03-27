<template>
  <div>
    <div class="position-relative">
      <div class="img_container grownups-img position-absolute"></div>
      <div class="fadeout" />
    </div>
    <div class="spacer" />
    <startpage-nav class-name="container" />
    <div class="mb-4 container info-text position-relative">
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
                :src="require('../../../../assets/images/frontpage/frontpage_3.webp')"
                fluid
                alt="Schüler und Lehrerin vor einem Monitor" />
              <p>
                Willkommen auf unserer Plattform, die transparenten Einblick in den Lernfortschritt
                Ihrer Schülerinnen und Schüler bietet - und das kostenfrei! Unsere Plattform
                ermöglicht es Ihnen, den Lernfortschritt jeder Klasse und jedes einzelnen Schülers
                transparent zu verfolgen, ohne dabei in finanzielle Hürden zu stoßen. Mit
                unbegrenzter Klassen- und Schülerzahl sowie der Möglichkeit, Klassen mit Kolleginnen
                und Kollegen zu teilen, bieten wir Ihnen die Flexibilität und Zusammenarbeit, die
                Sie benötigen, um erfolgreich zu sein.
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
                :src="require('../../../../assets/images/frontpage/frontpage_4.webp')"
                fluid
                alt="Schüler:innen arbeiten an Laptops" />
              <h4><u>Leichter Zugang und Datenschutz</u></h4>
              <p>
                Die einfache Handhabung für Schülerinnen und Schüler ist ein weiteres Highlight
                unserer Plattform: Durch die Nutzung eines QR-Codes wird der Zugang zu den Tests und
                Materialien spielend einfach. Darüber hinaus bieten wir umfassendes Fördermaterial,
                das es Ihnen ermöglicht, individuell auf die Bedürfnisse Ihrer Schülerinnen und
                Schüler einzugehen und ihren Lernprozess gezielt zu unterstützen.
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
      <div class="mb-4">
        <b-card class="shadow" body-class="info-card">
          <div>
            <h4><u>Tools für maßgeschneidertes Lernen</u></h4>
            Unsere Plattform stellt Ihnen eine Vielzahl von Tools und Ressourcen zur Verfügung, die
            es Ihnen ermöglichen, den Unterricht maßzuschneidern und gezielt auf die Bedürfnisse
            jedes einzelnen Schülers einzugehen. Von der Analyse von Lernkurven bis hin zur
            Identifizierung von Lücken im Verständnis - unsere Tools unterstützen Sie dabei, den
            Unterricht so zu gestalten, dass jeder Schüler sein volles Potenzial entfalten kann. Wir
            laden Sie ein, unsere Plattform zu erkunden und zu erfahren, wie Sie den Lernfortschritt
            Ihrer Schülerinnen und Schüler nachhaltig verbessern können.
          </div>
        </b-card>
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
  export default {
    name: 'StartageTeachers',
    components: { StartpageNav, RegisterForm },
    props: { isLoggedIn: Boolean },
  }
</script>
