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
];

shuffleArray(items);

let current = 0;
let result = [];

function correct() {
    next(1);
}

function incorrect() {
    next(0);
}

function next(res) {
    current++;
    if (current < items.length) {
        result.push({'item': items[current-1].id, 'group': items[current-1].group, 'result': res});
        $('#image').attr('src', media_paths[items[current].path]);
    }
    else {
        result.push({'item': items[current-1].id, 'group': items[current-1].group, 'result': res});
        let sum = [0, 0];
        for (let i = 0; i < result.length; ++i)
            sum[result[i].group] += result[i].result;

        //Ergebnisse speichern
        saveResults({'Übersicht': (sum[0] + sum[1]) / result.length, 'Detailauswertung': {'Vögel': sum[0] / 3, 'Katzen': sum[1] / 3}}, result);

        //Interpretieren des Ergebnis und Anzeigen des Feedbacks
        showFeedback(lastResult ? sum[0] + sum[1] >= lastResult['Übersicht'] ? 1 : -1 : 0, false);
    }
}

//Test starten
$('#image').attr('src', media_paths[items[current].path]);

