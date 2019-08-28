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

shuffleArray(items)

let current = 0
let result = []

function correct() {
    next(1)
}

function incorrect() {
    next(0)
}

function next(res) {
    current++
    if (current < items.length) {
        result.push({'item': items[current-1].id, 'group': items[current-1].group, 'result': res})
        $('#image').attr('src', media_paths[items[current].path])
    }
    else {
        result.push({'item': items[current-1].id, 'group': items[current-1].group, 'result': res})
        let sum = [0, 0]

        let p_items = []
        let n_items = []
        for (let i = 0; i < result.length; ++i) {
            sum[result[i].group] += result[i].result
            if (result[i].result == 0)
                n_items.push(result[i].item)
            else
                p_items.push(result[i].item)
        }

        let total = lastResult ? sum[0] + sum[1] >= lastResult.views['Übersicht'] ? 1 : -1 : 0

        //Ergebnisse speichern
        saveResults(
            {
                'V1': (sum[0] + sum[1]) / result.length,
                'V2': {'VT': sum[0] / 3, 'KT': sum[1] / 3, 'VG': sum[0] / 3, 'KG': sum[1] / 3},
                },
            {'total': total, 'positive': p_items, 'negative': n_items},
            result,
            function (data) {}
        )

        //Interpretieren des Ergebnis und Anzeigen des Feedbacks
        showFeedback(total, false)
    }
}

//Test starten
$('#testspace').attr('style', "font-family: '" + font_family + "'; font-size: " + font_size*2 + "em" )
$('.btn').attr('style', "font-family: '" + font_family + "'; font-size: 0.5em")
$('#image').attr('src', media_paths[items[current].path])
