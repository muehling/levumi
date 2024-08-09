let currentTask = -1
let result = []
let trend = undefined
let isPaused = false
let startTime
const maxTestDuration = window.config.timeLimit * 60 * 1000 // minutes * seconds * milliseconds

let fontSize = '2rem'
switch (window.font_size) {
  case 2:
    fontSize = '3rem'
    break
  case 3:
    fontSize = '3.5rem'
    break
}

const styles = { fontSize, fontFamily: window.font_family }

const rawItems = window.config.items
const items = Object.values(rawItems)

const next = res => {
  console.log('next', res, currentTask, items.length)

  if (isPaused) {
    return
  }
  const endTaskTimestamp = window.stopTimer()
  const isCorrect = res + '' === items[currentTask].correctAnswer + '' ? 1 : 0

  result.push({
    item: items[currentTask].id,
    question: items[currentTask].question,
    result: isCorrect,
    answer: res,
    time: endTaskTimestamp,
    group: items[currentTask].group,
  })
  if (currentTask === items.length - 1 || timerWidget.hasElapsed()) {
    console.log('zu ende')

    timerWidget.stopCounter()
    save()
    quit()
  } else {
    setNextItem()
  }
}

const setNextItem = () => {
  currentTask++
  const item = items[currentTask]

  window.startTimer()
  updateTask(item)
}

const quit = () => {
  if (window.config.endPage.length === 0) {
    let src = ''
    if (window.lastResult === undefined) {
      src = '/images/shared/Levumi-normal.jpg'
    } else if (trend === 1) {
      src = '/images/shared/Levumi-jubelt.gif'
    } else {
      src = '/images/shared/Levumi-liest.gif'
    }
    $('#content-container')
      .html(
        `<div class='end-pic-wrapper text-center' style="background-image: url('${src}')">      
          </div>
          <h1>Geschafft!</h1><br><br><br><h3>Um den Test abzuschließen, klicke bitte auf den Button unten.</h3><br><br>`
      )
      .css(styles)
      .on('click', window.exit)
  } else {
    const el = window.useContentPage({
      id: 'end-page',
      styles,
      content: window.config.endPage,
      continueConfig: { text: 'Fertig!', handler: window.exit },
    })
    $('#content-container').html(el)
  }
  $('#content-container').show()
  $('#start-end-button').html('Fertig!').off('click').on('click', window.exit).show()
  $('#question-container').remove()
  $('#button-container').remove()
}

const save = () => {
  const positive = result.filter(res => res.result === 1)
  const negative = result.filter(res => res.result === 0)

  const positiveDisplay = positive.map(res => `${res.question}, <${res.answer}>`).join(', ')
  const negativeDisplay = negative.map(res => `${res.question} <${res.answer}>`).join(', ')

  let correctData =
    '<strong>Anzahl richtig gelöst:</strong> ' +
    positive.length +
    '<hr style="margin-top:0; margin-bottom:0"/>' +
    positiveDisplay
  let falseData =
    '<strong>Anzahl falsch gelöst:</strong> ' +
    negative.length +
    '<hr style="margin-top:0; margin-bottom:0"/>' +
    negativeDisplay
  let correctPercentage = ((positive.length / result.length) * 100).toFixed(1)
  let timeTaken = Date.now() - startTime
  let answersPerMinute = ((positive.length + negative.length) / (timeTaken / 60000)).toFixed(2)
  let trend = window.lastResult ? (positive.length >= window.lastResult.views['V1'] ? 1 : -1) : 0

  window.saveResults(
    {
      V1: positive.length,
      V2: {
        RI: positive.length + ' von ' + (positive.length + negative.length),
        COR: correctData,
        FAL: falseData,
        KPC: correctPercentage,
        APM: answersPerMinute,
      },
      V3: {
        SUM: positive.length,
        RI: positive.length + ' von ' + (positive.length + negative.length),
        COR: correctData,
        FAL: falseData,
        KPC: correctPercentage,
        APM: answersPerMinute,
      },
    },
    { trend: trend, positive: positiveDisplay, negative: negativeDisplay },
    result,
    function () {}
  )
}
/*const save = () => {
  const testDuration = timerWidget.getTotalDuration()
  const wordsPerMinute = (result.length / testDuration).toFixed(0)

  const positive = result.filter(res => res.result === 1)
  const positiveTotal = positive.length
  const positiveItems = positive.map(res => res.item)
  const positiveQuestions = positive.map(res => `${res.question}, <${res.answer}>}`).join(', ')

  const negative = result.filter(res => res.result === 0)
  const negativeTotal = negative.length
  const negativeItems = negative.map(res => res.item)
  const negativeQuestions = negative.map(res => `${res.question} <${res.answer}>`).join(', ')

  const trend = window.lastResult ? (positiveTotal >= window.lastResult.views['V1'] ? 1 : -1) : 0
  const factor = ((positiveTotal / result.length) * 100).toFixed(1)
  console.log('result', result)

  let correct =
    '<strong>Anzahl richtig gelöster Items:</strong> ' +
    positiveTotal +
    '<hr style="margin-top:0; margin-bottom:0"/>' +
    positiveQuestions
  let wrong =
    '<strong>Anzahl falsch gelöster Items:</strong> ' +
    negativeTotal +
    '<hr style="margin-top:0; margin-bottom:0"/>' +
    negativeQuestions
//'RI', 'COR', 'FAL', 'KPC', 'APM'
  window.saveResults(
    {
      V1: positiveTotal,
      V2: { RI: correct, FGI: wrong, LG: factor, LGM: wordsPerMinute },
      V3: { SUM: positiveTotal, RGI: correct, FGI: wrong, LG: factor, LGM: wordsPerMinute },
    },
    { trend: trend, positive: positiveItems, negative: negativeItems },
    result,
    function () {}
  )
}*/

const updateTask = item => {
  const el = window.useMultipleChoice({
    id: item.id,
    styles,
    item,
    resultHandler: next,
  })
  $('#content-container').html(el)
}

if (window.config.startPage.length !== 0) {
  const el = window.useContentPage({
    id: 'start-page',
    styles,
    content: window.config.startPage,
    continueConfig: {
      text: 'Test starten',
      handler: () => {
        startTime = Date.now()
        setNextItem()
      },
    },
  })
  $('#content-container').html(el)
}

if (window.lastResult !== undefined) {
  window.shuffleArray(items)
}

const handlePause = isTimerPaused => {
  isPaused = isTimerPaused
}

const timerWidget = window.useTimerWidget({
  pauseHandler: handlePause,
  displayCounter: true,
  duration: maxTestDuration,
})

timerWidget.getElement().appendTo('#timer')
timerWidget.getPauseButton().appendTo('#timer')

$('#content-container, #timer, #pause-button').css(styles)
