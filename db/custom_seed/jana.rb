results = Result.all
results.each do |r|

	if r.assessment.test.shorthand != 'WS1' && r.assessment.test.shorthand != 'TS0' && r.assessment.test.shorthand != 'FB-PIQ-STU' &&
			r.assessment.test.shorthand != 'FB-PIQ' && r.assessment.test.shorthand != 'FB' && r.assessment.test.shorthand != 'FB2' && r.assessment.test.shorthand != 'BPL3b2' &&
			r.assessment.test.shorthand != 'BPL3b1' && r.assessment.test.shorthand != 'BPL3a2' && r.assessment.test.shorthand != 'BPL3a1'
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

    date_before_new_levumi = Date.parse('2019-09-01')

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



		if r.assessment.test.shorthand == 'SEL2' && r.test_date < date_before_new_levumi
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
				if d['item'] != 'I14' && d['item'] != 'I16' && d['item'] != 'I25' && d['description'] != "Beispielitem"
					if r.report['positive'].include?(d['item'])
            sum += 1
						new_data = new_data + [{'item':  items[d['item']][0],"group":d['group'].to_s, "answer":d['answer'], "time":d['time'], "result": 1}]
						p_items = p_items + [items[d['item']][0]]
            if d['group'] == 1
							ada_cor += 1
              if ada_cor_items == ""
                ada_cor_items = "" + items[d['item']][1]
              else
								ada_cor_items = ", " + items[d['item']][1]
              end
            elsif d['group'] == 2
							avp_cor += 1
							if avp_cor_items == ""
								avp_cor_items = "" + items[d['item']][1]
							else
								avp_cor_items = ", " + items[d['item']][1]
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
								ada_fal_items = ", " + items[d['item']][1]
							end
						elsif d['group'] == 2
							avp_fal += 1
							if avp_fal_items == ""
								avp_fal_items = "" + items[d['item']][1]
							else
								avp_fal_items = ", " + items[d['item']][1]
							end
						end
					else
						new_data = new_data + [{'item':  items[d['item']][0],"group":d['group'].to_s, "answer":d['answer'], "time":d['time'], "result": 'NA'}]
					end
				end
      end
      if r.data == [] || r.data[0]['description'] == "Beispielitem"
        lg = r.views['V2']['LG']
      else
				lg = ((sum/(sum + n_sum))*100).round(1).to_s
      end

			new_data = new_data + [{'item':  'I62',"group": '1', "answer":'NA', "time":'NA'}, {'item':  'I41',"group":'1', "answer":'NA', "time":'NA'}, {'item':  'I22',"group":'2', "answer":'NA', "time":'NA'}]
			ada = '<strong>Anzahl richtig gelöster Items:</strong> '+ada_cor.to_s+'<br/><strong>Richtig gelöste Items: </strong><br/>'+ada_cor_items+'<br/><br/><strong>Anzahl falsch gelöster Items:</strong> '+ada_fal.to_s+'<br/><strong>Falsch gelöste Items:</strong><br/>'+ada_fal_items
			avp = '<strong>Anzahl richtig gelöster Items:</strong> '+avp_cor.to_s+'<br/><strong>Richtig gelöste Items: </strong><br/>'+avp_cor_items+'<br/><br/><strong>Anzahl falsch gelöster Items:</strong> '+avp_fal.to_s+'<br/><strong>Falsch gelöste Items:</strong><br/>'+avp_fal_items
			views = {'V1': sum, 'V2': {'RI':''+sum.to_s + ' von 66', 'ADA': ada, 'AVP': avp, 'LG': lg, 'LGM': "-"},'V3': {'SUM':sum ,'RI':''+sum.to_s + ' von 66', 'ADA': ada, 'AVP': avp, 'LG': lg, 'LGM': "-"} }
			r.data = new_data
      r.views = views
    elsif r.assessment.test.shorthand == 'SEL4' && r.test_date < date_before_new_levumi
      items = {
					"I38" => "I1",
					"I61" => "I10",
					"I45" => "I11",
					"I23" => "I12",
					"I5" => "I13",
					"I18" => "I14",
					"I29" => "I15",
					"I60" => "I16",
					"I27" => "I17",
					"I58" => "I18",
					"I26" => "I19",
					"I8" => "I2",
					"I21" => "I20",
					"I48" => "I21",
					"I16" => "I22",
					"I32" => "I23",
					"I33" => "I24",
					"I14" => "I25",
					"I6" => "I26",
					"I2" => "I27",
					"I53" => "I28",
					"I22" => "I29",
					"I47" => "I3",
					"I28" => "I30",
					"I13" => "I31",
					"I37" => "I32",
					"I51" => "I33",
					"I54" => "I34",
					"I19" => "I35",
					"I55" => "I36",
					"I12" => "I37",
					"I9" => "I38",
					"I20" => "I39",
					"I62" => "I4",
					"I49" => "I40",
					"I39" => "I41",
					"I30" => "I42",
					"I24" => "I43",
					"I46" => "I44",
					"I36" => "I45",
					"I42" => "I46",
					"I10" => "I47",
					"I34" => "I48",
					"I59" => "I49",
					"I56" => "I5",
					"I25" => "I50",
					"I17" => "I51",
					"I43" => "I52",
					"I52" => "I53",
					"I41" => "I54",
					"I31" => "I55",
					"I4" => "I56",
					"I50" => "I57",
					"I3" => "I58",
					"I44" => "I59",
					"I57" => "I6",
					"I35" => "I60",
					"I40" => "I7",
					"I15" => "I8",
					"I11" => "I9"
			}
			r.data.each do |d|
        if d['item'] != 'I7' && d['description'] != "Beispielitem"
					if r.report['positive'].include?(d['item'])
						sum += 1
						new_data = new_data + [{'item':  items[d['item']][0],"group":d['group'].to_s, "answer":d['answer'], "time":d['time'], "result": 1}]
						p_items = p_items + [items[d['item']][0]]
						if d['group'] == 1
							ada_cor += 1
							if ada_cor_items == ""
								ada_cor_items = "" + items[d['item']][1]
							else
								ada_cor_items = ", " + items[d['item']][1]
							end
						elsif d['group'] == 2
							avp_cor += 1
							if avp_cor_items == ""
								avp_cor_items = "" + items[d['item']][1]
							else
								avp_cor_items = ", " + items[d['item']][1]
              end
            elsif d['group'] == 3
							avk_cor += 1
							if avk_cor_items == ""
								avk_cor_items = "" + items[d['item']][1]
							else
								avk_cor_items = ", " + items[d['item']][1]
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
								ada_fal_items = ", " + items[d['item']][1]
							end
						elsif d['group'] == 2
							avp_fal += 1
							if avp_fal_items == ""
								avp_fal_items = "" + items[d['item']][1]
							else
								avp_fal_items = ", " + items[d['item']][1]
              end
            elsif d['group'] == 3
							avk_fal += 1
							if avk_fal_items == ""
								avk_fal_items = "" + items[d['item']][1]
							else
								avk_fal_items = ", " + items[d['item']][1]
							end
						end
					else
						new_data = new_data + [{'item':  items[d['item']][0],"group":d['group'].to_s, "answer":d['answer'], "time":d['time'], "result": 'NA'}]
					end
				end
      end
			if r.data == [] || r.data[0]['description'] == "Beispielitem"
				lg = r.views['V2']['LG']
			else
				lg = ((sum/(sum + n_sum))*100).round(1).to_s
			end
			ada = '<strong>Anzahl richtig gelöster Items:</strong> '+ada_cor.to_s+'<br/><strong>Richtig gelöste Items: </strong><br/>'+ada_cor_items+'<br/><br/><strong>Anzahl falsch gelöster Items:</strong> '+ada_fal.to_s+'<br/><strong>Falsch gelöste Items:</strong><br/>'+ada_fal_items
			avp = '<strong>Anzahl richtig gelöster Items:</strong> '+avp_cor.to_s+'<br/><strong>Richtig gelöste Items: </strong><br/>'+avp_cor_items+'<br/><br/><strong>Anzahl falsch gelöster Items:</strong> '+avp_fal.to_s+'<br/><strong>Falsch gelöste Items:</strong><br/>'+avp_fal_items
			avk = '<strong>Anzahl richtig gelöster Items:</strong> '+avk_cor.to_s+'<br/><strong>Richtig gelöste Items: </strong><br/>'+avk_cor_items+'<br/><br/><strong>Anzahl falsch gelöster Items:</strong> '+avk_fal.to_s+'<br/><strong>Falsch gelöste Items:</strong><br/>'+avk_fal_items
			views = {'V1': sum, 'V2': {'RI':''+sum.to_s + ' von 60', 'ADA': ada, 'AVP': avp, 'AVK': avk, 'LG': lg, 'LGM': "-"},'V3': {'SUM':sum ,'RI':''+sum.to_s + ' von 60', 'ADA': ada, 'AVP': avp, 'AVK': avk, 'LG': lg, 'LGM': "-"} }
			r.data = new_data
      p views
			r.views = views
    elsif r.assessment.test.shorthand == 'SEL6' && r.test_date < date_before_new_levumi
			items = {
					"I2" => "I1",
					"I3" => "I2",
					"I4" => "I3",
					"I5" => "I4",
					"I6" => "I5",
					"I7" => "I6",
					"I8" => "I7",
					"I9" => "I8",
					"I10" => "I9",
					"I11" => "I10",
					"I12" => "I11",
					"I13" => "I12",
					"I14" => "I13",
					"I15" => "I14",
					"I16" => "I15",
					"I17" => "I16",
					"I18" => "I17",
					"I19" => "I18",
					"I20" => "I19",
					"I21" => "I20",
					"I22" => "I21",
					"I23" => "I22",
					"I24" => "I23",
					"I25" => "I24",
					"I26" => "I25",
					"I27" => "I26",
					"I28" => "I27",
					"I29" => "I28",
					"I30" => "I29",
					"I31" => "I30",
					"I32" => "I31",
					"I33" => "I32",
					"I34" => "I33",
					"I35" => "I34",
					"I36" => "I35",
					"I37" => "I36",
					"I38" => "I37",
					"I39" => "I38",
					"I40" => "I39",
					"I41" => "I40",
					"I42" => "I41",
					"I43" => "I42",
					"I44" => "I43",
					"I45" => "I44",
					"I46" => "I45",
					"I47" => "I46",
					"I48" => "I47",
					"I49" => "I48",
					"I50" => "I49",
					"I51" => "I50",
					"I52" => "I51",
					"I53" => "I52",
					"I54" => "I53",
					"I55" => "I54",
					"I56" => "I55",
					"I57" => "I56",
					"I58" => "I57",
					"I59" => "I58",
					"I60" => "I59",
					"I61" => "I60",
					"I62" => "I61",
					"I63" => "I62",
					"I64" => "I63",
					"I65" => "I64",
					"I66" => "I65",
					"I67" => "I66",
					"I68" => "I67",
					"I69" => "I68",
					"I70" => "I69",
					"I71" => "I70",
					"I72" => "I71",
					"I73" => "I72",
					"I74" => "I73",
					"I75" => "I74",
					"I76" => "I75",
					"I77" => "I76",
					"I78" => "I77",
					"I79" => "I78",
					"I80" => "I79",
					"I81" => "I80",
					"I82" => "I81",
					"I83" => "I82",
					"I84" => "I83",
					"I85" => "I84",
					"I86" => "I85",
					"I87" => "I86",
					"I88" => "I87",
					"I89" => "I88",
					"I90" => "I89",
					"I91" => "I90",
					"I92" => "I91",
					"I93" => "I92",
					"I94" => "I93"
			}
			r.data.each do |d|
        if d['description'] != "Beispielitem"
					if r.report['positive'].include?(d['item'])
						sum += 1
						new_data = new_data + [{'item':  items[d['item']][0],"group":d['group'].to_s, "answer":d['answer'], "time":d['time'], "result": 1}]
						p_items = p_items + [items[d['item']][0]]
						if d['group'] == 1
							complex_str_cor += 1
							if complex_str_cor_items == ""
								complex_str_cor_items = "" + items[d['item']][1]
							else
								complex_str_cor_items = ", " + items[d['item']][1]
							end
						elsif d['group'] == 2
							inf_cor += 1
							if inf_cor_items == ""
								inf_cor_items = "" + items[d['item']][1]
							else
								inf_cor_items = ", " + items[d['item']][1]
							end
						elsif d['group'] == 3
							coh_cor += 1
							if coh_cor_items == ""
								coh_cor_items = "" + items[d['item']][1]
							else
								coh_cor_items = ", " + items[d['item']][1]
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
								inf_fal_items = ", " + items[d['item']][1]
							end
						elsif d['group'] == 3
							coh_fal += 1
							if coh_fal_items == ""
								coh_fal_items = "" + items[d['item']][1]
							else
								coh_fal_items = ", " + items[d['item']][1]
							end
						end
					else
						new_data = new_data + [{'item':  items[d['item']][0],"group":d['group'].to_s, "answer":d['answer'], "time":d['time'], "result": 'NA'}]
					end
        end
      end
			if r.data == [] || r.data[0]['description'] == "Beispielitem"
				lg = r.views['V2']['LG']
			else
				lg = ((sum/(sum + n_sum))*100).round(1).to_s
			end
			coherence = '<strong>Anzahl richtig gelöster Items:</strong> '+coh_cor.to_s+'<br/><strong>Richtig gelöste Items: </strong><br/>'+coh_cor_items+'<br/><br/><strong>Anzahl falsch gelöster Items:</strong> '+coh_fal.to_s+'<br/><strong>Falsch gelöste Items:</strong><br/>'+coh_fal_items
			complex_structure = '<strong>Anzahl richtig gelöster Items:</strong> '+complex_str_cor.to_s+'<br/><strong>Richtig gelöste Items: </strong><br/>'+complex_str_cor_items+'<br/><br/><strong>Anzahl falsch gelöster Items:</strong> '+complex_str_fal.to_s+'<br/><strong>Falsch gelöste Items:</strong><br/>'+complex_str_fal_items
			inferenz = '<strong>Anzahl richtig gelöster Items:</strong> '+inf_cor.to_s+'<br/><strong>Richtig gelöste Items: </strong><br/>'+inf_cor_items+'<br/><br/><strong>Anzahl falsch gelöster Items:</strong> '+inf_fal.to_s+'<br/><strong>Falsch gelöste Items:</strong><br/>'+inf_fal_items
			views = {'V1': sum, 'V2': {'RI':''+sum.to_s + ' von 93', 'KOMS': complex_structure, 'INF': inferenz, 'KO': coherence, 'LG': ((sum/(sum +n_sum))*100).round(1).to_s, 'LGM': "-"},'V3': {'SUM':sum ,'RI':''+sum.to_s + ' von 93', 'KOMS': complex_structure, 'INF': inferenz, 'KO': coherence, 'LG': ((sum/(sum +n_sum))*100).round(1).to_s, 'LGM': "-"} }
			r.data = new_data
			r.views = views
		end
		r.save
	end
end

