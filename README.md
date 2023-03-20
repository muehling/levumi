# README

## Dokumentation Testschnittstelle

Die Testschnittstelle stellt Javascript-Funktionen bereit um durchgeführte Tests in Levumi zu speichern.
Außerdem werden einige Hilfsfunktionen für die Testdurchführung bereitgestellt, die verwendet werden können.
Die Funktion saveResults() muss am Ende der Testung aufgerufen werden, um die Daten zu speichen.
Mit der Funktion exit() wird die Testdurchführung beendet und eine Weiterleitung an Levumi veranlasst.
Alle anderen Funktionen sind optional.

#### function saveResults(views, report, data, callback)

##### views - Ergebnisse des Tests für Darstellung in Levumi aufbereitet

    Hash mit genau einem Eintrag pro definierter "View" des Tests (vgl. test.json - configuration/views).
    Key des entsprechenden Eintrags muss mit dem Wert für "label" des Views übereinstimmen.
    Die Daten die unter diesem Key gespeichert werden, werden unverändert für die Anzeige in Graph oder Tabelle verwendet.

##### report - Qualitative Aufbereitung für Verarbeitung durch Levumi

    Hash mit drei Einträgen:
    	* trend: 1 / 0 / -1 für "Verbesserung", "Keine Änderung" und "Verschlechterung", aus Sicht des Tests.
    	* positive: Array mit Shorthand der Items, die in dieser Testung "gut" waren.
    	* negative: Array mit Shorthand der Items, die in dieser Testung "schlecht" waren.

##### data - Rohdaten der Testung für statistische Auswertung

    Array mit genau einem Eintrag pro Item der Testung in der Reihenfolge der Testung
    Eintrag im Array ist ein Hash mit den folgenden Keys und Werten:
    	* item: Shorthand des Items
    	* result: Item-Rohwert (wird in diesem Format exportiert)
    	* (optional) time: Bearbeitungszeit des Items in ms
    	* (optional) answer: Gegebene Antwort
    	* (optional) ...
    Die verwendeten Keys müssen pro Test einheitlich sein und werden als eigene Spalte exportiert.

##### callback

    Zeiger auf parameterlose Funktion, die nach erfolgreichem Speichern der Ergebnisse aufgerufen wird.
    Diese Funktion kann z.B. dafür verwendet werden, den Test final zu beenden.

### function exit()

    Beendet den Testablauf.
    Darf im Falle einer erfolgreichen Testung erst aufgerufen werden, wenn die Messung erfolgreich gespeichert wurd.

### function startTimer()

    Speichert den aktuellen Zeitstempel, kann zusammen mit stopTimer() zur Zeitmessung verwendet werden.

### function stopTimer()

    Gibt die Differenz zwischen dem vorher gespeicherten Zeitstempel und der aktuellen Zeit zurück.

### function shuffleArray(array)

    Ordnet die Elemente des übergebenen Arrays zufällig neu an. Mutiert das übergebene Array!

### function showFeedback(result, timedout)

    Zeigt eine generische Ergebnisseite, die durch die Werte von result und timedout gestaltet wird.
        * result: -1, falls das aktuelle Ergebnis eine Verschlechterung darstellt, 0 falls keine Änderung erfolgt ist und 1, falls eine Verbesserung zur letzten Messung vorliegt.
        * timedout: true, falls das Ende des Tests durch ein Ablaufen der Zeit eingetreten ist, false falls alle Items bearbeitet wurden.

## Dokumentation Tests

Tests werden als einzelne Zip-Datei bereitgestellt, die alle notwendigen Informationen beinhalten.
Aus der Datei werden die entsprechenden Einträge in Levumi erzeugt um den Test durchzuführen.

### Verzeichnisstruktur

Im Hauptverzeichnis der Zip-Datei müssen sich zwei Dateien befinden:

    * test.json - Konfigurationsdatei des Tests
    * test.html - Hauptseite des Test, die bei der Durchführung angezeigt wird.

Darüberhinaus dürfen vier Unterverzeichnisse existieren. Alle dort existierenden Dateien werden bei der Testdurchführung zur Verfügung gestellt.

    *media - Hier sollen alle Arten von Mediendateien gespeichert werden (Bilder, Audio, Video)
    *info - Alle Dateien, die hier enthalten sind, werden in der DB abgelegt, und in der Testübersicht beim zugehörigen Test angezeigt. Bilder werden direkt abgebildet, alle anderen Datein werden als Download-Link dargestellt.
    *scripts - Hier sollen ggf. notwendige Javascript-Dateien gespeichert werden.
    *styles - Hier können eigene CSS-Dateien abgelegt werden.

### Struktur von test.html

Der Inhalt der Datei wird bei der Testausführung in eine HTML-Seite eingebettet.
Die Datei darf daher kein vollständiges, valides HTML-Dokument enthalten, sondern muss lediglich eine valide HTML-Struktur aufweisen.
Der Inhalt wird innerhalb des <body> Bereichs in ein <div> Block eingefügt.
Zur Darstellung und für den Testablauf sind Bootstrap und jQuery verfügbar.

Außerdem kann neben den oben beschriebenen Javascript Funktionen auf die folgenden Javascript-Variablen zugegriffen werden:

    *font_family: CSS-Name der für dieses Kind bevorzugten Schriftart (sind alle verfügbar).
    *font_size: Ein Wert zwischen 1 und 3, der die bevorzugte Schriftgröße des Kindes angibt (normal, größer, sehr groß). Muss vom Test selbstständig in sinnvolle Größenangaben umgerechnet werden.
    *media_paths: Hash der alle Dateien aus dem Unterverzeichnis 'media' beinhaltet. Jeder Eintrag hat als Key den Dateinamen aus der ZIP-Datei und als Wert den Pfad zur Datei auf dem Server.
    *last_result: Das im letzten Testdurchgang gespeicherte Objekt des Kindes. Enthält die keys 'views', 'report' und 'data', wie sie saveResults übergeben wurden.

### Struktur von test.json

In der test.json werden die Metadaten des Tests definiert. Folgende Felder müssen enthalten sein:

- `area`: Text, Bereich des Tests, z. B. "Mathematik Grundlagen"
- `competence`: Text, Testkompetenz, z. B. "Zahlenverständnis"
- `family`: Text, Testfamilie, z. B. "Zahlen lesen"
- `level`: Text, Niveaustufe
- `shorthand`: Text, Kurzbezeichnung, wird u. A. für die Benennung von Exporten verwendet
- `description`: Objekt, Beschreibung des Tests mit folgenden Attributen:
  - `full`: Text, Vollständige Beschreibung. Darf HTML-Tags enthalten.
  - `short`: Text, Kurzbeschreibung
  - `time_limit`: Text, Zeitbeschränkung des Tests
  - `usage`: Text, Hinweise zur Verwendung
- `version`: Zahl, bezeichnet die Testversion
- `student_test`: Zahl, 0 für vom Lehrer bzw. 1 für vom Schüler durchgeführte Tests
- `configuration`: Objekt, Definintion der Auswertungen
  - `views`: Array mit je einem Objekt pro Auswertung. Jedes Objekt muss die folgenden Attribute erhalten:
    - `key`: Eindeutiger Bezeichner
    - `label`: Dargestellte Bezeichnung
    - `student`: Boolean, true, falls Einzelauswertungen angezeigt werden sollen
    - `group`: Boolean, true, falls die Gruppenauswertung angezeigt werden soll
    - `type`: Text, aktuell werden `table`, `bar`, `graph_table` und `graph` unterstützt
    - `column_keys`: Array aus Texten. Die Keys müssen mit den in der test.js an die `saveResults`-Funktion geschickten Keys übereinstimmen.
    - `columns`: Array aus Texten. Spaltenbeschriftungen
    - `series_keys`: Array aus Texten, analog zu `column_keys`
    - `series`: Array aus Texten, analog zu `column`
    - `options`: optional, für `bar` und `graph` können hier ergänzende Optionen für die Darstellung hinterlegt werden. Für die Visualisierung wird das Paket `apexcharts` verwendet. Die Dokumentation findet sich hier: https://apexcharts.com/docs/options/annotations/
- `items`: Objekt mit einem Key/Value-Paar pro Test-Item. Der Key ist dabei die Id des Test-Items in der `test.js`, Value entspricht i. d. R. der `description`

## Dokumentation Fördermaterial
