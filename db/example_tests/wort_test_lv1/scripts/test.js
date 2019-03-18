let items = [
    {
        id: 'I1',
        itemtext: 'ma',
    },
    {
        id: 'I2',
        itemtext: 'Mu',
    },
    {
        id: 'I3',
        itemtext: 'le',
    },
    {
        id: 'I4',
        itemtext: 'mi',
    },
    {
        id: 'I5',
        itemtext: 'La',
    },
    {
        id: 'I6',
        itemtext: 'Mo',
    },
    {
        id: 'I7',
        itemtext: 'lu',
    },
    {
        id: 'I8',
        itemtext: 'Lo',
    },
    {
        id: 'I9',
        itemtext: 'me',
    },
    {
        id: 'I10',
        itemtext: 'li',
    },
    {
        id: 'I11',
        itemtext: 'lo',
    },
    {
        id: 'I12',
        itemtext: 'Ma',
    },
    {
        id: 'I13',
        itemtext: 'mo',
    },
    {
        id: 'I14',
        itemtext: 'Li',
    },
    {
        id: 'I15',
        itemtext: 'Lu',
    },
    {
        id: 'I16',
        itemtext: 'Me',
    },
    {
        id: 'I17',
        itemtext: 'mu',
    },
    {
        id: 'I18',
        itemtext: 'Mi',
    },
    {
        id: 'I19',
        itemtext: 'Le',
    },
    {
        id: 'I20',
        itemtext: 'la',
    }
];

function shuffleArray(array) {
    for (let i = array.length - 1; i > 0; i--) {
        const j = Math.floor(Math.random() * (i + 1));
        [array[i], array[j]] = [array[j], array[i]];
    }
}

shuffleArray(items);

let current = -1;
let result = [];

function cButtonClick() {
    if(current==-1){
        $('#itemtext').css('font-size',(parseInt($('#itemtext').css('font-size')) + 10) + 'px');
    }
    else{
        next(1)
    }


}
function iButtonClick() {
    if(current==-1){
        $('#itemtext').css('font-size',(parseInt($('#itemtext').css('font-size')) - 10) + 'px');
    }
    else {
        next(0)
    }
}
function sButtonClick() {
    next(-1)
}
let timedout = false;
function next(res) {
    console.log(result);
    current++;
    document.activeElement.blur();
    if(res==-1){
        $('#cButton').removeClass('btn-default');
        $('#cButton').addClass('btn-success');
        $('#iButton').removeClass('btn-default');
        $('#iButton').addClass('btn-danger');
        $('#sButton').prop('disabled',true);
        $('#itemtext').html(items[current].itemtext);
        startTimer();
        setTimeout(function () {
            timedout = true;
        }, 60000)
    }
    else{
        if (current < items.length&&!timedout) {
            result.push({'item': items[current-1].id, 'result': res, 'time': stopTimer()});
            $('#itemtext').html(items[current].itemtext);
            startTimer();
        }
        else {
            result.push({'item': items[current-1].id, 'result': res, 'time': stopTimer()});
            let sum = 0;
            for (let i = 0; i < result.length; ++i)
                sum += result[i].result;
            let factor = sum / result.length;
            for(let i = current;i<items.length;i++){
                result.push({'item': items[current-1].id, 'result': 'NA', 'time': 'NA'});
            }
            saveResults({'Übersicht': factor},  result);
            if(lastResult==-1){
                $('#pic').attr('src', '/images/shared/Levumi-normal-blau.jpg')
            }
            else if(sum>= lastResult){
                $('#pic').attr('src', '/images/shared/Levumi-jubelt.gif')
            }
            else{
                $('#pic').attr('src', '/images/shared/Levumi-weiterlesen.gif')
            }
            $('#pic').css('width', '300px');
            $(window).unbind('keydown');
            $('#cButton').hide();
            $('#iButton').hide();
            $('#sButton').hide();
            if (timedout)
                $('#itemtext').html('Zeit abgelaufen.<br/>Die Testergebnisse wurden geschickt!<br/>Sie können das Testfenster' +
                    ' nun schließen.<br/><br/><button class="btn btn-warning btn-lg " onclick="exit()">Fenster schließen!</button>')
                    .css('font-size', '40px')
                    .css('margin-top','0%');
            else
                $('#itemtext').html('Alle Items beantwortet.<br/>Die Testergebnisse wurden geschickt!<br/>Sie können' +
                    ' das Testfenster nun schließen.<br/><br/><button class="btn btn-warning btn-lg " onclick="exit()">Fenster schließen!</button>')
                    .css('font-size', '40px')
                    .css('margin-top','0%');
        }
    }
}

$(window).keydown(function(event) {
    switch (event.keyCode) {
        case 49:
        case 97:
            cButtonClick();
            break;
        case 48:
        case 96:
            iButtonClick();
            break;
    }
});

function checkResult() {
    if (lastResult >= 0 && lastResult < total)
        $('#pic').attr('src', '/images/shared/Levumi-jubelt.gif');
    else if(lastResult == -1)
        $('#pic').attr('src', '/images/shared/Levumi-normal-blau.jpg');
    else
        $('#pic').attr('src', '/images/shared/Levumi-weiterlesen.gif');
    if (false)
        $('#status').html('Zeit abgelaufen.<br/>Die Testergebnisse wurden geschickt!<br/>Sie können das Testfenster nun schließen.');
    else
        $('#status').html('Alle Items beantwortet.<br/>Die Testergebnisse wurden geschickt!<br/>Sie können das Testfenster nun schließen.');
}




