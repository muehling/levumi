//Items des Tests
let items = [
    {
        id: 'I1',
        text: 'li'
    },
    {
        id: 'I2',
        text: 'lo'
    },
    {
        id: 'I3',
        text: 'la'
    },
    {
        id: 'I4',
        text: 'lilo'
    },
    {
        id: 'I5',
        text: 'lila'
    },
    {
        id: 'I6',
        text: 'lilola'
    }
];
//Mischt ein Array
function shuffleArray(array) {
    for (let i = array.length - 1; i > 0; i--) {
        const j = Math.floor(Math.random() * (i + 1));
        [array[i], array[j]] = [array[j], array[i]];
    }
}
//Items mischen
shuffleArray(items);

let current = 0;
let result = [];

function correct() {
    next(1);
}

function incorrect() {
    next(0);
}
//Anzeigen des nächsten Items
function next(res) {
    current++;
    //Items vorhanden
    if (current < items.length) {
        result.push({'item': items[current-1].id, 'result': res});
        $('#itemtext').html(items[current].text);

    }
    //letztes Items wurde abgefragt
    else {
        result.push({'item': items[current-1].id, 'result': res});
        let sum = 0;
        for (let i = 0; i < result.length; ++i)
            sum += result[i].result;
        saveResults({'Übersicht': sum / 6}, result);

        //Wie wird das Ergebnis interpretiert + anzeigen der angebotenen Feedback-Seite
        let result_interp = 0;
        let timedout = false;
        if(lastResult==-1){}
        else if(sum>=lastResult)
            result_interp = 1;
        else
            result_interp = -1;
        show_feedback(result_interp, timedout);
    }
}
//Wird ausgeführt, um die erste Seite anzuzeigen
//Hier im Speziellen nach den Elementen zum Verändern der Schriftgröße
function start() {
    $('#testspace').html(
        "<p id='itemtext' style='font-family: fibel_nordregular; margin-top: 10%'></p>" +
        "<br/><button id='correct_button' class='btn btn-outline-success' style='font-size: 1.6em' onclick='correct()'>Korrekt</button>" +
        "<button id='false_button' class='btn btn-outline-danger' style='font-size: 1.6em; margin-left: 2%' onclick='incorrect()'>Falsch</button>"
    );
    $('#itemtext').css('font-size', font_size).html(items[current].text);
}


