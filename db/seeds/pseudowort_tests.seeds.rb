# -*- encoding : utf-8 -*-
items = %w{
momu
lela
mamo
limi
lome
mula
luli
mimo
mele
lalu
malu
leme
lilu
mole
loli
mumo
lami
mile
lumu
memo
lomu
mima
leli
meli
lulo
mola
lime
lali
mulu
mamu
lilo
lalo
melu
loma
molo
mume
lema
mala
lumi
mili
mulo
melo
limu
lamo
moma
muli
lolu
mumi
lula
moli
lelu
lume
lelo
mela
lumo
mule
lemi
memi
lomi
memu
milu
lame
lemo
milo
lemu
lole
lomo
lale
}

cbmN0 = TestCBM.create(name: "Pseudowörter lesen", len: items.size, info: "(c) Dr. Diehl ISER, Uni-Rostock", short_info: "(c) Dr. Diehl ISER, Uni-Rostock", time: 60, subject: "Deutsch", construct: "Leseflüssigkeit", level: "Niveaustufe 0", type_info:"Speed-Test", archive: false, student_access: false)

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
    $('#mainModalHeader').html(students[currentStudent]);
</script>")
it.save

cbmN0.save



items = %w{
raru
nire
musu
sena
losi
fula
mori
rifi
nela
sanu
lusa
fisa
mune
reno
nama
sire
foso
memu
line
rumi
nune
some
fefu
lalo
mima
nome
lale
fifo
nose
samo
rasa
mema
lufe
nima
fele
sero
refe
mesu
sume
lafo
nolo
fura
rami
mone
nifi
lomi
rimi
fosa
semo
nesu
mila
laro
sose
faro
refu
mosi
rema
fane
leni
sono
nare
remi
fofi
seli
menu
role
nisi
loru
numa
rasu
fina
siso
mefu
somi
mafo
rame
lesu
fafe
sife
mase
rure
lilo
nofa
sefe
meru
lunu
rura
sene
miri
leri
nofi
relo
sesa
lisu
sesi
nefu
rusi
lesa
nari
fame
refa
sifo
lusu
nile
rifu
sunu
lari
fini
mire
rari
lali
fulo
suna
ruri
memo
leli
safa
rusa
muso
lare
rili
nufo
loli
seno
rafu
famo
lofe
sime
risu
lifi
faso
mufo
nefi
sifu
rora
fimo
mimu
lumo
sama
rino
nofe
sisu
fela
rono
mefo
nifo
funu
somo
nufi
runo
malo
lone
safu
foni
nufe
runu
melu
soro
laso
meni
luro
fire
mono
naro
mufa
mera
samu
mili
fumo
mufu
lofo
mola
loso
mora
}

cbmN1 = TestCBM.create(name: "Pseudowörter lesen", len: items.size, info: "(c) Dr. Diehl ISER, Uni-Rostock", short_info: "(c) Dr. Diehl ISER, Uni-Rostock", time: 60, subject: "Deutsch", construct: "Leseflüssigkeit", level: "Niveaustufe 1", type_info:"Speed-Test", archive: false, student_access: false)

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
    $('#mainModalHeader').html(students[currentStudent]);
</script>")
it.save

cbmN1.save


items = %w{
pofen
halei
wapa
teitau
delsau
eidel
wemer
leisau
senhau
mendel
rawu
fenha
nenrau
teilei
sendu
heira
laulen
wenen
derho
pihau
enmer
senra
rauwa
daufer
heiwa
lenrei
teisei
weido
ferha
pawa
dofen
laudel
detei
wawu
haulen
derde
reidel
lensen
wadu
mertau
hauha
rahei
deldo
teisen
wamen
pahau
heifen
fenpi
derda
hura
weiha
saupi
wupi
laumer
dode
huwa
pader
duwu
ratei
tausau
hoder
wuda
datau
hupi
pihei
weiwa
haura
teimer
dellei
weipo
lenho
huhei
merpo
dodau
reipa
poder
halei
welen
dara
hupo
wepa
pawei
reihau
dohau
wuhei
reilau
haunen
merrei
lentau
huda
padau
weipa
delei
teidu
heiho
mermen
seiwei
wadau
dauha
reien
hendau
parau
waho
teifen
wetei
heidau
derpo
saulei
daudel
hauhen
weisau
leihei
ender
pahen
wapi
laupa
weda
hensei
durau
mensei
eirei
lauhu
heisau
reiwu
ferwa
weipi
dusau
nende
heiha
pilau
depa
menen
hurau
derdo
wuwa
hauwu
teiha
rauho
hopi
dado
deldu
rauwei
hudu
leilau
wuwei
dupi
pafen
seiei
humer
mentau
dudel
wulau
}
groups = %i{
0
0
0
0
1
0
0
0
1
1
0
1
1
0
1
0
0
0
1
0
1
1
0
0
0
1
0
0
1
0
0
0
0
0
0
1
0
1
0
1
0
0
1
0
0
0
0
1
1
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
1
0
1
0
1
0
0
0
0
0
0
0
0
0
0
0
0
0
0
1
1
0
0
0
0
0
0
1
0
0
0
0
1
0
0
0
0
0
1
0
0
0
0
0
1
0
0
0
0
1
0
1
0
0
0
0
1
0
0
1
0
0
0
0
0
1
0
0
0
0
0
0
1
0
0
0
0
0
0
1
0
1
0
0
}


cbmN2a = TestCBM.create(name: "Pseudowörter lesen", len: items.size, info: "(c) Dr. Diehl ISER, Uni-Rostock", short_info: "(c) Dr. Diehl ISER, Uni-Rostock", time: 60, subject: "Deutsch", construct: "Leseflüssigkeit", level: "Niveaustufe 2a", type_info:"Speed-Test", archive: false, student_access: false)

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
    }
    $('#mainModalHeader').html(students[currentStudent]);
</script>")
it.save

count = 0
items.each do |i|
  it = cbmN2a.items.build(itemtext: i, difficulty: groups[count], itemtype: 0, itemview:"
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
  count = count+ 1
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
    $('#mainModalHeader').html(students[currentStudent]);
</script>")
it.save

cbmN2a.save



items = %w{
keber
gibo
schuku
baku
kecha
boscha
gacher
schoschu
keschau
berbu
schochi
koki
schaubi
bicher
goga
bober
kicha
boka
schokau
benschau
kusche
gika
bensche
schuscho
gelsche
kaucher
buba
gober
schaugo
bascho
kebu
belbo
gabo
scheichi
belchen
kigo
boke
schebo
goscho
bergi
kuke
basche
schuba
bachi
gelgen
kiber
schecha
bischa
gobu
berbo
kagu
schasche
gelgu
benscho
schugel
scheischo
gaka
kokau
bigel
schekau
gibu
kauko
bercha
schoga
genschei
belgel
keka
belkau
schauben
giber
kauki
schego
berschei
scheibo
gugo
kigu
bokau
goschau
schobel
bugi
gische
kuchi
bagel
schogi
schauber
bochen
gaschau
schegi
kauba
schaba
bische
gengo
kuscho
bengi
schesche
berko
kigi
berscha
gigo
schoka
bogi
gengu
kauchi
scheigel
gischau
benko
kiku
gike
bugu
schoku
bachen
gischu
kuga
schagi
schubo
belke
gelka
kuschei
scheber
schacha
kogen
gaba
bochi
scheigo
berku
kasche
gelcha
schebi
guschu
belscho
genki
kischau
scheka
bobel
gasche
schescha
gobi
bakau
genben
scheku
berscho
}
groups = %i{
0
0
0
0
0
0
0
0
0
1
0
0
0
0
0
0
0
0
0
1
0
0
1
0
1
0
0
0
0
0
0
1
0
0
1
0
0
0
0
1
0
0
0
0
1
0
0
0
0
1
0
0
1
1
0
0
0
0
0
0
0
0
1
0
1
1
0
1
0
0
0
0
1
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
1
0
1
0
1
0
1
0
0
0
1
0
0
0
1
0
0
0
0
0
0
0
0
0
1
1
0
0
0
0
0
0
0
1
0
1
0
0
1
1
0
0
0
0
0
0
0
1
0
1
}


cbmN2b = TestCBM.create(name: "Pseudowörter lesen", len: items.size, info: "(c) Dr. Diehl ISER, Uni-Rostock", short_info: "(c) Dr. Diehl ISER, Uni-Rostock", time: 60, subject: "Deutsch", construct: "Leseflüssigkeit", level: "Niveaustufe 2b", type_info:"Speed-Test", archive: false, student_access: false)

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
    }
    $('#mainModalHeader').html(students[currentStudent]);
</script>")
it.save

count = 0
items.each do |i|
  it = cbmN2b.items.build(itemtext: i, difficulty: groups[count], itemtype: 0, itemview:"
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
  count = count +1
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
    $('#mainModalHeader').html(students[currentStudent]);
</script>")
it.save
cbmN2b.save

items = %w{
vuru
xine
zele
feuso
tyli
jenu
schöfo
quafu
pysa
jasu
speimi
steifo
hexaf
beulu
pyri
euma
stana
spesu
xila
scheura
zasi
hexef
vila
pyme
euni
feune
vala
jale
neumi
steime
zusu
schöse
zumo
vimi
speife
tyne
zeru
quase
vari
steiru
vane
eure
zifu
xisu
schöme
jera
speni
vise
quara
zamo
vano
hexim
feufu
tyru
zile
vasu
steisi
speilu
zeni
jara
neufu
vifo
pyfu
zema
eufo
stafi
vofa
geuso
quani
xilo
scheuno
zula
spelo
beure
viru
jeli
zafa
stalo
hexol
neusa
vore
schönu
geume
feuli
speira
zefo
steila
pyno
scheuse
vura
neune
jamo
beumi
zuri
speino
qualo
geufu
xime
stame
vomi
zale
vufo
spele
beusa
hexun
tyma
jemo
zisa
geula
vuni
zufe
eusu
scheufu
neulo
zanu
stasu
schöla
feuma
vono
beuno
geusi
jafi
scheuli
tyso
spema
vume
zino
jese
volu
zili
}

cbmN3a = TestCBM.create(name: "Pseudowörter lesen", len: items.size, info: "(c) Dr. Diehl ISER, Uni-Rostock", short_info: "(c) Dr. Diehl ISER, Uni-Rostock", time: 60, subject: "Deutsch", construct: "Leseflüssigkeit", level: "Niveaustufe 3a", type_info:"Speed-Test", archive: false, student_access: false)

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
    }
    $('#mainModalHeader').html(students[currentStudent]);
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
    $('#mainModalHeader').html(students[currentStudent]);
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
    $('#mainModalHeader').html(students[currentStudent]);
</script>")
it.save
cbmN3a.save




items = %w{
züstu
spuße
scheuvei
quäjo
xisti
vostau
stövo
hexsteu
jaujä
tyqui
pyhex
zäßen
steity
spity
jeußen
zuspei
steuvo
vaßer
schäzeu
züvö
speuspi
steisteu
juqua
zestau
stästö
steuvi
quavi
zösti
stuqua
spähex
zövi
voquä
scheuße
staustei
vövei
zuzau
spajo
schäzä
stuspu
zespü
juspeu
quäva
steße
zäschü
spiva
juzeu
stastö
veihex
zauza
schüvi
stözö
späschü
züjau
vistu
stoxi
spestö
zivei
quäspu
steischeu
veiquä
tyspa
zujau
stazü
xizä
schäqui
zausto
stezeu
speiva
veizei
hexze
zeuqua
stisto
spüspä
quispi
zeza
jaty
stespe
jauspi
scheujä
zauzä
steizü
veischeu
speize
zeißen
stözi
hexqui
jeste
zästä
quaja
staquä
spüsto
züjeu
vöjä
stiste
juspi
zeustö
veizi
steiqua
pysta
zesta
stoje
quäschü
züßer
spety
zeistau
stazau
jopy
schüty
zauzü
stije
speivi
vaschä
zavi
stuvo
jäzeu
tystau
steva
zausta
quäjau
spijo
steuschö
zauja
steuspeu
späspeu
schävei
zevö
stuste
jästau
speju
zöqua
stezü
xispeu
quastä
hexpy
zeujau
stöhex
spapy
schöjä
zasto
stäschü
spüva
pyschü
zustau
stispü
quaspi
speistu
zäpy
veißer
steizau
juße
zastau
steuza
vözeu
späzö
zustu
scheußer
stespi
spiste
zözi
spixi
stuva
quipy
zöstä
jastu
schüstö
spujeu
zeuzau
hexzü
spävei
jäzi
zußen
spusta
xischä
schäßer
zaqua
vipy
zista
späjo
spüvi
zeuzö
quajo
}

cbmN3b = TestCBM.create(name: "Pseudowörter lesen", len: items.size, info: "(c) Dr. Diehl ISER, Uni-Rostock", short_info: "(c) Dr. Diehl ISER, Uni-Rostock", time: 60, subject: "Deutsch", construct: "Leseflüssigkeit", level: "Niveaustufe 3b", type_info:"Speed-Test", archive: false, student_access: false)

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
    }
    $('#mainModalHeader').html(students[currentStudent]);
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
    $('#mainModalHeader').html(students[currentStudent]);
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
    $('#mainModalHeader').html(students[currentStudent]);
</script>")
it.save
cbmN3b.save



items = %w{
sprablu
drutro
fretre
glipla
breiklo
plokro
klukli
blaubro
schlafri
troplo
kreischlu
blabra
drokle
schluschli
krautro
plegla
gleispro
klikro
trautro
freupleu
sprikrei
breiklau
braukra
druglu
froplo
spraschlu
glible
blaschli
schlutrau
traudrei
kreiklo
kledrau
pleukrei
freiplau
gluglau
draubli
bleblu
sprokro
schlispri
brukli
trekrau
pleudri
kraubrei
klebla
bredra
pleuglu
dratri
klibra
fraudru
spribra
blefrei
trodra
schlublau
krobrau
glispro
trudri
plibra
drikrau
schladra
bropli
kleglei
spridrei
blablau
fridrau
krogli
gluklo
plopli
breispre
schlebru
blubro
glauplau
kleblo
frigle
bleschla
kragla
bladro
glabru
tridro
plaglu
schlibru
blakru
kluplau
glekra
krobre
fraupla
brokra
sprakle
druglei
sprekreu
dritrau
blotri
freitre
braukrau
breipli
gleigli
triglau
schlatra
blodru
trufro
pleuglei
schlubla
glaglo
fraukreu
drotra
klaubre
trebru
brafreu
gliple
draufre
blaupleu
plobre
broplu
schlespro
krabra
schlagli
blagle
plugli
trubri
bliple
bribrei
spriplu
frotre
schlaklu
klobrei
blofreu
glebrau
plaugla
treifrau
friklo
bradri
blaudru
freuspru
sprispre
draubrei
schlaspra
kraubla
blauspru
britre
triblu
pluglau
globre
blischla
spritru
klukru
schlaplau
frifrei
trischlo
brudrei
glutra
bluschli
drikle
glidra
spradro
freitrei
trablo
droblo
blefro
druschlu
blitro
glautrau
brable
schletri
spruspre
klutrau
tribrau
kruglo
blokro
freglo
glitra
breikra
spraschla
dribli
trufrau
schlabli
plaublu
glaubru
kraudru
blitri
klauklu
glotri
brischlu
schlatru
draplau
spreglau
frespre
trubre
glitrau
blaukrau
schlabro
}

cbmN4 = TestCBM.create(name: "Pseudowörter lesen", len: items.size, info: "(c) Dr. Diehl ISER, Uni-Rostock", short_info: "(c) Dr. Diehl ISER, Uni-Rostock", time: 60, subject: "Deutsch", construct: "Leseflüssigkeit", level: "Niveaustufe 4", type_info:"Speed-Test", archive: false, student_access: false)

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
    $('#mainModalHeader').html(students[currentStudent]);
</script>")
it.save

cbmN4.save



