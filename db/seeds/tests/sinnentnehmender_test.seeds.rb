# -*- encoding : utf-8 -*-

# Neue Elemente mit der festen Reihenfolge

items_n4 = %w{
	Augen
	fleißig
	Sobald
	Blumen
	schmeckt
	In
	Schere
	Haus
	wegen
	bevor
	wohne
	schnelle
	aber
	böse
	Baby
	Zwischen
	spricht
	Bett
	von
	scheint
	Nachdem
	runde
	Freunde
	gut
	Vogel
	Anstatt
	lustigen
	Durch
	Beine
	sammeln
	hungrig
	weder
	Sonne
	unter
	schläft
	Schuhe
	backt
	über
	Bilder
	Wenn
	süß
	Frösche
	Schwester
	dicke
	Biene
	Während
	für
	isst
	Enten
	Auf
	wartest
	Wasser
	neues
	außer
	spitz
	weil
	kauft
	Hase
	Tür
	mit
	Büro
}
before_gap_part_n4 = [
		"Ein Gesicht hat zwei",
		"Meine Schwester lernt immer",
		"",
		"Die",
		"Der Kuchen",
		"",
		"Die",
		"Meine Freundin zieht in ein neues",
		"Wir können",
		"Ich putze meine Zähne,",
		"Ich",
		"Das",
		"Ich habe eine gute Note,",
		"Die Polizei nimmt",
		"Das",
		"",
		"Lukas",
		"Meine Mama schläft im",
		"Diesen Stift habe ich",
		"Die Sonne",
		"",
		"Ein Apfel ist eine",
		"Die",
		"Durch meine Brille kann ich",
		"Der",
		"",
		"Lisa erzählt einen",
		"",
		"Ein Lama hat vier",
		"Im Wald",
		"Abends bin ich oft",
		"Paul hat",
		"Die",
		"Wir spielen",
		"Meine Oma",
		"Ich binde mir die",
		"Deine Freundin",
		"Du kletterst",
		"Lasse zeichnet schöne",
		"",
		"Die Limo ist",
		"Die",
		"Jutta geht mit ihrer",
		"Der",
		"Die",
		"",
		"Das Geschenk ist",
		"Das Mädchen",
		"Die",
		"",
		"Du",
		"Die Boje schwimmt auf dem",
		"Mein Papa kauft ein",
		"Jutta mag kein Obst essen,",
		"Eine Nadel ist",
		"Die Möwe kann fliegen,",
		"Paula",
		"Der",
		"Papa schließt abends die",
		"Das Auto zieht das andere Auto nur",
		"Mein Papa arbeitet in einem"
]


after_gap_part_n4 = [
		".",
		".",
		"ich fertig bin, melde ich mich bei dir.",
		"blühen auf der Wiese.",
		"uns allen gut.",
		"dem Schloss wohnt ein Geist.",
		"schneidet das Papier.",
		"um.",
		"dem schlechten Wetter nicht zu euch kommen.",
		"ich ins Bett gehe.",
		"bei meiner Familie.",
		"Auto rast die Straße entlang.",
		"Sina leider nicht.",
		"Räuber fest.",
		"schreit nach seiner Mutter.",
		"den Kissen liegt mein Heft.",
		"mit Frida über den Urlaub.",
		".",
		"meinem Opa.",
		"oft im Sommer.",
		"wir umgezogen sind, kaufen Mama und Papa neue Möbel.",
		"Frucht.",
		"machen viel Unsinn.",
		"sehen.",
		"fliegt zu seinem Nest.",
		"zu suchen, frage ich lieber meine Mama.",
		"Witz.",
		"das Fernglas sehe ich einen Turm.",
		".",
		"wir Blätter.",
		".",
		"einen Stift noch ein Heft.",
		"scheint jeden Tag.",
		"dem Tisch.",
		"samstags immer aus.",
		"zu.",
		"ein großes Brot.",
		"den Stamm.",
		".",
		"Wasser friert, wird es zu Eis.",
		".",
		"springen über die Straße.",
		"einkaufen.",
		"Mann schimpft laut.",
		"sitzt auf einer Blüte.",
		"meine Mama den Zaun streicht, spiele ich im Garten.",
		"meine Schwester.",
		"die Suppe.",
		"quaken auf dem See.",
		"dem Platz sitzen viele Leute.",
		"noch das Gewitter ab.",
		".",
		"Auto.",
		"Kirschen.",
		".",
		"sie ein Vogel ist.",
		"mir ein Geschenk.",
		"rennt über das Feld.",
		"ab.",
		"Mühe.",
		"."
]

item_alternatives_n4 = [
		%w{ Augen  Bücher  Autos  Finger  },
		%w{ dünn  grün  flach  fleißig  },
		%w{ Und  Doch  Sobald  Darum  },
		%w{ Jungen  Vögel  Stühle  Blumen  },
		%w{ riecht  trinkt  wählt  schmeckt  },
		%w{ Aus  Im  Durch  In  },
		%w{ Schere  Stirn  Pizza  Zwiebel  },
		%w{ Haus  Hemd  Beet  Heft  },
		%w{ wegen  hinter  über  für  },
		%w{ bald  davon  bevor  nachdem  },
		%w{ will  wohne  lasse  weiß  },
		%w{ frische  satte  schnelle  nahe  },
		%w{ dass  aber  weil  oder  },
		%w{ heiße  böse  flache  eckige  },
		%w{ Päckchen  Baby  Radio  Rätsel  },
		%w{ Vom  Aus  Zwischen  Im  },
		%w{ packt  backt  spricht  öffnet  },
		%w{ Tisch  Bett  Käfig  Bild  },
		%w{ hinter  mit  von  über  },
		%w{ regnet  schreit  schmilzt  scheint  },
		%w{ Als\ ob  Weder  Nachdem  Sondern  },
		%w{ warme  runde  lange  blaue  },
		%w{ Schuhe  Stifte  Freunde  Lichter  },
		%w{ frisch  laut  jung  gut  },
		%w{ Hund  Vater  Vogel  Verein  },
		%w{ Demnächst  Anstatt  Weil  Davon  },
		%w{ tiefen  lustigen  nassen  späten  },
		%w{ Im  Zu  Über  Durch  },
		%w{ Daumen  Bücher  Kamele  Beine  },
		%w{ schließen  sammeln  rechnen  stellen  },
		%w{ weit  hungrig  groß  nah  },
		%w{ obwohl  wegen  weder  dass  },
		%w{ Sonne  Wiese  Uhr  Puppe  },
		%w{ unter  drin  durch  von  },
		%w{ blickt  schläft  spült  schlägt  },
		%w{ Natur  Truhe  Schuhe  Schlüssel  },
		%w{ baut  backt  fragt  lernt  },
		%w{ zu  mitten  vom  über  },
		%w{ Bilder  Luft  Bisse  Kälte  },
		%w{ Wenn  Anstatt  Als  Bevor  },
		%w{ sandig  reich  leise  süß  },
		%w{ Pilze  Früchte  Frösche  Zähne  },
		%w{ Qual  Dusche  Schwester  Hütte  },
		%w{ eckige  runde  hohe  dicke  },
		%w{ Rinde  Blume  Biene  Nase  },
		%w{ Dafür  Während  Weder  Außer  },
		%w{ neben  unter  für  auf  },
		%w{ fährt  dreht  isst  läuft  },
		%w{ Häuser  Bären  Enten  Haare  },
		%w{ Durch  Drin  Auf  Aus  },
		%w{ triffst  wartest  liebst  entfernst  },
		%w{ Wasser  Bett  Löwen  Tuch  },
		%w{ kaltes  rundes  hohes  neues  },
		%w{ wegen  davon  damit  außer  },
		%w{ schuldig  spitz  lieb  laut  },
		%w{ außer  bevor  weil  davon  },
		%w{ rennt  kaut  kauft  brät  },
		%w{ Hase  Zahn  Rock  Sand  },
		%w{ Flasche  Tafel  Tür  Brücke  },
		%w{ mit  zu  zwischen  für  },
		%w{ Büro  Juni  Spaß  Maß  }
]
categories_n4 = %W{
	1
	2
	3
	1
	2
	3
	1
	1
	3
	3
	2
	2
	3
	2
	1
	3
	2
	1
	3
	2
	3
	1
	1
	2
	1
	3
	2
	3
	1
	2
	2
	3
	1
	3
	2
	1
	2
	3
	1
	3
	2
	1
	1
	2
	1
	3
	3
	2
	1
	3
	2
	1
	2
	3
	2
	3
	2
	1
	1
	3
	1
}

t = TestSEL.create(name: "Sinnentnehmendes Lesen",  info: "Sinnentnehmendes Lesen N4", shorthand: "SEL4",len: 63, time: 480, subject: "Deutsch", construct: "Sinnentnehmendes Lesen", student_access:true, archive: false, level: "N4")

i = t.items.build(itemtext: "Hallo", difficulty: 0, itemtype:-1, itemview: "items/studentbased/sinnentnehmender_lesetest/1hallo")
i.save

i = 0
while i<items_n4.size do
	it = t.items.build(itemtext: before_gap_part_n4[i] + "{" + item_alternatives_n4[i].join(",") + "}" + after_gap_part_n4[i], shorthand: items_n4[i], difficulty: categories_n4[i], itemtype: 0, itemview: "items/studentbased/sinnentnehmender_lesetest/2testItemStudent")
	it.save
	i = i+1
end

it = t.items.build(itemtext: "Ende", difficulty: 1, itemtype:1, itemview:"items/studentbased/sinnentnehmender_lesetest/3ende")
it.save
t.save




# Für die feste Reihenfolge
items_n2 = %w{
lerne
hell
Ende
Bruder
hell
Kuchen
Fibel
Schule
leben
Dose
male
schnell
Bein
laufen
schweren
Wasser
Abend
Keks
Lieder
kalt
Eier
besucht
Brot
Namen
scharfe
Fahrrad
wartet
kleinen
Berg
bade
Pause
faul
Schweine
baden
Taschen
blau
Ausflug
reiten
heimlich
Buch
Mofas
Abfall
tief
Boden
sieht
allein
Traktor
schlaue
trinkt
Kinder
Film
tollen
Ampel
Kater
lange
Weg
hebt
Milch
ruft
Opa
leere
Wand
Auto
Sofa
schwimmen
Seife
}


item_alternatives_n2 = [
		%w{ liege  tauche  lerne  reise  },
		%w{ tief  eng  hell  langsam  },
		%w{ Ende  Anfang  Plan  Kamm  },
		%w{ Bruder  Kopf  Sinn  Schatten  },
		%w{ lila  dunkel  hell  traurig  },
		%w{ Kuli  Kater  Kuchen  Uli  },
		%w{ Feder  Fibel  Leiter  Lupe  },
		%w{ Bibel  Schule  Schafe  Schuhe  },
		%w{ rutschen  leben  arbeiten  legen  },
		%w{ Dose  Lawine  Rose  Nadel  },
		%w{ lache  sehe  tobe  male  },
		%w{ schnell  weich  rosa  dumm  },
		%w{ Tal  Meer  Geschenk  Bein  },
		%w{ baden  leiden  laufen  klauen  },
		%w{ runden  breiten  schweren  dunklen  },
		%w{ Wal  Weg  Wasser  Wagen  },
		%w{ Baum  Abend  Mann  Boden  },
		%w{ Karo  Keks  Tag  Reis  },
		%w{ Berge  Lieder  Schatten  Ideen  },
		%w{ lang  warm  blau  kalt  },
		%w{ Eier  Essen  Fische  Wunden  },
		%w{ kauft  macht  rennt  besucht  },
		%w{ Bisons  Brot  Butter  Schatten  },
		%w{ Reifen  Samen  Ofen  Namen  },
		%w{ tiefe  scharfe  weiche  schlaue  },
		%w{ Ball  Ufer  Fahrrad  Kegel  },
		%w{ hebt  rennt  wartet  wirft  },
		%w{ kleinen  schlauen  klugen  faulen  },
		%w{ Bus  Berg  Baum  Fluss  },
		%w{ bade  dusche  finde  lese  },
		%w{ Pause  Leiter  Raupe  Woche  },
		%w{ faul  falsch  sicher  kalt  },
		%w{ Schweine  Leben  Schriften  Augen  },
		%w{ fallen  baden  bitten  glauben  },
		%w{ Leben  Taucher  Taschen  Daumen  },
		%w{ lau  blau  bitter  leicht  },
		%w{ Ausflug  Abfluss  Fisch  Hafer  },
		%w{ reisen  reiten  werfen  freuen  },
		%w{ heimlich  wund  langsam  lieb  },
		%w{ Bein  Eis  Buch  Auge  },
		%w{ Blumen  Sofas  Mofas  Flaschen  },
		%w{ Abfall  Sinn  Bau  Abend  },
		%w{ schwer  falsch  gelb  tief  },
		%w{ Mut  Kanal  Boden  Fisch  },
		%w{ freut  singt  sieht  weint  },
		%w{ rosa  allein  hell  leer  },
		%w{ Traktor  Salat  Reiter  Tuch  },
		%w{ harte  schlaue  giftige  graue  },
		%w{ trinkt  glaubt  taucht  sucht  },
		%w{ Hosen  Wege  Tische  Kinder  },
		%w{ Igel  Maler  Berg  Film  },
		%w{ runden  nassen  kalten  tollen  },
		%w{ Tafel  Gabel  Ampel  Ruhe  },
		%w{ Kater  Finger  Bauch  Tod  },
		%w{ lange  kluge  kranke  liebe  },
		%w{ Pudel  Wurm  Ofen  Weg  },
		%w{ leiht  heilt  feilt  hebt  },
		%w{ Milch  Mutter  Watte  Tasse  },
		%w{ fegt  schwimmt  geht  ruft  },
		%w{ Opa  Sonntag  Baum  Ofen  },
		%w{ leere  blinde  arme  schwache  },
		%w{ Kabel  Wand  Welt  Gabel  },
		%w{ Haus  Auto  Auge  Hund  },
		%w{ Tor  Sofa  Mond  Wasser  },
		%w{ grillen  schwimmen  wohnen  rennen  },
		%w{ Kuchen  Sand  Taler  Seife  }
]


before_gap_part_n2 = [
    "Ich",
    "Die Sonne scheint",
    "Am",
    "Mama holt meinen",
    "Morgens wird es",
    "Wir essen den",
    "In meiner",
    "Lisa geht in die",
    "Im Wald",
    "In der",
    "Ich",
    "Leon rennt",
    "Eine Frau gewinnt ein",
    "Wir",
    "Mein Papa hat einen",
    "Das Kanu schwimmt auf dem",
    "Am",
    "Ich gebe ihr einen",
    "Die",
    "Im Winter sind die Tage",
    "Ein Huhn legt",
    "Meine Oma",
    "Enten essen gerne",
    "",
    "Der Wolf hat",
    "Ich fahre auf einem",
    "Anna",
    "Wir reisen mit einer",
    "Eine Frau rodelt den",
    "Ich",
    "Wir machen eine",
    "Oft sind Esel",
    "Der Bauer hat drei",
    "Sonntags muss Bello immer",
    "Die Kinder legen ihre",
    "Der Kuli schreibt",
    "Sie kommt auf den",
    "Lina und Frida",
    "In der Klasse kichern wir",
    "Wir lesen ein",
    "Die",
    "Susi wirft den",
    "Meere sind",
    "Ich laufe auf dem",
    "Tom",
    "Ali sucht",
    "Wir fahren auf dem",
    "Lea und Lara sind",
    "Lino",
    "Die",
    "Ich schaue einen",
    "Marie hat einen",
    "Die",
    "Peter findet seinen",
    "Ich trage eine",
    "Wir laufen den",
    "Lisa",
    "Ich trinke meine",
    "Anton",
    "Ich warte auf meinen",
    "Tina gibt mir eine",
    "Der Mann rennt gegen die",
    "Ein",
    "Olaf liegt auf dem",
    "Die Kinder",
    "Ich wasche mich mit",
]
after_gap_part_n2 = [
    "in der Schule.",
    ".",
    "sind wir fertig",
    "ab.",
    ".",
    "auf.",
    "sind bunte Bilder.",
    ".",
    "Tiere.",
    "sind Kekse.",
    "Mama ein Bild.",
    ".",
    ".",
    "zu dem Lager.",
    "Tag.",
    ".",
    "gehe ich ins Bett.",
    "ab.",
    "sind laut.",
    ".",
    ".",
    "mich immer sonntags.",
    ".",
    "sind an jedem Auto.",
    "Krallen.",
    ".",
    "an der roten Ampel.",
    "Bahn.",
    "hinunter.",
    "gerne im See.",
    ".",
    ".",
    ".",
    ".",
    "ab.",
    ".",
    "nach",
    "im Wald.",
    ".",
    ".",
    "fahren langsam.",
    "weg.",
    ".",
    ".",
    "traurig aus.",
    ".",
    ".",
    "Kinder.",
    "eine Limo.",
    "schauen ein Bild an.",
    ".",
    "Traum.",
    "blinkt gelb.",
    "wieder.",
    "Hose.",
    "ab.",
    "eine Lupe auf.",
    ".",
    "Ina.",
    ".",
    "Tasse.",
    ".",
    "hat eine Hupe.",
    ".",
    "im Wasser.",
    "."
]

categories_n2 = %w{
	2
	2
	1
	1
	2
	1
	1
	1
	2
	1
	2
	2
	1
	2
	2
	1
	1
	1
	1
	2
	1
	2
	1
	1
	2
	1
	2
	2
	1
	2
	1
	2
	1
	2
	1
	2
	1
	2
	2
	1
	1
	1
	2
	1
	2
	2
	1
	2
	2
	1
	1
	2
	1
	1
	2
	1
	2
	1
	2
	1
	2
	1
	1
	1
	2
	1
}



tN2 = TestSEL.create(name: "Sinnentnehmendes Lesen", len: 68, info: "Sinnentnehmendes Lesen N2", shorthand: "SEL2",
										 subject: "Deutsch", construct: "Sinnentnehmendes Lesen", student_access:true, archive: false, level: "N2", time: 480)
i = tN2.items.build(itemtext: "Hallo", difficulty: 0, itemtype:-1, itemview: "items/studentbased/sinnentnehmender_lesetest/1hallo")
i.save

i = 0
while i<items_n2.size do
	it = tN2.items.build(itemtext: before_gap_part_n2[i] + "{" + item_alternatives_n2[i].join(",") + "}" + after_gap_part_n2[i], shorthand: items_n2[i], difficulty: categories_n2[i], itemtype: 0, itemview: "items/studentbased/sinnentnehmender_lesetest/2testItemStudent")
	it.save
	i = i+1
end
it = tN2.items.build(itemtext: "Ende", difficulty: 1, itemtype:1, itemview:"items/studentbased/sinnentnehmender_lesetest/3ende")
it.save
tN2.save