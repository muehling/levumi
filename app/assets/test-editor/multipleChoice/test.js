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

const updateTask = item => {
  const el = window.useMultipleChoice({
    id: item.id,
    styles,
    item,
    resultHandler: next,
  })
  $('#content-container').html(el)
}

const quit = () => {
  let el
  if (window.config.endPage) {
    el = window.useContentPage({
      id: 'end-page',
      styles,
      content: window.config.endPage,
      continueConfig: { text: 'Fertig!', handler: window.exit },
    })
  } else {
    el.window.useEndPage({ styles })
  }
  $('#content-container').html(el)
}

const save = () => {
  const duration = timerWidget.getTotalDuration()
  window.useSaveResult({ result, duration, dimensions: window.config.dimensions })
}

//######################################
//## start test
//######################################
if (window.config.startPage.length !== 0) {
  const el = window.useContentPage({
    id: 'start-page',
    styles,
    content: window.config.startPage,
    continueConfig: {
      text: 'Test starten',
      handler: () => {
        timerWidget.startCounter()
        setNextItem()
      },
    },
  })
  $('#content-container').html(el)
}

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
