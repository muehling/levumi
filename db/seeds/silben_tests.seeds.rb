# -*- encoding : utf-8 -*-
items = %w{
ma
Mu
le
mi
La
Mo
lu
Lo
me
li
lo
Ma
mo
Li
Lu
Me
mu
Mi
Le
la
}

cbmN0 = TestCBM.create(name: "Silben lesen", len: items.size, info: "(c) Dr. Diehl ISER, Uni-Rostock", short_info: "(c) Dr. Diehl ISER, Uni-Rostock", time: 60, subject: "Deutsch", construct: "Leseflüssigkeit", level: "Niveaustufe 0", type_info:"Speed-Test", archive: false, student_access: false)

it = cbmN0.items.build(itemtext: "Preparation", difficulty: 0, itemtype:-1, itemview:"
<div class='modal-content'>
  <div class='modal-header'>
    <button type='button' class='close' data-dismiss='modal' aria-label='Close'><span aria-hidden='true'>&times;</span></button>
    <h4 class='modal-title' id='mainModalHeader'></h4>
  </div>
  <div class='modal-body' id='modalBody'>
    <br/>
    <br/>
    <br/>
    <p style='font-family: fibel_nordregular; font-size:96px' id='itemText' class='text-center'>
      Test
    </p>
    <br/>
    <br/>
    <br/>
  </div>
  <div class='modal-footer' style='text-align: center'>
    <button id='cButton' type='button' class='btn btn-default btn-lg' onclick='cButtonClick()'>Schrift größer (Taste: 1)</button>
    <button id='sButton' type='button' class='btn btn-success' onclick='sButtonClick()'>Test starten</button>
    <button id='iButton' type='button' class='btn btn-default btn-lg' onclick='iButtonClick()'>Schrift kleiner (Taste: 0)</button>
  </div>
</div>
<script>
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
    var tempText = (document.getElementById('itemText'));
    function cButtonClick() {
        curSize=parseInt(tempText.style.fontSize) + 10;
        tempText.style.fontSize = curSize + 'px';
    }
    function iButtonClick() {
        curSize = parseInt(tempText.style.fontSize) - 10;
        tempText.style.fontSize = curSize + 'px';
    }
    function sButtonClick() {
        currentResult = currentResult + '0,';
        $(window).unbind('keydown');
        nextItem();
        timeoutId = window.setTimeout(timedOut, workTime);
    }
    $('#mainModalHeader').html(students[currentStudent]);
</script>")
it.save

items.each do |i|
  it = cbmN0.items.build(itemtext: i, difficulty: 0, itemtype: 0, itemview:"
  <div class='modal-content'>
  <div class='modal-header'>
    <button type='button' class='close' data-dismiss='modal' aria-label='Close'><span aria-hidden='true'>&times;</span></button>
    <h4 class='modal-title' id='mainModalHeader'></h4>
  </div>
  <div class='modal-body' id='modalBody'>
    <br/>
    <br/>
    <br/>
    <p style='font-family: fibel_nordregular; font-size:96px' id='itemText' class='text-center'>"+
      i +
      "</p>
    <br/>
    <br/>
    <br/>
  </div>
  <div class='modal-footer' style='text-align: center'>
    <button id='cButton' type='button' class='btn btn-success btn-lg' onclick='cButtonClick()'>Richtig (Taste: 1)</button>
    <button id='sButton' type='button' class='btn btn-default disabled'>Test starten</button>
    <button id='iButton' type='button' class='btn btn-danger btn-lg' onclick='iButtonClick()'>Falsch (Taste: 0)</button>
  </div>
</div>


<script>
    $(window).keydown(function(event) {
        switch (event.keyCode) {
            case 49:
            case 97:
                $(window).unbind('keydown');
                cButtonClick();
                break;
            case 48:
            case 96:
                $(window).unbind('keydown');
                iButtonClick();
                break;

        }
    });

    var tempText = (document.getElementById('itemText'));
    tempText.style.fontSize = curSize + 'px';

    function cButtonClick() {
        stopwatch = new Date() - stopwatch;
        currentTimes = currentTimes + stopwatch + ',';
        currentResult = currentResult + '1,';
        $(window).unbind('keydown');
        nextItem();
    }

    function iButtonClick() {
        stopwatch = new Date() - stopwatch;
        currentTimes = currentTimes + stopwatch + ',';
        currentResult = currentResult + '0,';
        $(window).unbind('keydown');
        nextItem();
    }
    $('#mainModalHeader').html(students[currentStudent]);
</script>")
  it.save
end

it = cbmN0.items.build(itemtext: "Ende", difficulty: 0, itemtype:1, itemview:"
<div class='modal-content'>
  <div class='modal-header'>
    <button type='button' class='close' data-dismiss='modal' aria-label='Close'><span aria-hidden='true'>&times;</span></button>
    <h4 class='modal-title' id='mainModalHeader'></h4>
  </div>
  <div class='modal-body' id='modalBody'>
    <br/>
    <br/>
    <br/>
    <p class='text-center'>
      <img id='pic' style='width: 250px;'/>
      <br/>
      <br/>
      <br/>
    </p>
    <p class='text-center' style='font-size: 24px' id='status'>
      <br/>
      <br/>
      <br/>
    </p>
    <br/>
    <br/>
    <br/>
  </div>
  <div class='modal-footer' style='text-align: center'>
    <button id='cButton' type='button' class='btn btn-default btn-lg disabled'>Richtig (Taste: 1)</button>
    <button id='sButton' type='button' class='btn btn-default disabled'>Test starten</button>
    <button id='iButton' type='button' class='btn btn-default btn-lg disabled'>Falsch (Taste: 0)</button>
  </div>
</div>


<script>
    var tempPic = (document.getElementById('pic'));
    var tempStatus = (document.getElementById('status'));
    var tempStudentButton = (document.getElementById('btn'+ currentStudent));

    if (lastResults[currentStudent] >= 0 && lastResults[currentStudent] < currentResult.split('1').length)
        tempPic.src = '/images/multiple_used/Levumi-jubelt.gif';
    else if(lastResults[currentStudent] == -1)
        tempPic.src = '/images/multiple_used/Levumi-normal-blau.jpg';
    else
        tempPic.src = '/images/multiple_used/Levumi-weiterlesen.gif';

    if (timedout)
        tempStatus.innerHTML = 'Zeit abgelaufen.<br/>Die Testergebnisse wurden gespeichert!<br/>Sie können das Testfenster nun schließen.';
    else
        tempStatus.innerHTML = 'Alle Items beantwortet.<br/>Die Testergebnisse wurden gespeichert!<br/>Sie können das Testfenster nun schließen.';

    tempStudentButton.classList.add('btn-success')
    $('#mainModalHeader').html(students[currentStudent]);
</script>")
it.save

cbmN0.save


items = %w{
fo
ra
Le
Su
na
Ro
si
Fe
Ni
mu
fu
ri
Sa
no
fa
so
Lu
Ne
Mi
Re
sa
le
Nu
ro
se
Lo
Fa
mi
Se
lu
fe
Ma
Li
me
ni
Ru
ma
Fo
nu
So
la
Mu
Ri
lo
su
Fi
ne
La
Si
Me
ru
Mo
Ra
li
No
re
mo
fi
Fu
Na
}

cbmN1 = TestCBM.create(name: "Silben lesen", len: items.size, info: "(c) Dr. Diehl ISER, Uni-Rostock", short_info: "(c) Dr. Diehl ISER, Uni-Rostock", time: 60, subject: "Deutsch", construct: "Leseflüssigkeit", level: "Niveaustufe 1", type_info:"Speed-Test", archive: false, student_access: false)
it = cbmN1.items.build(itemtext: "Preparation", difficulty: 0, itemtype:-1, itemview:"
<div class='modal-content'>
  <div class='modal-header'>
    <button type='button' class='close' data-dismiss='modal' aria-label='Close'><span aria-hidden='true'>&times;</span></button>
    <h4 class='modal-title' id='mainModalHeader'></h4>
  </div>
  <div class='modal-body' id='modalBody'>
    <br/>
    <br/>
    <br/>
    <p style='font-family: fibel_nordregular; font-size:96px' id='itemText' class='text-center'>
      Test
    </p>
    <br/>
    <br/>
    <br/>
  </div>
  <div class='modal-footer' style='text-align: center'>
    <button id='cButton' type='button' class='btn btn-default btn-lg' onclick='cButtonClick()'>Schrift größer (Taste: 1)</button>
    <button id='sButton' type='button' class='btn btn-success' onclick='sButtonClick()'>Test starten</button>
    <button id='iButton' type='button' class='btn btn-default btn-lg' onclick='iButtonClick()'>Schrift kleiner (Taste: 0)</button>
  </div>
</div>
<script>
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
    var tempText = (document.getElementById('itemText'));
    function cButtonClick() {
        curSize=parseInt(tempText.style.fontSize) + 10;
        tempText.style.fontSize = curSize + 'px';
    }
    function iButtonClick() {
        curSize = parseInt(tempText.style.fontSize) - 10;
        tempText.style.fontSize = curSize + 'px';
    }
    function sButtonClick() {
        currentResult = currentResult + '0,';
        $(window).unbind('keydown');
        nextItem();
        timeoutId = window.setTimeout(timedOut, workTime);
    }
    $('#mainModalHeader').html(students[currentStudent]);
</script>")
it.save

items.each do |i|
  it = cbmN1.items.build(itemtext: i, difficulty: 0, itemtype: 0, itemview:"
  <div class='modal-content'>
  <div class='modal-header'>
    <button type='button' class='close' data-dismiss='modal' aria-label='Close'><span aria-hidden='true'>&times;</span></button>
    <h4 class='modal-title' id='mainModalHeader'></h4>
  </div>
  <div class='modal-body' id='modalBody'>
    <br/>
    <br/>
    <br/>
    <p style='font-family: fibel_nordregular; font-size:96px' id='itemText' class='text-center'>"+
      i +
      "</p>
    <br/>
    <br/>
    <br/>
  </div>
  <div class='modal-footer' style='text-align: center'>
    <button id='cButton' type='button' class='btn btn-success btn-lg' onclick='cButtonClick()'>Richtig (Taste: 1)</button>
    <button id='sButton' type='button' class='btn btn-default disabled'>Test starten</button>
    <button id='iButton' type='button' class='btn btn-danger btn-lg' onclick='iButtonClick()'>Falsch (Taste: 0)</button>
  </div>
</div>


<script>
    $(window).keydown(function(event) {
        switch (event.keyCode) {
            case 49:
            case 97:
                $(window).unbind('keydown');
                cButtonClick();
                break;
            case 48:
            case 96:
                $(window).unbind('keydown');
                iButtonClick();
                break;

        }
    });

    var tempText = (document.getElementById('itemText'));
    tempText.style.fontSize = curSize + 'px';

    function cButtonClick() {
        stopwatch = new Date() - stopwatch;
        currentTimes = currentTimes + stopwatch + ',';
        currentResult = currentResult + '1,';
        $(window).unbind('keydown');
        nextItem();
    }

    function iButtonClick() {
        stopwatch = new Date() - stopwatch;
        currentTimes = currentTimes + stopwatch + ',';
        currentResult = currentResult + '0,';
        $(window).unbind('keydown');
        nextItem();
    }
    $('#mainModalHeader').html(students[currentStudent]);
</script>")
  it.save
end

it = cbmN1.items.build(itemtext: "Ende", difficulty: 0, itemtype:1, itemview:"
<div class='modal-content'>
  <div class='modal-header'>
    <button type='button' class='close' data-dismiss='modal' aria-label='Close'><span aria-hidden='true'>&times;</span></button>
    <h4 class='modal-title' id='mainModalHeader'></h4>
  </div>
  <div class='modal-body' id='modalBody'>
    <br/>
    <br/>
    <br/>
    <p class='text-center'>
      <img id='pic' style='width: 250px;'/>
      <br/>
      <br/>
      <br/>
    </p>
    <p class='text-center' style='font-size: 24px' id='status'>
      <br/>
      <br/>
      <br/>
    </p>
    <br/>
    <br/>
    <br/>
  </div>
  <div class='modal-footer' style='text-align: center'>
    <button id='cButton' type='button' class='btn btn-default btn-lg disabled'>Richtig (Taste: 1)</button>
    <button id='sButton' type='button' class='btn btn-default disabled'>Test starten</button>
    <button id='iButton' type='button' class='btn btn-default btn-lg disabled'>Falsch (Taste: 0)</button>
  </div>
</div>


<script>
    var tempPic = (document.getElementById('pic'));
    var tempStatus = (document.getElementById('status'));
    var tempStudentButton = (document.getElementById('btn'+ currentStudent));

    if (lastResults[currentStudent] >= 0 && lastResults[currentStudent] < currentResult.split('1').length)
        tempPic.src = '/images/multiple_used/Levumi-jubelt.gif';
    else if(lastResults[currentStudent] == -1)
        tempPic.src = '/images/multiple_used/Levumi-normal-blau.jpg';
    else
        tempPic.src = '/images/multiple_used/Levumi-weiterlesen.gif';

    if (timedout)
        tempStatus.innerHTML = 'Zeit abgelaufen.<br/>Die Testergebnisse wurden gespeichert!<br/>Sie können das Testfenster nun schließen.';
    else
        tempStatus.innerHTML = 'Alle Items beantwortet.<br/>Die Testergebnisse wurden gespeichert!<br/>Sie können das Testfenster nun schließen.';

    tempStudentButton.classList.add('btn-success')
    $('#mainModalHeader').html(students[currentStudent]);
</script>")
it.save

cbmN1.save




items = %w{
del
ho
Rei
Wu
nen
pi
en
lei
Tau
sen
fer
men
de
wa
Dau
Ra
Lei
hu
Sau
wei
da
hen
Pi
we
hau
Tei
De
pa
fen
der
Wei
Hu
po
Sei
We
tau
du
fei
Ho
Rau
sei
wu
Da
hei
Po
rau
Wa
Hei
Du
sau
len
rei
Do
ha
tei
Hau
ra
lau
Ha
dei
mer
dau
Pa
tei
do
}

cbmN2a = TestCBM.create(name: "Silben lesen", len: items.size, info: "(c) Dr. Diehl ISER, Uni-Rostock", short_info: "(c) Dr. Diehl ISER, Uni-Rostock", time: 60, subject: "Deutsch", construct: "Leseflüssigkeit", level: "Niveaustufe 2a", type_info:"Speed-Test", archive: false, student_access: false)
it = cbmN2a.items.build(itemtext: "Preparation", difficulty: 0, itemtype:-1, itemview:"
<div class='modal-content'>
  <div class='modal-header'>
    <button type='button' class='close' data-dismiss='modal' aria-label='Close'><span aria-hidden='true'>&times;</span></button>
    <h4 class='modal-title' id='mainModalHeader'></h4>
  </div>
  <div class='modal-body' id='modalBody'>
    <br/>
    <br/>
    <br/>
    <p style='font-family: fibel_nordregular; font-size:96px' id='itemText' class='text-center'>
      Test
    </p>
    <br/>
    <br/>
    <br/>
  </div>
  <div class='modal-footer' style='text-align: center'>
    <button id='cButton' type='button' class='btn btn-default btn-lg' onclick='cButtonClick()'>Schrift größer (Taste: 1)</button>
    <button id='sButton' type='button' class='btn btn-success' onclick='sButtonClick()'>Test starten</button>
    <button id='iButton' type='button' class='btn btn-default btn-lg' onclick='iButtonClick()'>Schrift kleiner (Taste: 0)</button>
  </div>
</div>
<script>
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
    var tempText = (document.getElementById('itemText'));
    function cButtonClick() {
        curSize=parseInt(tempText.style.fontSize) + 10;
        tempText.style.fontSize = curSize + 'px';
    }
    function iButtonClick() {
        curSize = parseInt(tempText.style.fontSize) - 10;
        tempText.style.fontSize = curSize + 'px';
    }
    function sButtonClick() {
        currentResult = currentResult + '0,';
        $(window).unbind('keydown');
        nextItem();
        timeoutId = window.setTimeout(timedOut, workTime);
    }
    $('#mainModalHeader').html(students[currentStudent]);
</script>")
it.save

items.each do |i|
  it = cbmN2a.items.build(itemtext: i, difficulty: 0, itemtype: 0, itemview:"
  <div class='modal-content'>
  <div class='modal-header'>
    <button type='button' class='close' data-dismiss='modal' aria-label='Close'><span aria-hidden='true'>&times;</span></button>
    <h4 class='modal-title' id='mainModalHeader'></h4>
  </div>
  <div class='modal-body' id='modalBody'>
    <br/>
    <br/>
    <br/>
    <p style='font-family: fibel_nordregular; font-size:96px' id='itemText' class='text-center'>"+
      i +
      "</p>
    <br/>
    <br/>
    <br/>
  </div>
  <div class='modal-footer' style='text-align: center'>
    <button id='cButton' type='button' class='btn btn-success btn-lg' onclick='cButtonClick()'>Richtig (Taste: 1)</button>
    <button id='sButton' type='button' class='btn btn-default disabled'>Test starten</button>
    <button id='iButton' type='button' class='btn btn-danger btn-lg' onclick='iButtonClick()'>Falsch (Taste: 0)</button>
  </div>
</div>


<script>
    $(window).keydown(function(event) {
        switch (event.keyCode) {
            case 49:
            case 97:
                $(window).unbind('keydown');
                cButtonClick();
                break;
            case 48:
            case 96:
                $(window).unbind('keydown');
                iButtonClick();
                break;

        }
    });

    var tempText = (document.getElementById('itemText'));
    tempText.style.fontSize = curSize + 'px';

    function cButtonClick() {
        stopwatch = new Date() - stopwatch;
        currentTimes = currentTimes + stopwatch + ',';
        currentResult = currentResult + '1,';
        $(window).unbind('keydown');
        nextItem();
    }

    function iButtonClick() {
        stopwatch = new Date() - stopwatch;
        currentTimes = currentTimes + stopwatch + ',';
        currentResult = currentResult + '0,';
        $(window).unbind('keydown');
        nextItem();
    }
    $('#mainModalHeader').html(students[currentStudent]);
</script>")
  it.save
end

it = cbmN2a.items.build(itemtext: "Ende", difficulty: 0, itemtype:1, itemview:"
<div class='modal-content'>
  <div class='modal-header'>
    <button type='button' class='close' data-dismiss='modal' aria-label='Close'><span aria-hidden='true'>&times;</span></button>
    <h4 class='modal-title' id='mainModalHeader'></h4>
  </div>
  <div class='modal-body' id='modalBody'>
    <br/>
    <br/>
    <br/>
    <p class='text-center'>
      <img id='pic' style='width: 250px;'/>
      <br/>
      <br/>
      <br/>
    </p>
    <p class='text-center' style='font-size: 24px' id='status'>
      <br/>
      <br/>
      <br/>
    </p>
    <br/>
    <br/>
    <br/>
  </div>
  <div class='modal-footer' style='text-align: center'>
    <button id='cButton' type='button' class='btn btn-default btn-lg disabled'>Richtig (Taste: 1)</button>
    <button id='sButton' type='button' class='btn btn-default disabled'>Test starten</button>
    <button id='iButton' type='button' class='btn btn-default btn-lg disabled'>Falsch (Taste: 0)</button>
  </div>
</div>


<script>
    var tempPic = (document.getElementById('pic'));
    var tempStatus = (document.getElementById('status'));
    var tempStudentButton = (document.getElementById('btn'+ currentStudent));

    if (lastResults[currentStudent] >= 0 && lastResults[currentStudent] < currentResult.split('1').length)
        tempPic.src = '/images/multiple_used/Levumi-jubelt.gif';
    else if(lastResults[currentStudent] == -1)
        tempPic.src = '/images/multiple_used/Levumi-normal-blau.jpg';
    else
        tempPic.src = '/images/multiple_used/Levumi-weiterlesen.gif';

    if (timedout)
        tempStatus.innerHTML = 'Zeit abgelaufen.<br/>Die Testergebnisse wurden gespeichert!<br/>Sie können das Testfenster nun schließen.';
    else
        tempStatus.innerHTML = 'Alle Items beantwortet.<br/>Die Testergebnisse wurden gespeichert!<br/>Sie können das Testfenster nun schließen.';

    tempStudentButton.classList.add('btn-success')
    $('#mainModalHeader').html(students[currentStudent]);
</script>")
it.save

cbmN2a.save





items = %w{
Gi
scha
bo
cher
gau
bel
ku
cho
Ka
Schei
chen
Ba
gel
sche
Go
Ke
bi
kei
chu
Schau
ber
Ki
gen
Schu
chei
Bu
kau
Ga
che
schau
Bi
gei
Sche
go
Kei
chau
bu
ki
ga
scho
Ku
Scha
ben
gu
schei
ba
kau
cha
Ko
schu
Bo
ke
Scho
gi
ka
Gu
ko
}

cbmN2b = TestCBM.create(name: "Silben lesen", len: items.size, info: "(c) Dr. Diehl ISER, Uni-Rostock", short_info: "(c) Dr. Diehl ISER, Uni-Rostock", time: 60, subject: "Deutsch", construct: "Leseflüssigkeit", level: "Niveaustufe 2b", type_info:"Speed-Test", archive: false, student_access: false)
it = cbmN2b.items.build(itemtext: "Preparation", difficulty: 0, itemtype:-1, itemview:"
<div class='modal-content'>
  <div class='modal-header'>
    <button type='button' class='close' data-dismiss='modal' aria-label='Close'><span aria-hidden='true'>&times;</span></button>
    <h4 class='modal-title' id='mainModalHeader'></h4>
  </div>
  <div class='modal-body' id='modalBody'>
    <br/>
    <br/>
    <br/>
    <p style='font-family: fibel_nordregular; font-size:96px' id='itemText' class='text-center'>
      Test
    </p>
    <br/>
    <br/>
    <br/>
  </div>
  <div class='modal-footer' style='text-align: center'>
    <button id='cButton' type='button' class='btn btn-default btn-lg' onclick='cButtonClick()'>Schrift größer (Taste: 1)</button>
    <button id='sButton' type='button' class='btn btn-success' onclick='sButtonClick()'>Test starten</button>
    <button id='iButton' type='button' class='btn btn-default btn-lg' onclick='iButtonClick()'>Schrift kleiner (Taste: 0)</button>
  </div>
</div>
<script>
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
    var tempText = (document.getElementById('itemText'));
    function cButtonClick() {
        curSize=parseInt(tempText.style.fontSize) + 10;
        tempText.style.fontSize = curSize + 'px';
    }
    function iButtonClick() {
        curSize = parseInt(tempText.style.fontSize) - 10;
        tempText.style.fontSize = curSize + 'px';
    }
    function sButtonClick() {
        currentResult = currentResult + '0,';
        $(window).unbind('keydown');
        nextItem();
        timeoutId = window.setTimeout(timedOut, workTime);
    }
    $('#mainModalHeader').html(students[currentStudent]);
</script>")
it.save

items.each do |i|
  it = cbmN2b.items.build(itemtext: i, difficulty: 0, itemtype: 0, itemview:"
  <div class='modal-content'>
  <div class='modal-header'>
    <button type='button' class='close' data-dismiss='modal' aria-label='Close'><span aria-hidden='true'>&times;</span></button>
    <h4 class='modal-title' id='mainModalHeader'></h4>
  </div>
  <div class='modal-body' id='modalBody'>
    <br/>
    <br/>
    <br/>
    <p style='font-family: fibel_nordregular; font-size:96px' id='itemText' class='text-center'>"+
      i +
      "</p>
    <br/>
    <br/>
    <br/>
  </div>
  <div class='modal-footer' style='text-align: center'>
    <button id='cButton' type='button' class='btn btn-success btn-lg' onclick='cButtonClick()'>Richtig (Taste: 1)</button>
    <button id='sButton' type='button' class='btn btn-default disabled'>Test starten</button>
    <button id='iButton' type='button' class='btn btn-danger btn-lg' onclick='iButtonClick()'>Falsch (Taste: 0)</button>
  </div>
</div>


<script>
    $(window).keydown(function(event) {
        switch (event.keyCode) {
            case 49:
            case 97:
                $(window).unbind('keydown');
                cButtonClick();
                break;
            case 48:
            case 96:
                $(window).unbind('keydown');
                iButtonClick();
                break;

        }
    });

    var tempText = (document.getElementById('itemText'));
    tempText.style.fontSize = curSize + 'px';

    function cButtonClick() {
        stopwatch = new Date() - stopwatch;
        currentTimes = currentTimes + stopwatch + ',';
        currentResult = currentResult + '1,';
        $(window).unbind('keydown');
        nextItem();
    }

    function iButtonClick() {
        stopwatch = new Date() - stopwatch;
        currentTimes = currentTimes + stopwatch + ',';
        currentResult = currentResult + '0,';
        $(window).unbind('keydown');
        nextItem();
    }
    $('#mainModalHeader').html(students[currentStudent]);
</script>")
  it.save
end

it = cbmN2b.items.build(itemtext: "Ende", difficulty: 0, itemtype:1, itemview:"
<div class='modal-content'>
  <div class='modal-header'>
    <button type='button' class='close' data-dismiss='modal' aria-label='Close'><span aria-hidden='true'>&times;</span></button>
    <h4 class='modal-title' id='mainModalHeader'></h4>
  </div>
  <div class='modal-body' id='modalBody'>
    <br/>
    <br/>
    <br/>
    <p class='text-center'>
      <img id='pic' style='width: 250px;'/>
      <br/>
      <br/>
      <br/>
    </p>
    <p class='text-center' style='font-size: 24px' id='status'>
      <br/>
      <br/>
      <br/>
    </p>
    <br/>
    <br/>
    <br/>
  </div>
  <div class='modal-footer' style='text-align: center'>
    <button id='cButton' type='button' class='btn btn-default btn-lg disabled'>Richtig (Taste: 1)</button>
    <button id='sButton' type='button' class='btn btn-default disabled'>Test starten</button>
    <button id='iButton' type='button' class='btn btn-default btn-lg disabled'>Falsch (Taste: 0)</button>
  </div>
</div>


<script>
    var tempPic = (document.getElementById('pic'));
    var tempStatus = (document.getElementById('status'));
    var tempStudentButton = (document.getElementById('btn'+ currentStudent));

    if (lastResults[currentStudent] >= 0 && lastResults[currentStudent] < currentResult.split('1').length)
        tempPic.src = '/images/multiple_used/Levumi-jubelt.gif';
    else if(lastResults[currentStudent] == -1)
        tempPic.src = '/images/multiple_used/Levumi-normal-blau.jpg';
    else
        tempPic.src = '/images/multiple_used/Levumi-weiterlesen.gif';

    if (timedout)
        tempStatus.innerHTML = 'Zeit abgelaufen.<br/>Die Testergebnisse wurden gespeichert!<br/>Sie können das Testfenster nun schließen.';
    else
        tempStatus.innerHTML = 'Alle Items beantwortet.<br/>Die Testergebnisse wurden gespeichert!<br/>Sie können das Testfenster nun schließen.';

    tempStudentButton.classList.add('btn-success')
    $('#mainModalHeader').html(students[currentStudent]);
</script>")
it.save


cbmN2b.save





items = %w{
schü
beu
Vi
spa
jä
hex
Zö
stau
Qui
ty
auch
Feu
spu
Ze
jo
Stö
quä
ßen
Schö
spei
Zei
stö
Vei
ju
Keu
xi
Py
Stä
Zi
ße
Auch
Jau
schä
qui
Eu
zü
Spi
Vö
Stei
Zä
vei
ßer
Stau
Qua
Spei
ja
Schä
Hex
Zeu
geu
Spa
Schü
Ju
py
zä
Stu
Beu
zau
sta
je
Quä
Ty
Spe
va
Zu
Euch
keu
Za
Vo
neu
Jo
sti
schö
eu
Spä
zei
stä
Spü
zi
feu
Jä
Sto
scheu
vö
Zü
Sti
seu
spä
Ste
Neu
zeu
sto
spi
Ja
euch
spe
qua
Zau
Je
Va
vo
stu
zö
Seu
stei
spü
ste
vi
za
Scheu
jau
Spu
zu
Sta
ze
cheu
}

cbmN3 = TestCBM.create(name: "Silben lesen", len: items.size, info: "(c) Dr. Diehl ISER, Uni-Rostock", short_info: "(c) Dr. Diehl ISER, Uni-Rostock", time: 60, subject: "Deutsch", construct: "Leseflüssigkeit", level: "Niveaustufe 3", type_info:"Speed-Test", archive: false, student_access: false)
it = cbmN3.items.build(itemtext: "Preparation", difficulty: 0, itemtype:-1, itemview:"
<div class='modal-content'>
  <div class='modal-header'>
    <button type='button' class='close' data-dismiss='modal' aria-label='Close'><span aria-hidden='true'>&times;</span></button>
    <h4 class='modal-title' id='mainModalHeader'></h4>
  </div>
  <div class='modal-body' id='modalBody'>
    <br/>
    <br/>
    <br/>
    <p style='font-family: fibel_nordregular; font-size:96px' id='itemText' class='text-center'>
      Test
    </p>
    <br/>
    <br/>
    <br/>
  </div>
  <div class='modal-footer' style='text-align: center'>
    <button id='cButton' type='button' class='btn btn-default btn-lg' onclick='cButtonClick()'>Schrift größer (Taste: 1)</button>
    <button id='sButton' type='button' class='btn btn-success' onclick='sButtonClick()'>Test starten</button>
    <button id='iButton' type='button' class='btn btn-default btn-lg' onclick='iButtonClick()'>Schrift kleiner (Taste: 0)</button>
  </div>
</div>
<script>
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
    var tempText = (document.getElementById('itemText'));
    function cButtonClick() {
        curSize=parseInt(tempText.style.fontSize) + 10;
        tempText.style.fontSize = curSize + 'px';
    }
    function iButtonClick() {
        curSize = parseInt(tempText.style.fontSize) - 10;
        tempText.style.fontSize = curSize + 'px';
    }
    function sButtonClick() {
        currentResult = currentResult + '0,';
        $(window).unbind('keydown');
        nextItem();
        timeoutId = window.setTimeout(timedOut, workTime);
    }
    $('#mainModalHeader').html(students[currentStudent]);
</script>")
it.save

items.each do |i|
  it = cbmN3.items.build(itemtext: i, difficulty: 0, itemtype: 0, itemview:"
  <div class='modal-content'>
  <div class='modal-header'>
    <button type='button' class='close' data-dismiss='modal' aria-label='Close'><span aria-hidden='true'>&times;</span></button>
    <h4 class='modal-title' id='mainModalHeader'></h4>
  </div>
  <div class='modal-body' id='modalBody'>
    <br/>
    <br/>
    <br/>
    <p style='font-family: fibel_nordregular; font-size:96px' id='itemText' class='text-center'>"+
      i +
      "</p>
    <br/>
    <br/>
    <br/>
  </div>
  <div class='modal-footer' style='text-align: center'>
    <button id='cButton' type='button' class='btn btn-success btn-lg' onclick='cButtonClick()'>Richtig (Taste: 1)</button>
    <button id='sButton' type='button' class='btn btn-default disabled'>Test starten</button>
    <button id='iButton' type='button' class='btn btn-danger btn-lg' onclick='iButtonClick()'>Falsch (Taste: 0)</button>
  </div>
</div>


<script>
    $(window).keydown(function(event) {
        switch (event.keyCode) {
            case 49:
            case 97:
                $(window).unbind('keydown');
                cButtonClick();
                break;
            case 48:
            case 96:
                $(window).unbind('keydown');
                iButtonClick();
                break;

        }
    });

    var tempText = (document.getElementById('itemText'));
    tempText.style.fontSize = curSize + 'px';

    function cButtonClick() {
        stopwatch = new Date() - stopwatch;
        currentTimes = currentTimes + stopwatch + ',';
        currentResult = currentResult + '1,';
        $(window).unbind('keydown');
        nextItem();
    }

    function iButtonClick() {
        stopwatch = new Date() - stopwatch;
        currentTimes = currentTimes + stopwatch + ',';
        currentResult = currentResult + '0,';
        $(window).unbind('keydown');
        nextItem();
    }
    $('#mainModalHeader').html(students[currentStudent]);
</script>")
  it.save
end

it = cbmN3.items.build(itemtext: "Ende", difficulty: 0, itemtype:1, itemview:"
<div class='modal-content'>
  <div class='modal-header'>
    <button type='button' class='close' data-dismiss='modal' aria-label='Close'><span aria-hidden='true'>&times;</span></button>
    <h4 class='modal-title' id='mainModalHeader'></h4>
  </div>
  <div class='modal-body' id='modalBody'>
    <br/>
    <br/>
    <br/>
    <p class='text-center'>
      <img id='pic' style='width: 250px;'/>
      <br/>
      <br/>
      <br/>
    </p>
    <p class='text-center' style='font-size: 24px' id='status'>
      <br/>
      <br/>
      <br/>
    </p>
    <br/>
    <br/>
    <br/>
  </div>
  <div class='modal-footer' style='text-align: center'>
    <button id='cButton' type='button' class='btn btn-default btn-lg disabled'>Richtig (Taste: 1)</button>
    <button id='sButton' type='button' class='btn btn-default disabled'>Test starten</button>
    <button id='iButton' type='button' class='btn btn-default btn-lg disabled'>Falsch (Taste: 0)</button>
  </div>
</div>


<script>
    var tempPic = (document.getElementById('pic'));
    var tempStatus = (document.getElementById('status'));
    var tempStudentButton = (document.getElementById('btn'+ currentStudent));

    if (lastResults[currentStudent] >= 0 && lastResults[currentStudent] < currentResult.split('1').length)
        tempPic.src = '/images/multiple_used/Levumi-jubelt.gif';
    else if(lastResults[currentStudent] == -1)
        tempPic.src = '/images/multiple_used/Levumi-normal-blau.jpg';
    else
        tempPic.src = '/images/multiple_used/Levumi-weiterlesen.gif';

    if (timedout)
        tempStatus.innerHTML = 'Zeit abgelaufen.<br/>Die Testergebnisse wurden gespeichert!<br/>Sie können das Testfenster nun schließen.';
    else
        tempStatus.innerHTML = 'Alle Items beantwortet.<br/>Die Testergebnisse wurden gespeichert!<br/>Sie können das Testfenster nun schließen.';

    tempStudentButton.classList.add('btn-success')
    $('#mainModalHeader').html(students[currentStudent]);
</script>")
it.save

cbmN3.save




items = %w{
kli
tra
Schlo
Ble
spru
Dra
frei
bro
Krau
pleu
glu
Bli
kreu
Schla
Drei
glo
bra
Fre
klu
Spre
plau
spro
Kra
brei
Plo
klau
Fro
glei
Schli
Tru
spri
dra
plu
drau
Freu
gla
Fri
kle
Spra
schle
Trei
bri
Kru
blo
Trau
Bla
schlu
krei
Spru
Klo
Frau
pla
Dro
bre
gli
Brau
Kro
schla
Tre
dri
glau
Pli
blu
fro
Krei
Plau
Gle
kra
Kli
Pleu
schli
spre
Dru
blau
bru
trau
plo
freu
Blu
tro
Schle
brau
Pla
Kreu
Glo
fri
Drau
trei
bli
Brei
kro
Tra
pli
krau
spra
gle
Blau
Schlu
Gla
Bro
Klau
Frei
dro
tru
Tri
klo
ple
schlo
Dri
bla
tre
frau
Glau
kru
ble
Glu
Bru
Glei
Klu
Tro
fre
Spri
Bre
Plu
Gli
Spro
Blo
dru
Bra
Kle
Bri
Ple
drei
tri
}

cbmN4 = TestCBM.create(name: "Silben lesen", len: items.size, info: "(c) Dr. Diehl ISER, Uni-Rostock", short_info: "(c) Dr. Diehl ISER, Uni-Rostock", time: 60, subject: "Deutsch", construct: "Leseflüssigkeit", level: "Niveaustufe 4", type_info:"Speed-Test", archive: false, student_access: false)
it = cbmN4.items.build(itemtext: "Preparation", difficulty: 0, itemtype:-1, itemview:"
<div class='modal-content'>
  <div class='modal-header'>
    <button type='button' class='close' data-dismiss='modal' aria-label='Close'><span aria-hidden='true'>&times;</span></button>
    <h4 class='modal-title' id='mainModalHeader'></h4>
  </div>
  <div class='modal-body' id='modalBody'>
    <br/>
    <br/>
    <br/>
    <p style='font-family: fibel_nordregular; font-size:96px' id='itemText' class='text-center'>
      Test
    </p>
    <br/>
    <br/>
    <br/>
  </div>
  <div class='modal-footer' style='text-align: center'>
    <button id='cButton' type='button' class='btn btn-default btn-lg' onclick='cButtonClick()'>Schrift größer (Taste: 1)</button>
    <button id='sButton' type='button' class='btn btn-success' onclick='sButtonClick()'>Test starten</button>
    <button id='iButton' type='button' class='btn btn-default btn-lg' onclick='iButtonClick()'>Schrift kleiner (Taste: 0)</button>
  </div>
</div>
<script>
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
    var tempText = (document.getElementById('itemText'));
    function cButtonClick() {
        curSize=parseInt(tempText.style.fontSize) + 10;
        tempText.style.fontSize = curSize + 'px';
    }
    function iButtonClick() {
        curSize = parseInt(tempText.style.fontSize) - 10;
        tempText.style.fontSize = curSize + 'px';
    }
    function sButtonClick() {
        currentResult = currentResult + '0,';
        $(window).unbind('keydown');
        nextItem();
        timeoutId = window.setTimeout(timedOut, workTime);
    }
    $('#mainModalHeader').html(students[currentStudent]);
</script>")
it.save

items.each do |i|
  it = cbmN4.items.build(itemtext: i, difficulty: 0, itemtype: 0, itemview:"
  <div class='modal-content'>
  <div class='modal-header'>
    <button type='button' class='close' data-dismiss='modal' aria-label='Close'><span aria-hidden='true'>&times;</span></button>
    <h4 class='modal-title' id='mainModalHeader'></h4>
  </div>
  <div class='modal-body' id='modalBody'>
    <br/>
    <br/>
    <br/>
    <p style='font-family: fibel_nordregular; font-size:96px' id='itemText' class='text-center'>"+
      i +
      "</p>
    <br/>
    <br/>
    <br/>
  </div>
  <div class='modal-footer' style='text-align: center'>
    <button id='cButton' type='button' class='btn btn-success btn-lg' onclick='cButtonClick()'>Richtig (Taste: 1)</button>
    <button id='sButton' type='button' class='btn btn-default disabled'>Test starten</button>
    <button id='iButton' type='button' class='btn btn-danger btn-lg' onclick='iButtonClick()'>Falsch (Taste: 0)</button>
  </div>
</div>


<script>
    $(window).keydown(function(event) {
        switch (event.keyCode) {
            case 49:
            case 97:
                $(window).unbind('keydown');
                cButtonClick();
                break;
            case 48:
            case 96:
                $(window).unbind('keydown');
                iButtonClick();
                break;

        }
    });

    var tempText = (document.getElementById('itemText'));
    tempText.style.fontSize = curSize + 'px';

    function cButtonClick() {
        stopwatch = new Date() - stopwatch;
        currentTimes = currentTimes + stopwatch + ',';
        currentResult = currentResult + '1,';
        $(window).unbind('keydown');
        nextItem();
    }

    function iButtonClick() {
        stopwatch = new Date() - stopwatch;
        currentTimes = currentTimes + stopwatch + ',';
        currentResult = currentResult + '0,';
        $(window).unbind('keydown');
        nextItem();
    }
    $('#mainModalHeader').html(students[currentStudent]);
</script>")
  it.save
end

it = cbmN4.items.build(itemtext: "Ende", difficulty: 0, itemtype:1, itemview:"
<div class='modal-content'>
  <div class='modal-header'>
    <button type='button' class='close' data-dismiss='modal' aria-label='Close'><span aria-hidden='true'>&times;</span></button>
    <h4 class='modal-title' id='mainModalHeader'></h4>
  </div>
  <div class='modal-body' id='modalBody'>
    <br/>
    <br/>
    <br/>
    <p class='text-center'>
      <img id='pic' style='width: 250px;'/>
      <br/>
      <br/>
      <br/>
    </p>
    <p class='text-center' style='font-size: 24px' id='status'>
      <br/>
      <br/>
      <br/>
    </p>
    <br/>
    <br/>
    <br/>
  </div>
  <div class='modal-footer' style='text-align: center'>
    <button id='cButton' type='button' class='btn btn-default btn-lg disabled'>Richtig (Taste: 1)</button>
    <button id='sButton' type='button' class='btn btn-default disabled'>Test starten</button>
    <button id='iButton' type='button' class='btn btn-default btn-lg disabled'>Falsch (Taste: 0)</button>
  </div>
</div>


<script>
    var tempPic = (document.getElementById('pic'));
    var tempStatus = (document.getElementById('status'));
    var tempStudentButton = (document.getElementById('btn'+ currentStudent));

    if (lastResults[currentStudent] >= 0 && lastResults[currentStudent] < currentResult.split('1').length)
        tempPic.src = '/images/multiple_used/Levumi-jubelt.gif';
    else if(lastResults[currentStudent] == -1)
        tempPic.src = '/images/multiple_used/Levumi-normal-blau.jpg';
    else
        tempPic.src = '/images/multiple_used/Levumi-weiterlesen.gif';

    if (timedout)
        tempStatus.innerHTML = 'Zeit abgelaufen.<br/>Die Testergebnisse wurden gespeichert!<br/>Sie können das Testfenster nun schließen.';
    else
        tempStatus.innerHTML = 'Alle Items beantwortet.<br/>Die Testergebnisse wurden gespeichert!<br/>Sie können das Testfenster nun schließen.';

    tempStudentButton.classList.add('btn-success')
    $('#mainModalHeader').html(students[currentStudent]);
</script>")
it.save

cbmN4.save