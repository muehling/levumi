let items = ['I1', 'I2'];
let pics = ['vogel.jpg', 'katze.jpg'];

let current = 0;
let result = [];

function correct() {
    next(true);
}

function incorrect() {
    next(false);
}

function next(last) {
    current++;
    if (current < items.length) {
        result = result + [{'item': items[current-1], 'res': last}]
        $('#image').attr('src', media_paths[pics[current]]);
    }
    else {
        saveResults(result);
        exit();
    }
}

$('#image').attr('src', media_paths[pics[current]]);


