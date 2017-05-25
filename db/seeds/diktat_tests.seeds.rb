# -*- encoding : utf-8 -*-
items = %w{
Leine
Teller
spülen
Flug
Zecke
Truhe
stärken
backt
fliegen
Versteck
fließen
Satz
über
Tee
einer
Geld
Zug
Läuse
bissig
packt
geht
spüren
Adventskranz
Kilo
seht
Fahne
See
Platz
Kino
Moor
Sahne
kommt
Keller
Decke
Stärke
Strahl
sonnt
Kräne
Beine
Mäuse
Sieb
winzig
Korb
Weihnachtsbaum
Video
Nationalmannschaft
Meer
Bäche
Strähne
dort
Feld
Verdeck
sind
}

audios =%w{
Woerter/1_Leine.mp3
Woerter/2_Teller.mp3
Woerter/3_spülen.mp3
Woerter/4_Flug.mp3
Woerter/5_Zecke.mp3
Woerter/6_Truhe.mp3
Woerter/7_stärken.mp3
Woerter/8_backt.mp3
Woerter/9_fliegen.mp3
Woerter/10_Versteck.mp3
Woerter/11_fließen.mp3
Woerter/12_Satz.mp3
Woerter/13_über.mp3
Woerter/14_Tee.mp3
Woerter/15_einer.mp3
Woerter/16_Geld.mp3
Woerter/17_Zug.mp3
Woerter/18_Läuse.mp3
Woerter/19_bissig.mp3
Woerter/20_packt.mp3
Woerter/21_geht.mp3
Woerter/22_spüren.mp3
Woerter/23_Adventskranz.mp3
Woerter/24_Kilo.mp3
Woerter/25_seht.mp3
Woerter/26_Fahne.mp3
Woerter/27_See.mp3
Woerter/28_Platz.mp3
Woerter/29_Kino.mp3
Woerter/30_Moor.mp3
Woerter/31_Sahne.mp3
Woerter/32_kommt.mp3
Woerter/33_Keller.mp3
Woerter/34_Decke.mp3
Woerter/35_Stärke.mp3
Woerter/36_Strahl.mp3
Woerter/37_sonnt.mp3
Woerter/38_Kräne.mp3
Woerter/39_Beine.mp3
Woerter/40_Mäuse.mp3
Woerter/41_Sieb.mp3
Woerter/42_winzig.mp3
Woerter/43_Korb.mp3
Woerter/44_Weihnachtsbaum.mp3
Woerter/45_Video.mp3
Woerter/46_Nationalmannschaft.mp3
Woerter/47_Meer.mp3
Woerter/48_Bäche.mp3
Woerter/49_Strähne.mp3
Woerter/50_dort.mp3
Woerter/51_Feld.mp3
Woerter/52_Verdeck.mp3
Woerter/53_sind.mp3
}

dicN1 = TestDictation.create(name: "Wörter schreiben", info: "", short_info: "", len: items.size, time: 1200, subject: "Deutsch", construct: "Rechtschreibung", student_access:true, level:"Level nicht bestimmt")

it = dicN1.items.build(itemtext: "Hallo", difficulty: 0, mediapath: "/audio/Anweisungen/15_Hallo.mp3", itemtype:-4, itemview:"
<audio id='audioItem'></audio>
<p style='font-family: fibel_nordregular; font-size:60px' class='text-center'>
  „Hallo, ich bin Levumi, heute möchte ich gerne wissen, wie gut du schon schreiben kannst.
  Einige Wörter sind leicht, andere Wörter sind schwer. Bitte konzentriere dich und schreibe so gut,
  wie du kannst! Bitte drücke jetzt die Eingabetaste, damit du beginnen kannst.“
  <img style='float: right; width: 250px ' src='/images/Levumi-normal-blau.jpg'/>
</p>
<br />
<br />
<br />
<footer>
  <table align='center'>
    <tr>
      <th><div style='font-family: fibel_nordregular;font-size:60px'>Nochmal anhören: <span><img style='width: 50px' src='/images/Tastatur_PfeilLinks.png'/></span> /&nbsp;&nbsp;</div></th>
      <th><div style='font-family: fibel_nordregular;font-size:60px'>Weiter: <span><img style='width: 50px' src='/images/Tastatur_EingabetasteAlleine.png'/></span></div></th>
    </tr>
  </table>
</footer>
<script>
    var tempAudio = (document.getElementById('audioItem'));
    tempAudio.src = itemDataSound[studentData[currentItemIndex]];
    tempAudio.play();
    currentResult = currentResult + ',';
    $(window).keyup(function (event) {
        if(event.keyCode==37){
            tempAudio.pause();
            tempAudio.currentTime = 0;
            tempAudio.play();
        }
        else {
            $(window).unbind('keyup');
            nextItem();
        }})
</script>")
it.save
it = dicN1.items.build(itemtext: "Erklärung", difficulty: 0, mediapath: "/audio/Anweisungen/15_Erklaerung.mp3", itemtype:-3,itemview:"
<audio id='audioItem'></audio>
<p style='font-family: fibel_nordregular; font-size:60px' class='text-center'>
  „Zuerst lese ich dir einen Satz vor. Danach diktiere ich dir das Wort aus dem Satz,
  dass du schreiben sollst. Dann schreibst du das Wort auf der Tastatur.“
  <img style='float: right; width: 250px ' src='/images/Levumi-normal-blau.jpg'/>
</p>
<br />
<br />
<footer>
  <table align='center'>
    <tr>
      <th><div style='font-family: fibel_nordregular;font-size:60px'>Nochmal anhören: <span><img style='width: 50px' src='/images/Tastatur_PfeilLinks.png'/></span> /&nbsp;&nbsp;</div></th>
      <th><div style='font-family: fibel_nordregular;font-size:60px'>Weiter: <span><img style='width: 50px' src='/images/Tastatur_EingabetasteAlleine.png'/></span></div></th>
    </tr>
  </table>
</footer>
<script>
    var tempAudio = (document.getElementById('audioItem'));
    tempAudio.src = itemDataSound[studentData[currentItemIndex]];
    tempAudio.play(); currentResult = currentResult + ',';
    $(window).keyup(function (event) {
        if(event.keyCode==37){
            tempAudio.pause();
            tempAudio.currentTime = 0;
            tempAudio.play();
        }else if(event.keyCode == 13) {
            $(window).unbind('keyup');
            nextItem();
        }})
</script>")
it.save
it = dicN1.items.build(itemtext: "Löschen und Audio", difficulty: 0, mediapath: "/audio/Anweisungen/16_ErklaerungTeilB.mp3", itemtype:-2,  itemview:"
<audio id='audioItem'></audio>
<p style='font-family: fibel_nordregular; font-size:60px' class='text-center'>
  „Wenn du ein Wort falsch geschrieben hast, kannst du die Löschtaste benutzen und die Buchstaben löschen,
  damit du das Wort noch einmal schreiben kannst. Wenn du das Wort nicht verstanden hast, drücke die linke Pfeiltaste,
  dann lese ich dir noch einmal vor, was du schreiben sollst. Achte ganz genau darauf, ob ein Wort groß oder klein geschrieben wird.“
  <img style='float: right; width: 250px ' src='/images/Levumi-normal-blau.jpg'/>
</p>
<br />
<br />
<br />
<footer>
  <table align='center'>
    <tr>
      <th><div style='font-family: fibel_nordregular;font-size:60px'>Nochmal anhören: <span><img style='width: 50px' src='/images/Tastatur_PfeilLinks.png'/></span> /&nbsp;&nbsp;</div></th>
      <th><div style='font-family: fibel_nordregular;font-size:60px'>Weiter: <span><img style='width: 50px' src='/images/Tastatur_EingabetasteAlleine.png'/></span></div></th>
    </tr>
  </table>
</footer>
<script>
    var tempAudio = (document.getElementById('audioItem'));
    tempAudio.src = itemDataSound[studentData[currentItemIndex]];
    tempAudio.play();
    currentResult = currentResult + ',';
    $(window).keyup(function (event) {
        if(event.keyCode==37){
            tempAudio.pause();
            tempAudio.currentTime = 0;
            tempAudio.play();
        }else if(event.keyCode == 13) {
            $(window).unbind('keyup');
            nextItem();
        }})
</script>")
it.save
it = dicN1.items.build(itemtext: "Ich beginne", difficulty: 0, mediapath: "/audio/Anweisungen/19_ich_beginne.mp3", itemtype:-1, itemview:"
<audio id='audioItem'></audio>
<p style='font-family: fibel_nordregular; font-size:60px' class='text-center'>
  „Ich beginne nun dir die Wörter zu diktieren.“
  <img style='float: right; width: 250px ' src='/images/Levumi-normal-blau.jpg'/>
</p>
<br />
<br />
<br />
<footer>
  <table align='center'>
    <tr>
      <th><div style='font-family: fibel_nordregular;font-size:60px'>Nochmal anhören: <span><img style='width: 50px' src='/images/Tastatur_PfeilLinks.png'/></span> /&nbsp;&nbsp;</div></th>
      <th><div style='font-family: fibel_nordregular;font-size:60px'>Weiter: <span><img style='width: 50px' src='/images/Tastatur_EingabetasteAlleine.png'/></span></div></th>
    </tr>
  </table>
</footer>
<script>
    var tempAudio = (document.getElementById('audioItem'));
    tempAudio.src = itemDataSound[studentData[currentItemIndex]];
    tempAudio.play();
    currentResult = currentResult + ',';
    $(window).keyup(function (event) {
        if(event.keyCode==37){tempAudio.pause();
        tempAudio.currentTime = 0;
        tempAudio.play();
        }
        else if(event.keyCode == 13) {
            $(window).unbind('keyup');
            if (timeoutId != -1) {
                window.clearTimeout(timeoutId);
            }
            timeoutId = window.setTimeout(timedOut, workTime + 500);
            nextItem();
        }})
</script>")
it.save

i=0
while i<items.size do
  it = dicN1.items.build(itemtext: items[i], mediapath:"/audio/" + audios[i], difficulty: 0, itemtype:0, itemview:"
  <audio id='audioItem'></audio>
<p align='center'>
  <input style='font-family: fibel_nordregular; font-size:96px' id='answer' type='text' class='text-center' align='middle'>
</p>
<br />
<br />
<br />
<footer>
  <table align='center'>
    <tr>
      <th><div style='font-family: fibel_nordregular;font-size:60px'>Nochmal anhören: <span><img style='width: 50px' src='/images/Tastatur_PfeilLinks.png'/></span> /&nbsp;&nbsp;</div></th>
      <th><div style='font-family: fibel_nordregular;font-size:60px'>Weiter: <span><img style='width: 50px' src='/images/Tastatur_EingabetasteAlleine.png'/></span></div></th>
    </tr>
  </table>
</footer>
<script>
    var tempAudio = (document.getElementById('audioItem'));
    tempAudio.src = itemDataSound[studentData[currentItemIndex]];
    tempAudio.play();
    var tempAnswer = (document.getElementById('answer'));
    tempAnswer.focus();
    $(window).keyup(function (event) {
        if(event.keyCode==37){
            tempAudio.pause();
            tempAudio.currentTime = 0;
            tempAudio.play();
        }
        else if(event.keyCode == 13) {
            $(window).unbind('keyup');
            if(tempAnswer.value=='"+items[i]+"'){
                currentResult = currentResult + '1,';
            }
            else {
                currentResult = currentResult + '0,';
            };
            stopwatch = new Date() - stopwatch;
            currentTimes = currentTimes + stopwatch + ',';
            nextItem();
        }});
    $(tempAnswer).keydown(function (event) {
        var key = event.charCode || event.keyCode;
        if (key == 37||key == 38||key == 39||key == 40||key == 32||key ==27) {
            event.preventDefault();
        }});
</script>"
  )
  it.save
  i= i+1
end

it = dicN1.items.build(itemtext: "Ende", difficulty: 0, mediapath: "/audio/Anweisungen/16_Fertig.mp3", itemtype:1, itemview:"
<audio id='audioItem'></audio>
<p style='font-family: fibel_nordregular; font-size:60px' class='text-center'>
  „Nun bist du fertig, drücke zum Schluss die Eingabetaste.“<br/>
  <img style='width: 250px ' src='/images/Levumi-jubelt.gif'/>
</p>
<br />
<footer>
  <table align='center'>
    <tr>
      <th><div style='font-family: fibel_nordregular;font-size:60px'>Nochmal anhören: <span><img style='width: 50px' src='/images/Tastatur_PfeilLinks.png'/></span> /&nbsp;&nbsp;</div></th>
      <th><div style='font-family: fibel_nordregular;font-size:60px'>Beenden: <span><img style='width: 50px' src='/images/Tastatur_EingabetasteAlleine.png'/></span></div></th>
    </tr>
  </table>
</footer>
<script>
    var tempAudio = (document.getElementById('audioItem'));
    tempAudio.src = itemDataSound[studentData[studentData.length-1]];
    tempAudio.play();
    currentResult = currentResult + ',';
    $(window).keyup(function (event) {
        if(event.keyCode==37){
            tempAudio.pause();
            tempAudio.currentTime = 0;
            tempAudio.play();
        }
        else if (event.keyCode == 13 && lastPage) {
            $(window).unbind('keydown');
            $(window).unbind('keyup');
            (document.getElementById('closeButton')).click();
        }})
</script>")
it.save

dicN1.save