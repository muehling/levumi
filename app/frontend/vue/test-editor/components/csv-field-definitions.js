export const fieldDefinitions = {
  multiple_choice: [
    'bestimmt, welcher Dimension das Item angehört. Wenn der Test keine Dimensionen enthält, muss diese Spalte leergelassen werden.',
    'enthält (optional) den Dateinamen des Bildes. Der hier eingetragene Name muss zwingend der gleiche wie der der hochgeladenen Bilddatei sein. Für Items ohne Bild bitte leer lassen. Sollen mehrere Bilder für ein Item angezeigt werden, müssen die Einträge durch Kommata OHNE Leerzeichen getrennt werden.',
    'enthält die dargestellte Frage.',
    'enthält die richtige Antwort.',
    'enthalten falsche Antworten. Für jede gefüllte Spalte wird im Test ein Button generiert. Es sollte mindestens eine falsche Antwort hinterlegt werden.',
  ],
  number_input: [
    'bestimmt, welcher Dimension das Item angehört. Wenn der Test keine Dimensionen enthält, muss diese Spalte leergelassen werden.',
    'enthält die erste statische Stelle der Aufgabe.',
    'enthalt den Operanden.',
    'enthält die zweite statische Stelle der Aufgabe.',
    'enthält die richtige Antwort.',
    'enthält die Position des Eingabefeldes. Für "echte" Rechenaufgaben ( 1 + 4= _ ) gilt die 3, für Platzhalteraufgaben ( _ + 3 = 5 ) 1 oder 2.',
    '',
  ],
}
