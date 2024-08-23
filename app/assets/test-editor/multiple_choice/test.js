let currentTask = -1
let result = []
let isPaused = false
const maxTestDuration = window.config.timeLimit * 60 * 1000 // minutes * seconds * milliseconds
const rawItems = window.config.items
const items = Object.values(rawItems)

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

const next = res => {
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

//TODO demokram rausfummeln

const displayDemoItem = () => {
  const itemIndex = Math.floor(Math.random() * Math.floor(items.length - 1))
  const demoEl = window.useMultipleChoice({ id: 0, styles, item: items[itemIndex] })
  const el = window.useDemoItem({ element: demoEl, continueHandler: endDemo })
  $('#content-container').html(el)
}

const displayFeedback = res => {
  const isCorrect = res + '' === items[currentTask].correctAnswer + '' ? 1 : 0
  const el = window.useFeedback({
    isCorrect: isCorrect,
    correctAnswer: items[currentTask].correctAnswer,
    styles,
    continueHandler: result => next(result),
  })
  $('#content-container').html(el)
}

const updateTask = item => {
  const resultHandler = window.config.options?.show_feedback ? displayFeedback : next

  const el = window.useMultipleChoice({
    id: item.id,
    styles,
    item,
    resultHandler,
  })
  $('#content-container').html(el)
}

const quit = () => {
  const el = window.useEndPage({ config: window.config.endPage, styles })
  $('#content-container').html(el)
}

const save = () => {
  const duration = timerWidget.getTotalDuration()
  window.useSaveResult({ result, duration, dimensions: window.config.dimensions })
}

//######################################
//## start test
//######################################
const el = window.useStartPage({
  styles,
  config: window.config.startPage,
  continueHandler: () => {
    timerWidget.startCounter()
    setNextItem()
  },
})
$('#content-container').html(el)

if (window.lastResult !== undefined) {
  window.shuffleArray(items)
}

//######################################
//## Timer
//######################################
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

//######################################
//## initial styling
//######################################
$('#content-container, #timer, #pause-button').css(styles)
