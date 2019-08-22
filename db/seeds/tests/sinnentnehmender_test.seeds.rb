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

t = TestSEL.create(name: "Sinnentnehmendes Lesen",  info: "Sinnentnehmendes Lesen N4", shorthand: "SEL4",len: 63, time: 300, subject: "Deutsch", construct: "Sinnentnehmendes Lesen", student_access:true, archive: false, level: "N4")

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
										 subject: "Deutsch", construct: "Sinnentnehmendes Lesen", student_access:true, archive: false, level: "N2", time: 300)
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

# Neuer Teil von Ibrahim

categories_n6 = %w{
	2
	1
	3
	1
	2
	3
	3
	2
	1
	2
	3
	1
	3
	2
	3
	2
	1
	1
	2
	3
	3
	2
	1
	1
	2
	3
	2
	1
	3
	2
	3
	1
	1
	3
	2
	3
	2
	1
	1
	3
	2
	2
	1
	3
	1
	2
	3
	1
	2
	3
	3
	2
	1
	1
	3
	2
	2
	1
	3
	2
	3
	1
	2
	1
	3
	2
	1
	3
	3
	1
	2
	1
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
	2
	2
	2
	2
	2
	2
	2
	2
	2
	2
}

before_gap_part_n6 = [
		"Lisa und Jonathan möchten beide vorne im Auto sitzen. Sie",
		"Lars, der seinen Geldbeutel auf dem Weg zum Laden verloren hatte, wird viel Ärger wegen des",
		"Heute war ich mit meinem Skateboard auf der Halfpipe. Ich habe das erste Mal meinen neuen",
		"Trotz der Warnung seiner Freunde machte sich Benjamin auf die",
		"Claudia muss heute als Hausaufgabe eine lange Geschichte lesen.",
		"Als die Schulglocke ein zweites Mal ertönt, laufen alle Kinder schnell in ihr",
		"Tom schießt beim Fußball sein erstes Tor. Die Zuschauer",
		"Ben ist in Anna verliebt. Er schenkt",
		"Trotz der langen Reise waren wir",
		"Jens fragt: „Kennst du den neuen Mitschüler in unserer Klasse?“. „",
		"Im Park spielt Jannis mit seinen Freunden Fußball auf dem Rasenplatz. Die",
		"Da eine Party eine gute Gelegenheit ist sich kennenzulernen, möchte ich meine Nachbarn",
		"Mein Bruder ist mit dem Auto gegen eine Laterne gefahren. Mama und Papa sind deshalb sehr",
		"Peter und Anna sehen sich zusammen einen Film im Kino an. Gerade wird auf der großen",
		"Moritz und Max laufen in der großen Pause um die Wette. Max ist zehn",
		"Das blaue Haus, das alleine auf der Wiese steht, ist schon sehr alt. Das kann man daran erkennen, dass die Farbe an dem",
		"Obwohl Pia großen Hunger hat, isst sie",
		"Obwohl Peter keine Vögel mag,",
		"Lukas kauft neue Blumen für den Garten. Zuhause gräbt er die",
		"Die Sekretärin lacht laut im Vorzimmer. Daraufhin macht Frau Schmidt ihre",
		"Viele Schiffen sind heute aus dem Hafen ausgelaufen. Deswegen sind viele",
		"Max hatte das Spielzeugauto seines kleinen Bruders Liam ausversehen heruntergeschmissen. Liam schreit: „Ich sage Mama, dass",
		"Der Student ist durch die Prüfung gefallen, obwohl er",
		"Selbst wenn es schneit,",
		"Für unser Essen heute Abend müssen wir noch einkaufen gehen. Eine Liste der benötigten",
		"Papa fährt immer mit dem Auto zur Arbeit. Auf dem Rückweg muss er manchmal",
		"In der Europäischen Union kann man in fast allen Ländern mit dem Euro bezahlen. Das",
		"Auch wenn wir früher losfahren, werden wir",
		"Heute genießen wir den letzten Tag des Wochenendes.",
		"Mama und ich machen einen gemeinsamen Ausflug in den Zoo.",
		"Pia und Jonas warten auf den Zug. Endlich",
		"Pia isst jeden Tag im Restaurant, obwohl sie",
		"Selbst wenn wir rennen,",
		"Bernhardt verletzte sich beim Fußball. George",
		"Das Gemälde im Museum, das von einem berühmten Künstler gemalt wurde, ist sehr teuer. Yannick findet das",
		"Viele Kinder möchten heute Schaukeln. Es bildet sich eine lange Schlange auf dem",
		"Mein bester Freund fragt mich: „Hast du eine neue Hose?“. Da ich mit meinem Papa shoppen war, antwortete ich: „",
		"Das teure Baumaterial, was beim Einkauf sehr teuer war, ist sehr",
		"Mama geht heute arbeiten, obwohl sie",
		"Alina kauft im Supermarkt Lebensmittel ein. Sie",
		"Kühe legen keine Eier, sondern bringen ihre Jungen lebend zur Welt. Nach der Geburt trinken",
		"Ein Fahrer steigt in sein Auto und gibt das Ziel in das Navigationsgerät ein. Er findet den richtigen",
		"Ole, der mit seinem neuen Ball kickt, verbietet Jan mit ihm zusammen zu",
		"Lisa möchte mit ihren Hausaufgaben beginnen. Dafür setzt sie sich an ihren",
		"Die meisten Schülerinnen und Schüler, die fleißig lernen, schreiben",
		"Mein Chirurg wurde wütend, weil ich nach der Operation alleine nach Hause gefahren bin. Nach meiner zweiten Operation bestand mein",
		"Schade, dass der Sommer schon wieder vorbei ist. In ein paar",
		"Auch wenn das Wetter gut wäre, würden wir",
		"Lars hatte zu seinem Geburtstag im August viele Kinder eingeladen. Sie",
		"Mira ist gerade in den Zug nach Hause gestiegen. Sie wird",
		"Ich habe vergessen vor dem Urlaub die Blumen zu gießen. Wenn ich in ein paar",
		"Jonathan hatte sich ein neues Motorrad gekauft.",
		"Obwohl der Schauspieler sehr",
		"Als ich klein war, wollte ich immer auf den Spielplatz, um zu",
		"In den letzten Jahrzehnten wurde sehr viel Müll in die Meere gekippt. An den Folgen sterben",
		"Thorsten fragt: „Hast du meine Brille gesehen?“. Seine Mama vermutet, dass",
		"Mit der Familie sind wir in die Berge gefahren.",
		"Der Angestellte geht nicht zur Arbeit, obwohl er",
		"Max feiert heute im Kindergarten seinen 5. Geburtstag. Nächstes",
		"Auf der Party lernte Thomas Nele kennen. Sein bester Freund hatte ihm schon von",
		"Heute ist schönes Wetter, da die Sonne die ganze Zeit scheint. Deshalb verbringen wir den Tag",
		"Pauls Freundin, die ihn sehr",
		"Der Lehrer fragt den Schüler nach der richtigen Antwort. Aber",
		"Am Strand, dort wo der Horizont gut zu sehen ist, sieht man wunderschöne",
		"An der Bahnstation steht immer eine Anzeigetafel mit den Abfahrtszeiten. Deswegen",
		"Anna ist mit ihren Eltern in den Ferien ans Meer gefahren.",
		"Zwar ist die Aufgabe einfach, aber ich verstehe sie trotzdem",
		"Jeden Samstag ist in der Stadt Wochenmarkt. An vielen",
		"Im Mittelalter wurden Hexen verbrannt.",
		"Das Licht erhellt, obwohl die Vorhänge zugezogen sind, den Raum",
		"Hans, der gerne liest, geht häufig in die Bücherei, um sich Bücher auszuleihen. Dort in der",
		"Das Rohr ist, nachdem es vom Balkon gefallen war, völlig",
		"Als die Vorstellung zu Ende ist, gibt es viel Applaus. Wir",
		"Plötzlich fängt es stark an zu regnen. Daher bittet mich Annette schnell die Fenster zu",
		"Die Eltern verbieten Marie und Paul bei dem kalten Wetter draußen zu spielen. Sie helfen",
		"Ich hoffe, dass du nichts dagegen hast, wenn ich mir das Buch",
		"Viele unserer Bäume verlieren einmal im Jahr ihre Blätter. Nur Nadelbäume sind auch im",
		"Im Krankenhaus bringen die Krankenschwestern meinen Papa das Essen. Die",
		"Da Paul mehr Geld benötigt, versucht er es zu",
		"Vögel schlucken ihre Nahrung im Ganzen herunter. Mein Wellensichtig",
		"Der Polizist verteilt in der Nachbarschaft Strafzettel. Ein Mann wurde wütend, als der",
		"Die Stunde begann. Ein paar",
		"Er versicherte, dass er mir das Geld zurückzahlt, sobald sich seine Lage",
		"Ich mag meine Großeltern sehr. Bei",
		"Papa ist sauer, weil unser Wagen in die Werkstatt muss. Das",
		"Es wird ziemlich kalt im Zimmer. Ole fragt Peter, ob er das Fenster",
		"Das Orchester beginnt mit dem Konzert. Die Zuhörer",
		"In ihrem Urlaub sind Tom und Lisa ans Meer gefahren. Sie sind oft im",
		"Alle Schüler holen ihre Mappen heraus. Sie",
		"Der Autofahrer hupt, weil die Frau das Auto nicht bemerkt. Die",
		"Weil es am Wochenende warm werden soll, gehe ich mit meinen Freunden ins Freibad. Das",
		"Um 23:33 Uhr kamt ihr am Bahnhof an. Sophia war dort, um",
		"Der Schiedsrichter erteilt dem fremden Zuschauer einen Platzverweis."
]

after_gap_part_n6 = [
		"sich um den Platz.",
		"Geldes bekommen.",
		"geschafft.",
		"Reise.",
		"hatte keine Lust ihre Hausaufgaben zu machen. ",
		".",
		"vor Freude.",
		"oft Blumen. ",
		"müde.",
		"habe ich noch nie gesehen“, antwortet Ahmet.",
		"ist noch leicht nass vom Regen.",
		".",
		"auf ihn.",
		"die Werbung, die immer vor dem Film gezeigt wird, abgespielt.",
		"schneller ins Ziel gelaufen als Moritz.",
		"schon verblasst ist. ",
		".",
		"er den Vogelpark.",
		"direkt in die Erde ein. ",
		"zu.",
		"frei.",
		"es kaputt gemacht hast.“ ",
		"gelernt hatte.",
		"Lisa die weite Strecke zur Arbeit. ",
		"hatte Mama schon geschrieben. ",
		", damit er immer gut nach Hause kommt.",
		"muss für Reisen in andere Länder nicht umgetauscht werden.",
		"einen Parkplatz finden.",
		"ist schon wieder Montag und wir müssen zur Schule gehen.",
		"sehen viele Tiere, die ich noch nicht kannte.",
		"er in den Bahnhof ein. ",
		"Geld verdient.",
		"wir den Zug.",
		"den Arzt.",
		"trotzdem hässlich.",
		".",
		"habe ich mir gestern gekauft. ",
		".",
		"krank ist.",
		"viel Geld an der Kasse.",
		"bei ihrer Mutter Milch.",
		"zum Zielort.",
		".",
		".",
		"Noten.",
		"darauf, dass ich abgeholt werde.",
		"ist schon Winter.",
		"einen Ausflug machen.",
		"im Garten.",
		"am Bahnhof ankommen.",
		"nach Hause komme, sind sie bestimmt verwelkt.",
		"soll sehr schnell fahren können.",
		"ist, bekommt er keine Rollen angeboten. ",
		".",
		"immer noch viele Tiere.",
		"auf dem Küchentisch liegt.",
		"hatte der Urlaub gut gefallen. ",
		"zu erledigen hatte.",
		", wenn er sechs wird, wird er eingeschult. ",
		"erzählt.",
		".",
		", möchte ihn trotzdem nicht heiraten.",
		"antwortet ihm nicht.",
		".",
		"ich die Züge nie.",
		"ist türkis und die Wellen sind hoch.",
		".",
		"wird Obst und Gemüse verkauft.",
		"glaubten die Menschen auch noch an Zauberei.",
		".",
		"sind sowohl neue als auch alte Bücher zu finden. ",
		".",
		"laut mit.",
		".",
		"beim Kuchen backen.",
		".",
		"grün.",
		"können nicht verstehen, dass er das Essen nicht mag. ",
		", indem er Zeitungen austrägt.",
		"seine Nahrung auch nicht.",
		"auch ihm einen Strafzettel an sein falsch geparktes Auto heftet. ",
		"später war ich eingeschlafen.",
		".",
		"war ich neulich zu Besuch. ",
		"ist schon wieder kaputt, da es nicht angesprungen ist. ",
		"kann.",
		".",
		"gesurft, da es viele Wellen gab. ",
		"die Arbeitsblätter ein um Ordnung zu schaffen.",
		"erschreckt sich sehr, so dass sie stehen bleibt.",
		"tut bestimmt gut bei der Hitze.",
		"zu begrüßen.",
		"muss nun den Platz verlassen."
]

item_alternatives_n6 = [
		%w{streiten vertragen verfolgen setzen},
		%w{verschwundenen gefundenen versteckten wiederbekommenen},
		%w{Trick Kuchen Torschuss Helm},
		%w{gefährliche grüne kurze sichere},
		%w{Sie Er Du Ihr},
		%w{Klassenzimmer Bett Kino Schwimmbad},
		%w{jubeln laufen joggen treten},
		%w{ihr mir uns dir},
		%w{nicht bereits sehr berühmt},
		%w{Ihn Euch Sie Seiner},
		%w{Wiese Asche Lampe Weide},
		%w{einladen ausladen einfordern umziehen},
		%w{sauer süß neidisch schnell},
		%w{Leinwand Decke Latzhose Tür},
		%w{Sekunden Jahre Kilometer Sachen},
		%w{Gebäude Fahrzeug Gras Fundort},
		%w{nichts viel Abendessen Nudeln},
		%w{besucht verachtet verlässt bestreut},
		%w{Pflanzen Bäume Blüten Pfanne},
		%w{Bürotür Gartentür Bücher Schnürsenkel},
		%w{Anlegeplätze Garagen Angler Netze},
		%w{du dir er ihm},
		%w{viel wenig weich schlecht},
		%w{läuft setzt schweigt lernt},
		%w{Lebensmittel Kleider Leistungen Geschäfte},
		%w{tanken laufen trinken fahren},
		%w{Geld Papier Grab Mitbringsel},
		%w{nie neulich immer lange},
		%w{Morgen Gestern Mittag Abend},
		%w{Wir Sie Unser Euch},
		%w{fährt verabschiedet rennt friert},
		%w{wenig viel arm weit},
		%w{verpassen bekommen verlieren fahren},
		%w{rief flüsterte lief hasste},
		%w{Bild Glas Band Buch},
		%w{Spielplatz Sportplatz Beet See},
		%w{Diese Wir Es Du},
		%w{hochwertig langweilig billig hoch},
		%w{sehr nicht neulich fleißig},
		%w{bezahlt bezaubert nimmt kauft},
		%w{sie er ihr wir},
		%w{Weg Hügel Flug Knopf},
		%w{spielen gehen spannen lernen},
		%w{Schreibtisch Schrank Drucker Baum},
		%w{gute schlechte graue viele},
		%w{Arzt Krankenpfleger Therapeut Arbeiter},
		%w{Monaten Sekunden Jahreszeiten Monden},
		%w{niemals besagte blinde grüne},
		%w{feiern frieren weinen pflanzen},
		%w{bald damals fahrend bellend},
		%w{Tagen Jahren Taufen Ländern},
		%w{Es Seiner Ihm Sie},
		%w{berühmt unbekannt bemalt bedeutungslos},
		%w{rutschen schwimmen rascheln platzen},
		%w{heutzutage gestern nass grau},
		%w{sie ihr wir du},
		%w{Uns Wir Dir Ihm},
		%w{reichlich nichts stark blau},
		%w{Jahr Leben Lachen Jahrtausend},
		%w{ihr uns ihnen euch},
		%w{draußen drinnen warm versteinert},
		%w{liebt hasst lehrt trägt},
		%w{dieser es ihn dir},
		%w{Sonnenuntergänge Hochhäuser Schränke Sonnenstühle},
		%w{verpasse bekomme bemale nehme},
		%w{Es Sie Unser Ihr},
		%w{nicht gut nachts dumm},
		%w{Ständen Bänken Stunden Feldern},
		%w{Damals Bald Übermorgen Dackel},
		%w{etwas dunkel nicht eckig},
		%w{Bibliothek Buchhandlung Apotheke Hundehütte},
		%w{verbogen neu rund verrostet},
		%w{klatschen schweigen kleben schlagen},
		%w{schließen putzen schleifen öffnen},
		%w{ihnen euch uns dir},
		%w{ausleihe auslege gebe schreibe},
		%w{Winter Sommer Wachstum Juli},
		%w{Pflegerinnen Feuerwehrmänner Polizistinnen Freundinnen},
		%w{verdienen stehlen kaufen drehen},
		%w{kaut schluckt kauft fliegt},
		%w{Ordnungshüter Verbrecher König Optiker},
		%w{Minuten Mauern Jahre Folgen},
		%w{verbessert verschlechtert verliert verbrennt},
		%w{ihnen sie euch meiner},
		%w{Auto Fahrrad Armband Werkzeug},
		%w{schließen öffnen schrumpfen putzen},
		%w{verstummen plappern vermuten singen direkt},
		%w{Ozean Osten Auto Fluss},
		%w{heften schmeißen hoffen schreiben},
		%w{Dame Dose Autotür Giraffe},
		%w{Schwimmen Rennen Schwitzen Schweben},
		%w{euch uns ihnen sich},
		%w{Dieser Sie Ihn Uns}
]


tN6 = TestSEL.create(name: "Sinnentnehmendes Lesen", len: 95, info: "Sinnentnehmendes Lesen N6", shorthand: "SEL6",
										 subject: "Deutsch", construct: "Sinnentnehmendes Lesen", student_access:true, archive: false, level: "N6", time: 300,
										 :generic_views => {"student" => "sel/student_overview.html.erb"})
i = tN6.items.build(itemtext: "Hallo", difficulty: 0, itemtype:-1, itemview: "items/studentbased/sinnentnehmender_lesetest/1hallo")
i.save

i = 0
while i<item_alternatives_n6.size do
	it = tN6.items.build(itemtext: before_gap_part_n6[i] + "{" + item_alternatives_n6[i].join(",") + "}" + after_gap_part_n6[i],
											 shorthand: item_alternatives_n6[i][0], difficulty: categories_n6[i], itemtype: 0, itemview: "items/studentbased/sinnentnehmender_lesetest/2testItemStudent")
	it.save
	i = i+1
end
it = tN6.items.build(itemtext: "Ende", difficulty: 1, itemtype:1, itemview:"items/studentbased/sinnentnehmender_lesetest/3ende")
it.save
tN6.save