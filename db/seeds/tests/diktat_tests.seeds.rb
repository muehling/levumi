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

dicN1 = TestDictation.create(name: "Wörter schreiben", info: "", shorthand: "WS1", len: items.size, time: 900, subject: "Deutsch", construct: "Rechtschreibung", student_access:true, level: "Level 1", archive: false)

it = dicN1.items.build(itemtext: "Hallo", difficulty: 0, mediapath: {"audios"=>["/audio/Diktiertest/Anweisungen/23b.mp3"]}, itemtype:-7, itemview:"items/studentbased/diktattest/1hallo")
it.save
it = dicN1.items.build(itemtext: "Erklärung", difficulty: 0, mediapath: {"audios"=>["/audio/Diktiertest/Anweisungen/24a.mp3"]}, itemtype:-6,itemview:"items/studentbased/diktattest/2explanation")
it.save
it = dicN1.items.build(itemtext: "Löschen und Audio", difficulty: 0, mediapath: {"audios"=>["/audio/Diktiertest/Anweisungen/25a.mp3"]}, itemtype:-5,  itemview:"items/studentbased/diktattest/3delete_and_audio")
it.save
it = dicN1.items.build(itemtext: "Hinweis", difficulty: 0, mediapath: {"audios"=>["/audio/Diktiertest/Anweisungen/29a.mp3","/audio/Diktiertest/Anweisungen/30b.mp3"]}, itemtype:-4,  itemview:"items/studentbased/diktattest/4hint")
it.save
it = dicN1.items.build(itemtext: "Beispiel", difficulty: 0, mediapath: {"audios"=>["/audio/Diktiertest/Anweisungen/31b1.mp3"]}, itemtype:-3,  itemview:"items/studentbased/diktattest/5example")
it.save
it = dicN1.items.build(itemtext: "Beispiele", difficulty: 0, mediapath: {"audios"=>["/audio/Diktiertest/Anweisungen/31b2.mp3","/audio/Diktiertest/Anweisungen/31b3.mp3"]}, itemtype:-2,  itemview:"items/studentbased/diktattest/6examples")
it.save
it = dicN1.items.build(itemtext: "Ich beginne", difficulty: 0, mediapath: {"audios"=>["/audio/Diktiertest/Anweisungen/32c.mp3"]}, itemtype:-1, itemview:"items/studentbased/diktattest/7startItem")
it.save

i=0
while i<items.size do
  it = dicN1.items.build(itemtext: items[i], mediapath:{"audios"=>["/audio/Diktiertest/" + audios[i]]}, difficulty: 0, itemtype:0, itemview:"items/studentbased/diktattest/8testItemStudent")
  it.save
  i= i+1
end

it = dicN1.items.build(itemtext: "Ende", difficulty: 0, mediapath: {"audios"=>["/audio/Diktiertest/Anweisungen/87a.mp3","/audio/Diktiertest/Anweisungen/88c.mp3","/audio/Diktiertest/Anweisungen/86b.mp3","/audio/Diktiertest/Anweisungen/89c.mp3"]}, itemtype:1, itemview:"items/studentbased/diktattest/9endItemStudent")
it.save

dicN1.save