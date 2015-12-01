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
}

cbmN1 = TestCBM.create(name: "CBM Wörter lesen - Niveaustufe 1", len: items.size, info: "(c) Dr. Diehl ISER, Uni-Rostock", short_info: "(c) Dr. Diehl ISER, Uni-Rostock", time: 60, subject: "Deutsch")

items.each do |i|
  it = cbmN1.items.build(itemtext: i, difficulty: 0)
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
Saum
Sauna
sause
sehen
Seife
Ware
Weiche
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

cbmN2a = TestCBM.create(name: "CBM Wörter lesen - Niveaustufe 2a", len: items.size, info: "(c) Dr. Diehl ISER, Uni-Rostock", short_info: "(c) Dr. Diehl ISER, Uni-Rostock", time: 60, subject: "Deutsch")

items.each do |i|
  it = cbmN2a.items.build(itemtext: i, difficulty: 0)
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

cbmN2b = TestCBM.create(name: "CBM Wörter lesen - Niveaustufe 2b", len: items.size, info: "(c) Dr. Diehl ISER, Uni-Rostock", short_info: "(c) Dr. Diehl ISER, Uni-Rostock", time: 60, subject: "Deutsch")

items.each do |i|
  it = cbmN2b.items.build(itemtext: i, difficulty: 0)
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
nadel
neu
Nudel
Scheine
Scheune
Schule
Seuche
außen
Boje
heißen
jaulen
Judo
Juli
Juni
Koje
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
Quote
Typ
Type
}

cbmN3 = TestCBM.create(name: "CBM Wörter lesen - Niveaustufe 3 Stufe", len: items.size, info: "(c) Dr. Diehl ISER, Uni-Rostock", short_info: "(c) Dr. Diehl ISER, Uni-Rostock", time: 60, subject: "Deutsch")

items.each do |i|
  it = cbmN3.items.build(itemtext: i, difficulty: 0)
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
Borte
Brote
falsche
Flasche
Forst
Frost
Frucht
Furcht
Karte
Kerze
Knoten
Knust
Konto
Korken
Kragen
Kreuze
Krone
Kunst
plus
Puls
scherben
schreiben
Galopp
Gipfel
}

cbmN4 = TestCBM.create(name: "CBM Wörter lesen - Niveaustufe 4", len: items.size, info: "(c) Dr. Diehl ISER, Uni-Rostock", short_info: "(c) Dr. Diehl ISER, Uni-Rostock", time: 60, subject: "Deutsch")

items.each do |i|
  it = cbmN4.items.build(itemtext: i, difficulty: 0)
  it.save
end

cbmN4.save
