<template>
  <div class="accordion instructionAccordion" role="tablist">
    <b-card no-body class="mb-1">
      <b-card-header header-tag="header" class="p-1" role="tab">
        <b-button v-b-toggle.accordion-1 block variant="info">
          So erstellen Sie eine CSV-Datei
        </b-button>
      </b-card-header>
      <b-collapse id="accordion-1" accordion="my-accordion" role="tabpanel">
        <b-card-body>
          <b-card-text class="textLeft">
            1. Erstellen Sie ein Spreadsheet-Dokument wie z.B. ein Excel-Dokument.
            <br />
            2. Klicken Sie auf
            <b>Speichern unter/als.</b>
            <br />
            3. Wählen Sie aus der Liste unten das Dateiformat
            <b>.csv</b>
            aus.
            <br />
            4. Geben Sie der Datei einen Namen und speichern Sie sie ab.
            <br />
          </b-card-text>
          <img class="instructionImage" src="/images/test-editor/create.png" />
        </b-card-body>
      </b-collapse>
    </b-card>
    <b-card v-if="type === 'multipleChoice'" no-body class="mb-1">
      <b-card-header header-tag="header" class="p-1" role="tab">
        <b-button v-b-toggle.accordion-2 block variant="info">
          So muss die CSV Datei für Multiple Choice Tests aussehen
        </b-button>
      </b-card-header>
      <b-collapse id="accordion-2" accordion="my-accordion" role="tabpanel">
        <b-card-body>
          <b-card-text class="textLeft">
            <h4>Jede Zeile der CSV-Datei besteht aus folgenden 5-9 Einträgen:</h4>
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
            - Die richtige Antwort
            <br />
            <br />
            <b>5. - 9. Spalte</b>
            - Die alternativen Antwortmögllichkeiten. Die erste Antwort muss angegeben werden, die
            anderen vier sind optional.
            <br />
          </b-card-text>
          <img class="instructionImage" src="/images/test-editor/multipleChoice.png" />
        </b-card-body>
      </b-collapse>
    </b-card>

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
