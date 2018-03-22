# -*- encoding : utf-8 -*-
items = %w{
Fimo
Sara
Nase
Omi
rufe
Mus
Leni
Mofa
Ali
Lara
Ufo
Rose
lila
Emil
Mimi
rosa
Susi
Luna
Ami
Lilo
Mami
Nora
Limo
Ofen
Lena
Resi
Fifi
Lisa
Uli
lese
Mama
Rosi
Name
Oma
Esel
Sofa
Lama
rase
Lose
Mia
Lora
}

cbmN1 = TestCBM.create(name: "Wörter lesen", len: items.size, info: "(c) Dr. Diehl ISER, Uni-Rostock", shorthand: "WL1", time: 60, subject: "Deutsch", construct: "Leseflüssigkeit", level: "Niveaustufe 1", type_info:"Speed-Test", archive: false, student_access: false)

it = cbmN1.items.build(itemtext: "Preparation", difficulty: 0, itemtype:-1, itemview:"items/userbased/preparationUser")
it.save

items.each do |i|
  it = cbmN1.items.build(itemtext: i, difficulty: 0, itemtype: 0, itemview:"items/userbased/testItemUser")
  it.save
end

it = cbmN1.items.build(itemtext: "Ende", difficulty: 0, itemtype:1, itemview:"items/userbased/endItemUser")
it.save

cbmN1.save



items = %w{
holen
Sauna
Ware
Eimer
Pirat
Auto
Tor
mein
Raum
rufen
Hupe
Feile
laufen
Maler
Seife
Pause
reime
Pilot
Maus
Hafen
leimen
taufen
Eisen
nein
sause
malen
Note
Reise
sehen
Hafer
laufe
Meile
Pute
Laune
Hosen
Haufen
Reifen
Lupe
Rosen
Ton
Leine
Weile
leise
lesen
Meise
}

cbmN2a = TestCBM.create(name: "Wörter lesen", len: items.size, info: "(c) Dr. Diehl ISER, Uni-Rostock", shorthand: "WL2a", time: 60, subject: "Deutsch", construct: "Leseflüssigkeit", level: "Niveaustufe 2a", type_info:"Speed-Test", archive: false, student_access: false)

it = cbmN2a.items.build(itemtext: "Preparation", difficulty: 0, itemtype:-1, itemview:"items/userbased/preparationUser")
it.save

items.each do |i|
  it = cbmN2a.items.build(itemtext: i, difficulty: 0, itemtype: 0, itemview:"items/userbased/testItemUser")
  it.save
end

it = cbmN2a.items.build(itemtext: "Ende", difficulty: 0, itemtype:1, itemview:"items/userbased/endItemUser")
it.save

cbmN2a.save



items = %w{
Regen
Beil
Kino
hauchen
Leber
genug
Daumen
reichen
gehen
Haken
Boden
heben
Gas
Pokal
gut
Bauch
genau
Segen
Lager
Kanal
gemein
gegen
Baum
suchen
Gebet
Laden
rauchen
Kilo
Bein
Daunen
Gel
Laken
Rauch
kaufen
Bogen
Gabel
Pauke
Kuli
Geige
fauchen
Leder
haben
}

groups = %i{
15
13
7
1
18
28
16
2
15
4
15
15
22
10
19
11
27
15
18
5
20
15
12
3
23
17
1
7
14
16
26
4
11
6
15
21
9
8
24
1
18
17
}

cbmN2b = TestCBM.create(name: "Wörter lesen", len: items.size, info: "(c) Dr. Diehl ISER, Uni-Rostock", shorthand: "WL2b", time: 60, subject: "Deutsch", construct: "Leseflüssigkeit", level: "Niveaustufe 2b", type_info:"Speed-Test", archive: false, student_access: false)

it = cbmN2b.items.build(itemtext: "Preparation", difficulty: 0, itemtype:-1, itemview:"items/userbased/preparationUser")
it.save

items.size.times do |i|
  it = cbmN2b.items.build(itemtext: items[i], difficulty: groups[i], itemtype: 0, itemview:"items/userbased/testItemUser")
  it.save
end

it = cbmN2b.items.build(itemtext: "Ende", difficulty: 0, itemtype:1, itemview:"items/userbased/endItemUser")
it.save

cbmN2b.save



items = %w{
Küche
heißen
Jäger
Nixe
Zeichen
quaken
Löwe
Vogel
Scheune
Typ
jaulen
Kühe
Eule
reißen
bequem
Tücher
reizen
mixen
Bücher
Quader
neu
Möwe
Scheine
heizen
Beute
Judo
Küken
Soße
quälen
Hobel
Keule
außen
lügen
Juli
Heizer
Schüler
Qual
Käse
Zeile
hexen
Kegel
Möbel
mögen
Schule
Heu
Tüte
Nudel
Juni
Beule
Kübel
quer
Kugel
Verkauf
Rübe
Nadel
sägen
Weizen
Hebel
Käfer
Hexe
Versuch
}

groups = %i{
19
8
17
26
1
27
21
15
2
29
9
19
2
8
24
16
1
26
16
27
6
21
2
1
4
10
20
12
28
5
2
7
22
11
3
23
27
18
2
8
5
5
22
2
6
4
5
11
2
5
28
5
13
19
5
22
1
5
17
25
14
}

cbmN3 = TestCBM.create(name: "Wörter lesen", len: items.size, info: "(c) Dr. Diehl ISER, Uni-Rostock", shorthand: "WL3", time: 60, subject: "Deutsch", construct: "Leseflüssigkeit", level: "Niveaustufe 3", type_info:"Speed-Test", archive: false, student_access: false)

it = cbmN3.items.build(itemtext: "Preparation", difficulty: 0, itemtype:-1, itemview:"items/userbased/preparationUser")
it.save

items.size.times do |i|
  it = cbmN3.items.build(itemtext: items[i], difficulty: groups[i], itemtype: 0, itemview:"items/userbased/testItemUser")
  it.save
end

it = cbmN3.items.build(itemtext: "Ende", difficulty: 0, itemtype:1, itemview:"items/userbased/endItemUser")
it.save

cbmN3.save



items = %w{
Gleis
schreiben
Wolke
Blüte
Rinder
Forst
Traube
Durst
Kreide
Schulter
Birke
Felder
Kirche
Probe
Gipfel
Brote
Türme
Freude
Kerze
Scherben
Puls
Konto
Graben
plus
Flasche
Wurm
Traum
Kreuze
Blase
Kragen
Würste
Torte
Glas
Knoten
Brause
Kirsche
Korken
Frost
Gurke
Schalter
falsche
Krone
Blume
Turm
Kreise
Birne
Frau
Karte
Wolken
Bruder
Turner
Frucht
Galopp
Würmer
Kinder
Gurken
Bluse
Wurst
Furcht
Kunst
Gelder
}

cbmN4 = TestCBM.create(name: "Wörter lesen", len: items.size, info: "(c) Dr. Diehl ISER, Uni-Rostock", shorthand: "WL4", time: 60, subject: "Deutsch", construct: "Leseflüssigkeit", level: "Niveaustufe 4", type_info:"Speed-Test", archive: false, student_access: false)

it = cbmN4.items.build(itemtext: "Preparation", difficulty: 0, itemtype:-1, itemview:"items/userbased/preparationUser")
it.save

items.each do |i|
  it = cbmN4.items.build(itemtext: i, difficulty: 0, itemtype: 0, itemview:"items/userbased/testItemUser")
  it.save
end

it = cbmN4.items.build(itemtext: "Ende", difficulty: 0, itemtype:1, itemview:"items/userbased/endItemUser")
it.save

cbmN4.save
