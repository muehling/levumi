# -*- encoding : utf-8 -*-
items = %w{
lese
lila
Lora
Susi
Sofa
Mama
Mami
Mofa
Name
Nase
Oma
Omi
rase
rosa
Rose
Rosi
Limo
Lama
Resi
Lose
Ufo
Ali
Lilo
Mimi
Uli
Mus
Fifi
Fimo
Emil
Lena
Esel
Ami
Mia
Leni
Luna
Lisa
Lara
Sara
Nora
rufe
Ofen
}

cbmN1 = TestCBM.create(name: "Wörter lesen", len: items.size, info: "(c) Dr. Diehl ISER, Uni-Rostock", short_info: "(c) Dr. Diehl ISER, Uni-Rostock", time: 60, subject: "Deutsch", construct: "Leseflüssigkeit", level: "Niveaustufe 1", archive: false, student_access: false)

items.each do |i|
  it = cbmN1.items.build(itemtext: i, difficulty: 0, itemtype: 0)
  it.save
end

cbmN1.save



items = %w{
Eimer
Eisen
Feile
Hafen
Hafer
Haufen
holen
Hosen
laufe
laufen
Laune
leimen
Leine
leise
lesen
malen
Maler
Maus
Meile
mein
Meise
nein
Raum
Reifen
reime
Reise
Rosen
rufen
Sauna
sause
sehen
Seife
Ware
Weile
Auto
Hupe
Lupe
Note
Pause
Pilot
Pirat
Pute
taufen
Ton
Tor
}

cbmN2a = TestCBM.create(name: "Wörter lesen", len: items.size, info: "(c) Dr. Diehl ISER, Uni-Rostock", short_info: "(c) Dr. Diehl ISER, Uni-Rostock", time: 60, subject: "Deutsch", construct: "Leseflüssigkeit", level: "Niveaustufe 2a", archive: false, student_access: false)

items.each do |i|
  it = cbmN2a.items.build(itemtext: i, difficulty: 0, itemtype: 0)
  it.save
end

cbmN2a.save



items = %w{
fauchen
hauchen
rauchen
reichen
suchen
Haken
Kanal
kaufen
Kilo
Kino
Kuli
Laken
Pauke
Pokal
Bauch
Baum
Beil
Bein
Boden
Bogen
Daumen
Daunen
haben
heben
Laden
Lager
Leber
Leder
Rauch
Regen
Segen
gegen
gut
gemein
Gabel
Gas
Gebet
gehen
Geige
Geist
Gel
genau
genug
Glaube
}

groups = %i{
1
1
1
2
3
4
5
6
7
7
8
4
9
10
11
12
13
14
15
15
16
16
17
15
17
18
18
18
11
15
15
15
19
20
21
22
23
15
24
25
26
27
28
9
}

cbmN2b = TestCBM.create(name: "Wörter lesen", len: items.size, info: "(c) Dr. Diehl ISER, Uni-Rostock", short_info: "(c) Dr. Diehl ISER, Uni-Rostock", time: 60, subject: "Deutsch", construct: "Leseflüssigkeit", level: "Niveaustufe 2b", archive: false, student_access: false)

items.size.times do |i|
  it = cbmN2b.items.build(itemtext: items[i], difficulty: groups[i], itemtype: 0)
  it.save
end

cbmN2b.save



items = %w{
Zeichen
Zeile
heizen
Heizer
reizen
Weizen
Beule
Beute
Eule
Hebel
Heu
Hobel
Kegel
Keule
Kugel
Nadel
neu
Nudel
Scheine
Scheune
Schule
außen
heißen
jaulen
Judo
Juli
Juni
reißen
Soße
Verkauf
Versuch
Vogel
Bücher
Jäger
Käfer
Käse
Kübel
Küche
Kühe
Küken
Löwe
lügen
Möbel
mögen
Möwe
Rübe
sägen
Schüler
Tücher
Tüte
bequem
Hexe
hexen
mixen
Nixe
Quader
quaken
Qual
quälen
quer
Typ
}

groups = %i{
1
2
1
3
1
1
2
4
2
5
6
5
5
2
5
5
6
5
2
2
2
7
8
9
10
11
11
8
12
13
14
15
16
17
17
18
5
19
19
20
21
22
5
22
21
19
22
23
16
4
24
25
8
26
26
27
27
27
28
28
29
}

cbmN3 = TestCBM.create(name: "Wörter lesen", len: items.size, info: "(c) Dr. Diehl ISER, Uni-Rostock", short_info: "(c) Dr. Diehl ISER, Uni-Rostock", time: 60, subject: "Deutsch", construct: "Leseflüssigkeit", level: "Niveaustufe 3", archive: false, student_access: false)

items.size.times do |i|
  it = cbmN3.items.build(itemtext: items[i], difficulty: groups[i], itemtype: 0)
  it.save
end

cbmN3.save



items = %w{
Blase
Blume
Bluse
Blüte
Brause
Brote
Bruder
Frau
Freude
Glas
Gleis
Graben
Kragen
Kreide
Kreise
Kreuze
Probe
Traube
Traum
Birke
Birne
Durst
Felder
Gelder
Gurke
Gurken
Kinder
Kirche
Kirsche
Rinder
Schalter
Schulter
Torte
Turm
Türme
Turner
Wolke
Wolken
Wurm
Würmer
Wurst
Würste
falsche
Flasche
Forst
Frost
Frucht
Furcht
Karte
Kerze
Knoten
Konto
Korken
Kreuze
Krone
Kunst
plus
Puls
Scherben
schreiben
Galopp
Gipfel
}

cbmN4 = TestCBM.create(name: "Wörter lesen", len: items.size, info: "(c) Dr. Diehl ISER, Uni-Rostock", short_info: "(c) Dr. Diehl ISER, Uni-Rostock", time: 60, subject: "Deutsch", construct: "Leseflüssigkeit", level: "Niveaustufe 4", archive: false, student_access: false)

items.each do |i|
  it = cbmN4.items.build(itemtext: i, difficulty: 0, itemtype: 0)
  it.save
end

cbmN4.save
