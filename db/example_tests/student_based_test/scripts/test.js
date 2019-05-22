let items = [
    {
        id: 'I1',
        path: 'vogel1.jpg',
        group: 0
    },
    {
        id: 'I2',
        path: 'vogel2.jpg',
        group: 0
    },
    {
        id: 'I3',
        path: 'vogel3.jpg',
        group: 0
    },
    {
        id: 'I4',
        path: 'katze1.jpg',
        group: 1
    },
    {
        id: 'I5',
        path: 'katze2.jpg',
        group: 1
    },
    {
        id: 'I6',
        path: 'katze3.png',
        group: 1
    }
]

let answers =  ['Vogel', 'Nashorn', 'Katze', 'Fahrradklingel']

function shuffleArray(array) {
    for (let i = array.length - 1; i > 0; i--) {
        const j = Math.floor(Math.random() * (i + 1))
        [array[i], array[j]] = [array[j], array[i]]
    }
}

shuffleArray(items)

let current = 0
let result = []


function next(btn) {
    let res = 0
    if (items[current].group == 1 && $('#btn' + btn).html() == 'Katze')
        res = 1
    if (items[current].group == 0 && $('#btn' + btn).html() == 'Vogel')
        res = 1
    current++
    if (current < items.length) {
        result.push({'item': items[current-1].id, 'group': items[current-1].group, 'result': res})
        $('#image').attr('src', media_paths[items[current].path])
        shuffleArray(answers)
        for (let i = 0; i < answers.length; ++i)
            $('#btn' + i).html(answers[i])
    }
    else {
        result.push({'item': items[current-1].id, 'group': items[current-1].group, 'result': res})
        let sum = [0, 0]
        for (let i = 0; i < result.length; ++i)
            sum[result[i].group] += result[i].result
        saveResults({'Übersicht': (sum[0] + sum[1]) / result.length, 'Detailauswertung': {'Vögel': sum[0] / 3, 'Katzen': sum[1] / 3}}, result)
        //Anzeigen einer individuellen Feedback-Seite
        $('#testspace').html(
            "<p id='evaluation' style='font-family: fibel_nordregular; font-size:60px;margin-top: 3%' class='text-center'></p>" +
            "<br /><p style='font-family: fibel_nordregular; font-size:60px' class='text-center'>" +
            "<img align='middle' id='levumi' style='width: 250px '/></p><br/><br/><br/>" +
            "<p class='text-center'><button class='btn btn-primary' onclick='exit()'>Test beenden</button></p>"
        )

        if (lastResult == -1){
            $('#levumi').attr('src', '/images/shared/Levumi-normal.gif');
            $('#evaluation').html('„Nun bist du fertig, du kannst den Test jetzt beenden.“');
        }
        else if(sum[0]+sum[1]== lastResult){
            $('#levumi').attr('src', '/images/shared/Levumi-spricht.gif');
            $('#evaluation').html('„Du hast genauso viele Tiere richtig zugeordnet, wie beim letzten Mal.“');
        }
        else if(sum[0]+sum[1]> lastResult){
            $('#levumi').attr('src', '/images/shared/Levumi-jubelt.gif');
            $('#evaluation').html('„Gut gemacht, du hast dich verbessert!“');
        }
        else{
            $('#levumi').attr('src', '/images/shared/Levumi-liest.gif');
            $('#evaluation').html('„Beim letzten Mal hast du mehr Tiere richtig zugeordnet.“');
        }
    }
}

//Start-Methode, welche beim Aufrufen der Testseite ausgeführt wird
function start() {
    $('#image').attr('src', media_paths[items[current].path]);
    shuffleArray(answers);
    for (let i = 0; i < answers.length; ++i)
        $('#btn' + i).html(answers[i]);
}

