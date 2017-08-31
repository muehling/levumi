# -*- encoding : utf-8 -*-
items = %w{
Fahne
Flug
Keller
Kilo
Korb
Läuse
Mäuse
Platz
Sahne
sonnt
spüren
Teller
Zecke
über
backt
Beine
Decke
dort
einer
Feld
fliegen
geht
Geld
Zug
Truhe
Tee
spülen
seht
See
packt
Sieb
sind
Satz
kommt
Kino
Leine
Meer
Strahl
Moor
Verdeck
Stärke
winzig
Bäche
Kräne
bissig
fließen
stärken
Strähne
Versteck
Video
Weihnachtsbaum
Adventskranz
Nationalmannschaft
}

audios =%w{
Woerter/58a.mp3
Woerter/36a.mp3
Woerter/65a.mp3
Woerter/56a.mp3
Woerter/75a.mp3
Woerter/50a.mp3
Woerter/72a.mp3
Woerter/60a.mp3
Woerter/63a.mp3
Woerter/69a.mp3
Woerter/54a.mp3
Woerter/34a.mp3
Woerter/37a.mp3
Woerter/45a.mp3
Woerter/40a.mp3
Woerter/71a.mp3
Woerter/66a.mp3
Woerter/82a.mp3
Woerter/47a.mp3
Woerter/83a.mp3
Woerter/41a.mp3
Woerter/53a.mp3
Woerter/48a.mp3
Woerter/49a.mp3
Woerter/38a.mp3
Woerter/46a.mp3
Woerter/35a.mp3
Woerter/57a.mp3
Woerter/59a.mp3
Woerter/52a.mp3
Woerter/73a.mp3
Woerter/85a.mp3
Woerter/44a.mp3
Woerter/64a.mp3
Woerter/61a.mp3
Woerter/33a.mp3
Woerter/79a.mp3
Woerter/68a.mp3
Woerter/62a.mp3
Woerter/84a.mp3
Woerter/67a.mp3
Woerter/74a.mp3
Woerter/80a.mp3
Woerter/70a.mp3
Woerter/51a.mp3
Woerter/43a.mp3
Woerter/39a.mp3
Woerter/81a.mp3
Woerter/42a.mp3
Woerter/77a.mp3
Woerter/76a.mp3
Woerter/55a.mp3
Woerter/78a.mp3
}

dicN1 = TestDictation.create(name: "Wörter schreiben", info: "", short_info: "", len: items.size, time: 2400, subject: "Deutsch", construct: "Rechtschreibung", student_access:true, level: "Level 1", archive: false)


it = dicN1.items.build(itemtext: "Hallo", difficulty: 0, mediapath: {"audios"=>["/audio/Diktiertest/Anweisungen/23b.mp3"]}, itemtype:-5, itemview:"
<audio id='audioItem'></audio>
<p style='font-family: fibel_nordregular; font-size:60px' class='text-center'>
  „Hallo, ich bin Levumi, heute möchte ich gerne wissen, wie gut du schon schreiben kannst.
 Einige Wörter sind leicht, andere Wörter sind schwer. Bitte konzentriere dich und schreibe so gut,
 wie du kannst! Bitte drücke jetzt die Eingabetaste, damit du beginnen kannst.“
  <img id='talkingLevumi' style='float: right; width: 250px ' src='/images/LeVuMi_SprechenBlinzeln.gif'/>
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
    tempAudio.src = itemDataSound[studentData[currentStudent][currentItemIndex]][0];
    tempAudio.play();
    $(window).keyup(function (event) {
        if(event.keyCode==37){
            tempAudio.pause();
            tempAudio.currentTime = 0;
            tempLevumiPic.src ='/images/LeVuMi_SprechenBlinzeln.gif';
            tempAudio.play();
        }
        else {
            $(window).unbind('keyup');
            nextItem();
        }});
     var tempLevumiPic = (document.getElementById('talkingLevumi'));
     tempAudio.addEventListener('ended', function()
     {
          tempLevumiPic.src ='/images/Levumi-normal-blau.jpg';
     });
</script>")
it.save

it = dicN1.items.build(itemtext: "Erklärung", difficulty: 0, mediapath: {"audios"=>["/audio/Diktiertest/Anweisungen/24a.mp3"]}, itemtype:-4,itemview:"
<audio id='audioItem'></audio>
<p style='font-family: fibel_nordregular; font-size:60px' class='text-center'>
  „Zuerst lese ich dir einen Satz vor. Danach diktiere ich dir das Wort aus dem Satz,
 das du schreiben sollst. Dann schreibst du das Wort auf der Tastatur.“
  <img id='talkingLevumi' style='float: right; width: 250px ' src='/images/LeVuMi_SprechenBlinzeln.gif'/>
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
    tempAudio.src = itemDataSound[studentData[currentStudent][currentItemIndex]][0];
    tempAudio.play();
    $(window).keyup(function (event) {
        if(event.keyCode==37){
            tempAudio.pause();
            tempAudio.currentTime = 0;
            tempLevumiPic.src ='/images/LeVuMi_SprechenBlinzeln.gif';
            tempAudio.play();
        }else if(event.keyCode == 13) {
            $(window).unbind('keyup');
            nextItem();
        }});
     var tempLevumiPic = (document.getElementById('talkingLevumi'));
     tempAudio.addEventListener('ended', function()
     {
          tempLevumiPic.src ='/images/Levumi-normal-blau.jpg';
     });
</script>")
it.save


it = dicN1.items.build(itemtext: "Löschen und Audio", difficulty: 0, mediapath: {"audios"=>["/audio/Diktiertest/Anweisungen/25a.mp3"]}, itemtype:-3,  itemview:"
<audio id='audioItem'></audio>
<p style='font-family: fibel_nordregular; font-size:60px' class='text-center'>
  „Wenn du einen Buchstaben oder ein Wort löschen möchtest, benutze die Löschtaste.
Wenn du das Wort nicht verstanden hast, drücke die linke Pfeiltaste, dann lese ich dir noch einmal vor, was du schreiben sollst.“
  <img id='talkingLevumi' style='float: right; width: 250px ' src='/images/LeVuMi_SprechenBlinzeln.gif'/>
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
    tempAudio.src = itemDataSound[studentData[currentStudent][currentItemIndex]][0];
    tempAudio.play();
    $(window).keyup(function (event) {
        if(event.keyCode==37){
            tempAudio.pause();
            tempAudio.currentTime = 0;
            tempLevumiPic.src ='/images/LeVuMi_SprechenBlinzeln.gif';
            tempAudio.play();
        }else if(event.keyCode == 13) {
            $(window).unbind('keyup');
            nextItem();
        }});
     var tempLevumiPic = (document.getElementById('talkingLevumi'));
     tempAudio.addEventListener('ended', function()
     {
          tempLevumiPic.src ='/images/Levumi-normal-blau.jpg';
     });
</script>")
it.save
it = dicN1.items.build(itemtext: "Hinweis", difficulty: 0, mediapath: {"audios"=>["/audio/Diktiertest/Anweisungen/29a.mp3"]}, itemtype:-2,  itemview:"
<audio id='audioItem'></audio>
<p style='font-family: fibel_nordregular; font-size:60px' class='text-center'>
  „Achte ganz genau darauf, ob ein Wort groß oder klein geschrieben wird.“
  <img id='talkingLevumi' style='float: right; width: 250px ' src='/images/LeVuMi_SprechenBlinzeln.gif'/>
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
    tempAudio.src = itemDataSound[studentData[currentStudent][currentItemIndex]][0];
    tempAudio.play();
    $(window).keyup(function (event) {
        if(event.keyCode==37){
            tempAudio.pause();
            tempAudio.currentTime = 0;
            tempLevumiPic.src ='/images/LeVuMi_SprechenBlinzeln.gif';
            tempAudio.play();
        }else if(event.keyCode == 13) {
            $(window).unbind('keyup');
            nextItem();
        }});
     var tempLevumiPic = (document.getElementById('talkingLevumi'));
     tempAudio.addEventListener('ended', function()
     {
          tempLevumiPic.src ='/images/Levumi-normal-blau.jpg';
     });
</script>")
it.save

it = dicN1.items.build(itemtext: "Ich beginne", difficulty: 0, mediapath: {"audios"=>["/audio/Diktiertest/Anweisungen/32c.mp3"]}, itemtype:-1, itemview:"
<audio id='audioItem'></audio>
<p style='font-family: fibel_nordregular; font-size:60px' class='text-center'>
  „Ich beginne nun, dir die Wörter zu diktieren.“
  <img id='talkingLevumi' style='float: right; width: 250px ' src='/images/LeVuMi_SprechenBlinzeln.gif'/>
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
    tempAudio.src = itemDataSound[studentData[currentStudent][currentItemIndex]][0];
    tempAudio.play();
    $(window).keyup(function (event) {
        if(event.keyCode==37){tempAudio.pause();
        tempAudio.currentTime = 0;
        tempLevumiPic.src ='/images/LeVuMi_SprechenBlinzeln.gif';
        tempAudio.play();
        }
        else if(event.keyCode == 13) {
            $(window).unbind('keyup');
            if (timeoutId != -1) {
                window.clearTimeout(timeoutId);
            }
            timeoutId = window.setTimeout(timedOut, workTime + 500);
            nextItem();
        }});
     var tempLevumiPic = (document.getElementById('talkingLevumi'));
     tempAudio.addEventListener('ended', function()
     {
          tempLevumiPic.src ='/images/Levumi-normal-blau.jpg';
     });
</script>")
it.save

i=0
while i<items.size do
  it = dicN1.items.build(itemtext: items[i], mediapath:{"audios"=>["/audio/Diktiertest/" + audios[i]]}, difficulty: 0, itemtype:0, itemview:"
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
    tempAudio.src = itemDataSound[studentData[currentStudent][currentItemIndex]][0];
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
            actualAnswers = actualAnswers + tempAnswer.value + ',';
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

it = dicN1.items.build(itemtext: "Ende", difficulty: 0, mediapath: {"audios"=>["/audio/Diktiertest/Anweisungen/87a.mp3","/audio/Diktiertest/Anweisungen/88c.mp3","/audio/Diktiertest/Anweisungen/86b.mp3","/audio/Diktiertest/Anweisungen/86b.mp3"]}, itemtype:1, itemview:"
<audio id='audioItem'></audio>
<p id='evaluation' style='font-family: fibel_nordregular; font-size:60px' class='text-center'></p>
<br />
<p style='font-family: fibel_nordregular; font-size:60px' class='text-center'><img align='middle' id='talkingLevumi' style='width: 250px '/></p>
<br />
<br />
<footer>
  <table align='center'><tr><th><div style='font-family: fibel_nordregular;font-size:60px'>
    Nochmal anhören: <span><img style='width: 50px' src='/images/Tastatur_PfeilLinks.png'/></span>
    /&nbsp;&nbsp;
  </div>
  </th>
    <th>
      <div style='font-family: fibel_nordregular;font-size:60px'>
        Weiter: <span><img style='width: 50px' src='/images/Tastatur_EingabetasteAlleine.png'/></span>
      </div>
    </th>
  </tr>
  </table>
</footer>
<script>
    var tempAudio = (document.getElementById('audioItem'));
    var tempPic = (document.getElementById('talkingLevumi'));
    var soundFlag = 0;
    if (lastResults[currentStudent] >= 0 && lastResults[currentStudent] < currentResult.split('1').length){
        $('#evaluation').html('„Gut gemacht, du hast dich verbessert!“');
        tempPic.src = '/images/Levumi-jubelt.gif';
        tempAudio.src = itemDataSound[studentData[currentStudent][currentItemIndex]][0];
        soundFlag =0;
    }
    else if(lastResults[currentStudent] >= 0 && lastResults[currentStudent] == currentResult.split('1').length){
        $('#evaluation').html('„Du hast genauso viele Wörter richtig geschrieben, wie beim letzten Mal.“');
        tempPic.src = '/images/LeVuMi_Sprechen.gif';
        tempAudio.src = itemDataSound[studentData[currentStudent][currentItemIndex]][1];
        soundFlag =1;
    }
    else if(lastResults[currentStudent] == -1){
        $('#evaluation').html('„Nun bist du fertig, drücke zum Schluss die Eingabetaste.“');
        tempPic.src = '/images/Levumi-normal-blau.jpg';
        tempAudio.src = itemDataSound[studentData[currentStudent][currentItemIndex]][2];
        soundFlag =2;
    }
    else{
        $('#evaluation').html('„Beim letzten Mal hast du mehr Wörter richtig geschrieben.“');
        tempPic.src = '/images/Levumi-weiterlesen.gif';
        tempAudio.src = itemDataSound[studentData[currentStudent][currentItemIndex]][3];
        soundFlag =3;
    }


    tempAudio.play();
    currentResult = currentResult + '1,';
    $(window).keyup(function (event) {
        if(event.keyCode==37){
            tempAudio.pause();
            tempAudio.currentTime = 0;
            if(soundFlag==0)
                tempLevumiPic.src ='/images/Levumi-jubelt.gif';
            else if(soundFlag==1)
                tempPic.src = '/images/Levumi-normal-blau.jpg';
            else if(soundFlag==2)
                tempPic.src = '/images/LeVuMi_Sprechen.gif';
            else
                tempPic.src = '/images/Levumi-weiterlesen.gif';

            tempAudio.play();
        }
        else if(event.keyCode == 13) {
            $(window).unbind('keyup');
            window.location.replace(pathMainPage);
        }});

    var tempLevumiPic = (document.getElementById('talkingLevumi'));
    tempAudio.addEventListener('ended', function() {
        tempLevumiPic.src ='/images/Levumi-normal-blau.jpg';
    });")
it.save

dicN1.save