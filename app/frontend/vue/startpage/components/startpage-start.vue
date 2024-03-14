<template>
  <div>
    <div class="position-relative">
      <div class="img_container alphabet-img position-absolute"></div>
    </div>
    <div class="spacer" />
    <div class="mb-4 container position-relative">
      <div class="mb-4 info-header shadow rounded">
        <h1 class="main-header my-4 text-center">Herzlich Willkommen bei Levumi!</h1>
      </div>
      <div class="mb-4">
        <div class="mb-1">
          <b-row>
            <b-col>
              <router-link class="info-link shadow" to="/lehrkraefte">
                <b-card class="text-center" body-class="info-card primary rounded">
                  <h4 class="card-title font-weight-bold">Für Lehrkräfte</h4>
                </b-card>
              </router-link>
            </b-col>
            <b-col>
              <router-link class="info-link" to="/forschung">
                <b-card class="shadow text-center" body-class="info-card primary rounded">
                  <h4 class="card-title font-weight-bold">Für Forschende</h4>
                </b-card>
              </router-link>
            </b-col>
            <b-col>
              <router-link class="info-link" to="/testinventar">
                <b-card class="shadow text-center" body-class="info-card primary rounded">
                  <h4 class="card-title font-weight-bold">Testinventar</h4>
                </b-card>
              </router-link>
            </b-col>
          </b-row>
        </div>
      </div>
      <div class="mb-4">
        <b-card class="shadow" body-class="info-card">
          <b-img
            class="img-bg ml-4 mb-4 float-right"
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
        <b-card class="shadow" body-class="info-card">
          <div class="embed-responsive embed-responsive-16by9 video-container float-right mb-4">
            <iframe
              title="Dieses Video stellt Ihnen die kostenfreie Online-Plattform Levumi vor und gibt Ihnen einen Einblick, inwiefern Sie durch die Arbeit mit Levumi profitieren können."
              class="embed-responsive-item"
              width="560"
              height="315"
              src="https://www.youtube-nocookie.com/embed/-F5cPsnC9IA"
              allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture"
              allowfullscreen></iframe>
          </div>
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
          <p>Das Video rechts stellt Ihnen die Plattform kurz vor.</p>
        </b-card>
      </div>
      <div class="mb-4">
        <b-card class="shadow" body-class="info-card">
          <b-img
            class="img-bg mr-4 mb-4 float-left"
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
        <b-card class="shadow" body-class="info-card">
          <p v-b-modal.register-modal class="text-bold text-center">
            Interessiert? Dann einfach einen
            <strong>kostenfreien Zugang anlegen!</strong>
          </p>
          <p id="levumi-newsletter" class="text-bold text-center">
            Neu: Der Levumi-Newsletter hält Sie auf dem Laufenden!
            <a
              href="https://mailman.tu-dortmund.de/mailman/listinfo/levumi.news.fk13"
              target="_blank"
              aria-describedby="levumi-newsletter">
              Jetzt abonnieren
            </a>
          </p>
        </b-card>
      </div>
    </div>
  </div>
</template>
<script>
  export default {
    name: 'StartpageStart',
  }
</script>
