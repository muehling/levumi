var items
var welcomePage
var endPage
var timeLimit = null
var started = false
var timeLeft = true
var indexOfQuestion = 0
var currentChoice
var correctCount = 0
var falseCount = 0
var result = []
var correctItems = []
var falseItems = []
var correctItemsForView = []
var falseItemsForView = []
var startTime
var questionStartTime

// Onclick listener für den Start
$('#startButton').on('click', function () {
  startQuiz()
})

$(document).ready(function () {
  items = config.items
  welcomePage = config.welcome
  endPage = config.end
  timeLimit = config.description.time_limit
  $('#container')
    .css('font-size', font_size + 'rem')
    .css('font-family', font_family)
  if (welcomePage.length != 0) {
    fillContainerWithContent(welcomePage)
  } else {
    $('#welcomeEndPageContainer').show()
  }
})

/**
 * Creates the welcome or the end page depensing on the parameter.
 * @param {any} page Contains the data for the page and therefore determines the content.
 */
function fillContainerWithContent(page) {
  $('#welcomeEndPageContainer').show()
  $('#questionContainer').hide()
  $('#imageContainer').hide()
  $('#welcomeEndPageContainer').html('')
  page.forEach(item => {
    if (item.type == 'image') {
      $('#welcomeEndPageContainer').append("<img id = 'pic' class = 'image'><br><br>")
      $('#pic').attr('src', media_paths[item.image])
    } else {
      $('#welcomeEndPageContainer').append(
        '<' + item.type + " class = 'element'>" + item.text + '</' + item.type + '><br><br>'
      )
    }
  })
}

/**
 * Adds the answerArray property to each question containing an array of the answers. This is used to iterate over it in order to create the buttons.
 */
function buildAnswerArray() {
  items.forEach(element => {
    var answerArray = []
    answerArray.push(element.correct)
    answerArray.push(element.false1)
    if ('false2' in element) {
      answerArray.push(element.false2)
    }
    if ('false3' in element) {
      answerArray.push(element.false3)
    }
    if ('false4' in element) {
      answerArray.push(element.false4)
    }
    if ('false5' in element) {
      answerArray.push(element.false5)
    }
    element['answerArray'] = answerArray
  })
}

/**
 * Shuffles the questions to get a randomized test.
 */
function shuffleItems() {
  for (let i = items.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1))
    ;[items[i], items[j]] = [items[j], items[i]]
  }
}

/**
 * Starts the global timer, that depends on the defined length of the whole test.
 */
function startTimerGlobal() {
  let time = timeLimit * 60000
  setTimeout(() => {
    timeLeft = false
  }, time)
  startTime = Date.now()
}

/**
 * If there are still time and questions left, this function loads all the content of the current question into the DOM.
 * It also randomly swaps the correct answer with another answer so it is in different places for different questions.
 * If there is no time or question left, it will stop the test and show the end page.
 */
function showCurrentQuestion() {
  // Still questions and time left
  if (timeLeft && indexOfQuestion < items.length) {
    var currentQuestion = items[indexOfQuestion]
    // writes the current question to the container
    var splitSentence = currentQuestion.question.split(currentQuestion.correct)
    var start = splitSentence[0]
    var end = splitSentence[1]

    $('#start').html(start)
    $('#word').html('..........').css('text-decoration', 'none')
    $('#end').html(end)

    if (currentQuestion.image != null && currentQuestion.image != '') {
      // Inserts the image into the container if provided.
      $('#imageContainer').html("<img id = 'questionPic' class = 'image' >")
      $('#questionPic').attr('src', media_paths[currentQuestion.image])
      $('#imageContainer').show()
    } else {
      $('#imageContainer').hide()
    }
    $('#buttonContainer').html('')
    var answers = [...currentQuestion.answerArray]
    // Swaps the correct answer with a random answer. This can be implemented differently if wished.
    var correctIndex = Math.floor(Math.random() * answers.length)
    ;[answers[0], answers[correctIndex]] = [answers[correctIndex], answers[0]]
    answers.forEach(function (item, index) {
      $('#buttonContainer').prepend(
        "<div class = 'col-lg-3'><button id = 'button" +
          index +
          "' class = 'answerButton btn btn-default btn-block' >" +
          item +
          '</button></div>'
      )
      $('#button' + index).on('click', function () {
        currentChoice = [index, correctIndex, currentQuestion.id, answers[index]]
        fillInAnswer(item)
      })
    })
    questionStartTime = Date.now()
  } else {
    stopTest()
  }
}

/**
 * Is called when the user clicks on one of the possible answers. It then shows this answer in the gap and underlines it with dots.
 * @param {String} answer
 */
function fillInAnswer(answer) {
  $('#word').html(answer).css('text-decoration', 'underline').css('text-decoration-style', 'dotted')
}

/**
 * Checks if the answer was correct and if so, it raises the correctCounter, else the falseCounter. In any case it increments indexOfQuestion,
 * pushes the item's ID on the corresponding array, pushes the result on the result array and calls showCurrent in order to show the next question.
 */
function checkAnswer() {
  let index = currentChoice[0]
  let correctIndex = currentChoice[1]
  let itemID = currentChoice[2]
  let givenAnswer = currentChoice[3]
  if (index == correctIndex) {
    correctCount++
    correctItems.push(itemID)
    correctItemsForView.push(items[indexOfQuestion].correct)
    result.push({
      item: itemID,
      result: 1,
      group: items[indexOfQuestion].group,
      answer: givenAnswer,
      time: takeQuestionTime(),
    })
  } else {
    falseCount++
    falseItems.push(itemID)
    falseItemsForView.push(items[indexOfQuestion].correct)
    result.push({
      item: itemID,
      result: 0,
      group: items[indexOfQuestion].group,
      answer: givenAnswer,
      time: takeQuestionTime(),
    })
  }
  indexOfQuestion++
  showCurrentQuestion()
}

/**
 * Shows the eng page. It also calls saveResults() which gathers and  uploads all the data for this test.
 */
function stopTest() {
  if (endPage.length == 0) {
    $('#welcomeEndPageContainer').html(
      '<h1>Geschafft!</h1><br><br><br><h3>Um den Test abzuschließen, klicke bitte auf den Button unten.</h3><br><br>'
    )
  } else {
    fillContainerWithContent(endPage)
  }
  $('#welcomeEndPageContainer').show()
  $('#questionContainer').hide()
  $('#imageContainer').hide()
  $('#continueContainer').hide()

  if (lastResult == undefined) {
    $('#levumi').attr('src', '/images/shared/Levumi-normal.jpg')
  } else if (correctCount > lastResult.views['V1']) {
    $('#levumi').attr('src', '/images/shared/Levumi-jubelt.gif')
  } else {
    $('#levumi').attr('src', '/images/shared/Levumi-liest.gif')
  }

  // Data for saveResults
  let correctData =
    '<strong>Anzahl richtig gelöst:</strong> ' +
    correctCount +
    '<hr style="margin-top:0; margin-bottom:0"/>' +
    correctItemsForView
  let falseData =
    '<strong>Anzahl falsch gelöst:</strong> ' +
    falseCount +
    '<hr style="margin-top:0; margin-bottom:0"/>' +
    falseItemsForView
  let correctPercentage = ((correctCount / result.length) * 100).toFixed(1)
  let timeTaken = Date.now() - startTime
  let answersPerMinute = ((correctCount + falseCount) / (timeTaken / 60000)).toFixed(2)
  let trend = lastResult ? (sum >= lastResult.views['V1'] ? 1 : -1) : 0

  saveResults(
    {
      V1: correctCount,
      V2: {
        RI: '' + correctCount + ' von ' + (correctCount + falseCount),
        COR: correctData,
        FAL: falseData,
        KPC: correctPercentage,
        APM: answersPerMinute,
      },
      V3: {
        SUM: correctCount,
        RI: '' + correctCount + ' von ' + (correctCount + falseCount),
        COR: correctData,
        FAL: falseData,
        KPC: correctPercentage,
        APM: answersPerMinute,
      },
    },
    { trend: trend, positive: correctItems, negative: falseItems },
    result,
    function () {}
  )

  $('#buttonContainer').html(
    '<br><br><button id = "endButton"  class ="col-md-4 btn btn-primary">Den Test beenden</button>'
  )
  $('#endButton').on('click', function () {
    exit()
  })
}

/**
 * Measures the time the user took to answer the current question.
 * @returns Returns the time the user took for the current question.
 */
function takeQuestionTime() {
  return Date.now() - questionStartTime
}

/**
 * hides the container for the welcome page.
 */
function hideWelcomePage() {
  $('#welcomeEndPageContainer').html('')
  $('#welcomeEndPageContainer').hide()
}

/**
 * Initiates all neccessary steps for starting the test.
 */
function startQuiz() {
  if (lastResult != undefined) {
    shuffleItems()
  }
  buildAnswerArray()
  hideWelcomePage()
  showCurrentQuestion()
  startTimerGlobal()
  $('#questionContainer').show()
  $('#imageContainer').show()
  $('#continueContainer').show()
  $('#continueButton').on('click', function () {
    checkAnswer()
  })
}
