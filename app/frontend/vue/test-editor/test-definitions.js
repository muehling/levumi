export const testDefinitions = {
  number_input: {
    label: 'Mathematik',
    description:
      'Für einfache Arithmetik-Aufgaben in der Form (<b>2 + 2 = _</b>). Auch Platzhalteraufgaben (<b>2 + _ = 5</b>) sind möglich.',
    renderer: 'v2/render/number_input',

    csvFieldHelp: [
      'bestimmt, welcher Dimension das Item angehört. Wenn der Test keine Dimensionen enthält, muss diese Spalte leergelassen werden.',
      'enthält die erste statische Stelle der Aufgabe.',
      'enthalt den Operanden.',
      'enthält die zweite statische Stelle der Aufgabe.',
      'enthält die richtige Antwort.',
      'enthält die Position des Eingabefeldes. Für "echte" Rechenaufgaben ( 1 + 4= _ ) gilt die 3, für Platzhalteraufgaben ( _ + 3 = 5 ) 1 oder 2.',
    ],
  },
  multiple_choice: {
    label: 'Multiple Choice',
    description:
      'Für Multiple Choice-Tests, wahlweise mit oder ohne Bild. Es sind beliebig viele falsche Antworten möglich.',
    renderer: 'v2/render/multiple_choice',
    csvFieldHelp: [
      'bestimmt, welcher Dimension das Item angehört. Wenn der Test keine Dimensionen enthält, muss diese Spalte leergelassen werden.',
      'enthält (optional) den Dateinamen des Bildes. Der hier eingetragene Name muss zwingend der gleiche wie der der hochgeladenen Bilddatei sein. Für Items ohne Bild bitte leer lassen. Sollen mehrere Bilder für ein Item angezeigt werden, müssen die Einträge durch Kommata OHNE Leerzeichen getrennt werden.',
      'enthält die dargestellte Frage.',
      'enthält die richtige Antwort.',
      'enthält die falschen Antworten, durch Kommata ohne Leerzeichen voneinander getrennt. Es sollte mindestens eine falsche Antwort hinterlegt werden.',
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
  },
}
