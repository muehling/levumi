# -*- encoding : utf-8 -*-
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

u = User.create(email: "test@test.com", password: "123", password_confirmation: "123", capabilities: "admin")
g = u.groups.build(name: "10a")
g.save
s = g.students.build(name: "Adam")
s.save
s = g.students.build(name: "Eva")
s.save

t = TestSpeed.create(name: "Lesetest", len: 4, info: "Lesetest für die Grundschule, 1. Klasse", short_info:  "Lesetest für die Grundschule, 1. Klasse",
                     subject: "Deutsch", construct: "Lesen", archive: false, level: "Level 0", time: 60)
i = t.items.build(itemtext: "haha", difficulty: 0.1)
i.save
i = t.items.build(itemtext: "hoha", difficulty: 0.4)
i.save
i = t.items.build(itemtext: "huho", difficulty: 0.7)
i.save
i = t.items.build(itemtext: "laho", difficulty: 0.9)
i.save

a = g.assessments.build(test_id: t.id)
a.save

m = a.measurements.build(date: Date.yesterday)
m.save


m = a.measurements.build(date: Date.today)
m.save


m = a.measurements.build(date: Date.tomorrow)
m.save





t = TestKeyboard.create(name: "Tastaturschulung",len: 26, info: "Tastartur für die Grundschule, 1. Klasse", short_info:
    "Tastarturtest für die Grundschule, 1. Klasse", subject: "Deutsch", construct: "Schreiben", archive: false, level: "Level 0", time: 60, student_access:true)
i = t.items.build(itemtext: "Hallo", difficulty: 0.1, audiopath: "/assets/Anweisungen/15_Hallo.mp3", itemview:"<audio id='audioItem' src='/assets/Anweisungen/1_Hallo_ich_bin_Levumi.mp3'></audio><p style='font-family: fibel_nordregular; font-size:60px' class='text-center'>„Hallo ich bin Levumi. Ich möchte heute mit dir üben, auf der Tastatur von einem Computer zu schreiben. Bitte höre mir ganz genau zu, damit du weisst, was du tun sollst. Bitte drücke jetzt irgendeine Taste auf der Tastatur, damit wir beginnen können.“<img style='float: right; width: 250px ' src='/assets/Levumi-normal-blau.jpg'/></p><br /><br /><br /><footer><table align='center'><tr><th><div style='font-family: fibel_nordregular;font-size:60px'>Nochmal anhören: <span><img style='width: 50px' src='/assets/Tastatur_PfeilLinks.png'/></span> /&nbsp;&nbsp;</div></th><th><div style='font-family: fibel_nordregular;font-size:60px'>Weiter: Irgendeine Taste</div></th></tr></table></footer><script>var tempAudio = (document.getElementById('audioItem')); tempAudio.play(); currentResult = currentResult + ',';$(window).keyup(function (event) {if(event.keyCode==37){tempAudio.pause(); tempAudio.currentTime = 0; tempAudio.play();}else {$(window).unbind('keyup'); nextItem();}})</script>")
i.save
i = t.items.build(itemtext: "Eingabetaste", difficulty: 0.2, audiopath: "/assets/Anweisungen/1_Eingabetaste.mp3",itemview:"<audio id='audioItem' src='/assets/Anweisungen/1_Eingabetaste.mp3'></audio><p style='font-family: fibel_nordregular; font-size:60px' class='text-center'>„Um zur nächsten Aufgabe zu kommen, drücke die Eingabetaste. Auf dem Bild siehst du, wo sie zu finden ist. Probiere sie jetzt aus.“<img style='float: right; width: 250px ' src='/assets/Levumi-normal-blau.jpg'/><br /><img style='width: 650px;margin-left: 125px' src='/assets/Tastatur_Eingabetaste.png'/></p><br /><br /><footer><table align='center'><tr><th><div style='font-family: fibel_nordregular;font-size:60px'>Nochmal anhören: <span><img style='width: 50px' src='/assets/Tastatur_PfeilLinks.png'/></span> /&nbsp;&nbsp;</div></th><th><div style='font-family: fibel_nordregular;font-size:60px'>Weiter: <span><img style='width: 50px' src='/assets/Tastatur_EingabetasteAlleine.png'/></span></div></th></tr></table></footer><script>var tempAudio = (document.getElementById('audioItem')); tempAudio.play(); currentResult = currentResult + ','; $(window).keyup(function (event) {if(event.keyCode==37){tempAudio.pause(); tempAudio.currentTime = 0; tempAudio.play();}else if(event.keyCode == 13) {$(window).unbind('keyup'); nextItem(); }})</script>")
i.save
i = t.items.build(itemtext: "Kopfhörer", difficulty: 0.1, audiopath: "/assets/Anweisungen/2_Kopfhörer.mp3",itemview:"<audio id='audioItem' src='/assets/Anweisungen/2_Kopfhörer.mp3'></audio><p style='font-family: fibel_nordregular; font-size:60px' class='text-center'>„Hier siehst du auf dem Bild einen Kopfhörer. Immer, wenn du den Kopfhörer siehst, musst du gut zuhören, damit du genau weißt, was du tun sollst.“<img style='float: right; width: 250px ' src='/assets/Levumi-normal-blau.jpg'/><br /><img style='width: 150px;margin-left: 125px' src='/assets/headphones.png'/></p><br /><br /><footer><table align='center'><tr><th><div style='font-family: fibel_nordregular;font-size:60px'>Nochmal anhören: <span><img style='width: 50px' src='/assets/Tastatur_PfeilLinks.png'/></span> /&nbsp;&nbsp;</div></th><th><div style='font-family: fibel_nordregular;font-size:60px'>Weiter: <span><img style='width: 50px' src='/assets/Tastatur_EingabetasteAlleine.png'/></span></div></th></tr></table></footer><script>var tempAudio = (document.getElementById('audioItem')); tempAudio.play(); currentResult = currentResult + ','; $(window).keyup(function (event) {if(event.keyCode==37){tempAudio.pause(); tempAudio.currentTime = 0; tempAudio.play();}else if(event.keyCode == 13) {$(window).unbind('keyup'); nextItem(); }})</script>")
i.save
i = t.items.build(itemtext: "Tastatur", difficulty: 0.1, audiopath: "/assets/Anweisungen/3_Tastatur.mp3",itemview:"<audio id='audioItem' src='/assets/Anweisungen/3_Tastatur.mp3'></audio><p style='font-family: fibel_nordregular; font-size:60px' class='text-center'>„Das Bild mit der Tastatur zeigt dir, wann du etwas mit der Tastatur eingeben sollst.“<img style='float: right; width: 250px ' src='/assets/Levumi-normal-blau.jpg'/><br /><img style='width: 150px;margin-left: 125px' src='/assets/tastartur.png'/></p><br /><br /><footer><table align='center'><tr><th><div style='font-family: fibel_nordregular;font-size:60px'>Nochmal anhören: <span><img style='width: 50px' src='/assets/Tastatur_PfeilLinks.png'/></span> /&nbsp;&nbsp;</div></th><th><div style='font-family: fibel_nordregular;font-size:60px'>Weiter: <span><img style='width: 50px' src='/assets/Tastatur_EingabetasteAlleine.png'/></span></div></th></tr></table></footer><script>var tempAudio = (document.getElementById('audioItem')); tempAudio.play(); currentResult = currentResult + ','; $(window).keyup(function (event) {if(event.keyCode==37){tempAudio.pause(); tempAudio.currentTime = 0; tempAudio.play();}else if(event.keyCode == 13) {$(window).unbind('keyup'); nextItem(); }})</script>")
i.save
i = t.items.build(itemtext: "Ton wiederholen", difficulty: 0.1, audiopath: "/assets/Anweisungen/6_Wiederholen.mp3",itemview:"<audio id='audioItem' src='/assets/Anweisungen/6_Wiederholen.mp3'></audio><p style='font-family: fibel_nordregular; font-size:60px' class='text-center'>„Wenn ich dir den Satz noch einmal vorlesen soll, drücke die linke Pfeiltaste. Auf dem Bild siehst du, dass sich diese Taste unten rechts befindet!“<img style='float: right; width: 250px ' src='/assets/Levumi-normal-blau.jpg'/><br /><img style='width: 650px;margin-left: 125px' src='/assets/Tastatur_Pfeil.png'/></p><br /><br /><footer><table align='center'><tr><th><div style='font-family: fibel_nordregular;font-size:60px'>Nochmal anhören: <span><img style='width: 50px' src='/assets/Tastatur_PfeilLinks.png'/></span> /&nbsp;&nbsp;</div></th><th><div style='font-family: fibel_nordregular;font-size:60px'>Weiter: <span><img style='width: 50px' src='/assets/Tastatur_EingabetasteAlleine.png'/></span></div></th></tr></table></footer><script>var tempAudio = (document.getElementById('audioItem')); tempAudio.play(); currentResult = currentResult + ','; $(window).keyup(function (event) {if(event.keyCode==37){tempAudio.pause(); tempAudio.currentTime = 0; tempAudio.play();}else if(event.keyCode == 13) {$(window).unbind('keyup'); nextItem(); }})</script>")
i.save
i = t.items.build(itemtext: "Umlaute", difficulty: 0.2, audiopath: "/assets/Anweisungen/5_Umlaute1Und2Und3.mp3",itemview:"<audio id='audioItem' src='/assets/Anweisungen/5_Umlaute1Und2Und3.mp3'></audio><p style='font-family: fibel_nordregular; font-size:60px' class='text-center'>„ä, ü, ö sind Umlaute, bestimmt kennst du diese Buchstaben. Auf der Tastatur findest du sie auf der rechten Seite. Auf dem Bild siehst du, wo du die Buchstaben auf der Tastatur sind. <br />Bitte drücke jetzt das ä, ü oder ö.“<img style='float: right; width: 250px ' src='/assets/Levumi-normal-blau.jpg'/><br /><img style='width: 650px;margin-left: 125px' src='/assets/Tastatur_Umlaute.png'/></p><br /><br /><footer><table align='center'><tr><th><div style='font-family: fibel_nordregular;font-size:60px'>Nochmal anhören: <span><img style='width: 50px' src='/assets/Tastatur_PfeilLinks.png'/></span> /&nbsp;&nbsp;</div></th><th><div style='font-family: fibel_nordregular;font-size:60px'>Weiter: ä, ü oder ö</div></th></tr></table></footer><script>var tempAudio = (document.getElementById('audioItem')); tempAudio.play(); currentResult = currentResult + ','; $(window).keyup(function (event) {if(event.keyCode==37){tempAudio.pause(); tempAudio.currentTime = 0; tempAudio.play();}else if(event.keyCode == 0||event.keyCode == 186||event.keyCode == 192||event.keyCode == 222) {$(window).unbind('keyup'); nextItem(); }})</script>")
i.save
i = t.items.build(itemtext: "Umlaute Aufgabenstellung", difficulty: 0.1, audiopath: "/assets/Anweisungen/6_Umlaute3.mp3",itemview:"<audio id='audioItem' src='/assets/Anweisungen/6_Umlaute3.mp3'></audio><p style='font-family: fibel_nordregular; font-size:60px' class='text-center'>„In den folgenden Wörtern fehlen die Umlaute. Kannst du mir bitte helfen, diese wieder einzufügen? Bitte ergänze jetzt für mich die fehlenden Umlaute.“<img style='float: right; width: 250px ' src='/assets/Levumi-normal-blau.jpg'/><br /><img style='float: left; width: 150px;margin-left: 125px' src='/assets/headphones.png'/></p><br /><br /><footer><table align='center'><tr><th><div style='font-family: fibel_nordregular;font-size:60px'>Nochmal anhören: <span><img style='width: 50px' src='/assets/Tastatur_PfeilLinks.png'/></span> /&nbsp;&nbsp;</div></th><th><div style='font-family: fibel_nordregular;font-size:60px'>Weiter: <span><img style='width: 50px' src='/assets/Tastatur_EingabetasteAlleine.png'/></span></div></th></tr></table></footer><script>var tempAudio = (document.getElementById('audioItem')); tempAudio.play(); currentResult = currentResult + ','; $(window).keyup(function (event) {if(event.keyCode==37){tempAudio.pause(); tempAudio.currentTime = 0; tempAudio.play();}else if(event.keyCode == 13) {$(window).unbind('keyup'); nextItem(); }})</script>")
i.save
i = t.items.build(itemtext: "Umlaute Aufgabe1", difficulty: 0.3, audiopath: "/assets/Anweisungen/6_Umlaute4.mp3",itemview:"<audio id='audioItem' src='/assets/Anweisungen/6_Umlaute4.mp3'></audio><p style='font-family: fibel_nordregular; font-size:60px' class='text-center'>„Bitte ergänze jetzt für mich die fehlenden Umlaute.“<img style='float: right; width: 250px ' src='/assets/Levumi-normal-blau.jpg'/><br /><img style='float: left; width: 150px;margin-left: 125px' src='/assets/headphones.png'/><br /><br /><img style='float: left; width: 150px;margin-left: 125px' src='/assets/tastartur.png'/></p><p style='font-family: fibel_nordregular; font-size:96px;margin-right:280px' type='text' class='text-center' align='middle'>B<span style='background-color:#FFFF00'>ä</span>ume</p><p style='font-family: fibel_nordregular; font-size:96px' type='text' class='text-center' align='middle'>B<input style='font-family: fibel_nordregular;padding-bottom: 10px; line-height: 50px; width: 50px; font-size:96px' id='answer' type='text' class='text-center' align='middle'>ume</p><br /><br /><footer><table align='center'><tr><th><div style='font-family: fibel_nordregular;font-size:60px'>Nochmal anhören: <span><img style='width: 50px' src='/assets/Tastatur_PfeilLinks.png'/></span> /&nbsp;&nbsp;</div></th><th><div style='font-family: fibel_nordregular;font-size:60px'>Weiter: <span><img style='width: 50px' src='/assets/Tastatur_EingabetasteAlleine.png'/></span></div></th></tr></table></footer><script>var tempAudio = (document.getElementById('audioItem'));var tempAnswer = (document.getElementById('answer'));tempAnswer.focus();$(tempAnswer).css('border','0px').css('border-bottom', 'black solid 1px').attr('maxlength', '1').attr('size','1').val('');;currentResult = currentResult + ',';$(window).keyup(function (event) {if(event.keyCode==37){tempAudio.pause();tempAudio.currentTime = 0;tempAudio.play();} else if(event.keyCode == 13 && tempAnswer.value == 'ä') {$(window).unbind('keyup');nextItem();}}); $(tempAnswer).keydown(function (event) {var key = event.charCode || event.keyCode;if (key == 37||key == 38||key == 39||key == 40||key == 32||key ==27) {event.preventDefault();}})</script>");
i.save
i = t.items.build(itemtext: "Umlaute Aufgabe2", difficulty: 0.3, audiopath: "/assets/Anweisungen/6_Umlaute4.mp3",itemview:"<audio id='audioItem' src='/assets/Anweisungen/6_Umlaute4.mp3'></audio><p style='font-family: fibel_nordregular; font-size:60px' class='text-center'>„Bitte ergänze jetzt für mich die fehlenden Umlaute.“<img style='float: right; width: 250px ' src='/assets/Levumi-normal-blau.jpg'/><br /><img style='float: left; width: 150px;margin-left: 125px' src='/assets/headphones.png'/><br /><br /><img style='float: left; width: 150px;margin-left: 125px' src='/assets/tastartur.png'/></p><p style='font-family: fibel_nordregular; font-size:96px;margin-right:280px' type='text' class='text-center' align='middle'>Schl<span style='background-color:#FFFF00'>ö</span>sser</p><p style='font-family: fibel_nordregular; font-size:96px' type='text' class='text-center' align='middle'>Schl<input style='font-family: fibel_nordregular;padding-bottom: 10px; line-height: 50px; width: 50px; font-size:96px' id='answer' type='text' class='text-center' align='middle'>sser</p><br /><br /><footer><table align='center'><tr><th><div style='font-family: fibel_nordregular;font-size:60px'>Nochmal anhören: <span><img style='width: 50px' src='/assets/Tastatur_PfeilLinks.png'/></span> /&nbsp;&nbsp;</div></th><th><div style='font-family: fibel_nordregular;font-size:60px'>Weiter: <span><img style='width: 50px' src='/assets/Tastatur_EingabetasteAlleine.png'/></span></div></th></tr></table></footer><script>var tempAudio = (document.getElementById('audioItem'));var tempAnswer = (document.getElementById('answer'));tempAnswer.focus();$(tempAnswer).css('border','0px').css('border-bottom', 'black solid 1px').attr('maxlength', '1').attr('size','1').val('');;currentResult = currentResult + ',';$(window).keyup(function (event) {if(event.keyCode==37){tempAudio.pause();tempAudio.currentTime = 0;tempAudio.play();} else if(event.keyCode == 13 && tempAnswer.value == 'ö') {$(window).unbind('keyup');nextItem();}}); $(tempAnswer).keydown(function (event) {var key = event.charCode || event.keyCode;if (key == 37||key == 38||key == 39||key == 40||key == 32||key ==27) {event.preventDefault();}})</script>");
i.save
i = t.items.build(itemtext: "Umlaute Aufgabe3", difficulty: 0.3, audiopath: "/assets/Anweisungen/6_Umlaute4.mp3",itemview:"<audio id='audioItem' src='/assets/Anweisungen/6_Umlaute4.mp3'></audio><p style='font-family: fibel_nordregular; font-size:60px' class='text-center'>„Bitte ergänze jetzt für mich die fehlenden Umlaute.“<img style='float: right; width: 250px ' src='/assets/Levumi-normal-blau.jpg'/><br /><img style='float: left; width: 150px;margin-left: 125px' src='/assets/headphones.png'/><br /><br /><img style='float: left; width: 150px;margin-left: 125px' src='/assets/tastartur.png'/></p><p style='font-family: fibel_nordregular; font-size:96px;margin-right:280px' type='text' class='text-center' align='middle'>s<span style='background-color:#FFFF00'>ü</span>ß</p><p style='font-family: fibel_nordregular; font-size:96px' type='text' class='text-center' align='middle'>s<input style='font-family: fibel_nordregular;padding-bottom: 10px; line-height: 50px; width: 50px; font-size:96px' id='answer' type='text' class='text-center' align='middle'>ß</p><br /><br /><footer><table align='center'><tr><th><div style='font-family: fibel_nordregular;font-size:60px'>Nochmal anhören: <span><img style='width: 50px' src='/assets/Tastatur_PfeilLinks.png'/></span> /&nbsp;&nbsp;</div></th><th><div style='font-family: fibel_nordregular;font-size:60px'>Weiter: <span><img style='width: 50px' src='/assets/Tastatur_EingabetasteAlleine.png'/></span></div></th></tr></table></footer><script>var tempAudio = (document.getElementById('audioItem'));var tempAnswer = (document.getElementById('answer'));tempAnswer.focus();$(tempAnswer).css('border','0px').css('border-bottom', 'black solid 1px').attr('maxlength', '1').attr('size','1').val('');;currentResult = currentResult + ',';$(window).keyup(function (event) {if(event.keyCode==37){tempAudio.pause();tempAudio.currentTime = 0;tempAudio.play();} else if(event.keyCode == 13 && tempAnswer.value == 'ü') {$(window).unbind('keyup');nextItem();}}); $(tempAnswer).keydown(function (event) {var key = event.charCode || event.keyCode;if (key == 37||key == 38||key == 39||key == 40||key == 32||key ==27) {event.preventDefault();}})</script>");
i.save
i = t.items.build(itemtext: "Löschtaste", difficulty: 0.2, audiopath: "/assets/Anweisungen/7_Löschtaste.mp3",itemview:"<audio id='audioItem' src='/assets/Anweisungen/7_Löschtaste.mp3'></audio><p style='font-family: fibel_nordregular; font-size:60px' class='text-center'>„Bestimmt hast du schon einmal an einem Computer etwas geschrieben, das du wieder löschen wolltest. Dafür benutzt man die Löschtaste. Auf dem Bild kannst du erkennen, wo du die Taste findest. Bitte drücke jetzt die Löschtaste auf der Tastatur.“<img style='float: right; width: 250px ' src='/assets/Levumi-normal-blau.jpg'/><br /><img style='width: 650px;margin-left: 125px' src='/assets/Tastatur_Backspace.png'/></p><br /><br /><footer><table align='center'><tr><th><div style='font-family: fibel_nordregular;font-size:60px'>Nochmal anhören: <span><img style='width: 50px' src='/assets/Tastatur_PfeilLinks.png'/></span> /&nbsp;&nbsp;</div></th><th><div style='font-family: fibel_nordregular;font-size:60px'>Weiter: Löschtaste</div></th></tr></table></footer><script>var tempAudio = (document.getElementById('audioItem')); tempAudio.play(); currentResult = currentResult + ','; $(window).keyup(function (event) {if(event.keyCode==37){tempAudio.pause(); tempAudio.currentTime = 0; tempAudio.play();}else if(event.keyCode == 8) {$(window).unbind('keyup'); nextItem(); }})</script>")
i.save
i = t.items.build(itemtext: "Löschaufgabe", difficulty: 0.3, audiopath: "/assets/Anweisungen/12_Löschaufgabe.mp3",itemview:"<audio id='audioItem' src='/assets/Anweisungen/12_Löschaufgabe.mp3'></audio><p style='font-family: fibel_nordregular; font-size:60px' class='text-center'>„Jetzt brauche ich deine Hilfe. Ich habe einen Satz geschrieben und möchte diesen wieder löschen. Bitte benutze die Löschtaste und lösche alle Buchstaben für mich.“<img style='float: right; width: 250px ' src='/assets/Levumi-normal-blau.jpg'/><br /><img style='float: left; width: 150px;margin-left: 125px' src='/assets/headphones.png'/><br /><br /><img style='float: left; width: 150px;margin-left: 125px' src='/assets/tastartur.png'/><input style='font-family: fibel_nordregular; font-size:96px;margin-right:250px' id='answer' type='text' class='text-center' align='middle'></p><br /><br /><footer><table align='center'><tr><th><div style='font-family: fibel_nordregular;font-size:60px'>Nochmal anhören: <span><img style='width: 50px' src='/assets/Tastatur_PfeilLinks.png'/></span> /&nbsp;&nbsp;</div></th><th><div style='font-family: fibel_nordregular;font-size:60px'>Weiter: <span><img style='width: 50px' src='/assets/Tastatur_EingabetasteAlleine.png'/></span></div></th></tr></table></footer><script>var tempAudio = (document.getElementById('audioItem'));tempAudio.play();var tempAnswer = (document.getElementById('answer'));tempAnswer.focus();$(tempAnswer).css('border','0px').css('border-bottom', 'black solid 1px').attr('maxlength', '28').attr('size','28').val('Bitte lösche alle Buchstaben');currentResult = currentResult + ',';$(window).keyup(function (event) {if(event.keyCode==37){tempAudio.pause();tempAudio.currentTime = 0;tempAudio.play();} else if(event.keyCode == 13 && tempAnswer.value == '') {$(window).unbind('keyup');nextItem();}}); $(tempAnswer).keydown(function (event) {var key = event.charCode || event.keyCode;if (key == 37||key == 38||key == 39||key == 40||key == 32||key ==27) {event.preventDefault();}})</script>");
i.save
i = t.items.build(itemtext: "ß", difficulty: 0.2, audiopath: "/assets/Anweisungen/9_ß.mp3",itemview:"<audio id='audioItem' src='/assets/Anweisungen/9_ß.mp3'></audio><p style='font-family: fibel_nordregular; font-size:60px' class='text-center'>„Nun geht es um einen Buchstaben, den es nur im Deutschen gibt, das ß. Es hat sich oben rechts versteckt. Drücke bitte die Taste für das ß auf der Tastatur“<img style='float: right; width: 250px ' src='/assets/Levumi-normal-blau.jpg'/><br /><img style='width: 650px;margin-left: 125px' src='/assets/Tastatur_ß.png'/></p><br /><br /><footer><table align='center'><tr><th><div style='font-family: fibel_nordregular;font-size:60px'>Nochmal anhören: <span><img style='width: 50px' src='/assets/Tastatur_PfeilLinks.png'/></span> /&nbsp;&nbsp;</div></th><th><div style='font-family: fibel_nordregular;font-size:60px'>Weiter: ß</div></th></tr></table></footer><script>var tempAudio = (document.getElementById('audioItem')); tempAudio.play(); currentResult = currentResult + ','; $(window).keyup(function (event) {if(event.keyCode==37){tempAudio.pause(); tempAudio.currentTime = 0; tempAudio.play();}else if(event.keyCode == 63) {$(window).unbind('keyup'); nextItem(); }})</script>")
i.save
i = t.items.build(itemtext: "ß Aufgabe1", difficulty: 0.3, audiopath: "/assets/Anweisungen/13_ß2.mp3",itemview:"<audio id='audioItem' src='/assets/Anweisungen/13_ß2.mp3'></audio><p style='font-family: fibel_nordregular; font-size:60px' class='text-center'>„Bitte ergänze jetzt das fehlende ß in den Wörtern.“<img style='float: right; width: 250px ' src='/assets/Levumi-normal-blau.jpg'/><br /><img style='float: left; width: 150px;margin-left: 125px' src='/assets/headphones.png'/><br /><br /><img style='float: left; width: 150px;margin-left: 125px' src='/assets/tastartur.png'/></p><p style='font-family: fibel_nordregular; font-size:96px;margin-right:280px' type='text' class='text-center' align='middle'>Spa<span style='background-color:#FFFF00'>ß</span></p><p style='font-family: fibel_nordregular; font-size:96px' type='text' class='text-center' align='middle'>Spa<input style='font-family: fibel_nordregular;padding-bottom: 10px; line-height: 50px; width: 50px; font-size:96px' id='answer' type='text' class='text-center' align='middle'></p><br /><br /><footer><table align='center'><tr><th><div style='font-family: fibel_nordregular;font-size:60px'>Nochmal anhören: <span><img style='width: 50px' src='/assets/Tastatur_PfeilLinks.png'/></span> /&nbsp;&nbsp;</div></th><th><div style='font-family: fibel_nordregular;font-size:60px'>Weiter: <span><img style='width: 50px' src='/assets/Tastatur_EingabetasteAlleine.png'/></span></div></th></tr></table></footer><script>var tempAudio = (document.getElementById('audioItem'));var tempAnswer = (document.getElementById('answer'));tempAnswer.focus();$(tempAnswer).css('border','0px').css('border-bottom', 'black solid 1px').attr('maxlength', '1').attr('size','1').val('');;currentResult = currentResult + ',';$(window).keyup(function (event) {if(event.keyCode==37){tempAudio.pause();tempAudio.currentTime = 0;tempAudio.play();} else if(event.keyCode == 13 && tempAnswer.value == 'ß') {$(window).unbind('keyup');nextItem();}}); $(tempAnswer).keydown(function (event) {var key = event.charCode || event.keyCode;if (key == 37||key == 38||key == 39||key == 40||key == 32||key ==27) {event.preventDefault();}})</script>");
i.save
i = t.items.build(itemtext: "ß Aufgabe2", difficulty: 0.3, audiopath: "/assets/Anweisungen/13_ß2.mp3",itemview:"<audio id='audioItem' src='/assets/Anweisungen/13_ß2.mp3'></audio><p style='font-family: fibel_nordregular; font-size:60px' class='text-center'>„Bitte ergänze jetzt das fehlende ß in den Wörtern.“<img style='float: right; width: 250px ' src='/assets/Levumi-normal-blau.jpg'/><br /><img style='float: left; width: 150px;margin-left: 125px' src='/assets/headphones.png'/><br /><br /><img style='float: left; width: 150px;margin-left: 125px' src='/assets/tastartur.png'/></p><p style='font-family: fibel_nordregular; font-size:96px;margin-right:280px' type='text' class='text-center' align='middle'>sü<span style='background-color:#FFFF00'>ß</span></p><p style='font-family: fibel_nordregular; font-size:96px' type='text' class='text-center' align='middle'>sü<input style='font-family: fibel_nordregular;padding-bottom: 10px; line-height: 50px; width: 50px; font-size:96px' id='answer' type='text' class='text-center' align='middle'></p><br /><br /><footer><table align='center'><tr><th><div style='font-family: fibel_nordregular;font-size:60px'>Nochmal anhören: <span><img style='width: 50px' src='/assets/Tastatur_PfeilLinks.png'/></span> /&nbsp;&nbsp;</div></th><th><div style='font-family: fibel_nordregular;font-size:60px'>Weiter: <span><img style='width: 50px' src='/assets/Tastatur_EingabetasteAlleine.png'/></span></div></th></tr></table></footer><script>var tempAudio = (document.getElementById('audioItem'));var tempAnswer = (document.getElementById('answer'));tempAnswer.focus();$(tempAnswer).css('border','0px').css('border-bottom', 'black solid 1px').attr('maxlength', '1').attr('size','1').val('');;currentResult = currentResult + ',';$(window).keyup(function (event) {if(event.keyCode==37){tempAudio.pause();tempAudio.currentTime = 0;tempAudio.play();} else if(event.keyCode == 13 && tempAnswer.value == 'ß') {$(window).unbind('keyup');nextItem();}}); $(tempAnswer).keydown(function (event) {var key = event.charCode || event.keyCode;if (key == 37||key == 38||key == 39||key == 40||key == 32||key ==27) {event.preventDefault();}})</script>");
i.save
i = t.items.build(itemtext: "ß Aufgabe3", difficulty: 0.3, audiopath: "/assets/Anweisungen/13_ß2.mp3",itemview:"<audio id='audioItem' src='/assets/Anweisungen/13_ß2.mp3'></audio><p style='font-family: fibel_nordregular; font-size:60px' class='text-center'>„Bitte ergänze jetzt das fehlende ß in den Wörtern.“<img style='float: right; width: 250px ' src='/assets/Levumi-normal-blau.jpg'/><br /><img style='float: left; width: 150px;margin-left: 125px' src='/assets/headphones.png'/><br /><br /><img style='float: left; width: 150px;margin-left: 125px' src='/assets/tastartur.png'/></p><p style='font-family: fibel_nordregular; font-size:96px;margin-right:280px' type='text' class='text-center' align='middle'>Fu<span style='background-color:#FFFF00'>ß</span></p><p style='font-family: fibel_nordregular; font-size:96px' type='text' class='text-center' align='middle'>Fu<input style='font-family: fibel_nordregular;padding-bottom: 10px; line-height: 50px; width: 50px; font-size:96px' id='answer' type='text' class='text-center' align='middle'></p><br /><br /><footer><table align='center'><tr><th><div style='font-family: fibel_nordregular;font-size:60px'>Nochmal anhören: <span><img style='width: 50px' src='/assets/Tastatur_PfeilLinks.png'/></span> /&nbsp;&nbsp;</div></th><th><div style='font-family: fibel_nordregular;font-size:60px'>Weiter: <span><img style='width: 50px' src='/assets/Tastatur_EingabetasteAlleine.png'/></span></div></th></tr></table></footer><script>var tempAudio = (document.getElementById('audioItem'));var tempAnswer = (document.getElementById('answer'));tempAnswer.focus();$(tempAnswer).css('border','0px').css('border-bottom', 'black solid 1px').attr('maxlength', '1').attr('size','1').val('');;currentResult = currentResult + ',';$(window).keyup(function (event) {if(event.keyCode==37){tempAudio.pause();tempAudio.currentTime = 0;tempAudio.play();} else if(event.keyCode == 13 && tempAnswer.value == 'ß') {$(window).unbind('keyup');nextItem();}}); $(tempAnswer).keydown(function (event) {var key = event.charCode || event.keyCode;if (key == 37||key == 38||key == 39||key == 40||key == 32||key ==27) {event.preventDefault();}})</script>");
i.save
i = t.items.build(itemtext: "Großschreibung", difficulty: 0.1, audiopath: "/assets/Anweisungen/11_Großschreibung.mp3",itemview:"<audio id='audioItem' src='/assets/Anweisungen/11_Großschreibung.mp3'></audio><p style='font-family: fibel_nordregular; font-size:60px' class='text-center'>„Um ein Wort großzuschreiben, muss man zwei Tasten gleichzeitig drücken: Den Pfeil, der nach oben zeigt, ganz links auf der Tastatur und eine Buchstabentaste. Am besten benutzt du dafür deine beiden Zeigefinger.“<img style='float: right; width: 250px ' src='/assets/Levumi-normal-blau.jpg'/><br /><img style='width: 650px;margin-left: 125px' src='/assets/Tastatur_Großschreiben.png'/></p><br /><br /><footer><table align='center'><tr><th><div style='font-family: fibel_nordregular;font-size:60px'>Nochmal anhören: <span><img style='width: 50px' src='/assets/Tastatur_PfeilLinks.png'/></span> /&nbsp;&nbsp;</div></th><th><div style='font-family: fibel_nordregular;font-size:60px'>Weiter: <span><img style='width: 50px' src='/assets/Tastatur_EingabetasteAlleine.png'/></span></div></th></tr></table></footer><script>var tempAudio = (document.getElementById('audioItem')); tempAudio.play(); currentResult = currentResult + ','; $(window).keyup(function (event) {if(event.keyCode==37){tempAudio.pause(); tempAudio.currentTime = 0; tempAudio.play();}else if(event.keyCode == 13) {$(window).unbind('keyup'); nextItem(); }})</script>")
i.save
i = t.items.build(itemtext: "Großschreibung Aufgabe1", difficulty: 0.3, audiopath: "/assets/Anweisungen/12_Großschreibung2.mp3",itemview:"<audio id='audioItem' src='/assets/Anweisungen/12_Großschreibung2.mp3'></audio><p style='font-family: fibel_nordregular; font-size:60px' class='text-center'>„Bitte ergänze jetzt das fehlende ß in den Wörtern.“<img style='float: right; width: 250px ' src='/assets/Levumi-normal-blau.jpg'/><br /><img style='float: left; width: 150px;margin-left: 125px' src='/assets/headphones.png'/><br /><br /><img style='float: left; width: 150px;margin-left: 125px' src='/assets/tastartur.png'/></p><p style='font-family: fibel_nordregular; font-size:96px;margin-right:280px' type='text' class='text-center' align='middle'><span style='background-color:#FFFF00'>H</span>aus</p><p style='font-family: fibel_nordregular; font-size:96px' type='text' class='text-center' align='middle'><input style='font-family: fibel_nordregular;padding-bottom: 10px; line-height: 50px; width: 50px; font-size:96px' id='answer' type='text' class='text-center' align='middle'>aus</p><br /><br /><footer><table align='center'><tr><th><div style='font-family: fibel_nordregular;font-size:60px'>Nochmal anhören: <span><img style='width: 50px' src='/assets/Tastatur_PfeilLinks.png'/></span> /&nbsp;&nbsp;</div></th><th><div style='font-family: fibel_nordregular;font-size:60px'>Weiter: <span><img style='width: 50px' src='/assets/Tastatur_EingabetasteAlleine.png'/></span></div></th></tr></table></footer><script>var tempAudio = (document.getElementById('audioItem'));var tempAnswer = (document.getElementById('answer'));tempAnswer.focus();$(tempAnswer).css('border','0px').css('border-bottom', 'black solid 1px').attr('maxlength', '1').attr('size','1').val('');;currentResult = currentResult + ',';$(window).keyup(function (event) {if(event.keyCode==37){tempAudio.pause();tempAudio.currentTime = 0;tempAudio.play();} else if(event.keyCode == 13 && tempAnswer.value == 'H') {$(window).unbind('keyup');nextItem();}}); $(tempAnswer).keydown(function (event) {var key = event.charCode || event.keyCode;if (key == 37||key == 38||key == 39||key == 40||key == 32||key ==27) {event.preventDefault();}})</script>");
i.save
i = t.items.build(itemtext: "Großschreibung Aufgabe2", difficulty: 0.3, audiopath: "/assets/Anweisungen/12_Großschreibung2.mp3",itemview:"<audio id='audioItem' src='/assets/Anweisungen/12_Großschreibung2.mp3'></audio><p style='font-family: fibel_nordregular; font-size:60px' class='text-center'>„Bitte ergänze jetzt das fehlende ß in den Wörtern.“<img style='float: right; width: 250px ' src='/assets/Levumi-normal-blau.jpg'/><br /><img style='float: left; width: 150px;margin-left: 125px' src='/assets/headphones.png'/><br /><br /><img style='float: left; width: 150px;margin-left: 125px' src='/assets/tastartur.png'/></p><p style='font-family: fibel_nordregular; font-size:96px;margin-right:280px' type='text' class='text-center' align='middle'><span style='background-color:#FFFF00'>G</span>arten</p><p style='font-family: fibel_nordregular; font-size:96px' type='text' class='text-center' align='middle'><input style='font-family: fibel_nordregular;padding-bottom: 10px; line-height: 50px; width: 50px; font-size:96px' id='answer' type='text' class='text-center' align='middle'>arten</p><br /><br /><footer><table align='center'><tr><th><div style='font-family: fibel_nordregular;font-size:60px'>Nochmal anhören: <span><img style='width: 50px' src='/assets/Tastatur_PfeilLinks.png'/></span> /&nbsp;&nbsp;</div></th><th><div style='font-family: fibel_nordregular;font-size:60px'>Weiter: <span><img style='width: 50px' src='/assets/Tastatur_EingabetasteAlleine.png'/></span></div></th></tr></table></footer><script>var tempAudio = (document.getElementById('audioItem'));var tempAnswer = (document.getElementById('answer'));tempAnswer.focus();$(tempAnswer).css('border','0px').css('border-bottom', 'black solid 1px').attr('maxlength', '1').attr('size','1').val('');;currentResult = currentResult + ',';$(window).keyup(function (event) {if(event.keyCode==37){tempAudio.pause();tempAudio.currentTime = 0;tempAudio.play();} else if(event.keyCode == 13 && tempAnswer.value == 'G') {$(window).unbind('keyup');nextItem();}}); $(tempAnswer).keydown(function (event) {var key = event.charCode || event.keyCode;if (key == 37||key == 38||key == 39||key == 40||key == 32||key ==27) {event.preventDefault();}})</script>");
i.save
i = t.items.build(itemtext: "Großschreibung Aufgabe3", difficulty: 0.3, audiopath: "/assets/Anweisungen/12_Großschreibung2.mp3",itemview:"<audio id='audioItem' src='/assets/Anweisungen/12_Großschreibung2.mp3'></audio><p style='font-family: fibel_nordregular; font-size:60px' class='text-center'>„Bitte ergänze jetzt das fehlende ß in den Wörtern.“<img style='float: right; width: 250px ' src='/assets/Levumi-normal-blau.jpg'/><br /><img style='float: left; width: 150px;margin-left: 125px' src='/assets/headphones.png'/><br /><br /><img style='float: left; width: 150px;margin-left: 125px' src='/assets/tastartur.png'/></p><p style='font-family: fibel_nordregular; font-size:96px;margin-right:280px' type='text' class='text-center' align='middle'><span style='background-color:#FFFF00'>S</span>onne</p><p style='font-family: fibel_nordregular; font-size:96px' type='text' class='text-center' align='middle'><input style='font-family: fibel_nordregular;padding-bottom: 10px; line-height: 50px; width: 50px; font-size:96px' id='answer' type='text' class='text-center' align='middle'>onne</p><br /><br /><footer><table align='center'><tr><th><div style='font-family: fibel_nordregular;font-size:60px'>Nochmal anhören: <span><img style='width: 50px' src='/assets/Tastatur_PfeilLinks.png'/></span> /&nbsp;&nbsp;</div></th><th><div style='font-family: fibel_nordregular;font-size:60px'>Weiter: <span><img style='width: 50px' src='/assets/Tastatur_EingabetasteAlleine.png'/></span></div></th></tr></table></footer><script>var tempAudio = (document.getElementById('audioItem'));var tempAnswer = (document.getElementById('answer'));tempAnswer.focus();$(tempAnswer).css('border','0px').css('border-bottom', 'black solid 1px').attr('maxlength', '1').attr('size','1').val('');;currentResult = currentResult + ',';$(window).keyup(function (event) {if(event.keyCode==37){tempAudio.pause();tempAudio.currentTime = 0;tempAudio.play();} else if(event.keyCode == 13 && tempAnswer.value == 'S') {$(window).unbind('keyup');nextItem();}}); $(tempAnswer).keydown(function (event) {var key = event.charCode || event.keyCode;if (key == 37||key == 38||key == 39||key == 40||key == 32||key ==27) {event.preventDefault();}})</script>");
i.save
i = t.items.build(itemtext: "Danke", difficulty: 0.1, audiopath: "/assets/Anweisungen/13_AbtippaufgabeDanke.mp3",itemview:"<audio id='audioItem' src='/assets/Anweisungen/13_AbtippaufgabeDanke.mp3'></audio><p style='font-family: fibel_nordregular; font-size:60px' class='text-center'>„Danke, dass du so gut mitmachst!“<img style='float: right; width: 250px ' src='/assets/Levumi-normal-blau.jpg'/><br /><img style='float: left; width: 150px;margin-left: 125px' src='/assets/headphones.png'/></p><br /><br /><footer><table align='center'><tr><th><div style='font-family: fibel_nordregular;font-size:60px'>Nochmal anhören: <span><img style='width: 50px' src='/assets/Tastatur_PfeilLinks.png'/></span> /&nbsp;&nbsp;</div></th><th><div style='font-family: fibel_nordregular;font-size:60px'>Weiter: <span><img style='width: 50px' src='/assets/Tastatur_EingabetasteAlleine.png'/></span></div></th></tr></table></footer><script>var tempAudio = (document.getElementById('audioItem')); tempAudio.play(); currentResult = currentResult + ','; $(window).keyup(function (event) {if(event.keyCode==37){tempAudio.pause(); tempAudio.currentTime = 0; tempAudio.play();}else if(event.keyCode == 13) {$(window).unbind('keyup'); nextItem(); }})</script>")
i.save
i = t.items.build(itemtext: "Abtippaufgabe", difficulty: 0.1, audiopath: "/assets/Anweisungen/8_Abtippaufgabe.mp3",itemview:"<audio id='audioItem' src='/assets/Anweisungen/8_Abtippaufgabe.mp3'></audio><p style='font-family: fibel_nordregular; font-size:60px' class='text-center'>„Jetzt hast du schon gut geübt, auf der Tastatur zu schreiben. Nun lese ich dir einen Satz vor. Die Wörter, die du schreiben sollst, sind gelb makiert. Wenn du das Wort geschrieben hast, drücke die Eingabetaste, damit du zum nächsten Wort gelangst.“<img style='float: right; width: 250px ' src='/assets/Levumi-normal-blau.jpg'/><br /><img style='float: left; width: 150px;margin-left: 125px' src='/assets/headphones.png'/></p><br /><br /><footer><table align='center'><tr><th><div style='font-family: fibel_nordregular;font-size:60px'>Nochmal anhören: <span><img style='width: 50px' src='/assets/Tastatur_PfeilLinks.png'/></span> /&nbsp;&nbsp;</div></th><th><div style='font-family: fibel_nordregular;font-size:60px'>Weiter: <span><img style='width: 50px' src='/assets/Tastatur_EingabetasteAlleine.png'/></span></div></th></tr></table></footer><script>var tempAudio = (document.getElementById('audioItem')); tempAudio.play(); currentResult = currentResult + ','; $(window).keyup(function (event) {if(event.keyCode==37){tempAudio.pause(); tempAudio.currentTime = 0; tempAudio.play();}else if(event.keyCode == 13) {$(window).unbind('keyup'); nextItem(); }})</script>")
i.save
i = t.items.build(itemtext: "Abtippaufgabe Garten", difficulty: 0.5, audiopath: "/assets/Anweisungen/13_AbtippaufgabeSatz.mp3",itemview:"<audio id='audioItem' src='/assets/Anweisungen/13_AbtippaufgabeSatz.mp3'></audio><p style='font-family: fibel_nordregular; font-size:60px' class='text-center'>„Im <span style='background-color:#FFFF00'>Garten</span> sind große Apfelbäume und Quittenbäume.“<img style='float: right; width: 250px ' src='/assets/Levumi-normal-blau.jpg'/><br /><img style='float: left; width: 150px;margin-left: 125px' src='/assets/headphones.png'/><br /><br /><img style='float: left; width: 150px;margin-left: 125px' src='/assets/tastartur.png'/><input style='font-family: fibel_nordregular; font-size:96px;margin-right:250px' id='answer' type='text' class='text-center' align='middle'></p><br /><br /><footer><table align='center'><tr><th><div style='font-family: fibel_nordregular;font-size:60px'>Nochmal anhören: <span><img style='width: 50px' src='/assets/Tastatur_PfeilLinks.png'/></span> /&nbsp;&nbsp;</div></th><th><div style='font-family: fibel_nordregular;font-size:60px'>Weiter: <span><img style='width: 50px' src='/assets/Tastatur_EingabetasteAlleine.png'/></span></div></th></tr></table></footer><script>var tempAudio = (document.getElementById('audioItem'));tempAudio.play();var tempAnswer = (document.getElementById('answer'));tempAnswer.focus();$(tempAnswer).css('border','0px').css('border-bottom', 'black solid 1px').attr('maxlength', '16').attr('size','16');currentResult = currentResult + ',';$(window).keyup(function (event) {if(event.keyCode==37){tempAudio.pause();tempAudio.currentTime = 0;tempAudio.play();} else if(event.keyCode == 13 && tempAnswer.value == 'Garten') {$(window).unbind('keyup');nextItem();}}); $(tempAnswer).keydown(function (event) {var key = event.charCode || event.keyCode;if (key == 37||key == 38||key == 39||key == 40||key == 32||key ==27) {event.preventDefault();}})</script>");
i.save
i = t.items.build(itemtext: "Abtippaufgabe Apfelbäume", difficulty: 0.8, audiopath: "/assets/Anweisungen/13_AbtippaufgabeSatz.mp3",itemview:"<audio id='audioItem' src='/assets/Anweisungen/13_AbtippaufgabeSatz.mp3'></audio><p style='font-family: fibel_nordregular; font-size:60px' class='text-center'>„Im Garten sind große <span style='background-color:#FFFF00'>Apfelbäume</span> und Quittenbäume.“<img style='float: right; width: 250px ' src='/assets/Levumi-normal-blau.jpg'/><br /><img style='float: left; width: 150px;margin-left: 125px' src='/assets/headphones.png'/><br /><br /><img style='float: left; width: 150px;margin-left: 125px' src='/assets/tastartur.png'/><input style='font-family: fibel_nordregular; font-size:96px;margin-right:250px' id='answer' type='text' class='text-center' align='middle'></p><br /><br /><footer><table align='center'><tr><th><div style='font-family: fibel_nordregular;font-size:60px'>Nochmal anhören: <span><img style='width: 50px' src='/assets/Tastatur_PfeilLinks.png'/></span> /&nbsp;&nbsp;</div></th><th><div style='font-family: fibel_nordregular;font-size:60px'>Weiter: <span><img style='width: 50px' src='/assets/Tastatur_EingabetasteAlleine.png'/></span></div></th></tr></table></footer><script>var tempAudio = (document.getElementById('audioItem'));tempAudio.play();var tempAnswer = (document.getElementById('answer'));tempAnswer.focus();$(tempAnswer).css('border','0px').css('border-bottom', 'black solid 1px').attr('maxlength', '16').attr('size','16');currentResult = currentResult + ',';$(window).keyup(function (event) {if(event.keyCode==37){tempAudio.pause();tempAudio.currentTime = 0;tempAudio.play();} else if(event.keyCode == 13 && tempAnswer.value == 'Apfelbäume') {$(window).unbind('keyup');nextItem();}}); $(tempAnswer).keydown(function (event) {var key = event.charCode || event.keyCode;if (key == 37||key == 38||key == 39||key == 40||key == 32||key ==27) {event.preventDefault();}})</script>");
i.save
i = t.items.build(itemtext: "Abtippaufgabe Quittenbäume", difficulty: 0.9, audiopath: "/assets/Anweisungen/13_AbtippaufgabeSatz.mp3",itemview:"<audio id='audioItem' src='/assets/Anweisungen/13_AbtippaufgabeSatz.mp3'></audio><p style='font-family: fibel_nordregular; font-size:60px' class='text-center'>„Im Garten sind große Apfelbäume und <span style='background-color:#FFFF00'>Quittenbäume</span>.“<img style='float: right; width: 250px ' src='/assets/Levumi-normal-blau.jpg'/><br /><img style='float: left; width: 150px;margin-left: 125px' src='/assets/headphones.png'/><br /><br /><img style='float: left; width: 150px;margin-left: 125px' src='/assets/tastartur.png'/><input style='font-family: fibel_nordregular; font-size:96px;margin-right:250px' id='answer' type='text' class='text-center' align='middle'></p><br /><br /><footer><table align='center'><tr><th><div style='font-family: fibel_nordregular;font-size:60px'>Nochmal anhören: <span><img style='width: 50px' src='/assets/Tastatur_PfeilLinks.png'/></span> /&nbsp;&nbsp;</div></th><th><div style='font-family: fibel_nordregular;font-size:60px'>Weiter: <span><img style='width: 50px' src='/assets/Tastatur_EingabetasteAlleine.png'/></span></div></th></tr></table></footer><script>var tempAudio = (document.getElementById('audioItem'));tempAudio.play();var tempAnswer = (document.getElementById('answer'));tempAnswer.focus();$(tempAnswer).css('border','0px').css('border-bottom', 'black solid 1px').attr('maxlength', '16').attr('size','16');currentResult = currentResult + ',';$(window).keyup(function (event) {if(event.keyCode==37){tempAudio.pause();tempAudio.currentTime = 0;tempAudio.play();} else if(event.keyCode == 13 && tempAnswer.value == 'Quittenbäume') {$(window).unbind('keyup');nextItem();}}); $(tempAnswer).keydown(function (event) {var key = event.charCode || event.keyCode;if (key == 37||key == 38||key == 39||key == 40||key == 32||key ==27) {event.preventDefault();}})</script>");
i.save
i = t.items.build(itemtext: "Geschafft", difficulty: 0.1, audiopath: "/assets/Anweisungen/14_Super_geschafft.mp3",itemview:"<audio id='audioItem' src='/assets/Anweisungen/14_Super_geschafft.mp3'></audio><p style='font-family: fibel_nordregular; font-size:60px' class='text-center'>„Super, du hast es geschafft! Das hast du toll gemacht!<br /> Zum Beenden des Testes drücke bitte die Eingabetaste.“<br /><img style='width: 250px ' src='/assets/Levumi-jubelt.gif'/></p><br /><br /><footer><table align='center'><tr><th><div style='font-family: fibel_nordregular;font-size:60px'>Nochmal anhören: <span><img style='width: 50px' src='/assets/Tastatur_PfeilLinks.png'/></span> /&nbsp;&nbsp;</div></th><th><div style='font-family: fibel_nordregular;font-size:60px'>Weiter: <span><img style='width: 50px' src='/assets/Tastatur_EingabetasteAlleine.png'/></span></div></th></tr></table></footer><script>var tempAudio = (document.getElementById('audioItem')); tempAudio.play(); currentResult = currentResult + '1,'; $(window).keyup(function (event) {if(event.keyCode==37){tempAudio.pause(); tempAudio.currentTime = 0; tempAudio.play();}else if(event.keyCode == 13 && lastPage) {$(window).unbind('keydown');$(window).unbind('keyup');(document.getElementById('closeButton')).click();}})</script>")
i.save

a = g.assessments.build(test_id: t.id)
a.save

m = a.measurements.build(date: Date.yesterday)
m.save


m = a.measurements.build(date: Date.today)
m.save


m = a.measurements.build(date: Date.tomorrow)
m.save


items = %w{
Leine
/assets/Woerter/1_Leine.mp3
Keller
/assets/Woerter/33_Keller.mp3
winzig
/assets/Woerter/42_winzig.mp3
Korb
/assets/Woerter/43_Korb.mp3
sind
/assets/Woerter/53_sind.mp3
}

dicN1 = TestDictation.create(name: "Wörter schreiben", info: "", short_info: "", len: items.size/2+5, time: 60, subject: "Deutsch", construct: "Rechtschreibung",
                             archive: false, student_access:true, level:"Level nicht bestimmt")

it = dicN1.items.build(itemtext: "Hallo", difficulty: 0, audiopath: "/assets/Anweisungen/15_Hallo.mp3", itemview:"
<audio id='audioItem' src='/assets/Anweisungen/15_Hallo.mp3'></audio>
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
it = dicN1.items.build(itemtext: "Erklärung", difficulty: 0, audiopath: "/assets/Anweisungen/15_Erklärung.mp3",itemview:"
<audio id='audioItem' src='/assets/Anweisungen/15_Erklärung.mp3'></audio>
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
it = dicN1.items.build(itemtext: "Löschen und Audio", difficulty: 0, audiopath: "/assets/Anweisungen/16_ErklärungTeilB.mp3",  itemview:"
<audio id='audioItem' src='/assets/Anweisungen/16_ErklärungTeilB.mp3'></audio>
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
it = dicN1.items.build(itemtext: "Ich beginne", difficulty: 0, audiopath: "/assets/Anweisungen/19_ich_beginne.mp3", itemview:"
<audio id='audioItem' src='/assets/Anweisungen/19_ich_beginne.mp3'></audio>
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
  it = dicN1.items.build(itemtext: items[i], audiopath:items[i+1], difficulty: 0, itemview:"
  <audio id='audioItem' src='"+items[i+1]+"'></audio>
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

it = dicN1.items.build(itemtext: "Ende", difficulty: 0, audiopath: "/assets/Anweisungen/20_geschafft.mp3", itemview:"
<audio id='audioItem' src='/assets/Anweisungen/20_geschafft.mp3'></audio>
<p style='font-family: fibel_nordregular; font-size:60px' class='text-center'>
  „Toll jetzt hast du es geschafft.<br/>Die Testergebnisse wurden gespeichert!
  <br/>Zum Beenden des Testes drücke bitte die Eingabetaste.“<br/>
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
    tempAudio.play();
    currentResult = ',' + currentResult;
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


a = g.assessments.build(test_id: dicN1.id)
a.save

m = a.measurements.build(date: Date.yesterday)
m.save


m = a.measurements.build(date: Date.today)
m.save


m = a.measurements.build(date: Date.tomorrow)
m.save