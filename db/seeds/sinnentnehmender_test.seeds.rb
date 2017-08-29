# The test looks like: Ich ... Wasser. (esse/trinke/spiele/schreibe/)
# The correct answers category 1
items_n4_k1 = %w{
	Augen
	Bett
	Bilder
	Beine
	runde
	Haus
	Schuhe
	Tür
	Schwester
	Büro
	Wasser
	Vogel
	Enten
	Blumen
	Freunde
	Hase
	Schere
	Baby
	Sonne
	Frösche
	Biene
}

# The alternatives to write on the buttons
item_alternatives_n4_k1 = [
	%w{	Bücher	Augen	Finger	Autos	},
	%w{	Tisch	Bett	Käfig	Bild	},
	%w{	Bisse	Bilder	Luft	Kälte	},
	%w{	Beine	Daumen	Kamel	Bücher	},
	%w{	runde	lange	blaue	warme	},
	%w{	Haus	Hemd	Heft	Beet	},
	%w{	Truhe	Schlüssel	Schuhe	Natur	},
	%w{	Brücke	Flasche	Tür	Tafel	},
	%w{	Hütte	Dusche	Schwester	Qual	},
	%w{	Spaß	Juni	Maß	Büro	},
	%w{	Tuch	Bett	Löwen	Wasser	},
	%w{	Vogel	Hund	Verein	Vater	},
	%w{	Enten	Bären	Häuser	Haare	},
	%w{	Blumen	Spechte	Jungen	Stühle	},
	%w{	Stifte	Freunde	Schuhe	Lichter	},
	%w{	Sand	Hase	Rock	Zahn	},
	%w{	Pizza	Schere	Zwiebel	Stirn	},
	%w{	Päckchen	Radio	Baby	Rätsel	},
	%w{	Uhr	Wiese	Sonne	Puppe	},
	%w{	Zähne	Pilze	Früchte	Frösche	},
	%w{	Blume	Rinde	Nase	Biene	}
]

# Sentence part to set before the gap
before_gap_part_n4_k1 = %w{
	Ein\ Gesicht\ hat\ zwei
	Mein\ Papa\ schläft\ im
	Lasse\ zeichnet\ schöne
	Ein\ Lama\ hat\ vier
	Ein\ Apfel\ ist\ eine
	Meine\ Freundin\ zieht\ in\ ein\ neues
	Ich\ binde\ mir\ die
	Papa\ schließt\ abends\ die
	Jutta\ geht\ mit\ ihrer\ 
	Mein\ Papa\ arbeitet\ in\ einem
	Die\ Boje\ schwimmt\ auf\ dem
	Der
	Die
	Die
	Die
	Der
	Die
	Das
	Die
	Die
	Die
}

# Sentence part after the gap
after_gap_part_n4_k1 = %w{
	.
	.
	.
	.
	Frucht.
	um.
	zu.
	ab.
	einkaufen.
	.
	.
	fliegt\ zu\ seinem\ Nest.
	quaken\ auf\ dem\ See.
	blühen\ auf\ der\ Wiese.
	machen\ viel\ Unsinn.\ 
	rennt\ über\ die\ Wiese.
	schneidet\ das\ Papier.\ 
	schreit\ nach\ seiner\ Mutter.
	scheint\ jeden\ Tag.\ 
	überqueren\ die\ Straße.\ 
	sitzt\ auf\ einer\ Blüte.
	fliegt\ zu\ seinem\ Nest.
}



t = TestDictation.create(name: "Sinnentnehmendes Lesen", len: 21, info: "Sinnentnehmendes Test für die Grundschule, 3. Klasse", short_info: "Sinnentnehmendes Lesen für die Grundschule, 3. Klasse",
					subject: "Deutsch", construct: "Sinnentnehmendes Lesen", student_access:true, archive: false, level: "Level 1", time: 480)
i = 0
while i<items.size do
	it = t.items.build(itemtext: items_n4_k1[i], difficulty: 1, itemtype: 0, itemview: "</br></br></br></br></br></br>
								<br><br>
								<div class='row text-center'>
										<div><label class='control-label' style='font-size: 60px'>" + before_gap_part_n4_k1[i] + " &nbsp</label>
										<label id='answer' class='control-label' style='color:#3498db; font-size: 60px'>...........</label>
										<label class='control-label' style='font-size: 60px'>  &nbsp" + after_gap_part_n4_k1[i] + "</label></div>
								</div>
								<br><br>
								<div class='row' id='rowButtons' >
									<div class='col-lg-1 col-md-offset-4' >
										<div class ='row'>
											<button id='button0' style='font-size: 30px' type='button' class='btn btn-default btn-block'>" + item_alternatives_n4_k1[i][0] +"</button>
										</div>
									</div>
									<div class='col-lg-1' >
										<div class ='row'>
											<button id='button1' style='font-size: 30px' type='button' class='btn btn-default btn-block'>" + item_alternatives_n4_k1[i][1] +"</button>
										</div>
									</div>
									<div class='col-lg-1' >
										<div class ='row'>
											<button id='button2' style='font-size: 30px' type='button' class='btn btn-default btn-block'>" + item_alternatives_n4_k1[i][2] +"</button>
										</div>
									</div>
									<div class='col-lg-1' >
										<div class ='row'>
											<button id='button3' style='font-size: 30px' type='button' class='btn btn-default btn-block'>"+ item_alternatives_n4_k1[i][3] +"</button>
										</div>
									</div>
								</div>
								<br><br><br><br>
								<div class='row text-center'>
									<div class='col-md-4 col-md-offset-4'>
											<button id='next' type='button' class='btn btn-lg btn-primary btn-block'><span style='font-size: 40px'>next</span></button>
									</div>
								</div>
								<script>
							        $('button').click(function(){
							        	if(this.id == 'next'){
							        		nextClicked();
							        	}
							        	else{
								        	buttonClicked(this.id);
							        	}
							        });
									function buttonClicked(buttonID){
								      var text = $('#'+buttonID).text();
								      $('#answer').html('<u>'+text+'</u>');
								    }
								    function nextClicked() {
							        		var tempAnswer = document.getElementById('answer');
								            actualAnswers = actualAnswers + tempAnswer.textContent;
								            if(tempAnswer.textContent=='"+items_n4_k1[i]+"'){
								                currentResult = currentResult + '1,';
								            }
								            else {
								                currentResult = currentResult + '0,';
								            };
								            stopwatch = new Date() - stopwatch;
								            currentTimes = currentTimes + stopwatch + ',';
								            nextItem();
							        };
								</script>")
	it.save
	i = i+1
end
it = t.items.build(itemtext: "Ende", difficulty: 1, itemtype:1, itemview:"</br></br></br></br></br></br>
								<div class='text-center'>
									<img style='width: 250px; ' src='/images/Levumi-jubelt.gif'/>
							</div>
								<br><br>
								<div class='row text-center'>
									<div class='col-md-4 col-md-offset-4'>
											<button id='geschafft' type='button' class='btn btn-lg btn-primary btn-block'><span style='font-size: 40px'>Geschafft</span></button>
									</div>
								</div>
								<script>
								$('#geschafft').click(function(){
										(document.getElementById('closeButton')).click();	
									});
								</script>")
it.save
t.save




# Correct items for the second category
items_n4_k2 = %w{
	süß
	spitz
	böse
	gut
	neues
	fleißig
	dicke
	lustigen
	hungrig
	schnelle
	backt
	isst
	spricht
	scheint
	wartest
	schläft
	kauft
	schmeckt
	sammeln
	wohne
}

item_alternatives_n4_k2 = [
	%w{	süß	leise	reich	sandig	},
	%w{	spitz	schuldig	lieb	laut	},
	%w{	böse	eckige	flache	heiße	},
	%w{	gut	frisch	laut	jung	},
	%w{	neues	rundes	kaltes	hohes	},
	%w{	fleißig	grün	flach	dünn	},
	%w{	hohe	dicke	runde	eckige	},
	%w{	späten	lustigen	nassen	tiefen	},
	%w{	nah	hungrig	groß	weit	},
	%w{	satte	schnelle	nahe	frische	},
	%w{	baut	backt	fragt	lernt	},
	%w{	fährt	läuft	isst	dreht	},
	%w{	informiert	arbeitet	spricht	backt	},
	%w{	schmilzt	regnet	scheint	schreit	},
	%w{	liebst	triffst	wartest	entfernst	},
	%w{	spült	schlägt	schläft	blickt	},
	%w{	rennt	brät	kaut	kauft	},
	%w{	wählt	riecht	trinkt	schmeckt	},
	%w{	stellen	rechnen	schließen	sammeln	},
	%w{	lasse	will	weiß	wohne	}
]

before_gap_part_n4_k2 = %w{
	Die\ Limo\ ist
	Eine\ Nadel\ ist
	Die\ Polizei\ verhaftet
	Durch\ meine\ Brille\ kann\ ich
	Mein\ Papa\ kauft\ ein\ 
	Meine\ Schwester\ lernt\ immer
	Der
	Lisa\ erzählt\ einen
	Abends\ bin\ ich\ oft
	Das
	Deine\ Freundin
	Das\ Mädchen
	Lukas
	Die\ Sonne
	Du
	Meine\ Oma 
	Paula
	Der\ Kuchen 
	Im\ Wald
	Ich
}

after_gap_part_n4_k2 = %w{
	.
	.
	Räuber.
	sehen.
	Auto.
	.
	Mann\ geht\ spazieren.
	Witz.
	.
	Auto\ rast\ die\ Straße\ herunter.
	ein\ großes\ Brot.
	die\ Suppe.
	mit\ Frida\ über\ den\ Urlaub.
	oft\ im\ Sommer.
	noch\ das\ Gewitter\ ab.
	samstags\ immer\ aus.
	mir\ ein\ Geschenk.
	uns\ allen\ gut.
	wir\ Blätter.
	bei\ meiner\ Familie.
}



t = TestDictation.create(name: "Sinnentnehmendes Lesen", len: 20, info: "Sinnentnehmendes Test für die Grundschule, 3. Klasse", short_info: "Sinnentnehmendes Lesen für die Grundschule, 3. Klasse",
					subject: "Deutsch", construct: "Sinnentnehmendes Lesen", student_access:true, archive: false, level: "Level 2", time: 480)
i = 0
while i<items.size do
	it = t.items.build(itemtext: items_n4_k2[i], difficulty: 1, itemtype: 0, itemview: "</br></br></br></br></br></br>
								<br><br>
								<div class='row text-center'>
										<div><label class='control-label' style='font-size: 60px'>" + before_gap_part_n4_k2[i] + " &nbsp</label>
										<label id='answer' class='control-label' style='color:#3498db; font-size: 60px'>...........</label>
										<label class='control-label' style='font-size: 60px'>  &nbsp" + after_gap_part_n4_k2[i] + "</label></div>
								</div>
								<br><br>
								<div class='row' id='rowButtons' >
									<div class='col-lg-1 col-md-offset-4' >
										<div class ='row'>
											<button id='button0' style='font-size: 30px' type='button' class='btn btn-default btn-block'>" + item_alternatives_n4_k2[i][0] +"</button>
										</div>
									</div>
									<div class='col-lg-1' >
										<div class ='row'>
											<button id='button1' style='font-size: 30px' type='button' class='btn btn-default btn-block'>" + item_alternatives_n4_k2[i][1] +"</button>
										</div>
									</div>
									<div class='col-lg-1' >
										<div class ='row'>
											<button id='button2' style='font-size: 30px' type='button' class='btn btn-default btn-block'>" + item_alternatives_n4_k2[i][2] +"</button>
										</div>
									</div>
									<div class='col-lg-1' >
										<div class ='row'>
											<button id='button3' style='font-size: 30px' type='button' class='btn btn-default btn-block'>"+ item_alternatives_n4_k2[i][3] +"</button>
										</div>
									</div>
								</div>
								<br><br><br><br>
								<div class='row text-center'>
									<div class='col-md-4 col-md-offset-4'>
											<button id='next' type='button' class='btn btn-lg btn-primary btn-block'><span style='font-size: 40px'>next</span></button>
									</div>
								</div>
								<script>
							        $('button').click(function(){
							        	if(this.id == 'next'){
							        		nextClicked();
							        	}
							        	else{
								        	buttonClicked(this.id);
							        	}
							        });
									function buttonClicked(buttonID){
								      var text = $('#'+buttonID).text();
								      $('#answer').html('<u>'+text+'</u>');
								    }
								    function nextClicked() {
							        		var tempAnswer = document.getElementById('answer');
								            actualAnswers = actualAnswers + tempAnswer.textContent;
								            if(tempAnswer.textContent=='"+items_n4_k2[i]+"'){
								                currentResult = currentResult + '1,';
								            }
								            else {
								                currentResult = currentResult + '0,';
								            };
								            stopwatch = new Date() - stopwatch;
								            currentTimes = currentTimes + stopwatch + ',';
								            nextItem();
							        };
								</script>")
	it.save
	i = i+1
end
it = t.items.build(itemtext: "Ende", difficulty: 1, itemtype:1, itemview:"</br></br></br></br></br></br>
								<div class='text-center'>
									<img style='width: 250px; ' src='/images/Levumi-jubelt.gif'/>
							</div>
								<br><br>
								<div class='row text-center'>
									<div class='col-md-4 col-md-offset-4'>
											<button id='geschafft' type='button' class='btn btn-lg btn-primary btn-block'><span style='font-size: 40px'>Geschafft</span></button>
									</div>
								</div>
								<script>
								$('#geschafft').click(function(){
										(document.getElementById('closeButton')).click();	
									});
								</script>")
it.save
t.save



# N4 Kategorie 3

items_n4_k3 = %w{
	weder
	aber
	Wenn
	Während
	außer
	Nachdem
	bevor
	weil
	Anstatt
	Sobald
	über
	Auf
	mit
	Durch
	für
	Zwischen
	wegen
	unter
	von
	In
}

item_alternatives_n4_k3 = [
	%w{	weder	dass	obwohl	wegen	},
	%w{	aber	dass	weil	oder	},
	%w{	Wenn	Bevor	Anstatt	Als	},
	%w{	Während	Dafür	Außer	Weder	},
	%w{	außer	davon	damit	wegen	},
	%w{	Als ob	Nachdem	Sondern	Weder	},
	%w{	nachdem	bevor	bald	davon	},
	%w{	bevor	weil	außer	davon	},
	%w{	weil	Anstatt	demnächst	davon	},
	%w{	Doch	Sobald	Und	Darum	},
	%w{	vom	zu	über	mitten	},
	%w{	drin	durch	Auf	aus	},
	%w{	für	zwischen	mit	zu	},
	%w{	Im	Über	Durch	Zu	},
	%w{	unter	auf	für	neben	},
	%w{	Im	Vom	Zwischen	Aus	},
	%w{	für	hinter	über	wegen	},
	%w{	von	durch	drin	unter	},
	%w{	mit	hinter	über	von	},
	%w{	im	durch	aus	In	}
]

before_gap_part_n4_k3 = %w{
	Paul\ hat
	Ich\ habe\ eine\ gute\ Note,
	\
	\
	Jutta\ mag\ kein\ Obst\ essen,
	\
	Ich\ putze\ meine\ Zähne,
	Die\ Möwe\ kann\ fliegen,
	\
	\
	Ich\ klettere
	\
	Das\ Auto\ zieht\ das\ andere\ Auto\ nur
	\
	Das\ Geschenk\ ist
	\
	Wir\ können
	Wir\ spielen
	Diesen\ Stift\ habe\ ich
}

after_gap_part_n4_k3 = %w{
	einen\ Stift\ noch\ ein\ Heft.
	Sina\ leider\ nicht.
	Wasser\ friert,\ wird\ es\ zu\ Eis.
	meine\ Mama\ den\ Zaun\ streicht,\ spiele\ ich\ im\ Garten.
	Kirschen.
	wir\ umgezogen\ sind,\ kaufen\ Mama\ und\ Papa\ neue\ Möbel.
	ich\ ins\ Bett\ gehe.
	sie\ ein\ Vogel\ ist.
	zu\ suchen,\ frage\ ich\ lieber\ meine\ Mama.
	ich\ fertig\ bin,\ melde\ ich\ mich\ bei\ dir.
	den\ Stamm.
	dem\ Platz\ sitzen\ viele\ Leute.
	Mühe.
	das\ Fernglas\ sehe\ ich\ einen\ Turm.
	meine\ Schwester.
	den\ Kissen\ liegt\ mein\ Heft.
	dem\ schlechten\ Wetter\ nicht\ zu\ euch\ kommen.
	dem\ Tisch\ „Verstecken“.
	meinem\ Opa.
	dem\ Schloss\ wohnt\ ein\ Geist.
}





t = TestDictation.create(name: "Sinnentnehmendes Lesen", len: 20, info: "Sinnentnehmendes Test für die Grundschule, 3. Klasse", short_info: "Sinnentnehmendes Lesen für die Grundschule, 3. Klasse",
					subject: "Deutsch", construct: "Sinnentnehmendes Lesen", student_access:true, archive: false, level: "Level 3", time: 480)
i = 0
while i<items.size do
	it = t.items.build(itemtext: items_n4_k3[i], difficulty: 1, itemtype: 0, itemview: "</br></br></br></br></br></br>
								<br><br>
								<div class='row text-center'>
										<div><label class='control-label' style='font-size: 60px'>" + before_gap_part_n4_k3[i] + " &nbsp</label>
										<label id='answer' class='control-label' style='color:#3498db; font-size: 60px'>...........</label>
										<label class='control-label' style='font-size: 60px'>  &nbsp" + after_gap_part_n4_k3[i] + "</label></div>
								</div>
								<br><br>
								<div class='row' id='rowButtons' >
									<div class='col-lg-1 col-md-offset-4' >
										<div class ='row'>
											<button id='button0' style='font-size: 30px' type='button' class='btn btn-default btn-block'>" + item_alternatives_n4_k3[i][0] +"</button>
										</div>
									</div>
									<div class='col-lg-1' >
										<div class ='row'>
											<button id='button1' style='font-size: 30px' type='button' class='btn btn-default btn-block'>" + item_alternatives_n4_k3[i][1] +"</button>
										</div>
									</div>
									<div class='col-lg-1' >
										<div class ='row'>
											<button id='button2' style='font-size: 30px' type='button' class='btn btn-default btn-block'>" + item_alternatives_n4_k3[i][2] +"</button>
										</div>
									</div>
									<div class='col-lg-1' >
										<div class ='row'>
											<button id='button3' style='font-size: 30px' type='button' class='btn btn-default btn-block'>"+ item_alternatives_n4_k3[i][3] +"</button>
										</div>
									</div>
								</div>
								<br><br><br><br>
								<div class='row text-center'>
									<div class='col-md-4 col-md-offset-4'>
											<button id='next' type='button' class='btn btn-lg btn-primary btn-block'><span style='font-size: 40px'>next</span></button>
									</div>
								</div>
								<script>
							        $('button').click(function(){
							        	if(this.id == 'next'){
							        		nextClicked();
							        	}
							        	else{
								        	buttonClicked(this.id);
							        	}
							        });
									function buttonClicked(buttonID){
								      var text = $('#'+buttonID).text();
								      $('#answer').html('<u>'+text+'</u>');
								    }
								    function nextClicked() {
							        		var tempAnswer = document.getElementById('answer');
								            actualAnswers = actualAnswers + tempAnswer.textContent;
								            if(tempAnswer.textContent=='"+items_n4_k3[i]+"'){
								                currentResult = currentResult + '1,';
								            }
								            else {
								                currentResult = currentResult + '0,';
								            };
								            stopwatch = new Date() - stopwatch;
								            currentTimes = currentTimes + stopwatch + ',';
								            nextItem();
							        };
								</script>")
	it.save
	i = i+1
end
it = t.items.build(itemtext: "Ende", difficulty: 1, itemtype:1, itemview:"</br></br></br></br></br></br>
								<div class='text-center'>
									<img style='width: 250px; ' src='/images/Levumi-jubelt.gif'/>
							</div>
								<br><br>
								<div class='row text-center'>
									<div class='col-md-4 col-md-offset-4'>
											<button id='geschafft' type='button' class='btn btn-lg btn-primary btn-block'><span style='font-size: 40px'>Geschafft</span></button>
									</div>
								</div>
								<script>
								$('#geschafft').click(function(){
										(document.getElementById('closeButton')).click();	
									});
								</script>")
it.save
t.save




# The following are the items for N2 with two categories, namely 1 and 2


items_n2_k1 = %w{
	Brot
	Bein
	Buch
	Pause
	Film
	Schweine
	Eier
	Milch
	Schule
	Wasser
	Wand
	Boden
	Sofa
	Seife
	Traktor
	Fahrrad
	Opa
	Kuchen
	Kater
	Berg
	Keks
	Abfall
	Ausflug
	Taschen
	Weg
	Bruder
	Auto
	Fibel
	Namen
	Dose
	Mofas
	Kinder
	Ende
	Abend
	Ampel
	Lieder
}

item_alternatives_n2_k1 = [
	%w{	Brot	Butter	Bisons	Schatten	},
	%w{	Bein	Geschenk	Meer	Tal	},
	%w{	Buch	Auge	Bein	Eis	},
	%w{	Pause	Leiter	Woche	Raupe	},
	%w{	Film	Maler	Igel	Berg	},
	%w{	Schweine	Leben	Schriften	Augen	},
	%w{	Eier	Fische	Essen	Wunden	},
	%w{	Watte	Milch	Mutter	Tasse	},
	%w{	Bibel	Schule	Schafe	Schuhe	},
	%w{	Wal	Wasser	Wagen	Weg	},
	%w{	Gabel	Wand	Kabel	Welt	},
	%w{	Mut	Boden	Fisch	Kanal	},
	%w{	Wasser	Sofa	Tor	Mond	},
	%w{	Sand	Seife	Taler	Kuchen	},
	%w{	Tuch	Traktor	Reiter	Salat	},
	%w{	Ufer	Ball	Fahrrad	Kegel	},
	%w{	Ofen	Baum	Opa	Sonntag	},
	%w{	Kuli	Kater	Kuchen	Uli	},
	%w{	Finger	Bauch	Kater	Tod	},
	%w{	Baum	Fluss	Berg	Bus	},
	%w{	Reis	Karo	Keks	Tag	},
	%w{	Abend	Sinn	Abfall	Bau	},
	%w{	Fisch	Abfluss	Ausflug	Hafer	},
	%w{	Leben	Taucher	Taschen	Daumen	},
	%w{	Wurm	Ofen	Pudel	Weg	},
	%w{	Sinn	Kopf	Schatten	Bruder	},
	%w{	Hund	Haus	Auge	Auto	},
	%w{	Leiter	Feder	Lupe	Fibel	},
	%w{	Samen	Ofen	Reifen	Namen	},
	%w{	Nadel	Rose	Lawine	Dose	},
	%w{	Flaschen	Blumen	Sofas	Mofas	},
	%w{	Hosen	Tische	Wege	Kinder	},
	%w{	Plan	Anfang	Kamm	Ende	},
	%w{	Mann	Baum	Boden	Abend	},
	%w{	Gabel	Ruhe	Tafel	Ampel	},
	%w{	Berge	Ideen	Schatten	Lieder	}
]

before_gap_part_n2_k1 = %w{
	Enten\ essen\ gerne
	Eine\ Frau\ gewinnt\ ein
	Wir\ lesen\ ein
	Wir\ machen\ eine
	Ich\ schaue\ einen
	Der\ Bauer\ hat\ drei
	Ein\ Huhn\ legt
	Ich\ trinke\ meine
	Lisa\ geht\ in\ die
	Das\ Kanu\ schwimmt\ auf\ dem
	Der\ Mann\ rennt\ gegen\ die
	Ich\ laufe\ auf\ dem
	Olaf\ liegt\ auf\ dem
	Ich\ wasche\ mich\ mit
	Wir\ fahren\ auf\ dem
	Ich\ fahre\ auf\ einem
	Ich\ warte\ auf\ meinen
	Wir\ essen\ den
	Peter\ findet\ seinen
	Eine\ Frau\ rodelt\ den
	Ich\ gebe\ ihr\ einen
	Susi\ wirft\ den
	Sie\ kommt\ auf\ den
	Die\ Kinder\ legen\ ihre
	Wir\ laufen\ den
	Mama\ holt\ meinen
	Ein
	In\ unserer
	\ 
	In\ der
	Die
	Die
	Am
	Am
	Die
	Die
}

after_gap_part_n2_k1 = %w{
	.
	.
	.
	.
	.
	.
	.
	.
	.
	.
	.
	.
	.
	.
	.
	.
	.
	auf.
	wieder.
	hinunter.
	ab.
	weg.
	nach.
	ab.
	ab.
	ab.
	hat\ eine\ Hupe.
	sind\ bunte\ Bilder.
	sind\ an\ jedem\ Auto.
	sind\ Kekse.
	fahren\ langsam.
	schauen\ ein\ Bild\ an.
	sind\ wir\ fertig.
	gehe\ ich\ ins\ Bett.
	blinkt gelb.
	sind\ laut.
}






items_n2_k2 = %w{
	schnell
	kalt
	hell
	heimlich
	blau
	tief
	hell
	allein
	faul
	tollen
	scharfe
	lange
	arme
	kleinen
	schweren
	schlaue
	besucht
	wartet
	schwimmen
	bade
	leben
	male
	lerne
	trinkt
	ruft
	baden
	laufen
	hebt
	sieht
	reiten
}

item_alternatives_n2_k2 = [
	%w{	schnell	rosa	dumm	weich	}
	%w{	kalt	warm	blau	lang	}
	%w{	hell	dunkel	lila	traurig	}
	%w{	heimlich	wund	langsam	lieb	}
	%w{	blau	bitter	lau	leicht	}
	%w{	tief	schwer	gelb	falsch	}
	%w{	eng	hell	langsam	tief	}
	%w{	rosa	allein	hell	leer	}
	%w{	kalt	faul	falsch	sicher	}
	%w{	kalten	tollen	nassen	runden	}
	%w{	weiche	scharfe	schlaue	tiefe	}
	%w{	kluge	lange	kranke	liebe	}
	%w{	schwache	leere	arme	blinde	}
	%w{	schlauen	faulen	kleinen	klugen	}
	%w{	dunklen	breiten	schweren	runden	}
	%w{	harte	graue	schlaue	giftige	}
	%w{	kauft	rennt	besucht	macht	}
	%w{	hebt	rennt	wartet	wirft	}
	%w{	rennen	grillen	schwimmen	wohnen	}
	%w{	dusche	lese	finde	bade	}
	%w{	arbeiten	legen	rutschen	leben	}
	%w{	sehe	tobe	lache	male	}
	%w{	reise	tauche	liege	lerne	}
	%w{	taucht	sucht	glaubt	trinkt	}
	%w{	geht	schwimmt	fegt	ruft	}
	%w{	fallen	bitten	glauben	baden	}
	%w{	baden	klauen	leiden	laufen	}
	%w{	feilt	leiht	heilt	hebt	}
	%w{	singt	weint	freut	sieht	}
	%w{	reisen	freuen	werfen	reiten	}
]

before_gap_part_n2_k2 = %w{
	Leon\ rennt
	Im\ Winter\ sind\ die\ Tage
	Morgens\ wird\ es
	In\ der\ Klasse\ kichern\ wir
	Der\ Kuli\ schreibt
	Meere\ sind
	Die\ Sonne\ scheint
	Ali\ sucht
	Oft\ sind\ Esel
	Marie\ hat\ einen
	Der\ Wolf\ hat
	Ich\ trage\ eine
	Tina\ gibt\ mir\ eine
	Wir\ reisen\ mit\ einer
	Mein\ Papa\ hat\ einen
	Lea\ und\ Lara\ sind
	Meine\ Oma
	Anna
	Einige\ Kinder
	Ich
	Im\ Wald
	Ich
	Ich
	Lino
	Anton
	Sonntags\ muss\ Bello\ immer
	Wir
	Lisa
	Tom
	Lina\ und\ Frida
}

after_gap_part_n2_k2 = %w{
	.
	.
	.
	.
	.
	.
	.
	.
	.
	Traum.
	Krallen.
	Hose.
	Tasse.
	Bahn.
	Beruf.
	Kinder.
	mich\ immer\ Sonntag.
	an\ der\ roten\ Ampel.
	im\ Wasser.
	gerne\ im\ See.
	Tiere.
	Mama\ ein\ Bild.
	in\ der\ Schule.
	eine\ Limo.
	Ina.
	.
	zu\ dem\ Lager.
	eine\ Lupe\ auf.
	traurig\ aus.
	im\ Wald.
}