<template>
  <div>
    <div class="position-relative">
      <div class="img_container children-img position-absolute"></div>
    </div>
    <div class="spacer" />
    <div class="mb-4 container info-text position-relative">
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
      <div class="mb-4 info-header shadow rounded">
        <h3>Forschungsmöglichkeiten auf unserer Plattform</h3>
      </div>
      <div class="mb-4">
        <b-card class="shadow" body-class="info-card">
          <b-img
            class="img-bg mr-4 mb-4 float-left shadow"
            :src="require('../../../../assets/images/frontpage/frontpage_7.webp')"
            fluid
            alt="Forschende diskutieren an einem Tisch" />
          <p>
            Levumi basiert auf der Idee Forschungsergebnisse in Form von (digitalen) Diagnostiken
            und Fördermaterialien schnell und unkompliziert der Schulpraxis zur Verfügung zu
            stellen. Umgekehrt möchten wir damit auch Forschenden die Möglichkeit geben, mit der
            Plattform und den Daten zu arbeiten, um evidenzbasierte Verbesserungen von
            Bildungspraktiken zu ermöglichen.
          </p>
        </b-card>
      </div>
      <div class="mb-4">
        <b-card class="shadow" body-class="info-card">
          <b-img
            class="img-bg ml-4 mb-4 float-right shadow"
            :src="require('../../../../assets/images/frontpage/frontpage_8.webp')"
            fluid
            alt="Forschende diskutieren vor einem Whiteboard" />
          <h4><u>Lernverlaufsdiagnostik: Datenanalyse und Testdesign</u></h4>
          <p>
            Für Forschende bietet Levumi die Möglichkeit, Studien durchzuführen und die erhobenen
            Rohdaten, Schüler:innen Merkmale und weitere Daten der Testungen für die eigenen
            Analysen zu exportieren. Auch hier ist der Datenschutz zentral, die Daten sind
            anonymisiert und können gemeinsam mit Lehrkräften erhoben werden, sofern diese auch
            einen Zugang zu Levumi besitzen.
          </p>
          <p>
            Zudem haben Sie durch die offene Struktur die Möglichkeit, eigene Testdesigns zu
            erstellen. Für die Testerstellung werden lediglich grundlegende Kenntnisse in HTML,
            Javascript und CSS benötigt. Für einfache Designs existiert auch ein Editor, der keine
            Programmierkenntnisse erfordert.
          </p>
        </b-card>
      </div>
    </div>
    <div v-if="!isLoggedIn" class="mb-4 container">
      <register-form />
    </div>

    <div class="my-4 container">
      <h3>Ausgewählte Literatur</h3>
    </div>
    <div class="container">
      <b-card class="shadow" body-class="info-card">
        <h4>Einführung und Artikel für die pädagogische Praxis</h4>
        <ul>
          <li>
            Jungjohann, J., Diehl, K., Mühling, A. & Gebhardt, M. (2018). Graphen der
            Lernverlaufsdiagnostik interpretieren und anwenden – Leseförderung mit der
            Onlineverlaufsmessung Levumi. Forschung Sprache, 6(2), 84–91.
            <br />
            <a target="_blank" href="http://dx.doi.org/10.17877/DE290R-19806">Zur Publikation</a>
          </li>
          <li>
            Jungjohann, J., DeVries, J.M., Gebhardt, M. & Mühling, A. (2018) Levumi: A web-based
            curriculum-based measurement to monitor learning progress in inclusive classrooms. In K.
            Miesenberger, G. Kouroupetroglou & P. Penaz (Hrsg.), Computers Helping People with
            Special Needs. 16th International Conference, ICCHP 2018, Linz, Austria, July 2018,
            Proceedings (S. 369–378). Springer.
            <br />
            <a target="_blank" href="https://doi.org/10.1007/978-3-319-94277-3_58">
              Zur Publikation
            </a>
          </li>
          <li>
            Ebenbeck, N., Jungjohann, J., Mühling, A. & Gebhardt, M. (2023). Die
            Bearbeitungs-geschwindigkeit von Kindern mit Lernschwierigkeiten als Grundlage für die
            Testentwicklung von Lernverlaufsdiagnostik. Zeitschrift für Heilpädagogik. 74, 29-37.
            <br />
            <a target="_blank" href="https://doi.org/10.5283/epub.53484">Zur Publikation</a>
          </li>
          <li>
            Jungjohann, J., Diehl, K. & Gebhardt, M. (2022). Datenbasierte Leseförderung im
            (inklusiven) Grundschulunterricht. Eine Umsetzung adaptiver Förderung mit
            Unterrichtsmaterialien und Lernverlaufstests. In S. Blumenthal, Y. Blumenthal & K.
            Mahlau (Hrsg.), Kinder mit Lern- und emotional-sozialen Entwicklungsauffälligkeiten in
            der Schule. Diagnostik – Prävention – Förderung (S. 177–189). Kohlhammer.
          </li>
          <li>
            Jungjohann, J., Bastian, M., Mühling, A., & Gebhardt, M. (2022). Die Sicht von
            Lehrkräften auf die Implementation und den Nutzen von webbasierten Lernverlaufstests.:
            Eine Interviewstudie in inklusiven Grundschulen. In N. Harsch, M. Jungwirth, M. Stein,
            Y. Noltensmeier, & N. Willenberg (Hrsg.), Diversität Digital Denken – The Wider View.:
            Eine Tagung des Zentrums für Lehrerbildung der Westfälischen Wilhelms-Universität
            Münster vom 08. bis 10.09.2021 (S. 405–408). WTM-Verlag.
            <br />
            <a target="_blank" href="https://doi.org/10.37626/GA9783959871785.0.42">
              Zur Publikation
            </a>
          </li>
          <li>
            Anderson, S., Jungjohann, J., Schurig, M. & Gebhardt, M. (2021). Verknüpfung von
            Lernverlaufsdiagnostik und Leseförderung. Die Konstruktionsprinzipien des Leseabenteuers
            „Levumi und Fredro auf Schatzsuche“. In N. Böhme, B. Dreer, H. Hahn, S. Heinecke, G.
            Mannhaupt & S. Tänzer (Hrsg.), Mythen, Widersprüche und Gewissheiten der
            Grundschulforschung (S. 173–179). Springer.
            <br />
            <a target="_blank" href="https://doi.org/10.1007/978-3-658-31737-9_20">
              Zur Publikation
            </a>
          </li>
          <li>
            Jungjohann, J. & Lutz, S. (2021). Schulische Förderpraxis mit und durch
            Lernverlaufsdiagnostik. spuren, 2, 58–62.
            <br />
            <a target="_blank" href="https://doi.org/10.5283/epub.45556">Zur Publikation</a>
          </li>
          <li>
            Jungjohann, J., Bastian, M., Mühling, A. & Gebhardt, M. (2020). Lernentwicklungen
            digital im inklusiven Unterricht diagnostizieren. Anwendungskonzept der webbasierten
            Lernverlaufsdiagnostik www.levumi.de. Computer & Unterricht, 30(117), 35–38.
          </li>
          <li>
            Ebenbeck, N., Jungjohann, J. & Gebhardt, M. (2022). Inklusive Lernverlaufsdiagnostik mit
            der Onlineplattform Levumi. Eine Übersicht für die Praxis. In M. Gebhardt, D. Scheer &
            M. Schurig (Hrsg.), Handbuch der sonderpädagogischen Diagnostik. Grundlagen und Konzepte
            der Statusdiagnostik, Prozessdiagnostik und Förderplanung (S. 783‐792). Regensburg:
            Universitätsbibliothek. https://doi.org/10.5283/epub.53149
            <br />
            <a
              target="_blank"
              href="https://epub.uni-regensburg.de/53391/1/59%20Inklusive%20Lernverlaufsdiagnostik%20mit%20der%20Onlineplattform%20Levumi%20%E2%80%93%20Eine%20%C3%9Cbersicht%20f%C3%BCr%20die%20Praxis.pdf">
              Zur Publikation
            </a>
          </li>
          <li>
            Blumenthal, S., Gebhardt, M., Förster, N. & Souvignier, E. (2022). Internetplattformen
            zur Diagnostik von Lernverläufen von Schülerinnen und Schülern in Deutschland. Ein
            Vergleich der Plattformen Lernlinie, Levumi und quop. Zeitschrift für Heilpädagogik 73
            (4), S. 153-167.
            <br />
            <a
              target="_blank"
              href="https://epub.uni-regensburg.de/52069/1/Blumenthal_2022_Internetplattformen%20zur%20Diagnostik%20von%20Lernverl%C3%A4ufen.pdf">
              Zur Publikation
            </a>
          </li>
          <li>
            Mühling, A., Jungjohann, J. & Gebhardt, M. (2019). Progress Monitoring in Primary
            Education using Levumi: A Case Study. In H. Lane, S. Zvacek & J. Uhomoibhi (Hrsg.),
            CSEDU 2019. Proceedings of the 11th International Conference on Computer Supported
            Education, 2-4 May, 2019, Heraklion, Greece (S. 137-144). SCITEPRESS – Science and
            Technology Publications.
            <br />
            <a
              target="_blank"
              href="https://epub.uni-regensburg.de/43909/1/2019_Mhling_Jungjohann_Gebhardt_ProgressMonitoringinPrimaryEducationusingLevumi.pdf">
              Zur Publikation
            </a>
          </li>
          <li>
            Gebhardt, M., Diehl, K. & Mühling, A. (2016). Online Lernverlaufsmessung für alle
            SchülerInnen in inklusiven Klassen. www.LEVUMI.de. Zeitschrift für Heilpädagogik,
            67(10), 444-454.
            <br />
            <a target="_blank" href="https://epub.uni-regensburg.de/43877/1/Gebhardt_Levumi.pdf">
              Zur Publikation
            </a>
          </li>
        </ul>
      </b-card>
      <b-card class="mt-4 shadow">
        <h4>Methoden und Data Mining</h4>
        <ul>
          <li>
            Jungjohann, J., Schurig, M., & Gebhardt, M. (2023). Classroom effects are as large as
            grade-level effects on curriculum-based measurement maze reading scores of secondary
            school students with and without special educational needs. Journal of Research in
            Reading.
            <a target="_blank" href="https://doi.org/10.1111/1467-9817.12436">Zur Publikation</a>
            <br />
            <a
              target="_blank"
              href="https://onlinelibrary.wiley.com/doi/epdf/10.1111/1467-9817.12436">
              Zur Publikation
            </a>
          </li>
          <li>
            Jungjohann, J., DeVries, J.M., Gebhardt, M. (2023). Measuring Oral Reading Fluency (ORF)
            Computer-Based and Paper-Based: Examining the Mode Effect in Reading Accuracy and
            Reading Fluency. Educ. Sci., 13, 624. https://doi.org/10.3390/educsci13060624
            <br />
            <a
              target="_blank"
              href="https://www.mdpi.com/2227-7102/13/6/624/pdf?version=1687181337">
              Zur Publikation
            </a>
          </li>
          <li>
            Jungjohann, J. (2022). Komplexe Nebensätze, Kohärenz- oder Inferenzbildung: Unterschiede
            im satzübergreifenden Leseverständnis von Jugendlichen mit sonderpädagogischem
            Unterstützungsbedarf im Bereich Sprache. Forschung Sprache, 10(2), 19–33.
            <a target="_blank" href="https://doi.org/10.5283/epub.53198">Zur Publikation</a>
          </li>
          <li>
            Jungjohann, J., Schurig, M. & Gebhardt, M. (2021). Pilotierung von Leseflüssigkeits- und
            Leseverständnistests zur Entwicklung von Instrumenten der Lernverlaufsdiagnostik.
            Ergebnisse einer Längsschnittstudie in der 3ten und 4ten Jahrgangsstufe.
            Vierteljahresschrift für Heilpädagogik und ihre Nachbargebiete Plus, 90, 1–19.
            <a target="_blank" href="https://doi.org/10.2378/vhn2021.art12d">Zur Publikation</a>
          </li>
          <li>
            Anderson, S., Jungjohann, J. & Gebhardt, M. (2020). Effects of using curriculum-based
            measurement (CBM) for progress monitoring in reading and an additive reading instruction
            in second classes. Zeitschrift für Grundschulforschung, 51(1), 151–166.
            <a target="_blank" href="https://doi.org/10.1007/s42278-019-00072-5">Zur Publikation</a>
          </li>
          <li>
            Ebenbeck, N. (2023). Computerized Adaptive Testing in Inclusive Education. University of
            Regensburg
            <br />
            <a
              target="_blank"
              href="https://epub.uni-regensburg.de/54551/1/Ebenbeck%20-%20CAT%20in%20inclusive%20education_Final_26.07.2023.pdf">
              Zur Publikation
            </a>
          </li>
          <li>
            Ebenbeck, N., Gebhardt, M. (2022). Simulating Computerized Adaptive Testing in Special
            Education based on Inclusive Progress Monitoring Data. Frontiers in Education. DOI:
            10.3389/feduc.2022.945733
            <br />
            <a
              target="_blank"
              href="https://www.frontiersin.org/articles/10.3389/feduc.2022.945733/pdf?isPublishedV2=False">
              Zur Publikation
            </a>
          </li>
          <li>
            Schurig, M., Jungjohann, J., & Gebhardt, M. (2021). Minimization of a Short
            Computer-Based Test in Reading. Front. Educ. 6:684595.
            <a target="_blank" href="https://doi.org/10.3389/feduc.2021.684595">Zur Publikation</a>
            <br />
            <a
              target="_blank"
              href="https://www.frontiersin.org/articles/10.3389/feduc.2021.684595/pdf?isPublishedV2=False">
              Zur Publikation
            </a>
          </li>
          <li>
            DeVries, J.M., Kuhn, J.-T., Gebhardt, M. (2020). What Applying Growth Mixture Modeling
            Can Tell Us About Predictors of Number Line Estimation. Journal of Numerical Cognition,
            6(1), 66-82.
            <a target="_blank" href="https://doi.org/10.5964/jnc.v6i1.212">Zur Publikation</a>
          </li>
        </ul>
      </b-card>
    </div>
  </div>
</template>
<script>
  import StartpageNav from './startpage-nav.vue'
  import RegisterForm from './register-form.vue'
  export default {
    name: 'StartpageResearchers',
    components: { StartpageNav, RegisterForm },
    props: { isLoggedIn: Boolean },
  }
</script>
