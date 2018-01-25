tipN0 = Test.create(name: "Tastaturschulung",len: 1, info: "Einführung in die Tastatur", 
	shorthand: "TS0", subject: "Deutsch", type_info:"Tastaturschulung", construct: "Rechtschreibung", archive: false, level: "Level 0", student_access:true)
it = tipN0.items.build(itemtext: "Hallo", difficulty: 0, itemtype:-28, mediapath: {"audios"=>["/audio/Abtipptest/Anweisungen/1a.mp3"]}, itemview:"items/studentbased/abtipptest/1hallo")
it.save
it = tipN0.items.build(itemtext: "Eingabetaste", difficulty: 0, itemtype:-27, mediapath: {"audios"=>["/audio/Abtipptest/Anweisungen/2a.mp3"]},itemview:"items/studentbased/abtipptest/2enter")
it.save
it = tipN0.items.build(itemtext: "Ton wiederholen", difficulty: 0, itemtype:-26, mediapath: {"audios"=>["/audio/Abtipptest/Anweisungen/3c.mp3"]},itemview:"items/studentbased/abtipptest/3repeat_sound")
it.save
it = tipN0.items.build(itemtext: "Kopfhörer", difficulty: 0, itemtype:-25, mediapath: {"audios"=>["/audio/Abtipptest/Anweisungen/4a.mp3", "/audio/Abtipptest/Anweisungen/5d.mp3"]},itemview:"items/studentbased/abtipptest/4headphones")
it.save
it = tipN0.items.build(itemtext: "Tastatur", difficulty: 0, itemtype:-24, mediapath: {"audios"=>["/audio/Abtipptest/Anweisungen/6c.mp3"]},itemview:"items/studentbased/abtipptest/5keyboard")
it.save
it = tipN0.items.build(itemtext: "Löschtaste", difficulty: 0, itemtype:-23, mediapath: {"audios"=>["/audio/Abtipptest/Anweisungen/8a.mp3"]},itemview:"items/studentbased/abtipptest/6backspace")
it.save
it = tipN0.items.build(itemtext: "Löschaufgabe", difficulty: 0, itemtype:-22, mediapath: {"audios"=>["/audio/Abtipptest/Anweisungen/9a.mp3"]},itemview:"items/studentbased/abtipptest/7delete_exercise")
it.save
it = tipN0.items.build(itemtext: "Umlaute", difficulty: 0, itemtype:-21, mediapath: {"audios"=>["/audio/Abtipptest/Anweisungen/10c.mp3", "/audio/Abtipptest/Anweisungen/11b.mp3"]},itemview:"items/studentbased/abtipptest/8umlaut")
it.save
it = tipN0.items.build(itemtext: "Umlaute Aufgabenstellung", difficulty: 0, itemtype:-20, mediapath: {"audios"=>["/audio/Abtipptest/Anweisungen/12a.mp3", "/audio/Abtipptest/Anweisungen/13a.mp3"]},itemview:"items/studentbased/abtipptest/9umlaut_task")
it.save
it = tipN0.items.build(itemtext: "Umlaute Aufgabe1", difficulty: 0, itemtype:-19, mediapath: {"audios"=>["/audio/Abtipptest/Anweisungen/1c.mp3"]},itemview:"items/studentbased/abtipptest/10umlaut_exercise1")
it.save
it = tipN0.items.build(itemtext: "Umlaute Aufgabe2", difficulty: 0, itemtype:-18, mediapath: {"audios"=>["/audio/Abtipptest/Anweisungen/2b.mp3"]},itemview:"items/studentbased/abtipptest/11umlaut_exercise2")
it.save
it = tipN0.items.build(itemtext: "Umlaute Aufgabe3", difficulty: 0, itemtype:-17, mediapath: {"audios"=>["/audio/Abtipptest/Anweisungen/3b.mp3"]},itemview:"items/studentbased/abtipptest/12umlaut_exercise3")
it.save
it = tipN0.items.build(itemtext: "Umlaute Lob", difficulty: 0, itemtype:-16, mediapath: {"audios"=>["/audio/Abtipptest/Anweisungen/14b.mp3"]},itemview:"items/studentbased/abtipptest/13umlaut_praise")
it.save
it = tipN0.items.build(itemtext: "ß", difficulty: 0, itemtype:-15, mediapath: {"audios"=>["/audio/Abtipptest/Anweisungen/15N.mp3"]},itemview:"items/studentbased/abtipptest/14ß")
it.save
it = tipN0.items.build(itemtext: "ß Aufgabenstellung", difficulty: 0, itemtype:-14, mediapath: {"audios"=>["/audio/Abtipptest/Anweisungen/16N.mp3"]},itemview:"items/studentbased/abtipptest/15ß_task")
it.save
it = tipN0.items.build(itemtext: "ß Aufgabe1", difficulty: 0, itemtype:-13, mediapath: {"audios"=>["/audio/Abtipptest/Anweisungen/4d.mp3"]},itemview:"items/studentbased/abtipptest/16ß_exercise1")
it.save
it = tipN0.items.build(itemtext: "ß Aufgabe2", difficulty: 0, itemtype:-12, mediapath: {"audios"=>["/audio/Abtipptest/Anweisungen/3b.mp3"]},itemview:"items/studentbased/abtipptest/17ß_exercise2")
it.save
it = tipN0.items.build(itemtext: "ß Aufgabe3", difficulty: 0, itemtype:-11, mediapath: {"audios"=>["/audio/Abtipptest/Anweisungen/5a.mp3"]},itemview:"items/studentbased/abtipptest/18ß_exercise3")
it.save
it = tipN0.items.build(itemtext: "Großschreibung", difficulty: 0, itemtype:-10, mediapath: {"audios"=>["/audio/Abtipptest/Anweisungen/17a.mp3"]},itemview:"items/studentbased/abtipptest/19capitalization")
it.save
it = tipN0.items.build(itemtext: "Großschreibung Aufgabenstellung", difficulty: 0, itemtype:-9, mediapath: {"audios"=>["/audio/Abtipptest/Anweisungen/18a.mp3"]},itemview:"items/studentbased/abtipptest/20capitalization_task")
it.save
it = tipN0.items.build(itemtext: "Großschreibung Aufgabe1", difficulty: 0, itemtype:-8, mediapath: {"audios"=>["/audio/Abtipptest/Anweisungen/7c.mp3"]},itemview:"items/studentbased/abtipptest/21capitalization_exercise1")
it.save
it = tipN0.items.build(itemtext: "Großschreibung Aufgabe2", difficulty: 0, itemtype:-7, mediapath: {"audios"=>["/audio/Abtipptest/Anweisungen/6a.mp3"]},itemview:"items/studentbased/abtipptest/22capitalization_exercise2")
it.save
it = tipN0.items.build(itemtext: "Großschreibung Aufgabe3", difficulty: 0, itemtype:-6, mediapath: {"audios"=>["/audio/Abtipptest/Anweisungen/8b.mp3"]},itemview:"items/studentbased/abtipptest/23capitalization_exercise3")
it.save
it = tipN0.items.build(itemtext: "Danke", difficulty: 0, itemtype:-5, mediapath: {"audios"=>["/audio/Abtipptest/Anweisungen/19a3.mp3"]},itemview:"items/studentbased/abtipptest/24thanks")
it.save
it = tipN0.items.build(itemtext: "Abtippaufgabe", difficulty: 0, itemtype:-4, mediapath: {"audios"=>["/audio/Abtipptest/Anweisungen/20c.mp3"]},itemview:"items/studentbased/abtipptest/25typewrite_exercise")
it.save
it = tipN0.items.build(itemtext: "Abtippaufgabe Levumi", difficulty: 0, itemtype:-3, mediapath: {"audios"=>["/audio/Abtipptest/Anweisungen/21a.mp3"]},itemview:"items/studentbased/abtipptest/26typewrite_levumi")
it.save
it = tipN0.items.build(itemtext: "Abtippaufgabe Quitten", difficulty: 0, itemtype:-2, mediapath: {"audios"=>["/audio/Abtipptest/Anweisungen/21a.mp3"]},itemview:"items/studentbased/abtipptest/27typewrite_quitten")
it.save
it = tipN0.items.build(itemtext: "Abtippaufgabe Bäume", difficulty: 0, itemtype:-1, mediapath: {"audios"=>["/audio/Abtipptest/Anweisungen/21a.mp3"]},itemview:"items/studentbased/abtipptest/28typewrite_baeume")
it.save
it = tipN0.items.build(itemtext: "Fertig", difficulty: 0, itemtype:0, mediapath: {"audios"=>["/audio/Abtipptest/Anweisungen/22a.mp3"]},itemview:"items/studentbased/abtipptest/29finished")
it.save

tipN0.save