# -*- encoding : utf-8 -*-
items = %w{
momu
lela
leli
memo
lema
mula
mulo
mumo
lulo
mamo
moma
mole
lilu
lomu
mulu
lamo
lumo
mamu
lemi
mela
mimo
memi
mule
lomi
muli
lame
memu
lole
lemu
loli
lime
loma
lilo
leme
lali
lami
molo
melu
lumi
mume
mele
mala
lomo
milo
malu
limu
lume
lolu
luli
lula
melo
meli
lelu
mima
lome
moli
lumu
mile
lalo
lalu
mola
lale
lelo
mumi
mili
lemo
milu
limi
}

cbmN0 = TestCBM.create(name: "Pseudowörter lesen", len: items.size, info: "(c) Dr. Diehl ISER, Uni-Rostock", short_info: "(c) Dr. Diehl ISER, Uni-Rostock", time: 60, subject: "Deutsch", construct: "Leseflüssigkeit", level: "Niveaustufe 0", archive: false, student_access: false)

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
    <button id='cButton' type='button' class='btn btn-default btn-lg' onclick='cButtonClick()'>Schrift größer</button>
    <button id='sButton' type='button' class='btn btn-success' onclick='sButtonClick()'>Test starten</button>
    <button id='iButton' type='button' class='btn btn-default btn-lg' onclick='iButtonClick()'>Schrift kleiner</button>
  </div>
</div>
<script>
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
        timeoutId = window.setTimeout(timedOut, workTime +500, true);
        currentResult = currentResult + '0,';
        nextItem();
    }
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
        tempPic.src = '/images/Levumi-jubelt.gif';
    else if(lastResults[currentStudent] == -1)
        tempPic.src = '/images/Levumi-normal-blau.jpg';
    else
        tempPic.src = '/images/Levumi-weiterlesen.gif';
    if (timedout)
        tempStatus.innerHTML = 'Zeit abgelaufen.<br/>Die Testergebnisse wurden gespeichert!<br/>Sie können das Testfenster nun schließen.';
    else
        tempStatus.innerHTML = 'Alle Items beantwortet.<br/>Die Testergebnisse wurden gespeichert!<br/>Sie können das Testfenster nun schließen.';
    tempStudentButton.classList.add('btn-success')
</script>")
it.save

cbmN0.save



items = %w{
raru
rumi
nire
nela
rasa
nama
rimi
reno
nifi
nesu
sire
rifi
mila
rema
leni
mone
lomi
fefu
lesu
sena
fini
laro
rusa
somo
fumo
nefi
fosa
lunu
mufa
refa
mora
faso
lisu
rasu
mufu
mili
fura
fisa
refe
memo
miri
sifu
lare
sesa
lumo
sama
fimo
runu
fane
mimu
lilo
mono
nifo
lusu
fifo
sanu
lafo
rono
nile
rino
rora
fulo
sisu
lofe
foni
nufe
mase
funu
nune
lari
rafu
fela
nefu
ruri
mera
nofi
nofa
mori
loso
lofo
role
siso
mefu
leri
musu
loli
mire
fafe
fire
lifi
naro
fofi
rifu
leli
fame
lali
semo
nufo
soro
lusa
relo
safu
risu
nolo
meru
mufo
rusi
lesa
nufi
laso
mefo
nofe
samu
memu
nari
sono
sose
lone
malo
seli
melu
rari
mosi
sene
nisi
foso
losi
sifo
remi
loru
rili
fele
samo
numa
nome
lalo
mesu
sefe
fina
sife
rami
fula
mima
mune
nare
sesi
lufe
refu
somi
mafo
sume
some
rura
luro
meni
muso
line
rame
nose
sero
nima
mema
rure
sunu
mola
safa
suna
runo
famo
seno
sime
menu
faro
lale
}

cbmN1 = TestCBM.create(name: "Pseudowörter lesen", len: items.size, info: "(c) Dr. Diehl ISER, Uni-Rostock", short_info: "(c) Dr. Diehl ISER, Uni-Rostock", time: 60, subject: "Deutsch", construct: "Leseflüssigkeit", level: "Niveaustufe 1", archive: false, student_access: false)

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
    <button id='cButton' type='button' class='btn btn-default btn-lg' onclick='cButtonClick()'>Schrift größer</button>
    <button id='sButton' type='button' class='btn btn-success' onclick='sButtonClick()'>Test starten</button>
    <button id='iButton' type='button' class='btn btn-default btn-lg' onclick='iButtonClick()'>Schrift kleiner</button>
  </div>
</div>
<script>
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
        timeoutId = window.setTimeout(timedOut, workTime +500, true);
        currentResult = currentResult + '0,';
        nextItem();
    }
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
        tempPic.src = '/images/Levumi-jubelt.gif';
    else if(lastResults[currentStudent] == -1)
        tempPic.src = '/images/Levumi-normal-blau.jpg';
    else
        tempPic.src = '/images/Levumi-weiterlesen.gif';
    if (timedout)
        tempStatus.innerHTML = 'Zeit abgelaufen.<br/>Die Testergebnisse wurden gespeichert!<br/>Sie können das Testfenster nun schließen.';
    else
        tempStatus.innerHTML = 'Alle Items beantwortet.<br/>Die Testergebnisse wurden gespeichert!<br/>Sie können das Testfenster nun schließen.';
    tempStudentButton.classList.add('btn-success')
</script>")
it.save

cbmN1.save

cbmN2a = TestCBM.create(name: "Pseudowörter lesen", len: 0, info: "(c) Dr. Diehl ISER, Uni-Rostock", short_info: "(c) Dr. Diehl ISER, Uni-Rostock", time: 60, subject: "Deutsch", construct: "Leseflüssigkeit", level: "Niveaustufe 2a", archive: false, student_access: false)

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
    <button id='cButton' type='button' class='btn btn-default btn-lg' onclick='cButtonClick()'>Schrift größer</button>
    <button id='sButton' type='button' class='btn btn-success' onclick='sButtonClick()'>Test starten</button>
    <button id='iButton' type='button' class='btn btn-default btn-lg' onclick='iButtonClick()'>Schrift kleiner</button>
  </div>
</div>
<script>
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
        timeoutId = window.setTimeout(timedOut, workTime +500, true);
        currentResult = currentResult + '0,';
        nextItem();
    }
</script>")
it.save

items = %w{
dofen
pofen
dodau
reidel
waho
weda
delei
teisen
laupa
daudel
tausau
detei
pader
saupi
wuwei
dara
rauho
wetei
dusau
heiho
weiha
rahei
hauwu
teitau
wepa
dado
pawa
hauha
daufer
rauwei
haunen
hupo
dudel
heiha
saulei
eidel
wadau
wamen
haura
teisei
teidu
wupi
teifen
heiwa
menen
durau
reiwu
leilau
weipo
wulau
rauwa
pihau
laulen
wawu
heidau
wadu
teiha
eirei
poder
teimer
halei
pawei
depa
hopi
wapi
dauha
pafen
huwa
leihei
huda
pahau
weido
heifen
haulen
dohau
seiwei
weisau
leiwe
dupi
weipi
wuwa
hurau
ratei
hupi
weipa
hauhen
pilau
rawu
laudel
welen
hura
wuda
datau
hoder
laumer
huhei
pihei
wapa
parau
padau
dode
reien
heira
lauhu
leisau
humer
teilei
duwu
wemer
reihau
weiwa
reipa
hudu
heisau
wuhei
pahen
reilau
wenen
}


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
</script>")
  it.save
end

cbmN2a.len = cbmN2a.len + items.size

items = %w{
hensei
enmer
lenrei
lenho
ender
mermen
mentau
delsau
lensen
merpo
lentau
hendau
seiei
fenha
deldu
mendel
fenpi
senra
derde
derda
sendu
deldo
ferha
nende
derho
derdo
mertau
dellei
senhau
mensei
nenrau
ferwa
derpo
merrei
}

items.each do |i|
  it = cbmN2a.items.build(itemtext: i, difficulty: 1, itemtype: 0, itemview:"
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
</script>")
  it.save
end

cbmN2a.len = cbmN2a.len + items.size


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
        tempPic.src = '/images/Levumi-jubelt.gif';
    else if(lastResults[currentStudent] == -1)
        tempPic.src = '/images/Levumi-normal-blau.jpg';
    else
        tempPic.src = '/images/Levumi-weiterlesen.gif';
    if (timedout)
        tempStatus.innerHTML = 'Zeit abgelaufen.<br/>Die Testergebnisse wurden gespeichert!<br/>Sie können das Testfenster nun schließen.';
    else
        tempStatus.innerHTML = 'Alle Items beantwortet.<br/>Die Testergebnisse wurden gespeichert!<br/>Sie können das Testfenster nun schließen.';
    tempStudentButton.classList.add('btn-success')
</script>")
it.save

cbmN2a.save




cbmN2b = TestCBM.create(name: "Pseudowörter lesen", len: 0, info: "(c) Dr. Diehl ISER, Uni-Rostock", short_info: "(c) Dr. Diehl ISER, Uni-Rostock", time: 60, subject: "Deutsch", construct: "Leseflüssigkeit", level: "Niveaustufe 2b", archive: false, student_access: false)

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
    <button id='cButton' type='button' class='btn btn-default btn-lg' onclick='cButtonClick()'>Schrift größer</button>
    <button id='sButton' type='button' class='btn btn-success' onclick='sButtonClick()'>Test starten</button>
    <button id='iButton' type='button' class='btn btn-default btn-lg' onclick='iButtonClick()'>Schrift kleiner</button>
  </div>
</div>
<script>
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
        timeoutId = window.setTimeout(timedOut, workTime +500, true);
        currentResult = currentResult + '0,';
        nextItem();
    }
</script>")
it.save

items = %w{
schuku
keber
keschau
kuscho
gibo
baku
kuke
gacher
kicha
bicher
goga
boscha
gika
kusche
gibu
bischa
bakau
gischau
kebu
schaubi
schebo
kischau
goschau
scheibo
schagi
gaba
schobel
schogi
schekau
schaba
gische
scheigo
schoschu
scheka
gischu
giber
schubo
bagel
scheigel
koki
schuba
gobi
boke
kigi
guschu
schacha
schokau
keka
scheber
kiku
kigu
scheischo
kecha
scheichi
schegi
bochen
bobel
bachi
basche
gigo
kaucher
bugi
gike
kigo
kauki
goscho
boka
schochi
bachen
kagu
kuchi
bogi
gasche
schauben
schoga
schuscho
kauba
schoku
scheku
bugu
kasche
schesche
schecha
kuschei
gober
schugel
kauchi
schasche
gaschau
schescha
bigel
kogen
kokau
kiber
schebi
schaugo
schoka
gugo
kuga
bober
bascho
schauber
buba
bokau
schego
bochi
gabo
bische
kauko
gaka
gobu
}

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
</script>")
  it.save
end
cbmN2b.len = cbmN2b.len + items.size

items = %w{
gelgu
berbo
gelcha
genki
belkau
belchen
benschau
gengo
gelsche
bensche
bengi
gelgen
gengu
berko
benko
belgel
berscha
belbo
genschei
berschei
belscho
berku
berscho
belke
bergi
bercha
berbu
gelka
benscho
genben
}

items.each do |i|
  it = cbmN2b.items.build(itemtext: i, difficulty: 1, itemtype: 0, itemview:"
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
        tempPic.src = '/images/Levumi-jubelt.gif';
    else if(lastResults[currentStudent] == -1)
        tempPic.src = '/images/Levumi-normal-blau.jpg';
    else
        tempPic.src = '/images/Levumi-weiterlesen.gif';
    if (timedout)
        tempStatus.innerHTML = 'Zeit abgelaufen.<br/>Die Testergebnisse wurden gespeichert!<br/>Sie können das Testfenster nun schließen.';
    else
        tempStatus.innerHTML = 'Alle Items beantwortet.<br/>Die Testergebnisse wurden gespeichert!<br/>Sie können das Testfenster nun schließen.';
    tempStudentButton.classList.add('btn-success')
</script>")
it.save

cbmN2b.len = cbmN2b.len + items.size

cbmN2b.save

items = %w{
scheura
scheuse
scheuli
scheuno
scheufu
euma
eure
euni
eufo
eusu
neusa
neune
neumi
neulo
neufu
geula
geume
geusi
geuso
geufu
beusa
beure
beumi
beuno
beulu
hexaf
hexef
hexim
hexol
hexun
jara
jale
jafi
jamo
jasu
pysa
pyme
pyri
pyno
pyfu
quara
quase
quani
qualo
quafu
schöla
schöse
schöme
schöfo
schönu
spema
spele
speni
spelo
spesu
speira
speife
speimi
speino
speilu
stana
stame
stafi
stalo
stasu
steila
steime
steisi
steifo
steiru
tyma
tyne
tyli
tyso
tyru
vala
vane
vari
vano
vasu
vofa
vore
vomi
vono
volu
xila
xime
xine
xilo
xisu
zafa
zale
zasi
zamo
zanu
zisa
zile
zili
zino
zifu
feuma
feune
feuli
feuso
feufu
zula
zufe
zuri
zumo
zusu
zema
zele
zeni
zefo
zeru
vila
vise
vimi
vifo
viru
vura
vume
vuni
vufo
vuru
jera
jese
jeli
jemo
jenu
}

cbmN3a = TestCBM.create(name: "Pseudowörter lesen", len: items.size, info: "(c) Dr. Diehl ISER, Uni-Rostock", short_info: "(c) Dr. Diehl ISER, Uni-Rostock", time: 60, subject: "Deutsch", construct: "Leseflüssigkeit", level: "Niveaustufe 3a", archive: false, student_access: false)

it = cbmN3a.items.build(itemtext: "Preparation", difficulty: 0, itemtype:-1, itemview:"
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
    <button id='cButton' type='button' class='btn btn-default btn-lg' onclick='cButtonClick()'>Schrift größer</button>
    <button id='sButton' type='button' class='btn btn-success' onclick='sButtonClick()'>Test starten</button>
    <button id='iButton' type='button' class='btn btn-default btn-lg' onclick='iButtonClick()'>Schrift kleiner</button>
  </div>
</div>
<script>
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
        timeoutId = window.setTimeout(timedOut, workTime +500, true);
        currentResult = currentResult + '0,';
        nextItem();
    }
</script>")
it.save

items.each do |i|
  it = cbmN3a.items.build(itemtext: i, difficulty: 0, itemtype: 0, itemview:"
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
</script>")
  it.save
end

it = cbmN3a.items.build(itemtext: "Ende", difficulty: 0, itemtype:1, itemview:"
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
        tempPic.src = '/images/Levumi-jubelt.gif';
    else if(lastResults[currentStudent] == -1)
        tempPic.src = '/images/Levumi-normal-blau.jpg';
    else
        tempPic.src = '/images/Levumi-weiterlesen.gif';
    if (timedout)
        tempStatus.innerHTML = 'Zeit abgelaufen.<br/>Die Testergebnisse wurden gespeichert!<br/>Sie können das Testfenster nun schließen.';
    else
        tempStatus.innerHTML = 'Alle Items beantwortet.<br/>Die Testergebnisse wurden gespeichert!<br/>Sie können das Testfenster nun schließen.';
    tempStudentButton.classList.add('btn-success')
</script>")
it.save
cbmN3a.save




items = %w{
züstu
zäßen
quäjo
steity
quavi
zevö
steuvo
steisteu
zöqua
steuvi
zuspei
quäspu
stästö
stuqua
spity
xisti
züvö
staustei
stuspu
zösti
zövi
quäva
vipy
steße
xizä
spuße
zuzau
zausto
zeuqua
speuspi
schäzeu
stastö
zeza
zauzä
spähex
jauspi
vözeu
pysta
zeißen
jopy
speistu
schüty
stöhex
stäschü
späzö
schävei
stispü
vostau
stözö
zauza
stoxi
züßer
zäschü
schäzä
juspeu
zivei
spestö
zausta
zujau
quäschü
schöjä
veißer
speiva
pyhex
scheujä
staquä
steischeu
züjau
zußen
spüsto
tyqui
stiste
spiva
spijo
juße
jastu
spävei
zeuzö
vöjä
jeußen
zeujau
steizau
zespü
zasto
spujeu
steuza
stövo
hexzü
spety
schäqui
hexpy
späspeu
jäzeu
spüva
hexqui
jästau
hexze
spiste
xispeu
speize
vövei
stespi
jaujä
speivi
zauzü
stezeu
scheußer
tyspa
scheuvei
veiquä
zista
vistu
quäjau
zeuzau
quispi
vaschä
zesta
schüvi
stije
zavi
veischeu
steuschö
zauja
jaty
quastä
steuspeu
voquä
juspi
späjo
stoje
zeustö
pyschü
stözi
zeistau
steizü
spüspä
zestau
jäzi
stuva
quaja
stisto
spajo
stazü
scheuße
quaspi
steva
tystau
jeste
zaqua
speju
stuste
stezü
juqua
veizi
hexsteu
spapy
xischä
schüstö
stespe
spixi
züjeu
juzeu
quajo
zustau
veizei
quipy
zastau
veihex
stuvo
zustu
zästä
schäßer
spusta
stazau
steiqua
späschü
zäpy
zözi
vaßer
zöstä
spüvi
}

cbmN3b = TestCBM.create(name: "Pseudowörter lesen", len: items.size, info: "(c) Dr. Diehl ISER, Uni-Rostock", short_info: "(c) Dr. Diehl ISER, Uni-Rostock", time: 60, subject: "Deutsch", construct: "Leseflüssigkeit", level: "Niveaustufe 3b", archive: false, student_access: false)

it = cbmN3b.items.build(itemtext: "Preparation", difficulty: 0, itemtype:-1, itemview:"
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
    <button id='cButton' type='button' class='btn btn-default btn-lg' onclick='cButtonClick()'>Schrift größer</button>
    <button id='sButton' type='button' class='btn btn-success' onclick='sButtonClick()'>Test starten</button>
    <button id='iButton' type='button' class='btn btn-default btn-lg' onclick='iButtonClick()'>Schrift kleiner</button>
  </div>
</div>
<script>
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
        timeoutId = window.setTimeout(timedOut, workTime +500, true);
        currentResult = currentResult + '0,';
        nextItem();
    }
</script>")
it.save

items.each do |i|
  it = cbmN3b.items.build(itemtext: i, difficulty: 0, itemtype: 0, itemview:"
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
</script>")
  it.save
end

it = cbmN3b.items.build(itemtext: "Ende", difficulty: 0, itemtype:1, itemview:"
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
        tempPic.src = '/images/Levumi-jubelt.gif';
    else if(lastResults[currentStudent] == -1)
        tempPic.src = '/images/Levumi-normal-blau.jpg';
    else
        tempPic.src = '/images/Levumi-weiterlesen.gif';
    if (timedout)
        tempStatus.innerHTML = 'Zeit abgelaufen.<br/>Die Testergebnisse wurden gespeichert!<br/>Sie können das Testfenster nun schließen.';
    else
        tempStatus.innerHTML = 'Alle Items beantwortet.<br/>Die Testergebnisse wurden gespeichert!<br/>Sie können das Testfenster nun schließen.';
    tempStudentButton.classList.add('btn-success')
</script>")
it.save
cbmN3b.save



items = %w{
sprablu
spridrei
dratri
frigle
breispre
fretre
glauplau
kragla
bropli
schlispri
sprakle
froplo
plaugla
bleschla
brokra
trufro
glidra
krautro
braukra
gleispro
dritrau
plugli
blubro
glaglo
fraupla
blakru
druglei
schlebru
bliple
gluglau
braukrau
trodra
tridro
drokle
blablau
broplu
schlaplau
blefrei
pleuglei
schlatru
blaupleu
spraschlu
druschlu
plibra
kluplau
breipli
blabra
klibra
schletri
draubli
druglu
glispro
blaudru
trudri
britre
globre
gleigli
fridrau
klaubre
glotri
spradro
pleuglu
bleblu
blagle
brafreu
gliple
krogli
brukli
schlibru
blodru
blischla
trekrau
klukru
klobrei
schlabro
glautrau
spriplu
blaubro
plobre
trebru
fraudru
friklo
traudrei
glipla
kreischlu
fraukreu
schlatra
sprokro
spritru
bladro
sprikrei
schlabli
kleglei
freglo
klukli
spreglau
droblo
blitro
spruspre
glitra
blokro
draplau
kraudru
schladra
treifrau
blauspru
glitrau
trischlo
schlutrau
kruglo
krobre
kreiklo
frotre
freiplau
bredra
tribrau
blaukrau
blofreu
plopli
plegla
schlagli
krobrau
frespre
drikle
trablo
brable
glebrau
klebla
spraschla
spribra
plaublu
schlublau
brischlu
kraubrei
freuspru
schlaklu
kledrau
bluschli
triblu
klauklu
trubre
pluglau
plokro
schlaspra
blitri
pleudri
dribli
trufrau
brudrei
schluschli
gluklo
schlafri
klikro
frifrei
draubrei
blaschli
glabru
pleukrei
blefro
glekra
klutrau
breikra
plaglu
breiklo
trubri
kraubla
schlespro
freupleu
drutro
freitrei
drikrau
triglau
freitre
drotra
glaubru
sprekreu
kleblo
schlubla
breiklau
draufre
glible
troplo
bradri
trautro
blotri
krabra
bribrei
glutra
sprispre
}

cbmN4 = TestCBM.create(name: "Pseudowörter lesen", len: items.size, info: "(c) Dr. Diehl ISER, Uni-Rostock", short_info: "(c) Dr. Diehl ISER, Uni-Rostock", time: 60, subject: "Deutsch", construct: "Leseflüssigkeit", level: "Niveaustufe 4", archive: false, student_access: false)

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
    <button id='cButton' type='button' class='btn btn-default btn-lg' onclick='cButtonClick()'>Schrift größer</button>
    <button id='sButton' type='button' class='btn btn-success' onclick='sButtonClick()'>Test starten</button>
    <button id='iButton' type='button' class='btn btn-default btn-lg' onclick='iButtonClick()'>Schrift kleiner</button>
  </div>
</div>
<script>
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
        timeoutId = window.setTimeout(timedOut, workTime +500, true);
        currentResult = currentResult + '0,';
        nextItem();
    }
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
        tempPic.src = '/images/Levumi-jubelt.gif';
    else if(lastResults[currentStudent] == -1)
        tempPic.src = '/images/Levumi-normal-blau.jpg';
    else
        tempPic.src = '/images/Levumi-weiterlesen.gif';
    if (timedout)
        tempStatus.innerHTML = 'Zeit abgelaufen.<br/>Die Testergebnisse wurden gespeichert!<br/>Sie können das Testfenster nun schließen.';
    else
        tempStatus.innerHTML = 'Alle Items beantwortet.<br/>Die Testergebnisse wurden gespeichert!<br/>Sie können das Testfenster nun schließen.';
    tempStudentButton.classList.add('btn-success')
</script>")
it.save

cbmN4.save



