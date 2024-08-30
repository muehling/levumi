export const testDefinitions = {
  number_input: {
    label: 'Mathematik',
    description:
      'Für einfache Arithmetik-Aufgaben in der Form <b>2 + 2 = _</b>. Auch Platzhalteraufgaben (<b>2 + _ = 5</b>) sind möglich.',
    renderer: 'v2/render/number_input',
  },
  multiple_choice: {
    label: 'Multiple Choice',
    description:
      'Für Multiple Choice-Tests, wahlweise mit oder ohne Bild. Es sind beliebig viele falsche Antworten möglich.',
    renderer: 'v2/render/multiple_choice',
  },
  audio_images_multiple_choice: {
    label: 'Audio/Bilder',
    description:
      'Für Multiple Choice-Tests. Die Frage wird als Audio-Datei hinterlegt, die Antworten als Bilder dargestellt.',
    renderer: 'v2/render/audio_images_multiple_choice',
  },
}
