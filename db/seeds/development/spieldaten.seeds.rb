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





t = TestKeyboard.create(name: "Tastaturschulung",len: 9, info: "Tastertur für die Grundschule, 1. Klasse", short_info:
    "Tasterturtest für die Grundschule, 1. Klasse", subject: "Deutsch", construct: "Schreiben", archive: false, level: "Level 0", time: 60, student_access:true)
i = t.items.build(itemtext: "Einleitung", difficulty: 0.1)
i.save
i = t.items.build(itemtext: "Eingabetaste", difficulty: 0.1)
i.save
i = t.items.build(itemtext: "Erklärung Bilder", difficulty: 0.1)
i.save
i = t.items.build(itemtext: "Audio wiederholden", difficulty: 0.1)
i.save
i = t.items.build(itemtext: "Umlaute", difficulty: 0.3)
i.save
i = t.items.build(itemtext: "Löschtaste", difficulty: 0.1)
i.save
i = t.items.build(itemtext: "ß-Taste", difficulty: 0.3)
i.save
i = t.items.build(itemtext: "Großschreibung", difficulty: 0.3)
i.save
i = t.items.build(itemtext: "Abtippaufgabe", difficulty: 0.5)
i.save

a = g.assessments.build(test_id: t.id)
a.save

m = a.measurements.build(date: Date.yesterday)
m.save


m = a.measurements.build(date: Date.today)
m.save


m = a.measurements.build(date: Date.tomorrow)
m.save


t = TestDictation.create(name: "Diktiertest", len: 10, info: "Diktiertest für die Grundschule, 1. Klasse", short_info:
    "Diktiertesttest für die Grundschule, 1. Klasse", subject: "Deutsch", construct: "Schreiben", archive: false, level: "Level 0", time: 60, student_access:true)
i = t.items.build(itemtext: "Hallo", difficulty: 0.1, audiopath: "Anweisungen/15_Hallo.mp3", itemview:"<p style='font-family: fibel_nordregular; font-size:60px' class='text-center'>„Hallo, ich bin Levumi, heute möchte ich gerne wissen, wie gut du schon schreiben kannst. Einige Wörter sind leicht, andere Wörter sind schwer. Bitte konzentriere dich und schreibe so gut, wie du kannst! Bitte drücke jetzt irgendeine Taste auf der Tastatur, damit du beginnen kannst.“<img style='float: right; width: 250px ' src='/assets/Levumi-jubelt.gif'/></p><script>currentResult = currentResult + ',';$(window).keyup(function (event) { $(window).unbind('keyup'); nextItem();})</script>")
i.save
i = t.items.build(itemtext: "Erklärung", difficulty: 0.1, audiopath: "Anweisungen/15_Erklärung.mp3",itemview:"<p style='font-family: fibel_nordregular; font-size:60px' class='text-center'>„Zuerst lese ich dir einen Satz vor. Danach diktiere ich dir das Wort aus dem Satz, dass du schreiben sollst. Dann schreibst du das Wort auf der Tastatur.“<img style='float: right; width: 250px ' src='/assets/Levumi-jubelt.gif'/></p><script>currentResult = currentResult + ','; $(window).keyup(function (event) { if(event.keyCode == 13) {$(window).unbind('keyup'); nextItem(); }})</script>")
i.save
i = t.items.build(itemtext: "Löschen und Audio", difficulty: 0.1, audiopath: "Anweisungen/16_ErklärungTeilB.mp3",  itemview:"<p style='font-family: fibel_nordregular; font-size:60px' class='text-center'>„Wenn du ein Wort falsch geschrieben hast, kannst du die Löschtaste benutzen und die Buchstaben löschen, damit du das Wort noch einmal schreiben kannst. Wenn du das Wort nicht verstanden hast, drücke die linke Pfeiltaste, dann lese ich dir noch einmal vor, was du schreiben sollst. Achte ganz genau darauf, ob ein Wort groß oder klein geschrieben wird.“<img style='float: right; width: 250px ' src='/assets/Levumi-jubelt.gif'/></p><script>currentResult = currentResult + ','; $(window).keyup(function (event) { if(event.keyCode == 13) {$(window).unbind('keyup'); nextItem(); }})</script>")
i.save
i = t.items.build(itemtext: "Ich beginne", difficulty: 0.1, audiopath: "Anweisungen/19_ich_beginne.mp3", itemview:"<p style='font-family: fibel_nordregular; font-size:60px' class='text-center'>„Ich beginne nun dir die Wörter zu diktieren:“<img style='float: right; width: 250px ' src='/assets/Levumi-jubelt.gif'/></p><script>currentResult = currentResult + ','; $(window).keyup(function (event) { if(event.keyCode == 13) {$(window).unbind('keyup'); nextItem();}})</script>")
i.save
i = t.items.build(itemtext: "Flug", difficulty: 0.1, audiopath: "Woerter/4_Flug.mp3", itemview:"<p align='center'><input style='font-family: fibel_nordregular; font-size:96px' id='answer' type='text' class='text-center' placeholder='Flug' align='middle'></p><script>$(window).keyup(function (event) { if(event.keyCode == 13) {$(window).unbind('keyup'); if(document.getElementById('answer').value=='Flug'){currentResult = currentResult + '1,';}else {currentResult = currentResult + '0,';}; nextItem();}})</script>")
i.save
i = t.items.build(itemtext: "einer", difficulty: 0.4, audiopath: "Woerter/15_einer.mp3", itemview:"<p align='center'><input style='font-family: fibel_nordregular; font-size:96px' id='answer' type='text' class='text-center' placeholder='einer' align='middle'></p><script>$(window).keyup(function (event) { if(event.keyCode == 13) {$(window).unbind('keyup'); if(document.getElementById('answer').value=='einer'){currentResult = currentResult + '1,';}else {currentResult = currentResult + '0,';}; nextItem(); }})</script>")
i.save
i = t.items.build(itemtext: "Keller", difficulty: 0.7, audiopath: "Woerter/33_Keller.mp3",  itemview:"<p align='center'><input style='font-family: fibel_nordregular; font-size:96px' id='answer' type='text' class='text-center' placeholder='Keller' align='middle'></p><script>$(window).keyup(function (event) { if(event.keyCode == 13) {$(window).unbind('keyup'); if(document.getElementById('answer').value=='Keller'){currentResult = currentResult + '1,';}else {currentResult = currentResult + '0,';}; nextItem(); }})</script>")
i.save
i = t.items.build(itemtext: "Stärke", difficulty: 0.9, audiopath: "Woerter/35_Stärke.mp3", itemview:"<p align='center'><input style='font-family: fibel_nordregular; font-size:96px' id='answer' type='text' class='text-center' placeholder='Stärke' align='middle'></p><script>$(window).keyup(function (event) { if(event.keyCode == 13) {$(window).unbind('keyup'); if(document.getElementById('answer').value=='Stärke'){currentResult = currentResult + '1,';}else {currentResult = currentResult + '0,';}; nextItem(); }})</script>")
i.save
i = t.items.build(itemtext: "Sieb", difficulty: 0.9, audiopath: "Woerter/41_Sieb.mp3",  itemview:"<p align='center'><input style='font-family: fibel_nordregular; font-size:96px' id='answer' type='text' class='text-center' placeholder='Sieb' align='middle'></p><script>$(window).keyup(function (event) { if(event.keyCode == 13) {$(window).unbind('keyup'); if(document.getElementById('answer').value=='Sieb'){currentResult = currentResult + '1,';}else {currentResult = currentResult + '0,';}; nextItem(); }})</script>")
i.save
i = t.items.build(itemtext: "Weihnachtsbaum", difficulty: 0.9, audiopath: "Woerter/44_Weihnachtsbaum.mp3", itemview:"<p align='center'><input style='font-family: fibel_nordregular; font-size:96px' id='answer' type='text' class='text-center' placeholder='blabla' align='middle'></p><script>$(window).keyup(function (event) { if(event.keyCode == 13) {$(window).unbind('keyup'); if(document.getElementById('answer').value=='Weihnachtsbaum'){currentResult = currentResult + '1,';}else {currentResult = currentResult + '0,';}; nextItem(); }})</script>")
i.save

a = g.assessments.build(test_id: t.id)
a.save


m = a.measurements.build(date: Date.today)
m.save


m = a.measurements.build(date: Date.tomorrow)
m.save

