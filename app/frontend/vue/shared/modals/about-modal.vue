<template>
  <BModal
    :model-value="store.generalModals.isAboutOpen"
    scrollable
    ok-only
    size="xl"
    title="Über das Projekt"
    @hidden="close">
    <p class="text-justify">
      Die Onlineplattform Levumi ist eine Plattform die Schulpraxis und Forschung verbindet. Sie ist
      kostenlos und mit einem Fokus auf Datenschutz im Unterricht einsetzbar, gleichzeitig wird sie
      für Forschungsprojekte genutzt und anhand der Ergebnisse und anderer aktueller Forschung
      weiterentwickelt.
    </p>
    <p class="text-justify">Ausgewählte Publikationen:</p>
    <ul>
      <li>
        Jungjohann, J., Diehl, K., Mühling, A. & Gebhardt, M. (2018).
        <a
          href="https://www.researchgate.net/publication/328961566_Graphen_der_Lernverlaufsdiagnostik_interpretieren_und_anwenden_-_Leseforderung_mit_der_Onlineverlaufsmessung_Levumi_In_Forschung_Sprache_62_84-91">
          Graphen der Lernverlaufsdiagnostik interpretieren und anwenden – Leseförderung mit der
          Onlineverlaufsmessung Levumi
        </a>
        . Forschung Sprache, 6(2), 84-91.
      </li>
      <li>
        Mühling, A., Gebhardt, M. & Diehl, K. (2017).
        <a href="https://doi.org/10.1007/s00287-017-1069-7">
          Formative Diagnostik durch die Onlineplattform Levumi
        </a>
        . Informatik Spektrum, 40(6), 556-561.
      </li>
      <li>
        Gebhardt, M., Diehl, K. & Mühling, A. (2016).
        <a
          href="https://www.researchgate.net/publication/308720288_Online_Lernverlaufsmessung_fur_alle_SchulerInnen_in_inklusiven_Klassen_wwwLEVUMIde">
          Online Lernverlaufsmessung für alle SchülerInnen in inklusiven Klassen. www.LEVUMI.de
        </a>
        . Zeitschrift für Heilpädagogik, 67(10), 444-454.
      </li>
    </ul>

    <h5>Das Levumi-Team</h5>
    <p>
      Die Seite wird von Prof. Dr. Andreas Mühling und Prof. Dr. Markus Gebhardt betrieben und
      verantwortet.
      <br />
      <br />
      Sven Anderson (Bereich Mathematik)
      <br />
      Morten Bastian (Weiterentwicklung der Plattform)
      <br />
      Jens Beckmann (Weiterentwicklung der Plattform)
      <br />
      Dr. Jana Jungjohann (Betreuung Blog und Bereich Lesen und Rechtschreibung)
      <br />
      Dr. Michael Schurig (Bereich Datenaufbereitung und Analysen)
      <br />
      <br />
      Teile der Plattform wurden als studentische Projekte und Abschlussarbeiten an der CAU Kiel
      realisiert.
    </p>
    <h5>Kooperationspartner aus Forschung und Schulpraxis</h5>
    <h6>Lesen</h6>
    <p>
      Prof. Dr. Kirsten Diehl, Uni Flensburg
      <br />
      Prof. Dr. Katrin Liebers, Universität Leipzig
    </p>

    <h6>Mathematik</h6>
    <p>
      Prof. Dr. Jan Kuhl, TU Dortmund
      <br />
      Prof. Dr. Stefan Ufer, LMU München
      <br />
      Dr. Daniel Sommerhoff, IPN Kiel
      <br />
      Sarah Schulz, TU Dortmund
    </p>

    <h6>Rechtschreibung</h6>
    <p>
      Anne Barwasser, Universität Köln
      <br />
      Rebecca Hüninghake, TU Dortmund
      <br />
      Lisa Mau, Universität Flensburg
      <br />
      Kerstin Nobel, Universität Köln
    </p>

    <h6>Fragebögen</h6>
    <p>
      Prof. Dr. David Scheer, Pädagogische Hochschule Heidelberg
      <br />
      Dr. Michael Schurig, TU Dortmund
      <br />
      Prof. Dr. Carmen Zubriggen, Universität Luxemburg
    </p>
  </BModal>
</template>
<script>
  import { useGlobalStore } from 'src/store/store'

  export default {
    name: 'AboutModal',
    setup() {
      const store = useGlobalStore()
      return { store }
    },

    methods: {
      close() {
        this.store.generalModals.isAboutOpen = false
      },
    },
  }
</script>
