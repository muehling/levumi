export const testDefinitions = {
  number_input: {
    label: 'Mathematik',
    description:
      'Für einfache Arithmetik-Aufgaben in der Form (<b>2 + 2 = _</b>). Auch Platzhalteraufgaben (<b>2 + _ = 5</b>) sind möglich.',
    renderer: 'v2/render/number_input',
    csvFieldHelp: [
      'bestimmt, welcher Dimension das Item angehört. Wenn der Test keine Dimensionen enthält, muss diese Spalte leergelassen werden.',
      'enthält die erste Stelle der Aufgabe.',
      'enthalt den Operator.',
      'enthält die zweite Stelle der Aufgabe.',
      'enthält die richtige Antwort.',
      'enthält die Position des Eingabefeldes. Für "echte" Rechenaufgaben ( 1 + 4= _ ) gilt die 3, für Platzhalteraufgaben ( _ + 3 = 5 ) 1 oder ( 3 + _ = 5 ) 2.',
    ],
    demoLine: [`Addition ohne Zehnerübergang;4;+;4;8;3`],
    additionalInfo: [],
    options: [],
  },
  multiple_choice: {
    label: 'Multiple Choice',
    description:
      'Für Multiple Choice-Tests, wahlweise mit oder ohne Bild. Es sind beliebig viele falsche Antworten möglich. Sowohl in der Frage als auch in den Antworten kann HTML verwendet werden.',
    renderer: 'v2/render/multiple_choice',
    csvFieldHelp: [
      'bestimmt, welcher Dimension das Item angehört. Wenn der Test keine Dimensionen enthält, muss diese Spalte leergelassen werden.',
      'enthält (optional) den Dateinamen des Bildes. Der hier eingetragene Name muss zwingend der gleiche wie der der hochgeladenen Bilddatei sein. Für Items ohne Bild bitte leer lassen. Sollen mehrere Bilder für ein Item angezeigt werden, müssen die Einträge durch Kommata OHNE Leerzeichen getrennt werden.',
      'enthält die dargestellte Frage. HTML¹ ist eingeschränkt zulässig.',
      'enthält die richtige Antwort. JSON² ist zulässig.',
      'enthält die falschen Antworten, durch | ohne Leerzeichen voneinander getrennt. Es muss mindestens eine falsche Antwort hinterlegt werden. JSON² ist zulässig.',
    ],
    demoLine: [
      `Säugetiere;bild1.png;Welches Tier siehst du?;Kalb;Maus,Katze,Pferd`,
      `;;<b class='text-danger'>sehen</b>;Ja;Nein|{"text":"Vielleicht", "styles":"btn-danger"}|{"text":"Ich weiß nicht", "styles":"btn-success"}`,
      `5;pb4_bett.png;(Bett, T);{"text":"Hinten","index":3};{"text":"Vorne","index":1}|{"text":"Mitte","index":2}|{"text":"Gar nicht","styles":"btn-danger","index":4}|{"text":"Ich weiß nicht!","styles":"btn-danger","index":5}`,
    ],
    additionalInfo: [
      `1) HTML-Elemente sind zulässig, können aber nur über die Vergabe von Klassen gestylt werden: <span class='text-danger'>Test</span> oder <b>Test</b>.`,
      `2) Für JSON-Objekte sind folgende Keys zulässig: text (dargestellter Text), styles (CSS-Klassennamen), index (Sortierreihenfolge, nur relevant mit der Option "Antworten sortieren").`,
    ],
    options: [
      {
        label: 'Keyboard verwenden',
        id: 'useKeyboard',
        type: 'boolean',
        description:
          'Gedacht für Lehrkräfte-Tests. Wenn angehakt, wird "1" als "richtig" und "0" als "falsch" interpretiert. Nicht kompatibel mit dem Weiter-Knopf.',
      },
      {
        label: 'Antworten randomisieren',
        id: 'randomizeItems',
        type: 'boolean',
        description:
          'Wenn angehakt, werden die Items randomisiert, andernfalls erscheinen sie wie in der CSV definiert. Nicht kompatibel mit "Antworten sortieren"',
      },
      {
        label: 'Antworten sortieren',
        id: 'sortItems',
        type: 'boolean',
        description: 'Wenn angehakt, werden die Antworten alphabetisch sortiert.',
      },
      {
        label: 'Weiter-Knopf anzeigen',
        id: 'showContinue',
        type: 'boolean',
        description:
          'Wenn angehakt, wird ein Weiter-Knopf angezeigt, mit dem es zum nächsten Item geht. Ansonsten geht es direkt mit Klick auf eine Antwort weiter. Nicht kompatibel mit der Keyboard-Option.',
      },
      {
        label: 'Item-Text nicht anzeigen',
        id: 'hideItemText',
        type: 'boolean',
        description:
          'Wenn angehakt, wird der Itemtext nicht angezeigt. Kann in Kombination mit Bildern sinnvoll sein.',
      },
      {
        label: 'Item-Beschreibung',
        id: 'customItemDescription',
        type: 'text',
        description: 'Text, der oberhalb des Items angezeigt wird. HTML kann verwendet werden.',
      },
    ],
  },
  audio_images_multiple_choice: {
    label: 'Audio/Bilder',
    description:
      'Für Multiple Choice-Tests. Die Frage wird als Audio-Datei hinterlegt, die Antworten als anklickbare Bilder dargestellt.',
    renderer: 'v2/render/audio_images_multiple_choice',
    csvFieldHelp: [
      'bestimmt, welcher Dimension das Item angehört. Wenn der Test keine Dimensionen enthält, muss diese Spalte leergelassen werden.',
      'enthält die Frage als Text.',
      'enthält den Namen der Audio-Datei',
      'enthält den Namen des richtigen anzuklickenden Bildes.',
      'enthält die Namen der falschen Bilder, durch Kommata ohne Leerzeichen voneinander getrennt.',
    ],
    demoLine: [`Dimension 1;Satz 6;audio6.mp3;levumi1.gif;bild1.png,bild5.png,bild3.png`],
    additionalInfo: [],
    options: [],
  },
}
