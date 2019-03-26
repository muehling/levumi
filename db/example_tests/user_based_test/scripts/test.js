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

function shuffleArray(array) {
    for (let i = array.length - 1; i > 0; i--) {
        const j = Math.floor(Math.random() * (i + 1));
        [array[i], array[j]] = [array[j], array[i]];
    }
}

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
        saveResults({'Übersicht': (sum[0] + sum[1]) / result.length, 'Detailauswertung': {'Vögel': sum[0] / 3, 'Katzen': sum[1] / 3}}, result);
        $('#testspace').html("<button class='btn btn-primary onclick='exit()'>Test beenden</button>");
    }
}

$('#image').attr('src', media_paths[items[current].path]);


