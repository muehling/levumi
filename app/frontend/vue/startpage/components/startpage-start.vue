<template>
  <div>
    <div>
      <div class="container-fluid">
        <section
          id="carousel"
          class="carousel slide carousel-fade"
          data-ride="carousel"
          aria-label="Allgemeine Informationen über Levumi">
          <div class="carousel-inner">
            <section class="carousel-item active" aria-describedby="tab-0">
              <div class="container">
                <div class="flex-fill">
                  <div class="img_container alphabet-img">
                    <p id="tab-0" class="lead m-auto">
                      Levumi - Kompetenzorientierte Lernverlaufsdiagnostik, einfach gemacht!
                    </p>
                  </div>
                </div>
              </div>
            </section>

            <section class="carousel-item" aria-describedby="tab-1">
              <div class="container">
                <div class="flex-fill">
                  <div class="img_container grownups-img">
                    <p id="tab-1" class="lead" style="width: 80%">
                      Durch regelmäßige, kurze Testungen werden Lernzuwächse und Problemfelder
                      sichtbar.
                      <br />
                      Wir bieten aktuell unter anderem Tests zum Lesen, zur Rechtschreibung und für
                      Mathematik an.
                      <br />
                      Wenn es Fördermaterial gibt, so wird Ihnen dieses spezifisch für Ihre
                      Schüler:innen empfohlen.
                      <br />
                      Sie können sich auch Notizen zu den Lernverläufen direkt in Levumi machen!
                      <br />
                      Zusammenarbeit im Team wird effektiv unterstützt: Teilen Sie die Ergebnisse
                      mit Kolleg:innen oder arbeiten Sie zusammen an Ihren Klassen!
                    </p>
                  </div>
                </div>
              </div>
            </section>

            <section class="carousel-item" aria-describedby="tab-2">
              <div class="container">
                <div class="flex-fill">
                  <div class="img_container children-img">
                    <p id="tab-2" class="lead mt-auto ml-auto" style="width: 80%">
                      Levumi unterstützt Regelschullehrkräfte und sonderpädagogische Lehrkräfte bei
                      der Diagnose und Förderung einzelner Schüler:innen sowie der gesamten
                      Schulklasse.
                      <br />
                      Durch eine regelmäßige Testung können Sie den Lernverlauf Ihrer Schüler:innen
                      sichtbar machen und Schwierigkeiten im Lernen frühzeitig erkennen.
                      <br />
                      Die Teilnahme ist kostenfrei und der Schutz der Daten ist ein zentrales
                      Anliegen von Levumi!
                      <br />
                      Alle Daten werden auf Servern der CAU Kiel gespeichert. Außerdem setzen wir
                      Verschlüsselungstechniken zur Anonymisierung der Daten ein.
                      <br />
                    </p>
                  </div>
                </div>
              </div>
            </section>
          </div>
        </section>
        <section class="text-center mt-3" aria-label="Blog, Videobeschreibung und Newsletter">
          <p id="blog-description" class="lead">
            Der
            <a
              href="https://www.levumi-blog.uni-kiel.de"
              aria-describedby="blog-description"
              target="_blank">
              Levumi Blog
            </a>
            unterstützt Sie bei allen Fragen rund um die Plattform und informiert über
            praxisrelevante Forschungsergebnisse .
            <br />
            Das folgende Video stellt Ihnen die Plattform kurz vor.
          </p>
          <div class="embed-responsive embed-responsive-16by9 video-container">
            <iframe
              title="Dieses Video stellt Ihnen die kostenfreie Online-Plattform Levumi vor und gibt Ihnen einen Einblick, inwiefern Sie durch die Arbeit mit Levumi profitieren können."
              class="embed-responsive-item"
              width="560"
              height="315"
              src="https://www.youtube-nocookie.com/embed/-F5cPsnC9IA"
              allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture"
              allowfullscreen></iframe>
          </div>
          <div class="text-center mt-3">
            <p class="lead">Interessiert? Dann einfach einen kostenfreien Zugang anlegen</p>
            <p id="levumi-newsletter" class="lead">
              Neu: Der Levumi-Newsletter hält Sie auf dem Laufenden!
              <a
                href="https://mailman.tu-dortmund.de/mailman/listinfo/levumi.news.fk13"
                target="_blank"
                aria-describedby="levumi-newsletter">
                Jetzt abonnieren
              </a>
            </p>
          </div>
        </section>
      </div>
    </div>
  </div>
</template>
<script>
  export default {
    name: 'StartpageStart',
  }
</script>
