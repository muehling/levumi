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
            <img
              src="/images/shared/Levumi-normal_small.png"
              class="mb-3 ml-3"
              alt="Levumi"
              width="48"
              height="48" />
          </span>
        </h1>
      </div>
      <startpage-nav />
      <div class="mb-4">
        <b-card class="shadow" body-class="info-card">
          <b-img
            class="img-bg ml-4 mb-4 float-right shadow"
            :src="require('../../../../assets/images/frontpage/frontpage_2.webp')"
            fluid
            alt="Schüler und Lehrerin im Klassenzimmer" />
          <p></p>
          <p>
            Levumi unterstützt Regelschullehrkräfte und speziell sonderpädagogische Lehrkräfte bei
            der Diagnose und Förderung sowohl auf individueller Basis wie auch für gesamte Klassen.
          </p>
          <p>
            Durch regelmäßige, meist kurze Testungen können Sie den Lernverlauf Ihrer Schülerinnen
            und Schüler sichtbar machen und problematische Entwicklungen frühzeitig erkennen.
          </p>
          <p>
            Die Verwendung ist kostenfrei und der Schutz der Daten ist ein zentrales Anliegen von
            Levumi!
          </p>
          <p>
            Alle Daten werden auf Servern der CAU Kiel gespeichert. Außerdem setzen wir
            Verschlüsselungstechniken zur Anonymisierung der Daten ein.
          </p>
        </b-card>
      </div>
      <div class="mb-4">
        <b-row>
          <b-col v-if="!isLoggedIn" lg="6">
            <register-form />
          </b-col>
          <b-col :class="!isLoggedIn ? 'col-lg-6' : 'col'">
            <b-card class="shadow" body-class="info-card">
              <div class="embed-responsive embed-responsive-16by9 video-container mb-4">
                <video controls>
                  <source :src="require('../../../../assets/levumi_intro.mp4')" type="video/mp4" />
                  Ihr Browser unterstützt leider kein Abspielen von Videos.
                </video>
              </div>
            </b-card>
          </b-col>
        </b-row>
      </div>
      <div class="mb-4">
        <b-card class="shadow" body-class="info-card">
          <b-img
            class="img-bg mr-4 mb-4 float-left shadow"
            :src="require('../../../../assets/images/frontpage/frontpage_5.webp')"
            fluid
            alt="Eine Lehrerin demonstriert ihren Schüler:innen etwas an einer Landkarte" />
          <p>
            Wir bieten aktuell unter anderem Tests zum Lesen, zur Rechtschreibung und für Mathematik
            an. Vorhandenes Fördermaterial wird spezifisch anhand der Testergebnisse empfohlen.
          </p>
          <p>Sie können sich Notizen zu den Lernverläufen direkt in Levumi machen!</p>
          <p>
            Zusammenarbeit im Team wird effektiv unterstützt: Teilen Sie die Ergebnisse mit anderen
            Lehrkräften oder arbeiten Sie zusammen an Ihren Klassen!
          </p>
        </b-card>
      </div>
      <div class="mb-4">
        <b-row>
          <b-col>
            <b-card class="shadow" body-class="info-card">
              <h4><u>Levumi-Blog</u></h4>
              <p id="blog-description" class="">
                Der
                <a
                  href="https://www.levumi-blog.uni-kiel.de"
                  aria-describedby="blog-description"
                  target="_blank">
                  Levumi Blog
                </a>
                unterstützt Sie bei allen Fragen rund um die Plattform und informiert über
                praxisrelevante Forschungsergebnisse.
              </p>
              <p>
                Hier veröffentlichen wir regelmäßig Neuigkeiten zu Tests, Fördermaterialien, Tipps
                zur Bedienung und andere relevante Informationen.
              </p>
            </b-card>
          </b-col>
          <b-col>
            <b-card class="shadow" body-class="info-card">
              <h4><u>Levumi-Newsletter</u></h4>
              <p id="levumi-newsletter" class="">
                Bleiben Sie immer auf dem Laufenden mit unserem Newsletter! Erhalten Sie regelmäßig
                exklusive Updates, Tipps und Neuigkeiten rund um Levumi. Profitieren Sie von
                wertvollen Einblicken und informativen Ressourcen, die speziell auf Ihre Bedürfnisse
                zugeschnitten sind.
              </p>
              <div class="text-left">
                <a
                  class="btn btn-success"
                  href="https://mailman.tu-dortmund.de/mailman/listinfo/levumi.news.fk13"
                  target="_blank"
                  aria-describedby="levumi-newsletter">
                  Jetzt abonnieren
                </a>
              </div>
            </b-card>
          </b-col>
        </b-row>
        <startpage-unis />
        <div class="spacer"></div>
      </div>
    </div>
  </div>
</template>
<script>
  import RegisterForm from './register-form.vue'
  import StartpageNav from './startpage-nav.vue'
  import StartpageUnis from './startpage-unis.vue'
  export default {
    name: 'StartpageStart',
    components: { RegisterForm, StartpageNav, StartpageUnis },
    props: { isLoggedIn: Boolean },
  }
</script>
