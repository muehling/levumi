results = Result.all
results.each do |r|
	#Zusätzliche Sicherheitsabfrage: Kann an meinen Datensatz gelegen haben, aber manchmal gab es keine Assessments und falls Daten vom Beispieltest in der Datenabank liegen
	#Sollte in der Live-Version eigentlich nicht vorkommen
	if r.assessment.nil? || r.data.nil?
		next
	end
	#Folgende Tests besitzen keine LG oder LGM, also rausfiltern
	if r.assessment.test.shorthand != 'WS1' && r.assessment.test.shorthand != 'TS0' && r.assessment.test.shorthand != 'FB-PIQ-STU' &&
			r.assessment.test.shorthand != 'FB-PIQ' && r.assessment.test.shorthand != 'FB' && r.assessment.test.shorthand != 'FB2' && r.assessment.test.shorthand != 'BPL3b2' &&
			r.assessment.test.shorthand != 'BPL3b1' && r.assessment.test.shorthand != 'BPL3a2' && r.assessment.test.shorthand != 'BPL3a1' && r.assessment.test.shorthand != 'Ex_S_1'
		read_accuracy = r.views['V2']['LG'].to_f
		read_words = r.views['V2']['LGM'].to_f
		read_accuracy = read_accuracy.round(1).to_s
		if read_words != "-"
			read_words = read_words.round.to_s
		end
		r.views['V2']['LG'] = read_accuracy
		r.views['V3']['LG'] = read_accuracy
		r.views['V2']['LGM'] = read_words
		r.views['V3']['LGM'] = read_words

		new_data = []
		p_items =  []
		n_items = []
		#SEL2 und 4
		ada_cor = 0
		avp_cor = 0
		avk_cor = 0
		ada_cor_items = ""
		avp_cor_items = ""
		avk_cor_items = ""
		ada_fal = 0
		avp_fal = 0
		avk_fal = 0
		ada_fal_items = ""
		avp_fal_items = ""
		avk_fal_items = ""
		#SEL6
		coh_cor = 0
		complex_str_cor = 0
		inf_cor = 0
		coh_cor_items = ""
		complex_str_cor_items = ""
		inf_cor_items = ""
		coh_fal = 0
		complex_str_fal = 0
		inf_fal = 0
		coh_fal_items = ""
		complex_str_fal_items = ""
		inf_fal_items = ""
		sum = 0
		n_sum = 0
		if !r.data[0].key?('result')
			if r.assessment.test.shorthand == 'SEL2'
					items = {
							"I36" => ["I1", "Taschen"],
							"I48" => ["I10", "Traktor"],
							"I23" => ["I11", "besucht"],
							"I59" => ["I12", "Milch"],
							"I5" => ["I13", "Bruder"],
							"I26" => ["I14", "scharfe"],
							"I12" => ["I15", "male"],
							"I51" => ["I16", "Kinder"],
							"I41" => ["I17", "Buch"],
							"I33" => ["I18", "faul"],
							"I60" => ["I19", "ruft"],
							"I31" => ["I2", "bade"],
							"I7" => ["I20", "Kuchen"],
							"I38" => ["I21", "Ausflug"],
							"I37" => ["I23", "blau"],
							"I30" => ["I24", "Berg"],
							"I46" => ["I25", "sieht"],
							"I57" => ["I26", "Weg"],
							"I43" => ["I27", "Abfall"],
							"I39" => ["I28", "reiten"],
							"I10" => ["I29", "leben"],
							"I28" => ["I3", "wartet"],
							"I32" => ["I30", "Pause"],
							"I67" => ["I31", "Seife"],
							"I56" => ["I32", "lange"],
							"I22" => ["I33", "Eier"],
							"I35" => ["I34", "baden"],
							"I6" => ["I35", "hell"],
							"I17" => ["I36", "Wasser"],
							"I61" => ["I37", "Opa"],
							"I40" => ["I38", "heimlich"],
							"I2" => ["I39", "lerne"],
							"I52" => ["I4", "Film"],
							"I20" => ["I40", "Lieder"],
							"I62" => ["I42", "leere"],
							"I18" => ["I43", "Abend"],
							"I29" => ["I44", "kleinen"],
							"I3" => ["I45", "hell"],
							"I64" => ["I46", "Auto"],
							"I9" => ["I47", "Schule"],
							"I50" => ["I48", "trinkt"],
							"I44" => ["I49", "tief"],
							"I27" => ["I5", "Fahrrad"],
							"I19" => ["I50", "Keks"],
							"I54" => ["I51", "Ampel"],
							"I58" => ["I52", "hebt"],
							"I11" => ["I53", "Dose"],
							"I13" => ["I54", "schnell"],
							"I66" => ["I55", "schwimmen"],
							"I65" => ["I56", "Sofa"],
							"I15" => ["I57", "laufen"],
							"I55" => ["I58", "Kater"],
							"I4" => ["I59", "Ende"],
							"I49" => ["I6", "schlaue"],
							"I47" => ["I60", "allein"],
							"I34" => ["I61", "Schweine"],
							"I42" => ["I63", "Mofas"],
							"I24" => ["I64", "Brot"],
							"I45" => ["I65", "Boden"],
							"I8" => ["I66", "Fibel"],
							"I63" => ["I7", "Wand"],
							"I53" => ["I8", "tollen"],
							"I21" => ["I9", "kalt"]
					}
					r.data.each do |d|
						if d['item'] != 'I14' && d['item'] != 'I16' && d['item'] != 'I25'
							if r.report['positive'].include?(d['item'])
								sum += 1
								new_data = new_data + [{'item':  items[d['item']][0],"group":d['group'].to_s, "answer":d['answer'], "time":d['time'], "result": 1}]
								p_items = p_items + [items[d['item']][0]]
								if d['group'] == 1
									ada_cor += 1
									if ada_cor_items == ""
										ada_cor_items = "" + items[d['item']][1]
									else
										ada_cor_items += ", " + items[d['item']][1]
									end
								elsif d['group'] == 2
									avp_cor += 1
									if avp_cor_items == ""
										avp_cor_items = "" + items[d['item']][1]
									else
										avp_cor_items += ", " + items[d['item']][1]
									end
								end
							elsif r.report['negative'].include?(d['item'])
								n_sum += 1
								new_data = new_data + [{'item':  items[d['item']][0],"group":d['group'].to_s, "answer":d['answer'], "time":d['time'], "result": 0}]
								n_items = n_items + [items[d['item']][0]]
								if d['group'] == 1
									ada_fal += 1
									if ada_fal_items == ""
										ada_fal_items = "" + items[d['item']][1]
									else
										ada_fal_items += ", " + items[d['item']][1]
									end
								elsif d['group'] == 2
									avp_fal += 1
									if avp_fal_items == ""
										avp_fal_items = "" + items[d['item']][1]
									else
										avp_fal_items += ", " + items[d['item']][1]
									end
								end
							else
								new_data = new_data + [{'item':  items[d['item']][0],"group":d['group'].to_s, "answer":d['answer'], "time":d['time'], "result": 'NA'}]
							end
						end
					end
					lg = ((sum.to_f/(sum + n_sum).to_f)*100).round(1).to_s
					new_data = new_data + [{'item':  'I62',"group": '1', "answer":'NA', "time":'NA'}, {'item':  'I41',"group":'1', "answer":'NA', "time":'NA'}, {'item':  'I22',"group":'2', "answer":'NA', "time":'NA'}]
					ada = '<strong>Anzahl richtig gelöster Items:</strong> '+ada_cor.to_s+'<hr style="margin-top:0; margin-bottom:0"/>'+ada_cor_items+'<br/><br/><strong>Anzahl falsch gelöster Items:</strong> '+ada_fal.to_s+'<hr style="margin-top:0; margin-bottom:0"/>'+ada_fal_items
					avp = '<strong>Anzahl richtig gelöster Items:</strong> '+avp_cor.to_s+'<hr style="margin-top:0; margin-bottom:0"/>'+avp_cor_items+'<br/><br/><strong>Anzahl falsch gelöster Items:</strong> '+avp_fal.to_s+'<hr style="margin-top:0; margin-bottom:0"/>'+avp_fal_items
					views = {'V1': sum, 'V2': {'RI':''+sum.to_s + ' von 66', 'ADA': ada, 'AVP': avp, 'LG': lg, 'LGM': "-"},'V3': {'SUM':sum ,'RI':''+sum.to_s + ' von 66', 'ADA': ada, 'AVP': avp, 'LG': lg, 'LGM': "-"} }
					r.data = new_data
					r.report['positive'] = p_items
					r.report['negative'] = n_items
					r.views = views
			elsif r.assessment.test.shorthand == 'SEL4'
					items = {
							"I38" => ["I1", "backt"],
							"I61" => ["I10", "mit"],
							"I45" => ["I11", "dicke"],
							"I23" => ["I12", "runde"],
							"I5" => ["I13", "Blumen"],
							"I18" => ["I14", "spricht"],
							"I29" => ["I15", "Durch"],
							"I60" => ["I16", "Tür"],
							"I27" => ["I17", "Anstatt"],
							"I58" => ["I18", "kauft"],
							"I26" => ["I19", "Vogel"],
							"I8" => ["I2", "Schere"],
							"I21" => ["I20", "scheint"],
							"I48" => ["I21", "für"],
							"I16" => ["I22", "Baby"],
							"I32" => ["I23", "hungrig"],
							"I33" => ["I24", "weder"],
							"I14" => ["I25", "aber"],
							"I6" => ["I26", "schmeckt"],
							"I2" => ["I27", "Augen"],
							"I53" => ["I28", "Wasser"],
							"I22" => ["I29", "Nachdem"],
							"I47" => ["I3", "Während"],
							"I28" => ["I30", "lustigen"],
							"I13" => ["I31", "schnelle"],
							"I37" => ["I32", "Schuhe"],
							"I51" => ["I33", "Auf"],
							"I54" => ["I34", "neues"],
							"I19" => ["I35", "Bett"],
							"I55" => ["I36", "außer"],
							"I12" => ["I37", "wohne"],
							"I9" => ["I38", "Haus"],
							"I20" => ["I39", "von"],
							"I62" => ["I4", "Büro"],
							"I49" => ["I40", "isst"],
							"I39" => ["I41", "über"],
							"I30" => ["I42", "Beine"],
							"I24" => ["I43", "Freunde"],
							"I46" => ["I44", "Biene"],
							"I36" => ["I45", "schläft"],
							"I42" => ["I46", "süß"],
							"I10" => ["I47", "wegen"],
							"I34" => ["I48", "Sonne"],
							"I59" => ["I49", "Hase"],
							"I56" => ["I5", "spitz"],
							"I25" => ["I50", "gut"],
							"I17" => ["I51", "Zwischen"],
							"I43" => ["I52", "Frösche"],
							"I52" => ["I53", "wartest"],
							"I41" => ["I54", "Wenn"],
							"I31" => ["I55", "sammeln"],
							"I4" => ["I56", "Sobald"],
							"I50" => ["I57", "Enten"],
							"I3" => ["I58", "fleißig"],
							"I44" => ["I59", "Schwester"],
							"I57" => ["I6", "weil"],
							"I35" => ["I60", "unter"],
							"I40" => ["I7", "Bilder"],
							"I15" => ["I8", "böse"],
							"I11" => ["I9", "bevor"]
					}
					r.data.each do |d|
						if d['item'] != 'I7'
							if r.report['positive'].include?(d['item'])
								sum += 1
								new_data = new_data + [{'item':  items[d['item']][0],"group":d['group'].to_s, "answer":d['answer'], "time":d['time'], "result": 1}]
								p_items = p_items + [items[d['item']][0]]
								if d['group'] == 1
									ada_cor += 1
									if ada_cor_items == ""
										ada_cor_items = "" + items[d['item']][1]
									else
										ada_cor_items += ", " + items[d['item']][1]
									end
								elsif d['group'] == 2
									avp_cor += 1
									if avp_cor_items == ""
										avp_cor_items = "" + items[d['item']][1]
									else
										avp_cor_items += ", " + items[d['item']][1]
									end
								elsif d['group'] == 3
									avk_cor += 1
									if avk_cor_items == ""
										avk_cor_items = "" + items[d['item']][1]
									else
										avk_cor_items += ", " + items[d['item']][1]
									end
								end
							elsif r.report['negative'].include?(d['item'])
								n_sum += 1
								new_data = new_data + [{'item':  items[d['item']][0],"group":d['group'].to_s, "answer":d['answer'], "time":d['time'], "result": 0}]
								n_items = n_items + [items[d['item']][0]]
								if d['group'] == 1
									ada_fal += 1
									if ada_fal_items == ""
										ada_fal_items = "" + items[d['item']][1]
									else
										ada_fal_items += ", " + items[d['item']][1]
									end
								elsif d['group'] == 2
									avp_fal += 1
									if avp_fal_items == ""
										avp_fal_items = "" + items[d['item']][1]
									else
										avp_fal_items += ", " + items[d['item']][1]
									end
								elsif d['group'] == 3
									avk_fal += 1
									if avk_fal_items == ""
										avk_fal_items = "" + items[d['item']][1]
									else
										avk_fal_items += ", " + items[d['item']][1]
									end
								end
							else
								new_data = new_data + [{'item':  items[d['item']][0],"group":d['group'].to_s, "answer":d['answer'], "time":d['time'], "result": 'NA'}]
							end
						end
					end
					lg = ((sum.to_f/(sum + n_sum).to_f)*100).round(1).to_s
					ada = '<strong>Anzahl richtig gelöster Items:</strong> '+ada_cor.to_s+'<hr style="margin-top:0; margin-bottom:0"/>'+ada_cor_items+'<br/><br/><strong>Anzahl falsch gelöster Items:</strong> '+ada_fal.to_s+'<hr style="margin-top:0; margin-bottom:0"/>'+ada_fal_items
					avp = '<strong>Anzahl richtig gelöster Items:</strong> '+avp_cor.to_s+'<hr style="margin-top:0; margin-bottom:0"/>'+avp_cor_items+'<br/><br/><strong>Anzahl falsch gelöster Items:</strong> '+avp_fal.to_s+'<hr style="margin-top:0; margin-bottom:0"/>'+avp_fal_items
					avk = '<strong>Anzahl richtig gelöster Items:</strong> '+avk_cor.to_s+'<hr style="margin-top:0; margin-bottom:0"/>'+avk_cor_items+'<br/><br/><strong>Anzahl falsch gelöster Items:</strong> '+avk_fal.to_s+'<hr style="margin-top:0; margin-bottom:0"/>'+avk_fal_items
					views = {'V1': sum, 'V2': {'RI':''+sum.to_s + ' von 60', 'ADA': ada, 'AVP': avp, 'AVK': avk, 'LG': lg, 'LGM': "-"},'V3': {'SUM':sum ,'RI':''+sum.to_s + ' von 60', 'ADA': ada, 'AVP': avp, 'AVK': avk, 'LG': lg, 'LGM': "-"} }
					r.data = new_data
					r.report['positive'] = p_items
					r.report['negative'] = n_items
					r.views = views
			elsif r.assessment.test.shorthand == 'SEL6'
					items = {
							"I2" => ["I1", "streiten"],
							"I3" => ["I2", "verschwundenen"],
							"I4" => ["I3", "Trick"],
							"I5" => ["I4", "gefährliche"],
							"I6" => ["I5", "Sie"],
							"I7" => ["I6", "Klassenzimmer"],
							"I8" => ["I7", "jubeln"],
							"I9" => ["I8", "ihr"],
							"I10" => ["I9", "nicht"],
							"I11" => ["I10", "Ihn"],
							"I12" => ["I11", "Wiese"],
							"I13" => ["I12", "einladen"],
							"I14" => ["I13", "sauer"],
							"I15" => ["I14", "Leinwand"],
							"I16" => ["I15", "Sekunden"],
							"I17" => ["I16", "Gebäude"],
							"I18" => ["I17", "nichts"],
							"I19" => ["I18", "besucht"],
							"I20" => ["I19", "Pflanzen"],
							"I21" => ["I20", "Bürotür"],
							"I22" => ["I21", "Anlegeplätze"],
							"I23" => ["I22", "du"],
							"I24" => ["I23", "viel"],
							"I25" => ["I24", "läuft"],
							"I26" => ["I25", "Lebensmittel"],
							"I27" => ["I26", "tanken"],
							"I28" => ["I27", "Geld"],
							"I29" => ["I28", "nie"],
							"I30" => ["I29", "Morgen"],
							"I31" => ["I30", "Wir"],
							"I32" => ["I31", "fährt"],
							"I33" => ["I32", "wenig"],
							"I34" => ["I33", "verpassen"],
							"I35" => ["I34", "rief"],
							"I36" => ["I35", "Bild"],
							"I37" => ["I36", "Spielplatz"],
							"I38" => ["I37", "Diese"],
							"I39" => ["I38", "hochwertig"],
							"I40" => ["I39", "sehr"],
							"I41" => ["I40", "bezahlt"],
							"I42" => ["I41", "sie"],
							"I43" => ["I42", "Weg"],
							"I44" => ["I43", "spielen"],
							"I45" => ["I44", "Schreibtisch"],
							"I46" => ["I45", "gute"],
							"I47" => ["I46", "Arzt"],
							"I48" => ["I47", "Monate"],
							"I49" => ["I48", "niemals"],
							"I50" => ["I49", "feiern"],
							"I51" => ["I50", "bald"],
							"I52" => ["I51", "Tagen"],
							"I53" => ["I52", "Es"],
							"I54" => ["I53", "berühmt"],
							"I55" => ["I54", "rutschen"],
							"I56" => ["I55", "heutzutage"],
							"I57" => ["I56", "sie"],
							"I58" => ["I57", "Uns"],
							"I59" => ["I58", "reichlich"],
							"I60" => ["I59", "Jahr"],
							"I61" => ["I60", "ihr"],
							"I62" => ["I61", "draußen"],
							"I63" => ["I62", "liebt"],
							"I64" => ["I63", "dieser"],
							"I65" => ["I64", "Sonnenuntergänge"],
							"I66" => ["I65", "verpasse"],
							"I67" => ["I66", "Es"],
							"I68" => ["I67", "nicht"],
							"I69" => ["I68", "Ständen"],
							"I70" => ["I69", "Damals"],
							"I71" => ["I70", "etwas"],
							"I72" => ["I71", "Bibliothek"],
							"I73" => ["I72", "verbogen"],
							"I74" => ["I73", "klatschen"],
							"I75" => ["I74", "schließen"],
							"I76" => ["I75", "ihnen"],
							"I77" => ["I76", "ausleihe"],
							"I78" => ["I77", "Winter"],
							"I79" => ["I78", "Pflegerinnen"],
							"I80" => ["I79", "verdienen"],
							"I81" => ["I80", "kaut"],
							"I82" => ["I81", "Ordnungshüter"],
							"I83" => ["I82", "Minuten"],
							"I84" => ["I83", "verbessert"],
							"I85" => ["I84", "ihnen"],
							"I86" => ["I85", "Auto"],
							"I87" => ["I86", "schließen"],
							"I88" => ["I87", "verstummen"],
							"I89" => ["I88", "Ozean"],
							"I90" => ["I89", "heften"],
							"I91" => ["I90", "Dame"],
							"I92" => ["I91", "Schwimmen"],
							"I93" => ["I92", "euch"],
							"I94" => ["I93", "Dieser"]
					}
					r.data.each do |d|
						if r.report['positive'].include?(d['item'])
							sum += 1
							new_data = new_data + [{'item':  items[d['item']][0],"group":d['group'].to_s, "answer":d['answer'], "time":d['time'], "result": 1}]
							p_items = p_items + [items[d['item']][0]]
							if d['group'] == 1
								complex_str_cor += 1
								if complex_str_cor_items == ""
									complex_str_cor_items = "" + items[d['item']][1]
								else
									complex_str_cor_items += ", " + items[d['item']][1]
								end
							elsif d['group'] == 2
								inf_cor += 1
								if inf_cor_items == ""
									inf_cor_items = "" + items[d['item']][1]
								else
									inf_cor_items += ", " + items[d['item']][1]
								end
							elsif d['group'] == 3
								coh_cor += 1
								if coh_cor_items == ""
									coh_cor_items = "" + items[d['item']][1]
								else
									coh_cor_items += ", " + items[d['item']][1]
								end
							end
						elsif r.report['negative'].include?(d['item'])
							n_sum += 1
							new_data = new_data + [{'item':  items[d['item']][0],"group":d['group'].to_s, "answer":d['answer'], "time":d['time'], "result": 0}]
							n_items = n_items + [items[d['item']][0]]
							if d['group'] == 1
								complex_str_fal += 1
								if complex_str_fal_items == ""
									complex_str_fal_items = "" + items[d['item']][1]
								else
									complex_str_fal_items = ", " + items[d['item']][1]
								end
							elsif d['group'] == 2
								inf_fal += 1
								if inf_fal_items == ""
									inf_fal_items = "" + items[d['item']][1]
								else
									inf_fal_items += ", " + items[d['item']][1]
								end
							elsif d['group'] == 3
								coh_fal += 1
								if coh_fal_items == ""
									coh_fal_items = "" + items[d['item']][1]
								else
									coh_fal_items += ", " + items[d['item']][1]
								end
							end
						else
							new_data = new_data + [{'item':  items[d['item']][0],"group":d['group'].to_s, "answer":d['answer'], "time":d['time'], "result": 'NA'}]
						end
					end
					lg = ((sum.to_f/(sum + n_sum).to_f)*100).round(1).to_s
					coherence = '<strong>Anzahl richtig gelöster Items:</strong> '+coh_cor.to_s+'<hr style="margin-top:0; margin-bottom:0"/>'+coh_cor_items+'<br/><br/><strong>Anzahl falsch gelöster Items:</strong> '+coh_fal.to_s+'<hr style="margin-top:0; margin-bottom:0"/>'+coh_fal_items
					complex_structure = '<strong>Anzahl richtig gelöster Items:</strong> '+complex_str_cor.to_s+'<hr style="margin-top:0; margin-bottom:0"/>'+complex_str_cor_items+'<br/><br/><strong>Anzahl falsch gelöster Items:</strong> '+complex_str_fal.to_s+'<hr style="margin-top:0; margin-bottom:0"/>'+complex_str_fal_items
					inferenz = '<strong>Anzahl richtig gelöster Items:</strong> '+inf_cor.to_s+'<hr style="margin-top:0; margin-bottom:0"/>'+inf_cor_items+'<br/><br/><strong>Anzahl falsch gelöster Items:</strong> '+inf_fal.to_s+'<hr style="margin-top:0; margin-bottom:0"/>'+inf_fal_items
					views = {'V1': sum, 'V2': {'RI':''+sum.to_s + ' von 93', 'KOMS': complex_structure, 'INF': inferenz, 'KO': coherence, 'LG': ((sum/(sum +n_sum))*100).round(1).to_s, 'LGM': "-"},'V3': {'SUM':sum ,'RI':''+sum.to_s + ' von 93', 'KOMS': complex_structure, 'INF': inferenz, 'KO': coherence, 'LG': ((sum/(sum +n_sum))*100).round(1).to_s, 'LGM': "-"} }
					r.data = new_data
					r.report['positive'] = p_items
					r.report['negative'] = n_items
					r.views = views
			else
				r.data.each do |d|
					d['description'] = r.assessment.test.items[d['item']]
					if r.report['positive'].include?(d['item'])
						d['result'] = 1
					elsif r.report['negative'].include?(d['item'])
						d['result'] = 0
					else
						d['result'] = 'NA'
					end
				end
			end
			r.save
    else
			#Falls Daten von gestern auf heute übertragen wurden. Einheitliche Darstellung
			if r.assessment.test.shorthand == 'SEL2'
				r.views['V2']['ADA'] = (r.views['V2']['ADA'].sub '<br/><strong>Richtig gelöste Items: </strong><br/>', '<hr style="margin-top:0; margin-bottom:0"/>').sub '<br/><strong>Falsch gelöste Items:</strong><br/>', '<hr style="margin-top:0; margin-bottom:0"/>'
				r.views['V3']['ADA'] = (r.views['V3']['ADA'].sub '<br/><strong>Richtig gelöste Items: </strong><br/>', '<hr style="margin-top:0; margin-bottom:0"/>').sub '<br/><strong>Falsch gelöste Items:</strong><br/>', '<hr style="margin-top:0; margin-bottom:0"/>'
				r.views['V2']['AVP'] = (r.views['V2']['AVP'].sub '<br/><strong>Richtig gelöste Items: </strong><br/>', '<hr style="margin-top:0; margin-bottom:0"/>').sub '<br/><strong>Falsch gelöste Items:</strong><br/>', '<hr style="margin-top:0; margin-bottom:0"/>'
				r.views['V3']['AVP'] = (r.views['V3']['AVP'].sub '<br/><strong>Richtig gelöste Items: </strong><br/>', '<hr style="margin-top:0; margin-bottom:0"/>').sub '<br/><strong>Falsch gelöste Items:</strong><br/>', '<hr style="margin-top:0; margin-bottom:0"/>'
      elsif r.assessment.test.shorthand == 'SEL4'
				r.views['V2']['ADA'] = (r.views['V2']['ADA'].sub '<br/><strong>Richtig gelöste Items: </strong><br/>', '<hr style="margin-top:0; margin-bottom:0"/>').sub '<br/><strong>Falsch gelöste Items:</strong><br/>', '<hr style="margin-top:0; margin-bottom:0"/>'
				r.views['V3']['ADA'] = (r.views['V3']['ADA'].sub '<br/><strong>Richtig gelöste Items: </strong><br/>', '<hr style="margin-top:0; margin-bottom:0"/>').sub '<br/><strong>Falsch gelöste Items:</strong><br/>', '<hr style="margin-top:0; margin-bottom:0"/>'
				r.views['V2']['AVP'] = (r.views['V2']['AVP'].sub '<br/><strong>Richtig gelöste Items: </strong><br/>', '<hr style="margin-top:0; margin-bottom:0"/>').sub '<br/><strong>Falsch gelöste Items:</strong><br/>', '<hr style="margin-top:0; margin-bottom:0"/>'
				r.views['V3']['AVP'] = (r.views['V3']['AVP'].sub '<br/><strong>Richtig gelöste Items: </strong><br/>', '<hr style="margin-top:0; margin-bottom:0"/>').sub '<br/><strong>Falsch gelöste Items:</strong><br/>', '<hr style="margin-top:0; margin-bottom:0"/>'
				r.views['V2']['AVK'] = (r.views['V3']['AVK'].sub '<br/><strong>Richtig gelöste Items: </strong><br/>', '<hr style="margin-top:0; margin-bottom:0"/>').sub '<br/><strong>Falsch gelöste Items:</strong><br/>', '<hr style="margin-top:0; margin-bottom:0"/>'
				r.views['V3']['AVK'] = (r.views['V3']['AVK'].sub '<br/><strong>Richtig gelöste Items: </strong><br/>', '<hr style="margin-top:0; margin-bottom:0"/>').sub '<br/><strong>Falsch gelöste Items:</strong><br/>', '<hr style="margin-top:0; margin-bottom:0"/>'
      elsif r.assessment.test.shorthand == 'SEL6'
				r.views['V2']['KOMS'] = (r.views['V2']['KOMS'].sub '<br/><strong>Richtig gelöste Items: </strong><br/>', '<hr style="margin-top:0; margin-bottom:0"/>').sub '<br/><strong>Falsch gelöste Items:</strong><br/>', '<hr style="margin-top:0; margin-bottom:0"/>'
				r.views['V3']['KOMS'] = (r.views['V3']['KOMS'].sub '<br/><strong>Richtig gelöste Items: </strong><br/>', '<hr style="margin-top:0; margin-bottom:0"/>').sub '<br/><strong>Falsch gelöste Items:</strong><br/>', '<hr style="margin-top:0; margin-bottom:0"/>'
				r.views['V2']['INF'] = (r.views['V2']['INF'].sub '<br/><strong>Richtig gelöste Items: </strong><br/>', '<hr style="margin-top:0; margin-bottom:0"/>').sub '<br/><strong>Falsch gelöste Items:</strong><br/>', '<hr style="margin-top:0; margin-bottom:0"/>'
				r.views['V3']['INF'] = (r.views['V3']['INF'].sub '<br/><strong>Richtig gelöste Items: </strong><br/>', '<hr style="margin-top:0; margin-bottom:0"/>').sub '<br/><strong>Falsch gelöste Items:</strong><br/>', '<hr style="margin-top:0; margin-bottom:0"/>'
				r.views['V2']['KO'] = (r.views['V3']['KO'].sub '<br/><strong>Richtig gelöste Items: </strong><br/>', '<hr style="margin-top:0; margin-bottom:0"/>').sub '<br/><strong>Falsch gelöste Items:</strong><br/>', '<hr style="margin-top:0; margin-bottom:0"/>'
				r.views['V3']['KO'] = (r.views['V3']['KO'].sub '<br/><strong>Richtig gelöste Items: </strong><br/>', '<hr style="margin-top:0; margin-bottom:0"/>').sub '<br/><strong>Falsch gelöste Items:</strong><br/>', '<hr style="margin-top:0; margin-bottom:0"/>'
      end
		end
	end
end

