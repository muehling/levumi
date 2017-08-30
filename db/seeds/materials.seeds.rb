# -*- encoding : utf-8 -*-

mat1 = Material.create(subject: "Deutsch", construct: "Leseflüssigkeit", block: "FB 1 - Vorläuferfähigkeiten", blockinfo:
 "Vorläuferfähigkeiten des Schriftspracherwerbs werden in der Regel im Kindergartenalter angebahnt und entwickeln sich mit dem Grundschuleintritt fort.
 Die phonologische Bewusstheit gilt als eine der wichtigsten Voraussetzungen für den Leseerwerb. Typische Übungsaufgaben zur phonologischen Bewusstheit
 finden auf mündlich oder bildlicher Ebene statt. Beispiele sind das Finden von Reimwörtern, das Segmentieren von Wörtern in Silben und das Identifizieren
 von gleichen Anlauten. Diese Übungen werden früh sowohl mündlich, als auch nur auf Bildebene.An dieser Stelle möchten wir auf die kostenlosen Arbeitsmaterialien
 des Bildungsservers Berlin-Brandenburg verweisen. Unter dem nachfolgenden Link finden Sie ein Arbeitsheft für Schülerinnen und Schüler sowie ein Begleitheft
 für Lehrkräfte mit Aufgaben zur phonologischen Bewusstheit (Schülerheft S.4-12). <a href='http://bildungsserver.berlin-brandenburg.de/unterricht/lernstandsanalysen-vergleichsarb/ilea/ilea1/'>Bildungsserver</a>")
mat1.save


mat2 = Material.create(subject: "Deutsch", construct: "Leseflüssigkeit", block: "FB 2 - Buchstaben-Lautbeziehung", exercisetype: "Anlaute finden", blockinfo: "
Im Mittelpunkt dieses Förderbausteins steht die systematische Buchstabenanalyse sowie die Graphem-Phonem-Korrespondenz. Zum einen müssen die Schülerinnen und Schüler
 einen sicheren Umgang in der Zuordnung von Lauten zu Buchstaben und umgekehrt entwickeln. Besonders die Differenzierung von orthographischen (z.B. d/b) und auditiven
 (z.B. k/g) ähnlichen Buchstaben kann Schwierigkeiten bereiten. Zudem spielt die Untergliederung von Wörtern in kleinere Einheiten eine bedeutsame Rolle, um
 beispielsweise eine Basis für die orthographische Schreibweise zu schaffen.", exerciseinfo:"
 Die Kinder müssen den Anfangslaut auditiv differenzieren und dem passenden Graphem zuordnen. Dabei entsprechen die Anlaute den Niveaustufen von LeVuMi.
 Diese Übung festigt die phonologische Bewusstheit anhand von Schriftmaterial und übt die auditive Diskriminierung von Lauten am Wortanfang.",
                       data: ["FB 2_Anlaute finden_Vorlage.docx", "FB 2_Anlaute finden_N0.pdf", "FB 2_Anlaute finden_N1.pdf", "FB 2_Anlaute finden_N2a.pdf","FB 2_Anlaute finden_N2b.pdf", "FB 2_Anlaute finden_N3.pdf"])
mat2.save

mat3 = Material.create(subject: "Deutsch", construct: "Leseflüssigkeit", block: "FB 2 - Buchstaben-Lautbeziehung", exercisetype: "Buchstabengitter", blockinfo: "
Im Mittelpunkt dieses Förderbausteins steht die systematische Buchstabenanalyse sowie die Graphem-Phonem-Korrespondenz. Zum einen müssen die Schülerinnen und Schüler
 einen sicheren Umgang in der Zuordnung von Lauten zu Buchstaben und umgekehrt entwickeln. Besonders die Differenzierung von orthographischen (z.B. d/b) und auditiven
 (z.B. k/g) ähnlichen Buchstaben kann Schwierigkeiten bereiten. Zudem spielt die Untergliederung von Wörtern in kleinere Einheiten eine bedeutsame Rolle, um
 beispielsweise eine Basis für die orthographische Schreibweise zu schaffen.", exerciseinfo:"
 Die Kinder müssen einen Laut innerhalb eines Wortes identifizieren und das passende Graphem zuordnen.
 Die Isolierung eines Lautes ist in der Wortmitte oder am Wortende anspruchsvoller als am Wortanfang.
 Diese Übung festigt die phonologische Bewusstheit anhand von Schriftmaterial und übt die auditive Diskriminierung von Lauten in der Wortmitte und am Wortende.",
                       data: ["FB 2_Buchstabengitter_Vorlage.docx", "FB 2_Buchstabengitter_N0.pdf", "FB 2_Buchstabengitter_N1.pdf", "FB 2_Buchstabengitter_N2a.pdf","FB 2_Buchstabengitter_N2b.pdf", "FB 2_Buchstabengitter_N3.pdf"])
mat3.save

mat4 = Material.create(subject: "Deutsch", construct: "Leseflüssigkeit", block: "FB 3 - Richtiges Lesen", exercisetype: "Buchstaben verbinden", blockinfo: "
In diesem Förderbaustein steht die reine Lesesynthese im Vordergrund. Damit sich der technische Lesevorgang festigen kann, sollten Übungen auf Silbenebene
 und mit Pseudowörtern genutzt werden. Ohne Kontext können die präsentierten Wörter nicht assoziiert werden und die Wörter müssen alphabetisch erlesen
werden.  ", exerciseinfo:"
 Die Kinder müssen die Grapheme des Zielwortes in der richtigen Reihenfolge verbinden. Diese Übung schult die Berücksichtigung aller Grapheme innerhalb eines Wortes.",
                       data: ["FB 3_Buchstaben verbinden_Vorlage.docx", "FB 3_Buchstaben verbinden_N1.pdf", "FB 3_Buchstaben verbinden_N2b.pdf"])
mat4.save

mat5 = Material.create(subject: "Deutsch", construct: "Leseflüssigkeit", block: "FB 3 - Richtiges Lesen", exercisetype: "Purzelsilben", blockinfo: "
In diesem Förderbaustein steht die reine Lesesynthese im Vordergrund. Damit sich der technische Lesevorgang festigen kann, sollten Übungen auf Silbenebene
 und mit Pseudowörtern genutzt werden. Ohne Kontext können die präsentierten Wörter nicht assoziiert werden und die Wörter müssen alphabetisch erlesen
werden.  ", exerciseinfo:"
 Die Kinder müssen Silben mit einander in der richtigen Reihenfolge verbinden. Diese Aufgabe bietet keine Bildunterstützung und fördert unterbewusst die Silbensegmentierung.",
                       data: ["FB 3_Purzelsilben_Vorlage.docx", "FB 3_Purzelsilben_N4.pdf"])
mat5.save

mat6 = Material.create(subject: "Deutsch", construct: "Leseflüssigkeit", block: "FB 3 - Richtiges Lesen", exercisetype: "Silbenbögen malen", blockinfo: "
In diesem Förderbaustein steht die reine Lesesynthese im Vordergrund. Damit sich der technische Lesevorgang festigen kann, sollten Übungen auf Silbenebene
 und mit Pseudowörtern genutzt werden. Ohne Kontext können die präsentierten Wörter nicht assoziiert werden und die Wörter müssen alphabetisch erlesen
werden.  ", exerciseinfo:"
 Die Kinder müssen das Wort erlesen, in Silben segmentieren und die Silbenbögen einzeichnen. Diese Übung festigt die phonologische Bewusstheit anhand von Schriftmaterial und übt die Silbensegmentierung.",
                       data: ["FB 3_Silbenbögen malen_Vorlage.docx", "FB 3_Silbenbögen malen_N1.pdf", "FB 3_Silbenbögen malen_N2a.pdf", "FB 3_Silbenbögen malen_N2b.pdf", "FB 3_Silbenbögen malen_N3.pdf"])
mat6.save

mat7 = Material.create(subject: "Deutsch", construct: "Leseflüssigkeit", block: "FB 3 - Richtiges Lesen", exercisetype: "Anfangssilben finden", blockinfo: "
In diesem Förderbaustein steht die reine Lesesynthese im Vordergrund. Damit sich der technische Lesevorgang festigen kann, sollten Übungen auf Silbenebene
 und mit Pseudowörtern genutzt werden. Ohne Kontext können die präsentierten Wörter nicht assoziiert werden und die Wörter müssen alphabetisch erlesen
werden.  ", exerciseinfo:"
 Die Kinder müssen die richtige Anfangssilbe von einem Wort herausfinden und markieren. Hierfür ist ein Abgleich zwischen der gesprochenen Silbe und der Schrift notwendig.
 Diese Übung trainiert das Wahrnehmen von kleineren Einheiten innerhalb eines Wortes.",
                       data: ["FB 3_Anfangssilben finden_Vorlage.docx", "FB 3_Anfangssilben finden_N1.pdf", "FB 3_Anfangssilben finden_N2a.pdf"])
mat7.save

mat8 = Material.create(subject: "Deutsch", construct: "Leseflüssigkeit", block: "FB 3 - Richtiges Lesen", exercisetype: "Silben verbinden", blockinfo: "
In diesem Förderbaustein steht die reine Lesesynthese im Vordergrund. Damit sich der technische Lesevorgang festigen kann, sollten Übungen auf Silbenebene
 und mit Pseudowörtern genutzt werden. Ohne Kontext können die präsentierten Wörter nicht assoziiert werden und die Wörter müssen alphabetisch erlesen
werden.  ", exerciseinfo:"
 Die Kinder müssen je eine Silbe mit einer zweiten Silbe lesend verbinden. Diese Übung schult eine flexible Synthese, da die kombinierten Silben keine bekannten Verbindungen darstellen.",
                       data: ["FB 3_Silben verbinden_Vorlage.docx","FB 3_Silben verbinden_N0.pdf", "FB 3_Silben verbinden_N1.pdf","FB 3_Silben verbinden_N2a.pdf","FB 3_Silben verbinden_N2b.pdf","FB 3_Silben verbinden_N3.pdf","FB 3_Silben verbinden_N4.pdf"])
mat8.save

mat9 = Material.create(subject: "Deutsch", construct: "Leseflüssigkeit", block: "FB 3 - Richtiges Lesen", exercisetype: "Wörterberge", blockinfo: "
In diesem Förderbaustein steht die reine Lesesynthese im Vordergrund. Damit sich der technische Lesevorgang festigen kann, sollten Übungen auf Silbenebene
 und mit Pseudowörtern genutzt werden. Ohne Kontext können die präsentierten Wörter nicht assoziiert werden und die Wörter müssen alphabetisch erlesen
werden.  ", exerciseinfo:"
 Die Kinder sollen Zeile für Zeile erlesen. In der untersten Ebene haben sie ein langes und anspruchsvolles Wort erlesen. Diese Übung sensibilisiert für den Aufbau und die Struktur mehrsilbiger Wörter.
 Zudem kann eine aufbauende Lesestrategie adaptiert werden.",
                       data: ["FB 3_Wörterberge_Vorlage.docx", "FB 3_Wörterberge_N4.pdf"])
mat9.save

mat10 = Material.create(subject: "Deutsch", construct: "Leseflüssigkeit", block: "FB 4 - Wörter kennen und erkennen", exercisetype: "Miniwörter finden", blockinfo: "
Im Zuge des Leseerwerbs speichern Schülerinnen und Schüler immer mehr Einträge in ihrem mentalen Lexikon ab. Je hochfrequenter ein Kind mit speziellem Wortmaterial
 arbeitet, desto wahrscheinlicher ist eine automatisierte Wiedererkennung in unbekannten Kontexten. Eine automatisierte Worterkennung trägt zur Entlastung des
 Arbeitsgedächtnisses bei. So kann mehr Kapazität für das Leseverstehen bereitgestellt werden.  Besonders die Arbeit mit Signalgruppen (z.B. <ung>, <ent>)
 und einem Sichtwortschatz (alterstypische Häufigkeits-, Funktions- und Alltagswörter) eignet sich für den systematischen Ausbau des
mentalen Lexikons.", exerciseinfo:"
Die Kinder müssen mehrfach vorkommende Miniwörter in einer Aufzählung herausfinden und markieren.
 Diese Übung präsentiert hochfrequent häufig vorkommende Wörter, sodass sie im mentalen Lexikon abgespeichert werden.
Durch diese mechanische Aufgabe wird besonders das simultane Erfassen von bis zu vier Buchstaben geschult.",
                        data: ["FB 4_Miniwörter üben_Vorlage.docx", "FB 4_Miniwörter üben_N2.pdf","FB 4_Miniwörter üben_N4.pdf"])
mat10.save

mat11 = Material.create(subject: "Deutsch", construct: "Leseflüssigkeit", block: "FB 4 - Wörter kennen und erkennen", exercisetype: "Wörterteppich", blockinfo: "
Im Zuge des Leseerwerbs speichern Schülerinnen und Schüler immer mehr Einträge in ihrem mentalen Lexikon ab. Je hochfrequenter ein Kind mit speziellem Wortmaterial
 arbeitet, desto wahrscheinlicher ist eine automatisierte Wiedererkennung in unbekannten Kontexten. Eine automatisierte Worterkennung trägt zur Entlastung des
 Arbeitsgedächtnisses bei. So kann mehr Kapazität für das Leseverstehen bereitgestellt werden.  Besonders die Arbeit mit Signalgruppen (z.B. <ung>, <ent>)
 und einem Sichtwortschatz (alterstypische Häufigkeits-, Funktions- und Alltagswörter) eignet sich für den systematischen Ausbau des
mentalen Lexikons.", exerciseinfo:"
Diese Wortsammlung entstammt dem Sichtwortschatz der entsprechenden Niveaustufe. Mit einem Wörterteppich können unterschiedliche Übungen realisiert werden.
 Je nach Fähigkeitsstad der Kinder kann auch nur ein Teil des Wortmaterials verwendet werden.<br/>
Beispielsweise kann ein Lesebingo durchgeführt werden. Dafür kann ein leeres Grundraster den Schülerinnen und Schülern zur Verfügung gestellt werden,
 auf dem sie die ausgeschnittenen Wörter aufkleben können. Dann werden nacheinander Wörter aus dem Fundus laut vorgelesen.
 Die Kinder können die genannten Wörter beispielsweise mit Muggelsteinen abdecken. Wer zuerst eine Reihe abgedeckt hat, gewinnt.
 In diesem Spielformat müssen die Kinder ihre ausgewählten Wörter merken und kontinuierlich überprüfen.",
                        data: ["FB 4_Wörterteppich_Vorlage.docx", "FB 4_Wörterteppich_N2.pdf","FB 4_Wörterteppich_N4.pdf"])
mat11.save

mat12 = Material.create(subject: "Deutsch", construct: "Leseflüssigkeit", block: "FB 5 - Inhalte verstehen", exercisetype: "Lesen zu Bildern", blockinfo: "
Schon früh im Leseerwerb kann das semantisch-lexikalische Lesen geübt werden. Dafür kann das Wortmaterial in einen bildlichen oder geschichtlichen Kontext gesetzt werden.
 Aufgaben können zudem eine kindgerechte Kontrolle integrieren. Diese können aufzeigen, ob die Schülerin oder der Schüler den Inhalt das Gelesene verstanden hat.
 Beispielsweise wird einem Bild ein entsprechendes geschriebenes Wort oder umgekehrt zugeordnet. Die Kombination mit orthographisch oder semantisch ähnlichen Ablenkern,
 kann den Anspruch erhöhen.", exerciseinfo:"
Die Kinder müssen die richtig geschriebenen Wörter identifizieren, die zum Bild passen. Diese Übung schult die Diskriminierung orthographisch ähnlicher Wörter.",
                        data: ["FB 5_Lesen zu Bildern_Vorlage.docx","FB 5_Lesen zu Bildern_N1.pdf","FB 5_Lesen zu Bildern_N2a.pdf","FB 5_Lesen zu Bildern_N2b.pdf","FB 5_Lesen zu Bildern_N3.pdf"])
mat12.save

mat13 = Material.create(subject: "Deutsch", construct: "Leseflüssigkeit", block: "FB 5 - Inhalte verstehen", exercisetype: "Wörter finden", blockinfo: "
Schon früh im Leseerwerb kann das semantisch-lexikalische Lesen geübt werden. Dafür kann das Wortmaterial in einen bildlichen oder geschichtlichen Kontext gesetzt werden.
 Aufgaben können zudem eine kindgerechte Kontrolle integrieren. Diese können aufzeigen, ob die Schülerin oder der Schüler den Inhalt das Gelesene verstanden hat.
 Beispielsweise wird einem Bild ein entsprechendes geschriebenes Wort oder umgekehrt zugeordnet. Die Kombination mit orthographisch oder semantisch ähnlichen Ablenkern,
 kann den Anspruch erhöhen.", exerciseinfo:"
Die Kinder müssen das Zielwort richtig erlesen. Ihnen werden stets zwei Ablenker präsentiert. Diese sind orthographisch oder semantisch ähnlich, damit
 nicht lediglich ein logographisches Wiedererkennen stattfindet. Diese Übung trainiert den Abgleich zwischen dem erlesenen Material und dem Inhalt.",
                        data: ["FB 5_Wörter finden_Vorlage.docx", "FB 5_Wörter finden_N2a.pdf","FB 5_Wörter finden_N2b.pdf","FB 5_Wörter finden_N3.pdf","FB 5_Wörter finden_N4.pdf"])
mat13.save

mat14 = Material.create(subject: "Deutsch", construct: "Leseflüssigkeit", block: "FB 5 - Inhalte verstehen", exercisetype: "Bilder finden", blockinfo: "
Schon früh im Leseerwerb kann das semantisch-lexikalische Lesen geübt werden. Dafür kann das Wortmaterial in einen bildlichen oder geschichtlichen Kontext gesetzt werden.
 Aufgaben können zudem eine kindgerechte Kontrolle integrieren. Diese können aufzeigen, ob die Schülerin oder der Schüler den Inhalt das Gelesene verstanden hat.
 Beispielsweise wird einem Bild ein entsprechendes geschriebenes Wort oder umgekehrt zugeordnet. Die Kombination mit orthographisch oder semantisch ähnlichen Ablenkern,
 kann den Anspruch erhöhen.", exerciseinfo:"
Die Kinder müssen die passenden Bilder dem erlesenen Wort zuordnen. Dafür steht jeweils Paare zur Verfügung. Diese Übung lenkt den Fokus auf das sinnentnehmende Lesen.",
                        data: ["FB 5_Bilder finden_Vorlage.docx", "FB 5_Bilder finden_N2a.pdf","FB 5_Bilder finden_N2b.pdf","FB 5_Bilder finden_N3.pdf","FB 5_Bilder finden_N4.pdf"])
mat14.save

mat15 = Material.create(subject: "Deutsch", construct: "Leseflüssigkeit", block: "FB 5 - Inhalte verstehen", exercisetype: "Lies und male", blockinfo: "
Schon früh im Leseerwerb kann das semantisch-lexikalische Lesen geübt werden. Dafür kann das Wortmaterial in einen bildlichen oder geschichtlichen Kontext gesetzt werden.
 Aufgaben können zudem eine kindgerechte Kontrolle integrieren. Diese können aufzeigen, ob die Schülerin oder der Schüler den Inhalt das Gelesene verstanden hat.
 Beispielsweise wird einem Bild ein entsprechendes geschriebenes Wort oder umgekehrt zugeordnet. Die Kombination mit orthographisch oder semantisch ähnlichen Ablenkern,
 kann den Anspruch erhöhen.", exerciseinfo:"
Variante 1: Die Kinder müssen zunächst das Zielwort aus mehreren Silben zusammensetzen (phonologisches Rekodieren), den Inhalt aktivieren und danach zeichnen.
 Das Zeichnen überprüft, ob der Inhalt richtig verstanden wurde. Die Ablenker sind i.d.R. phonologische ähnlich. Diese Übung kombiniert die Förderbausteine FB 3 und FB 5.<br/>
Variante 2: Den Kindern wird ein schwarz/weiß Bild gegeben, welches nach Anleitung ausgemalt oder ergänzt werden muss.",
                        data: ["Fb 5_Lies und male_Vorlage.docx", "Fb 5_Lies und male_N1.pdf","Fb 5_Lies und male_N2a.pdf","Fb 5_Lies und male_N2b.pdf","Fb 5_Lies und male_N3.pdf","FB 5_Male an_N4(1).pdf","FB 5_Male an_N4(2).pdf"])
mat15.save

mat16 = Material.create(subject: "Deutsch", construct: "Leseflüssigkeit", block: "FB 6 - Mit einander lesen", exercisetype: "Wiederholtes Lesen", blockinfo: "
Flüssiges Lesen ist eine wichtige Voraussetzung für sinnentnehmendes Lesen. Es kann besonders durch laute Leseverfahren geschult werden. Dabei ist es wichtig,
 dass die Lesezeit der einzelnen Schülerinnen und Schüler möglichst hoch ist. Ein bekanntes Verfahren ist das Lesetandem, indem jeweils ein lesestarkes mit einem
 leseschwächeren Kind gemeinsam liest. Dabei werden Textpassagen gemeinsam laut oder halblaut gelesen und der lesestärkere Part gibt seinem Gegenüber Hilfestellungen.<br/>
Hier folgen demnächst weitere Informationen zu geeigneten Übungsformaten.  ", exerciseinfo:"
Die Kinder lesen in Partnerarbeit einen vorher bestimmten Text. Dabei überprüft der Trainer das Lesen des Sportlers und fungiert als Lesemodell.
 Dabei wird der Text mehrmals gelesen, bis die Leseleistung dem Ziel entspricht. ",
                        data: ["FB 6_Tandem lesen_Vorlage.docx", "FB 6_Tandem lesen.pdf"])
mat16.save

mat17 = Material.create(subject: "Deutsch", construct: "Leseflüssigkeit", block: "Sammlung FB 1 bis FB 6", exercisetype: "Gesamtes Fördermaterial", blockinfo:
    "Hier steht Ihnen das gesamte Fördermaterial in Form einer zip-Datei zur Verfügung.",
                        data: ["Arbeitsblaetter Levumi.zip"])
mat17.save