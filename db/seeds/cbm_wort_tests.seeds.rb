# -*- encoding : utf-8 -*-

items = %w{
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
leder
Rauch
Regen
Segen
}

cbmN1 = TestSpeed.create(name: "CBM Wörter lesen - N2 Stufe 6", len: items.size, info: "(c) Dr. Diehl ISER, Uni-Rostock", short_info: "(c) Dr. Diehl ISER, Uni-Rostock", time: 60)

items.each do |i|
  it = cbmN1.items.build(itemtext: i, difficulty: 0)
  it.save
end

cbmN1.save



items = %w{
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

cbmN2 = TestSpeed.create(name: "CBM Wörter lesen - N3 Stufe 7-10", len: items.size, info: "(c) Dr. Diehl ISER, Uni-Rostock", short_info: "(c) Dr. Diehl ISER, Uni-Rostock", time: 60)

items.each do |i|
  it = cbmN2.items.build(itemtext: i, difficulty: 0)
  it.save
end

cbmN2.save



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
}

cbmN3 = TestSpeed.create(name: "CBM Wörter lesen - N4 Stufe 11-13", len: items.size, info: "(c) Dr. Diehl ISER, Uni-Rostock", short_info: "(c) Dr. Diehl ISER, Uni-Rostock", time: 60)

items.each do |i|
  it = cbmN3.items.build(itemtext: i, difficulty: 0)
  it.save
end

cbmN3.save

