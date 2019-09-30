#Janas Testresult anpassen
r = Result.find(3290)
r.report['positive'] = ["I27", "I38", "I43", "I56", "I47", "I12", "I19", "I50", "I30", "I59", "I28", "I25", "I39", "I45", "I29", "I34", "I53", "I54", "I3", "I4", "I11", "I21", "I46", "I36", "I6", "I10", "I5"]
r.report['negative'] = ["I57", "I17", "I16", "I58", "I32", "I55", "I9", "I35", "I20", "I52"]
r.views['V1'] = 27
r.views['V2']['RI'] = "27 von 60"
r.views['V2']['RI'] = "27 von 60"
r.views['V3']['SUM'] = 27
r.save

results = Result.all
results.each do |r|
	#Zusätzliche Sicherheitsabfrage: Kann an meinen Datensatz gelegen haben, aber manchmal gab es keine Assessments und falls Daten vom Beispieltest in der Datenabank liegen
	#Sollte in der Live-Version eigentlich nicht vorkommen
  #Daten checken, da Daten von Usern, die nach dem letzten Update dazu gekommen sind nicht überprüft werden müssen/sollten(Umparsen der Daten!)
	if r.assessment.nil? || r.data.nil? || (r.student.group.owner.created_at > Date.parse('2019-09-25')) || (r.update_at != false && r.updated_at > Date.parse("2019-09-25"))
		next
  end
  #Mir fällt gerade nichts besseres ein^^'
  test_example_data = true
  if r.data[0]['description'].nil?
  else
    	if r.data[0]['description'] == "Beispielitem"
        test_example_data = false
      end
  end
	#Nur die folgenden Daten müssen betrachtet werden
	if (r.assessment.test.shorthand == 'SEL2' || r.assessment.test.shorthand == 'SEL4' ||r.assessment.test.shorthand == 'SEL6') && r.test_date < Date.parse('2019-09-05')
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
		if r.assessment.test.shorthand == 'SEL2'
			items = {
					"I34" => ["I1", "Taschen"],
					"I60" => ["I10", "Traktor"],
					"I33" => ["I11", "besucht"],
					"I52" => ["I12", "Milch"],
					"I59" => ["I13", "Bruder"],
					"I53" => ["I15", "male"],
					"I48" => ["I16", "Kinder"],
					"I38" => ["I17", "Buch"],
					"I30" => ["I18", "faul"],
					"I12" => ["I19", "ruft"],
					"I24" => ["I2", "bade"],
					"I35" => ["I20", "Kuchen"],
					"I23" => ["I21", "Ausflug"],
					"I22" => ["I22", "schwierigen"],
					"I1" => ["I23", "blau"],
					"I44" => ["I24", "Berg"],
					"I65" => ["I25", "sieht"],
					"I32" => ["I26", "Weg"],
					"I63" => ["I27", "Abfall"],
					"I21" => ["I28", "reiten"],
					"I47" => ["I29", "leben"],
					"I5" => ["I3", "wartet"],
					"I2" => ["I30", "Pause"],
					"I55" => ["I31", "Seife"],
					"I58" => ["I32", "lange"],
					"I9" => ["I33", "Eier"],
					"I61" => ["I34", "baden"],
					"I13" => ["I35", "hell"],
					"I19" => ["I37", "Opa"],
					"I28" => ["I38", "heimlich"],
					"I39" => ["I39", "lerne"],
					"I16" => ["I4", "Film"],
					"I50" => ["I40", "Lieder"],
					"I41" => ["I41", "Geschenk"],
					"I37" => ["I42", "leere"],
					"I36" => ["I43", "Abend"],
					"I3" => ["I44", "kleinen"],
					"I45" => ["I45", "hell"],
					"I7" => ["I46", "Auto"],
					"I66" => ["I47", "Schule"],
					"I6" => ["I48", "trinkt"],
					"I27" => ["I49", "tief"],
					"I14" => ["I5", "Fahrrad"],
					"I43" => ["I50", "Keks"],
					"I8" => ["I51", "Ampel"],
					"I26" => ["I52", "hebt"],
					"I29" => ["I53", "Dose"],
					"I15" => ["I54", "schnell"],
					"I56" => ["I55", "schwimmen"],
					"I46" => ["I56", "Sofa"],
					"I51" => ["I58", "Kater"],
					"I10" => ["I6", "schlaue"],
					"I25" => ["I60", "allein"],
					"I18" => ["I61", "Schweine"],
					"I62" => ["I62", "Reifen"],
					"I17" => ["I63", "Mofas"],
					"I11" => ["I64", "Brot"],
					"I49" => ["I65", "Boden"],
					"I20" => ["I66", "Fibel"],
					"I42" => ["I7", "Wand"],
					"I4" => ["I8", "tollen"],
					"I40" => ["I9", "kalt"]
			}
			r.data.each do |d|
        if d['item'] == 'I54' || d['item'] == 'I57' || d['item'] == 'I64'
				else
					if r.report['positive'].include?(d['item'])
						sum += 1
						new_data = new_data + [{'item':  items[d['item']][0], 'description': items[d['item']][1], "group":d['group'].to_s, "answer":d['answer'], "time":d['time'], "result": 1}]
						p_items = p_items + [items[d['item']][0]]
						if d['group'] == '1' || d['group'] == 1
							ada_cor += 1
							if ada_cor_items == ""
								ada_cor_items = "" + items[d['item']][1]
							else
								ada_cor_items += ", " + items[d['item']][1]
							end
						elsif d['group'] == '2' || d['group'] == 2
							avp_cor += 1
							if avp_cor_items == ""
								avp_cor_items = "" + items[d['item']][1]
							else
								avp_cor_items += ", " + items[d['item']][1]
							end
						end
					elsif r.report['negative'].include?(d['item'])
						n_sum += 1
						new_data = new_data + [{'item':  items[d['item']][0], 'description': items[d['item']][1], "group":d['group'].to_s, "answer":d['answer'], "time":d['time'], "result": 0}]
						n_items = n_items + [items[d['item']][0]]
						if d['group'] == '1' || d['group'] == 1
							ada_fal += 1
							if ada_fal_items == ""
								ada_fal_items = "" + items[d['item']][1]
							else
								ada_fal_items += ", " + items[d['item']][1]
							end
						elsif d['group'] == '2' || d['group'] == 2
							avp_fal += 1
							if avp_fal_items == ""
								avp_fal_items = "" + items[d['item']][1]
							else
								avp_fal_items += ", " + items[d['item']][1]
							end
						end
					else
						new_data = new_data + [{'item':  items[d['item']][0], 'description': items[d['item']][1], "group":d['group'].to_s, "answer":d['answer'], "time":d['time'], "result": 'NA'}]
					end
        end
			end
			lg = ((sum.to_f/(sum + n_sum).to_f)*100).round(1).to_s
			ada = '<strong>Anzahl richtig gelöster Items:</strong> '+ada_cor.to_s+'<hr style="margin-top:0; margin-bottom:0"/>'+ada_cor_items+'<br/><br/><strong>Anzahl falsch gelöster Items:</strong> '+ada_fal.to_s+'<hr style="margin-top:0; margin-bottom:0"/>'+ada_fal_items
			avp = '<strong>Anzahl richtig gelöster Items:</strong> '+avp_cor.to_s+'<hr style="margin-top:0; margin-bottom:0"/>'+avp_cor_items+'<br/><br/><strong>Anzahl falsch gelöster Items:</strong> '+avp_fal.to_s+'<hr style="margin-top:0; margin-bottom:0"/>'+avp_fal_items
			views = {'V1': sum, 'V2': {'RI':''+sum.to_s + ' von 66', 'ADA': ada, 'AVP': avp, 'LG': lg, 'LGM': "-"},'V3': {'SUM':sum ,'RI':''+sum.to_s + ' von 66', 'ADA': ada, 'AVP': avp, 'LG': lg, 'LGM': "-"} }
			r.data = new_data
			r.report['positive'] = p_items
			r.report['negative'] = n_items
			r.views = views
    elsif r.assessment.test.shorthand == 'SEL4' && test_example_data
			items = r.assessment.test.items
			r.data.each do |d|
				if r.report['positive'].include?(d['item'])
					sum += 1
          if items[d['item']] == 'runde'
						new_data = new_data + [{'item': d['item'], 'description': items[d['item']], "group":"2", "answer":d['answer'], "time": d['time'], "result": 1}]
					else
						new_data = new_data + [{'item': d['item'], 'description': items[d['item']], "group":d['group'].to_s, "answer": d['answer'], "time":d['time'], "result": 1}]
          end
					if d['group'] == '1' || d['group'] == 1
            if items[d['item']] == 'runde'
							avp_cor += 1
							if avp_cor_items == ""
								avp_cor_items = "" + items[d['item']]
							else
								avp_cor_items += ", " + items[d['item']]
							end
            else
							ada_cor += 1
							if ada_cor_items == ""
								ada_cor_items = "" + items[d['item']]
							else
								ada_cor_items += ", " + items[d['item']]
							end
            end
					elsif d['group'] == '2' || d['group'] == 2
						avp_cor += 1
						if avp_cor_items == ""
							avp_cor_items = "" + items[d['item']]
						else
							avp_cor_items += ", " + items[d['item']]
						end
					elsif d['group'] == '3' || d['group'] == 3
						avk_cor += 1
						if avk_cor_items == ""
							avk_cor_items = "" + items[d['item']]
						else
							avk_cor_items += ", " + items[d['item']]
						end
					end
				elsif r.report['negative'].include?(d['item'])
					n_sum += 1
          if items[d['item']] == 'runde'
						new_data = new_data + [{'item': d['item'], 'description': items[d['item']], "group":'2', "answer":d['answer'], "time":d['time'], "result": 0}]
					else
						new_data = new_data + [{'item': d['item'], 'description': items[d['item']], "group":d['group'].to_s, "answer":d['answer'], "time":d['time'], "result": 0}]
					end
					if d['group'] == '1' || d['group'] == 1
            if items[d['item']] == 'runde'
							avp_fal += 1
							if avp_fal_items == ""
								avp_fal_items = "" + items[d['item']]
							else
								avp_fal_items += ", " + items[d['item']]
							end
            else
							ada_fal += 1
							if ada_fal_items == ""
								ada_fal_items = "" + items[d['item']]
							else
								ada_fal_items += ", " + items[d['item']]
							end
            end
					elsif d['group'] == '2' || d['group'] == 2
						avp_fal += 1
						if avp_fal_items == ""
							avp_fal_items = "" + items[d['item']]
						else
							avp_fal_items += ", " + items[d['item']]
						end
					elsif d['group'] == '3' || d['group'] == 3
						avk_fal += 1
						if avk_fal_items == ""
							avk_fal_items = "" + items[d['item']]
						else
							avk_fal_items += ", " + items[d['item']]
						end
					end
				else
					new_data = new_data + [{'item': d['item'], 'description': items[d['item']], "group":d['group'].to_s, "answer":d['answer'], "time":d['time'], "result": 'NA'}]
				end
			end
			lg = ((sum.to_f/(sum + n_sum).to_f)*100).round(1).to_s
			ada = '<strong>Anzahl richtig gelöster Items:</strong> '+ada_cor.to_s+'<hr style="margin-top:0; margin-bottom:0"/>'+ada_cor_items+'<br/><br/><strong>Anzahl falsch gelöster Items:</strong> '+ada_fal.to_s+'<hr style="margin-top:0; margin-bottom:0"/>'+ada_fal_items
			avp = '<strong>Anzahl richtig gelöster Items:</strong> '+avp_cor.to_s+'<hr style="margin-top:0; margin-bottom:0"/>'+avp_cor_items+'<br/><br/><strong>Anzahl falsch gelöster Items:</strong> '+avp_fal.to_s+'<hr style="margin-top:0; margin-bottom:0"/>'+avp_fal_items
			avk = '<strong>Anzahl richtig gelöster Items:</strong> '+avk_cor.to_s+'<hr style="margin-top:0; margin-bottom:0"/>'+avk_cor_items+'<br/><br/><strong>Anzahl falsch gelöster Items:</strong> '+avk_fal.to_s+'<hr style="margin-top:0; margin-bottom:0"/>'+avk_fal_items
			views = {'V1': sum, 'V2': {'RI':''+sum.to_s + ' von 60', 'ADA': ada, 'AVP': avp, 'AVK': avk, 'LG': lg, 'LGM': "-"},'V3': {'SUM':sum ,'RI':''+sum.to_s + ' von 60', 'ADA': ada, 'AVP': avp, 'AVK': avk, 'LG': lg, 'LGM': "-"} }
			r.data = new_data
			r.views = views
		elsif r.assessment.test.shorthand == 'SEL6'
			items = r.assessment.test.items
			r.data.each do |d|
				if r.report['positive'].include?(d['item'])
					sum += 1
					new_data = new_data + [{'item': d['item'], 'description': items[d['item']], "group":d['group'].to_s, "answer":d['answer'], "time":d['time'], "result": 1}]
					if d['group'] == '1' || d['group'] == 1
						complex_str_cor += 1
						if complex_str_cor_items == ""
							complex_str_cor_items = "" + items[d['item']]
						else
							complex_str_cor_items += ", " + items[d['item']]
						end
					elsif d['group'] == '2' || d['group'] == 2
						inf_cor += 1
						if inf_cor_items == ""
							inf_cor_items = "" + items[d['item']]
						else
							inf_cor_items += ", " + items[d['item']]
						end
					elsif d['group'] == '3' || d['group'] == 3
						coh_cor += 1
						if coh_cor_items == ""
							coh_cor_items = "" + items[d['item']]
						else
							coh_cor_items += ", " + items[d['item']]
						end
					end
				elsif r.report['negative'].include?(d['item'])
					n_sum += 1
					new_data = new_data + [{'item': d['item'], 'description': items[d['item']], "group":d['group'].to_s, "answer":d['answer'], "time":d['time'], "result": 0}]
					if d['group'] == '1' || d['group'] == 1
						complex_str_fal += 1
						if complex_str_fal_items == ""
							complex_str_fal_items = "" + items[d['item']]
						else
							complex_str_fal_items += ", " + items[d['item']]
						end
					elsif d['group'] == '2' || d['group'] == 2
						inf_fal += 1
						if inf_fal_items == ""
							inf_fal_items = "" + items[d['item']]
						else
							inf_fal_items += ", " + items[d['item']]
						end
					elsif d['group'] == '3' || d['group'] == 3
						coh_fal += 1
						if coh_fal_items == ""
							coh_fal_items = "" + items[d['item']]
						else
							coh_fal_items += ", " + items[d['item']]
						end
					end
				else
					new_data = new_data + [{'item': d['item'], 'description': items[d['item']], "group":d['group'].to_s, "answer":d['answer'], "time":d['time'], "result": 'NA'}]
				end
			end
			lg = ((sum.to_f/(sum + n_sum).to_f)*100).round(1).to_s
			coherence = '<strong>Anzahl richtig gelöster Items:</strong> '+coh_cor.to_s+'<hr style="margin-top:0; margin-bottom:0"/>'+coh_cor_items+'<br/><br/><strong>Anzahl falsch gelöster Items:</strong> '+coh_fal.to_s+'<hr style="margin-top:0; margin-bottom:0"/>'+coh_fal_items
			complex_structure = '<strong>Anzahl richtig gelöster Items:</strong> '+complex_str_cor.to_s+'<hr style="margin-top:0; margin-bottom:0"/>'+complex_str_cor_items+'<br/><br/><strong>Anzahl falsch gelöster Items:</strong> '+complex_str_fal.to_s+'<hr style="margin-top:0; margin-bottom:0"/>'+complex_str_fal_items
			inferenz = '<strong>Anzahl richtig gelöster Items:</strong> '+inf_cor.to_s+'<hr style="margin-top:0; margin-bottom:0"/>'+inf_cor_items+'<br/><br/><strong>Anzahl falsch gelöster Items:</strong> '+inf_fal.to_s+'<hr style="margin-top:0; margin-bottom:0"/>'+inf_fal_items
			views = {'V1': sum, 'V2': {'RI':''+sum.to_s + ' von 93', 'KOMS': complex_structure, 'INF': inferenz, 'KO': coherence, 'LG': ((sum/(sum +n_sum))*100).round(1).to_s, 'LGM': "-"},'V3': {'SUM':sum ,'RI':''+sum.to_s + ' von 93', 'KOMS': complex_structure, 'INF': inferenz, 'KO': coherence, 'LG': ((sum/(sum +n_sum))*100).round(1).to_s, 'LGM': "-"} }
			r.data = new_data
			r.views = views
		else
		end
	else
  end
	r.save
end

