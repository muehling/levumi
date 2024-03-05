/*global font_size, font_family, lastResult, saveResults, shuffleArray, startTimer, stopTimer, exit, $*/

let items = [
  {
    id: 'I001',
    itemtext: '8',
    description: '3 + 5 = 8',
    firstNumber: '3',
    secondNumber: '5',
    operation: 1,
    group: 4,
  },
  {
    id: 'I002',
    itemtext: '20',
    description: '10 + 10 = 20',
    firstNumber: '10',
    secondNumber: '10',
    operation: 1,
    group: 2,
  },
  {
    id: 'I003',
    itemtext: '12',
    description: '20 - 8 = 12',
    firstNumber: '20',
    secondNumber: '8',
    operation: 0,
    group: 8,
  },
  {
    id: 'I004',
    itemtext: '4',
    description: '19 - 15 = 4',
    firstNumber: '19',
    secondNumber: '15',
    operation: 0,
    group: 7,
  },
  {
    id: 'I005',
    itemtext: '20',
    description: '2 + 18 = 20',
    firstNumber: '2',
    secondNumber: '18',
    operation: 1,
    group: 3,
  },
  {
    id: 'I006',
    itemtext: '14',
    description: '6 + 8 = 14',
    firstNumber: '6',
    secondNumber: '8',
    operation: 1,
    group: 6,
  },
  {
    id: 'I007',
    itemtext: '7',
    description: '6 + 1 = 7',
    firstNumber: '6',
    secondNumber: '1',
    operation: 1,
    group: 1,
  },
  {
    id: 'I008',
    itemtext: '12',
    description: '7 + 5 = 12',
    firstNumber: '7',
    secondNumber: '5',
    operation: 1,
    group: 5,
  },
  {
    id: 'I009',
    itemtext: '18',
    description: '9 + 9 = 18',
    firstNumber: '9',
    secondNumber: '9',
    operation: 1,
    group: 5,
  },
  {
    id: 'I010',
    itemtext: '20',
    description: '19 + 1 = 20',
    firstNumber: '19',
    secondNumber: '1',
    operation: 1,
    group: 2,
  },
  {
    id: 'I011',
    itemtext: '9',
    description: '11 - 2 = 9',
    firstNumber: '11',
    secondNumber: '2',
    operation: 0,
    group: 8,
  },
  {
    id: 'I012',
    itemtext: '20',
    description: '3 + 17 = 20',
    firstNumber: '3',
    secondNumber: '17',
    operation: 1,
    group: 3,
  },
  {
    id: 'I013',
    itemtext: '16',
    description: '7 + 9 = 16',
    firstNumber: '7',
    secondNumber: '9',
    operation: 1,
    group: 6,
  },
  {
    id: 'I014',
    itemtext: '10',
    description: '18 - 8 = 10',
    firstNumber: '18',
    secondNumber: '8',
    operation: 0,
    group: 7,
  },
]

const dimensions = [
  { id: 1, label: 'Addition ohne Zehnerübergang' },
  { id: 2, label: 'Addition zum nächsten Zehner' },
  { id: 3, label: 'Addition zum nächsten Zehner (1. Summand < 2. Summand)' },
  { id: 4, label: 'Addition ohne Zehnerübergang (1. Summand < 2. Summand)' },
  { id: 5, label: 'Addition mit Zehnerübergang' },
  { id: 6, label: 'Addition mit Zehnerübergang (1. Summand < 2. Summand)' },
  { id: 7, label: 'Subtraktion ohne Zehnerübergang' },
  { id: 8, label: 'Subtraktion mit Zehnerübergang' },
]

let currentTask = -1
let result = []
let demoStep = 3
let trend = undefined
const maxTestDuration = 3 * 60 * 1000 // minutes * seconds * milliseconds

/*##################################################
## display initial demo steps
##################################################*/
const playDemo = () => {
  let title = 'Beispiel'
  let hint =
    'Zum Eingeben der Lösung kannst du sowohl die Tastatur als auch den Ziffernblock benutzen.'
  switch (demoStep) {
    case 3:
      calcWidget.update({ currentTask: '1 + 5' })
      break
    case 2:
      calcWidget.update({ currentTask: '7 - 3' })
      break
    case 1:
      hint = ''
      title = ''
      calcWidget.update({ continueText: 'Weiter' })
      setNextItem()
      timerWidget.startCounter()
  }
  demoStep--
  $('#title').text(title)
  $('#hint').text(hint)
}

const setNextItem = () => {
  currentTask++
  const item = items[currentTask]
  startTimer()
  calcWidget.update({
    currentTask: `${item.firstNumber} ${item.operation ? '+' : '-'} ${item.secondNumber}`,
  })
}

/*##################################################
## store result and display next task
##################################################*/
const next = res => {
  if (demoStep) {
    playDemo()
    return
  }
  const endTaskTimestamp = stopTimer()
  const isCorrect = res === items[currentTask].itemtext ? 1 : 0
  result.push({
    item: items[currentTask].id,
    description: items[currentTask].description,
    result: isCorrect,
    answer: res,
    time: endTaskTimestamp,
    group: items[currentTask].group,
  })
  if (currentTask === items.length - 1 || timerWidget.hasElapsed()) {
    timerWidget.stopCounter()
    save()
    quit()
  } else {
    setNextItem()
  }
}

const quit = () => {
  let src = ''
  if (lastResult === undefined) {
    src = '/images/shared/Levumi-normal.jpg'
  } else if (trend === 1) {
    src = '/images/shared/Levumi-jubelt.gif'
  } else {
    src = '/images/shared/Levumi-liest.gif'
  }
  $('#testspace').html(
    `<div class='end-pic-wrapper'><img id='end-pic' src=${src}/></div><button id='endTest' class='btn btn-lg btn-primary btn-block'>Geschafft!</button>`
  )
  $('#endTest').css({ fontSize, fontFamily: font_family }).on('click', exit)
}

/*##################################################
## save after test is complete
##################################################*/
const save = () => {
  const testDuration = timerWidget.getTotalDuration()
  const wordsPerMinute = (result.length / testDuration).toFixed(0)

  const positiveTotal = result.reduce((acc, item) => (item.result === 1 ? acc + 1 : acc), 0)
  const positiveItems = result.filter(res => res.result === 1).map(res => res.item)
  const negativeItems = result.filter(res => res.result === 0).map(res => res.item)

  trend = lastResult ? (positiveTotal >= lastResult.views['V1'] ? 1 : -1) : 0
  const factor = ((positiveTotal / result.length) * 100).toFixed(1)

  const positiveWithDimensions = dimensions.reduce((acc, dimension) => {
    const d = result
      .filter(res => res.result === 1 && res.group === dimension.id)
      .map(res => `(${res.description})`)
    return `${acc}<strong>${dimension.label}: ${d.length}</strong><hr class='my-0'/>${d.join(
      ', '
    )}<br/></br/>`
  }, '')

  const negativeWithDimensions = dimensions.reduce((acc, dimension) => {
    const d = result
      .filter(res => res.result === 0 && res.group === dimension.id)
      .map(res => `(${res.description})`)
    return `${acc}<strong>${dimension.label}: ${d.length}</strong><hr class='my-0'/>${d.join(
      ', '
    )}<br/></br/>`
  }, '')

  saveResults(
    {
      V1: positiveTotal,
      V2: {
        RGI: positiveWithDimensions,
        FGI: negativeWithDimensions,
        LG: factor,
        LGM: wordsPerMinute,
      },
      V3: {
        SUM: positiveTotal,
        RGI: positiveWithDimensions,
        FGI: negativeWithDimensions,
        LG: factor,
        LGM: wordsPerMinute,
      },
    },
    {
      trend: trend,
      positive: positiveItems,
      negative: negativeItems,
      result_number: result_number,
    },
    result,
    function () {}
  )

  //todo
  // Eingabe für saveResults zusammenklöppeln
  // shuffleItems neu schreiben
}

/*##################################################
## initial styling
##################################################*/
let fontSize = '3em'
switch (font_size) {
  case 2:
    fontSize = '4em'
    break
  case 3:
    fontSize = '4.5em'
    break
}
$('#title, #hint, #timer').css({ fontSize, fontFamily: font_family })

/*##################################################
## init widgets
##################################################*/
const calcWidget = window.useCalculatorWidget({
  submitHandler: result => next(result),
  inputHandler: () => {
    if (demoStep === 1) {
      $('#hint').append(' Keine Fragen mehr? Dann starte den Test.')
      calcWidget.update({ continueText: "Los geht's!" })
    }
  },
})

const timerWidget = window.useTimerWidget({
  // timedOutHandler: quit,
  displayCounter: true,
  duration: maxTestDuration,
})

calcWidget.getElement().appendTo('#calculator')
timerWidget.getElement().appendTo('#timer')

/*##################################################
## randomize items and start test
##################################################*/
let result_number
if (lastResult == undefined) {
  result_number = 1
} else {
  result_number = lastResult.report['result_number'] + 1
  //shuffleItems() // todo die müsste noch saubergemacht und eingebaut werden
  shuffleArray(items)
}
next('')
