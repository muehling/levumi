let items = [
  {
    id: 'I1',
    path: 'vogel1.jpg',
    group: 0,
  },
  {
    id: 'I2',
    path: 'vogel2.jpg',
    group: 0,
  },
  {
    id: 'I3',
    path: 'vogel3.jpg',
    group: 0,
  },
  {
    id: 'I4',
    path: 'katze1.jpg',
    group: 1,
  },
  {
    id: 'I5',
    path: 'katze2.jpg',
    group: 1,
  },
  {
    id: 'I6',
    path: 'katze3.png',
    group: 1,
  },
]

let answers = ['Vogel', 'Nashorn', 'Katze', 'Fahrradklingel']

shuffleArray(items)

let current = 0
let result = []

$('#btn0').on('click', () => next(0))
$('#btn1').on('click', () => next(1))
$('#btn2').on('click', () => next(2))
$('#btn3').on('click', () => next(3))

function next(btn) {
  stopTimer()
  let res = 0
  if (items[current].group == 1 && $('#btn' + btn).html() == 'Katze') {
    res = 1
  }
  if (items[current].group == 0 && $('#btn' + btn).html() == 'Vogel') {
    res = 1
  }
  current++
  if (current < items.length) {
    result.push({
      item: items[current - 1].id,
      group: items[current - 1].group,
      result: res,
      time: stopwatch,
    })
    $('#image').attr('src', media_paths[items[current].path])
    shuffleArray(answers)
    for (let i = 0; i < answers.length; ++i) {
      $('#btn' + i).html(answers[i])
    }
    startTimer()
  } else {
    result.push({ item: items[current - 1].id, group: items[current - 1].group, result: res })
    let sum = [0, 0]

    let p_items = []
    let n_items = []
    for (let i = 0; i < result.length; ++i) {
      sum[result[i].group] += result[i].result
      if (result[i].result == 0) {
        n_items.push(result[i].item)
      } else {
        p_items.push(result[i].item)
      }
    }

    let total = lastResult ? (sum[0] + sum[1] >= lastResult.views['V1'] ? 1 : -1) : 0

    saveResults(
      {
        V1: (sum[0] + sum[1]) / result.length,
        V2: { V: sum[0] / 3, K: sum[1] / 3 },
      },
      { trend: total, positive: p_items, negative: n_items },
      result,
      function (data) {}
    )

    //Anzeigen einer individuellen Feedback-Seite
    $('#testspace').html(
      "<p id='evaluation' margin-top: 3% class='text-center'></p>" +
        "<br /><p class='text-center'>" +
        "<img align='middle' id='levumi' style='width: 250px '/></p><br/><br/><br/>" +
        "<p class='text-center'><button class='btn btn-primary' id='exit-button'>Test beenden</button></p>"
    )
    $('#exit-button').on('click', exit)

    if (lastResult == undefined) {
      $('#levumi').attr('src', '/images/shared/Levumi-normal.jpg')
      $('#evaluation').html('„Nun bist du fertig, du kannst den Test jetzt beenden.“')
    } else if (sum[0] + sum[1] == lastResult.views['Übersicht']) {
      $('#levumi').attr('src', '/images/shared/Levumi-spricht.gif')
      $('#evaluation').html(
        '„Du hast genauso viele Tiere richtig zugeordnet, wie beim letzten Mal.“'
      )
    } else if (sum[0] + sum[1] > lastResult.views['Übersicht']) {
      $('#levumi').attr('src', '/images/shared/Levumi-jubelt.gif')
      $('#evaluation').html('„Gut gemacht, du hast dich verbessert!“')
    } else {
      $('#levumi').attr('src', '/images/shared/Levumi-liest.gif')
      $('#evaluation').html('„Beim letzten Mal hast du mehr Tiere richtig zugeordnet.“')
    }
  }
}

//Test starten
$('#testspace').attr(
  'style',
  "font-family: '" + font_family + "'; font-size: " + font_size * 2 + 'em'
)
$('.btn').attr('style', "font-family: '" + font_family + "'; font-size: 1em")
$('#image').attr('src', media_paths[items[current].path])
shuffleArray(answers)
for (let i = 0; i < answers.length; ++i) $('#btn' + i).html(answers[i])
startTimer()
