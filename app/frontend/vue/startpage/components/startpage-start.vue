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
            alt="Generic stock image" />
          <p></p>
          <p>
            Levumi unterstützt Regelschullehrkräfte und sonderpädagogische Lehrkräfte bei der
            Diagnose und Förderung einzelner Schüler:innen sowie der gesamten Schulklasse.
          </p>
          <p>
            Durch eine regelmäßige Testung können Sie den Lernverlauf Ihrer Schüler:innen sichtbar
            machen und Schwierigkeiten im Lernen frühzeitig erkennen.
          </p>
          <p>
            Die Teilnahme ist kostenfrei und der Schutz der Daten ist ein zentrales Anliegen von
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
            <b-card class="shadow" body-class="info-card">
              <p class="text-bold text-left">
                Interessiert? Dann einfach einen
                <strong>kostenfreien Zugang anlegen!</strong>
              </p>
              <hr />
              <register-form />
            </b-card>
          </b-col>
          <b-col :class="!isLoggedIn ? 'col-lg-6' : 'col'">
            <b-card class="shadow" body-class="info-card">
              <div class="embed-responsive embed-responsive-16by9 video-container mb-4">
                <iframe
                  title="Dieses Video stellt Ihnen die kostenfreie Online-Plattform Levumi vor und gibt Ihnen einen Einblick, inwiefern Sie durch die Arbeit mit Levumi profitieren können."
                  class="embed-responsive-item"
                  src="https://www.youtube-nocookie.com/embed/-F5cPsnC9IA"
                  allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture"
                  allowfullscreen></iframe>
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
            alt="Generic stock image" />
          <p>Durch regelmäßige, kurze Testungen werden Lernzuwächse und Problemfelder sichtbar.</p>
          <p>
            Wir bieten aktuell unter anderem Tests zum Lesen, zur Rechtschreibung und für Mathematik
            an. Wenn es Fördermaterial gibt, so wird Ihnen dieses spezifisch für Ihre Schüler:innen
            empfohlen.
          </p>
          <p>Sie können sich auch Notizen zu den Lernverläufen direkt in Levumi machen!</p>
          <p>
            Zusammenarbeit im Team wird effektiv unterstützt: Teilen Sie die Ergebnisse mit
            Kolleg:innen oder arbeiten Sie zusammen an Ihren Klassen!
          </p>
        </b-card>
      </div>
      <div class="mb-4">
        <b-row>
          <b-col>
            <b-card class="shadow" body-class="info-card">
              <h4>Levumi-Blog</h4>
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
              <h4>Levumi-Newsletter</h4>
              <p id="levumi-newsletter" class="">
                Bleiben Sie immer auf dem Laufenden mit unserem Newsletter! Erhalten Sie regelmäßig
                exklusive Updates, Tipps und Neuigkeiten rund um Levumi. Profitieren Sie von
                wertvollen Einblicken, und informativen Ressourcen, die speziell auf Ihre
                Bedürfnisse zugeschnitten sind.
              </p>
              <div class="text-center">
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
        <div class="spacer"></div>
      </div>
    </div>
  </div>
</template>
<script>
  import RegisterForm from './register-form.vue'
  import StartpageNav from './startpage-nav.vue'
  export default {
    name: 'StartpageStart',
    components: { RegisterForm, StartpageNav },
    props: { isLoggedIn: Boolean },
  }
</script>
