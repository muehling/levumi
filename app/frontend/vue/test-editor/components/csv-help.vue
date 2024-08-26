<template>
  <div class="accordion instructionAccordion" role="tablist">
    <div v-if="type === 'multiple_choice'" no-body class="mb-1">
      <b-button v-b-toggle.accordion-2 variant="outline-secondary" class="mt-3">
        Hinweise zur CSV-Struktur
      </b-button>

      <b-collapse id="accordion-2" accordion="my-accordion" role="tabpanel">
        <b-card>
          <p class="pt-3">Jede Zeile der CSV-Datei besteht aus folgenden 5-9 Einträgen:</p>
          <p>
            <b>Spalte 1</b>
            bestimmt, welcher Dimension das Item angehört. Wenn der Test keine Dimensionen enthält,
            muss diese Spalte leergelassen werden.
          </p>
          <p>
            <b>Spalte 2</b>
            enthält (optional) den Dateinamen des Bildes. Der hier eingetragene Name muss zwingend
            der gleiche wie der der hochgeladenen Bilddatei sein. Für Items ohne Bild bitte leer
            lassen. Sollen mehrere Bilder für ein Item angezeigt werden, müssen die Einträge durch
            Kommata OHNE Leerzeichen getrennt werden
          </p>
          <p>
            <b>Spalte 3</b>
            enthält die dargestellte Frage.
          </p>
          <p>
            <b>Spalte 4</b>
            enthält die richtige Antwort.
          </p>
          <p>
            <b>Alle weiteren Spalten</b>
            enthalten falsche Antworten. Für jede gefüllte Spalte wird im Test ein Button generiert.
            Es sollte mindestens eine falsche Antwort hinterlegt werden.
          </p>
        </b-card>
      </b-collapse>
    </div>
    <b-card v-if="type === 'trueOrFalse'" no-body class="mb-1">
      <b-card-header header-tag="header" class="p-1" role="tab">
        <b-button v-b-toggle.accordion-3 block variant="info">
          So muss die CSV Datei für Ja/Nein Tests aussehen
        </b-button>
      </b-card-header>
      <b-collapse id="accordion-3" accordion="my-accordion" role="tabpanel">
        <b-card-body>
          <b-card-text class="textLeft">
            <h4>Jede Zeile der CSV-Datei besteht aus folgenden 3-4 Einträgen:</h4>
            <br />
            <b>1. Spalte</b>
            - Bestimmt zu welcher Gruppe eine Frage gehört. Ein Beispiel aus der Mathematik wäre,
            dass Aufgaben mit Zehnerübertrag eine andere Gruppe sind, als welche ohne. Wenn Sie
            nicht differenzieren möchten tragen Sie bitte überall eine 1 ein.
            <br />
            <br />
            <b>2. Spalte</b>
            - Bitte hier den Namen des Bildes angeben falls gewünscht. Der hier eingetragene Name
            muss zwingend der gleiche wie der der hochgeladenen Datei sein.
            <br />
            <br />
            <b>3. Spalte</b>
            - Bitte hier die Frage angeben.
            <br />
            <br />
            <b>4. Spalte</b>
            - Bitte hier die "Ja" oder "Nein" eintragen, jenachdem was zutrifft.
            <br />
          </b-card-text>
          <img class="instructionImage" src="/images/test-editor/trueOrFalse.png" />
        </b-card-body>
      </b-collapse>
    </b-card>

    <b-card v-if="type === 'gapText'" no-body class="mb-1">
      <b-card-header header-tag="header" class="p-1" role="tab">
        <b-button v-b-toggle.accordion-3 block variant="info">
          So muss die CSV Datei für Lückentext Tests aussehen
        </b-button>
      </b-card-header>
      <b-collapse id="accordion-3" accordion="my-accordion" role="tabpanel">
        <b-card-body>
          <b-card-text class="textLeft">
            <h4>Jede Zeile der CSV-Datei besteht aus folgenden 5-9 Einträgen:</h4>
            <br />
            <b>1. Spalte</b>
            - Bestimmt zu welcher Gruppe eine Frage gehört. Ein Beispiel aus der Mathematik wäre,
            dass Aufgaben mit Zehnerübertrag eine andere Gruppe sind, als welche ohne. Wenn Sie
            nicht differenzieren möchten tragen Sie bitte überall eine 1 ein.
            <br />
            <b>2. Spalte</b>
            - Bitte hier den Namen des Bildes angeben falls gewünscht. Der hier eingetragene Name
            muss zwingend der gleiche wie der der hochgeladenen Datei sein.
            <br />
            <b>3. Spalte</b>
            - Bitte hier den ganzen Satz inklusive des gesuchten Wortes angeben.
            <br />
            <b>4. Spalte</b>
            - Das Wort, das gesucht wird. Im Test wird dieses durch eine Lücke ersetzt. Bitte achten
            Sie darauf, dass die Schreibweise die gleich wie im Satz ist.
            <br />
            <b>5. - 9. Spalte</b>
            - Die alternativen Antwortmöglichkeiten. Die erste Antwort muss angegeben werden, die
            anderen vier sind optional.
          </b-card-text>
          <img class="instructionImage" src="/images/test-editor/gapText.png" />
        </b-card-body>
      </b-collapse>
    </b-card>
  </div>
</template>
<script>
  export default {
    name: 'CsvHelp',
    props: { type: String },
  }
</script>
