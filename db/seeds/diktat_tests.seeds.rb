# -*- encoding : utf-8 -*-
items = %w{
Leine
Woerter/1_Leine.mp3
Teller
Woerter/2_Teller.mp3
spülen
Woerter/3_spülen.mp3
Flug
Woerter/4_Flug.mp3
Zecke
Woerter/5_Zecke.mp3
Truhe
Woerter/6_Truhe.mp3
stärken
Woerter/7_stärken.mp3
backt
Woerter/8_backt.mp3
fliegen
Woerter/9_fliegen.mp3
Versteck
Woerter/10_Versteck.mp3
fließen
Woerter/11_fließen.mp3
Satz
Woerter/12_Satz.mp3
über
Woerter/13_über.mp3
Tee
Woerter/14_Tee.mp3
einer
Woerter/15_einer.mp3
Geld
Woerter/16_Geld.mp3
Zug
Woerter/17_Zug.mp3
Läuse
Woerter/18_Läuse.mp3
bissig
Woerter/19_bissig.mp3
packt
Woerter/20_packt.mp3
geht
Woerter/21_geht.mp3
spüren
Woerter/22_spüren.mp3
Adventskranz
Woerter/23_Adventskranz.mp3
Kilo
Woerter/24_Kilo.mp3
seht
Woerter/25_seht.mp3
Fahne
Woerter/26_Fahne.mp3
See
Woerter/27_See.mp3
Platz
Woerter/28_Platz.mp3
Kino
Woerter/29_Kino.mp3
Moor
Woerter/30_Moor.mp3
Sahne
Woerter/31_Sahne.mp3
kommt
Woerter/32_kommt.mp3
Keller
Woerter/33_Keller.mp3
Decke
Woerter/34_Decke.mp3
Stärke
Woerter/35_Stärke.mp3
Strahl
Woerter/36_Strahl.mp3
sonnt
Woerter/37_sonnt.mp3
Kräne
Woerter/38_Kräne.mp3
Beine
Woerter/39_Beine.mp3
Mäuse
Woerter/40_Mäuse.mp3
Sieb
Woerter/41_Sieb.mp3
winzig
Woerter/42_winzig.mp3
Korb
Woerter/43_Korb.mp3
Weihnachtsbaum
Woerter/44_Weihnachtsbaum.mp3
Video
Woerter/45_Video.mp3
Nationalmannschaft
Woerter/46_Nationalmannschaft.mp3
Meer
Woerter/47_Meer.mp3
Bäche
Woerter/48_Bäche.mp3
Strähne
Woerter/49_Strähne.mp3
dort
Woerter/50_dort.mp3
Feld
Woerter/51_Feld.mp3
Verdeck
Woerter/52_Verdeck.mp3
sind
Woerter/53_sind.mp3
}

dicN1 = TestDictation.create(name: "Wörter schreiben", info: "", short_info: "", len: items.size/2+5, time: 1200, subject: "Deutsch", construct: "Rechtschreibung", student_access:true, level:"Level nicht bestimmt")

it = dicN1.items.build(itemtext: "Hallo", difficulty: 0, itemtype: -4, audiopath: "Anweisungen/15_Hallo.mp3", itemview:"
<audio id='audioItem'></audio>
<p style='font-family: fibel_nordregular; font-size:60px' class='text-center'>
  „Hallo, ich bin Levumi, heute möchte ich gerne wissen, wie gut du schon schreiben kannst.
  Einige Wörter sind leicht, andere Wörter sind schwer. Bitte konzentriere dich und schreibe so gut,
  wie du kannst! Bitte drücke jetzt irgendeine Taste auf der Tastatur, damit du beginnen kannst.“
  <img style='float: right; width: 250px ' src='/assets/Levumi-normal-blau.jpg'/>
</p>
<br />
<br />
<br />
<footer>
  <table align='center'>
    <tr>
      <th><div style='font-family: fibel_nordregular;font-size:60px'>Nochmal anhören: <span><img style='width: 50px' src='/assets/Tastatur_PfeilLinks.png'/></span> /&nbsp;&nbsp;</div></th>
      <th><div style='font-family: fibel_nordregular;font-size:60px'>Weiter: Irgendeine Taste</div></th>
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
it = dicN1.items.build(itemtext: "Erklärung", difficulty: 0, itemtype: -3, audiopath: "Anweisungen/15_Erklärung.mp3",itemview:"
<audio id='audioItem'></audio>
<p style='font-family: fibel_nordregular; font-size:60px' class='text-center'>
  „Zuerst lese ich dir einen Satz vor. Danach diktiere ich dir das Wort aus dem Satz,
  dass du schreiben sollst. Dann schreibst du das Wort auf der Tastatur.“
  <img style='float: right; width: 250px ' src='/assets/Levumi-normal-blau.jpg'/>
</p>
<br />
<br />
<footer>
  <table align='center'>
    <tr>
      <th><div style='font-family: fibel_nordregular;font-size:60px'>Nochmal anhören: <span><img style='width: 50px' src='/assets/Tastatur_PfeilLinks.png'/></span> /&nbsp;&nbsp;</div></th>
      <th><div style='font-family: fibel_nordregular;font-size:60px'>Weiter: <span><img style='width: 50px' src='/assets/Tastatur_EingabetasteAlleine.png'/></span></div></th>
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
it = dicN1.items.build(itemtext: "Löschen und Audio", difficulty: 0, itemtype: -2, audiopath: "Anweisungen/16_ErklärungTeilB.mp3",  itemview:"
<audio id='audioItem'></audio>
<p style='font-family: fibel_nordregular; font-size:60px' class='text-center'>
  „Wenn du ein Wort falsch geschrieben hast, kannst du die Löschtaste benutzen und die Buchstaben löschen,
  damit du das Wort noch einmal schreiben kannst. Wenn du das Wort nicht verstanden hast, drücke die linke Pfeiltaste,
  dann lese ich dir noch einmal vor, was du schreiben sollst. Achte ganz genau darauf, ob ein Wort groß oder klein geschrieben wird.“
  <img style='float: right; width: 250px ' src='/assets/Levumi-normal-blau.jpg'/>
</p>
<br />
<br />
<br />
<footer>
  <table align='center'>
    <tr>
      <th><div style='font-family: fibel_nordregular;font-size:60px'>Nochmal anhören: <span><img style='width: 50px' src='/assets/Tastatur_PfeilLinks.png'/></span> /&nbsp;&nbsp;</div></th>
      <th><div style='font-family: fibel_nordregular;font-size:60px'>Weiter: <span><img style='width: 50px' src='/assets/Tastatur_EingabetasteAlleine.png'/></span></div></th>
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
it = dicN1.items.build(itemtext: "Ich beginne", difficulty: 0, itemtype: -1, audiopath: "Anweisungen/19_ich_beginne.mp3", itemview:"
<audio id='audioItem'></audio>
<p style='font-family: fibel_nordregular; font-size:60px' class='text-center'>
  „Ich beginne nun dir die Wörter zu diktieren:“
  <img style='float: right; width: 250px ' src='/assets/Levumi-normal-blau.jpg'/>
</p>
<br />
<br />
<br />
<footer>
  <table align='center'>
    <tr>
      <th><div style='font-family: fibel_nordregular;font-size:60px'>Nochmal anhören: <span><img style='width: 50px' src='/assets/Tastatur_PfeilLinks.png'/></span> /&nbsp;&nbsp;</div></th>
      <th><div style='font-family: fibel_nordregular;font-size:60px'>Weiter: <span><img style='width: 50px' src='/assets/Tastatur_EingabetasteAlleine.png'/></span></div></th>
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
  it = dicN1.items.build(itemtext: items[i], audiopath:items[i+1], itemtype: 0, difficulty: 0, itemview:"
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
      <th><div style='font-family: fibel_nordregular;font-size:60px'>Nochmal anhören: <span><img style='width: 50px' src='/assets/Tastatur_PfeilLinks.png'/></span> /&nbsp;&nbsp;</div></th>
      <th><div style='font-family: fibel_nordregular;font-size:60px'>Weiter: <span><img style='width: 50px' src='/assets/Tastatur_EingabetasteAlleine.png'/></span></div></th>
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
  i= i+2
end

it = dicN1.items.build(itemtext: "Ende", difficulty: 0, audiopath: "Anweisungen/20_geschafft.mp3", itemtype:1, itemview:"
<audio id='audioItem'></audio>
<p style='font-family: fibel_nordregular; font-size:60px' class='text-center'>
  „Toll jetzt hast du es geschafft.
  <br/>Zum Beenden des Programms drücke bitte die Eingabetaste.“<br/>
  <img style='width: 250px ' src='/assets/Levumi-jubelt.gif'/>
</p>
<br />
<footer>
  <table align='center'>
    <tr>
      <th><div style='font-family: fibel_nordregular;font-size:60px'>Nochmal anhören: <span><img style='width: 50px' src='/assets/Tastatur_PfeilLinks.png'/></span> /&nbsp;&nbsp;</div></th>
      <th><div style='font-family: fibel_nordregular;font-size:60px'>Beenden: <span><img style='width: 50px' src='/assets/Tastatur_EingabetasteAlleine.png'/></span></div></th>
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