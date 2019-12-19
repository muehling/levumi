#Lösung für SEL2
t = Test.find_by shorthand: "SEL2"
assessments = Assessment.where(test_id: t.id)
results = Result.where(assessment_id: assessments.ids).where('test_date > 2019-09-08').order(:test_date)
items_sel2 = {"I1"=> { "group"=> "1", "correct_answer"=> "Taschen"},
              "I2"=> { "group"=> "2", "correct_answer"=> "bade"},
              "I3"=> { "group"=> "2", "correct_answer"=> "wartet"},
              "I4"=> { "group"=> "1", "correct_answer"=> "Film"},
              "I5"=> { "group"=> "1", "correct_answer"=> "Fahrrad"},
              "I6"=> { "group"=> "2", "correct_answer"=> "schlaue"},
              "I7"=> { "group"=> "1", "correct_answer"=> "Wand"},
              "I8"=> { "group"=> "2", "correct_answer"=> "tollen"},
              "I9"=> { "group"=> "2", "correct_answer"=> "kalt"},
              "I10"=> { "group"=> "1", "correct_answer"=> "Traktor"},
              "I11"=> { "group"=> "2", "correct_answer"=> "besucht"},
              "I12"=> { "group"=> "1", "correct_answer"=> "Milch"},
              "I13"=> { "group"=> "1", "correct_answer"=> "Bruder"},
              "I14"=> { "group"=> "2", "correct_answer"=> "scharfe"},
              "I15"=> { "group"=> "2", "correct_answer"=> "male"},
              "I16"=> { "group"=> "1", "correct_answer"=> "Kinder"},
              "I17"=> { "group"=> "1", "correct_answer"=> "Buch"},
              "I18"=> { "group"=> "2", "correct_answer"=> "faul"},
              "I19"=> { "group"=> "2", "correct_answer"=> "ruft"},
              "I20"=> { "group"=> "1", "correct_answer"=> "Kuchen"},
              "I21"=> { "group"=> "1", "correct_answer"=> "Ausflug"},
              "I22"=> { "group"=> "2", "correct_answer"=> "schwierigen"},
              "I23"=> { "group"=> "2", "correct_answer"=> "blau"},
              "I24"=> { "group"=> "1", "correct_answer"=> "Berg"},
              "I25"=> { "group"=> "2", "correct_answer"=> "sieht"},
              "I26"=> { "group"=> "1", "correct_answer"=> "Weg"},
              "I27"=> { "group"=> "1", "correct_answer"=> "Abfall"},
              "I28"=> { "group"=> "2", "correct_answer"=> "reiten"},
              "I29"=> { "group"=> "2", "correct_answer"=> "leben"},
              "I30"=> { "group"=> "1", "correct_answer"=> "Pause"},
              "I31"=> { "group"=> "1", "correct_answer"=> "Seife"},
              "I32"=> { "group"=> "2", "correct_answer"=> "lange"},
              "I33"=> { "group"=> "1", "correct_answer"=> "Eier"},
              "I34"=> { "group"=> "2", "correct_answer"=> "baden"},
              "I35"=> { "group"=> "2", "correct_answer"=> "hell"},
              "I36"=> { "group"=> "1", "correct_answer"=> "Wasser"},
              "I37"=> { "group"=> "1", "correct_answer"=> "Opa"},
              "I38"=> { "group"=> "2", "correct_answer"=> "heimlich"},
              "I39"=> { "group"=> "2", "correct_answer"=> "lerne"},
              "I40"=> { "group"=> "1", "correct_answer"=> "Lieder"},
              "I41"=> { "group"=> "1", "correct_answer"=> "Geschenk"},
              "I42"=> { "group"=> "2", "correct_answer"=> "leere"},
              "I43"=> { "group"=> "1", "correct_answer"=> "Abend"},
              "I44"=> { "group"=> "2", "correct_answer"=> "kleinen"},
              "I45"=> { "group"=> "2", "correct_answer"=> "hell"},
              "I46"=> { "group"=> "1", "correct_answer"=> "Auto"},
              "I47"=> { "group"=> "1", "correct_answer"=> "Schule"},
              "I48"=> { "group"=> "2", "correct_answer"=> "trinkt"},
              "I49"=> { "group"=> "2", "correct_answer"=> "tief"},
              "I50"=> { "group"=> "1", "correct_answer"=> "Keks"},
              "I51"=> { "group"=> "1", "correct_answer"=> "Ampel"},
              "I52"=> { "group"=> "2", "correct_answer"=> "hebt"},
              "I53"=> { "group"=> "1", "correct_answer"=> "Dose"},
              "I54"=> { "group"=> "2", "correct_answer"=> "schnell"},
              "I55"=> { "group"=> "2", "correct_answer"=> "schwimmen"},
              "I56"=> { "group"=> "1", "correct_answer"=> "Sofa"},
              "I57"=> { "group"=> "2", "correct_answer"=> "laufen"},
              "I58"=> { "group"=> "1", "correct_answer"=> "Kater"},
              "I59"=> { "group"=> "1", "correct_answer"=> "Ende"},
              "I60"=> { "group"=> "2", "correct_answer"=> "allein"},
              "I61"=> { "group"=> "1", "correct_answer"=> "Schweine"},
              "I62"=> { "group"=> "1", "correct_answer"=> "Reifen"},
              "I63"=> { "group"=> "1", "correct_answer"=> "Mofas"},
              "I64"=> { "group"=> "1", "correct_answer"=> "Brot"},
              "I65"=> { "group"=> "1", "correct_answer"=> "Boden"},
              "I66"=> { "group"=> "1", "correct_answer"=> "Fibel"}
}
results.each do |r|
  negative = []
  positive = []
  data = []
  p_sum = 0
  n_sum = 0
  ada_correct_items = ""
  ada_false_items = ""
  ada_positve = 0
  ada_negative = 0

  avp_correct_items = ""
  avp_false_items = ""
  avp_positve = 0
  avp_negative = 0

  r.data.each do |d|
    result = 0
    item = items_sel2[d["item"]]
    if item["group"] == "1"
      if d["answer"].gsub(/\u00AD/, '') == item["correct_answer"]
        p_sum += 1
        result = 1
        positive += [d["item"]]
        ada_positve += 1
        if ada_correct_items == ""
          ada_correct_items += item["correct_answer"]
        else
          ada_correct_items += ", " +item["correct_answer"]
        end
      elsif d["answer"].gsub(/\u00AD/, '') != "NA"
        n_sum += 1
        ada_negative += 1
        negative += [d["item"]]
        if ada_false_items == ""
          ada_false_items += item["correct_answer"]
        else
          ada_false_items += ", " + item["correct_answer"]
        end
      else
        result = "NA"
      end
    elsif d["answer"].gsub(/\u00AD/, '') != "NA"
      if d["answer"].gsub(/\u00AD/, '') == item["correct_answer"]
        p_sum += 1
        avp_positve += 1
        result = 1
        positive += [d["item"]]
        if avp_correct_items == ""
          avp_correct_items += item["correct_answer"]
        else
          avp_correct_items += ", " +item["correct_answer"]
        end
      else
        avp_negative += 1
        n_sum += 1
        negative += [d["item"]]
        if avp_false_items == ""
          avp_false_items += item["correct_answer"]
        else
          avp_false_items += ", " + item["correct_answer"]
        end
      end
    else
      result = "NA"
    end
    data += [{"item": d["item"], "result": result, "group": item["group"], "description": item["correct_answer"], "answer": d["answer"].gsub(/\u00AD/, ''), "time": d["time"] }]
  end
  if r.data[0]["time"] != "NA" && r.id > 283 && r.id < 14157 && r.data[0]["time"] != "NA" && r.data[0]["time"] > 300000
      data[0] = {"item": data[0][:item], "result": data[0][:result], "group": data[0][:group], "description": data[0][:description], "answer": data[0][:answer], "time": "NA" }
  end
  last_result = Result.where(assessment_id: r.assessment_id, student_id: r.student_id).where.not(id: r.id).where("test_date < ? ", r.test_date).order(:test_week).last
  trend = last_result.nil? ? 0: (last_result.views['V1'] <= p_sum ? 1: -1)

  lg = ((p_sum.to_f/ (p_sum.to_f+n_sum.to_f))* 100).round(2).to_s
  ri = p_sum.to_s + " von 66"
  ada = "\u003cstrong\u003eAnzahl richtig gelöster Items:\u003c/strong\u003e " + ada_positve.to_s + "\u003chr style=\"margin-top:0; margin-bottom:0\"/\u003e" + ada_correct_items + "\u003cbr/\u003e\u003cbr/\u003e\u003cstrong\u003eAnzahl falsch gelöster Items:\u003c/strong\u003e " + ada_negative.to_s + "\u003chr style=\"margin-top:0; margin-bottom:0\"/\u003e"+ ada_false_items
  avp = "\u003cstrong\u003eAnzahl richtig gelöster Items:\u003c/strong\u003e " + avp_positve.to_s+ "\u003chr style=\"margin-top:0; margin-bottom:0\"/\u003e" + avp_correct_items+ "\u003cbr/\u003e\u003cbr/\u003e\u003cstrong\u003eAnzahl falsch gelöster Items:\u003c/strong\u003e " +avp_negative.to_s + "\u003chr style=\"margin-top:0; margin-bottom:0\"/\u003e" + avp_false_items

  r.report = {
      "trend":trend,
      "negative":negative,
      "positive": positive
  }
  r.data = data
  v1  = p_sum
  v2 = {
      "LG": lg,
      "RI": ri,
      "ADA": ada,
      "AVP": avp,
      "LGM": r.views["V2"]["LGM"]

  }
  v3 = {
      "LG": lg,
      "RI": ri,
      "ADA": ada,
      "AVP": avp,
      "LGM": r.views["V2"]["LGM"],
      "SUM": p_sum
  }
  views = {
      "V1": v1,
      "V2": v2,
      "V3": v3
  }
  r.views = views
  r.save
end

#Lösung für SEL4
t = Test.find_by shorthand: "SEL4"
assessments = Assessment.where(test_id: t.id)
results = Result.where(assessment_id: assessments.ids).where('test_date > 2019-09-10').order(:test_date)
items_sel4 = {"I1"=> { "group"=> "2", "correct_answer"=> "backt"},
              "I2"=> { "group"=> "1", "correct_answer"=> "Schere"},
              "I3"=> { "group"=> "3", "correct_answer"=> "Während"},
              "I4"=> { "group"=> "1", "correct_answer"=> "Büro"},
              "I5"=> { "group"=> "2", "correct_answer"=> "spitz"},
              "I6"=> { "group"=> "3", "correct_answer"=> "weil"},
              "I7"=> { "group"=> "1", "correct_answer"=> "Bilder"},
              "I8"=> { "group"=> "2", "correct_answer"=> "böse"},
              "I9"=> { "group"=> "3", "correct_answer"=> "bevor"},
              "I10"=> { "group"=> "3", "correct_answer"=> "mit"},
              "I11"=> { "group"=> "2", "correct_answer"=> "dicke"},
              "I12"=> { "group"=> "2", "correct_answer"=> "runde"},
              "I13"=> { "group"=> "1", "correct_answer"=> "Blumen"},
              "I14"=> { "group"=> "2", "correct_answer"=> "spricht"},
              "I15"=> { "group"=> "3", "correct_answer"=> "Durch"},
              "I16"=> { "group"=> "1", "correct_answer"=> "Tür"},
              "I17"=> { "group"=> "3", "correct_answer"=> "Anstatt"},
              "I18"=> { "group"=> "2", "correct_answer"=> "kauft"},
              "I19"=> { "group"=> "1", "correct_answer"=> "Vogel"},
              "I20"=> { "group"=> "2", "correct_answer"=> "scheint"},
              "I21"=> { "group"=> "3", "correct_answer"=> "für"},
              "I22"=> { "group"=> "1", "correct_answer"=> "Baby"},
              "I23"=> { "group"=> "2", "correct_answer"=> "hungrig"},
              "I24"=> { "group"=> "3", "correct_answer"=> "weder"},
              "I25"=> { "group"=> "3", "correct_answer"=> "aber"},
              "I26"=> { "group"=> "2", "correct_answer"=> "schmeckt"},
              "I27"=> { "group"=> "1", "correct_answer"=> "Augen"},
              "I28"=> { "group"=> "1", "correct_answer"=> "Wasser"},
              "I29"=> { "group"=> "3", "correct_answer"=> "Nachdem"},
              "I30"=> { "group"=> "2", "correct_answer"=> "lustigen"},
              "I31"=> { "group"=> "2", "correct_answer"=> "schnelle"},
              "I32"=> { "group"=> "1", "correct_answer"=> "Schuhe"},
              "I33"=> { "group"=> "3", "correct_answer"=> "Auf"},
              "I34"=> { "group"=> "2", "correct_answer"=> "neues"},
              "I35"=> { "group"=> "1", "correct_answer"=> "Bett"},
              "I36"=> { "group"=> "3", "correct_answer"=> "außer"},
              "I37"=> { "group"=> "2", "correct_answer"=> "wohne"},
              "I38"=> { "group"=> "1", "correct_answer"=> "Haus"},
              "I39"=> { "group"=> "3", "correct_answer"=> "von"},
              "I40"=> { "group"=> "2", "correct_answer"=> "isst"},
              "I41"=> { "group"=> "3", "correct_answer"=> "über"},
              "I42"=> { "group"=> "1", "correct_answer"=> "Beine"},
              "I43"=> { "group"=> "1", "correct_answer"=> "Freunde"},
              "I44"=> { "group"=> "1", "correct_answer"=> "Biene"},
              "I45"=> { "group"=> "2", "correct_answer"=> "schläft"},
              "I46"=> { "group"=> "2", "correct_answer"=> "süß"},
              "I47"=> { "group"=> "3", "correct_answer"=> "wegen"},
              "I48"=> { "group"=> "1", "correct_answer"=> "Sonne"},
              "I49"=> { "group"=> "1", "correct_answer"=> "Hase"},
              "I50"=> { "group"=> "2", "correct_answer"=> "gut"},
              "I51"=> { "group"=> "3", "correct_answer"=> "Zwischen"},
              "I52"=> { "group"=> "1", "correct_answer"=> "Frösche"},
              "I53"=> { "group"=> "2", "correct_answer"=> "wartest"},
              "I54"=> { "group"=> "3", "correct_answer"=> "Wenn"},
              "I55"=> { "group"=> "2", "correct_answer"=> "sammeln"},
              "I56"=> { "group"=> "3", "correct_answer"=> "Sobald"},
              "I57"=> { "group"=> "1", "correct_answer"=> "Enten"},
              "I58"=> { "group"=> "2", "correct_answer"=> "fleißig"},
              "I59"=> { "group"=> "1", "correct_answer"=> "Schwester"},
              "I60"=> { "group"=> "3", "correct_answer"=> "unter"},
}
results.each do |r|
  negative = []
  positive = []
  data = []
  p_sum = 0
  n_sum = 0
  ada_correct_items = ""
  ada_false_items = ""
  ada_positve = 0
  ada_negative = 0

  avp_correct_items = ""
  avp_false_items = ""
  avp_positve = 0
  avp_negative = 0

  avk_correct_items = ""
  avk_false_items = ""
  avk_positve = 0
  avk_negative = 0


  r.data.each do |d|
    result = 0
    item = items_sel4[d["item"]]
    if item["group"] == "1"
      if d["answer"].gsub(/\u00AD/, '') == item["correct_answer"]
        p_sum += 1
        result = 1
        positive += [d["item"]]
        ada_positve += 1
        if ada_correct_items == ""
          ada_correct_items += item["correct_answer"]
        else
          ada_correct_items += ", " +item["correct_answer"]
        end
      elsif d["answer"].gsub(/\u00AD/, '') != "NA"
        n_sum += 1
        ada_negative += 1
        negative += [d["item"]]
        if ada_false_items == ""
          ada_false_items += item["correct_answer"]
        else
          ada_false_items += ", " + item["correct_answer"]
        end
      else
        result = "NA"
      end
    elsif item["group"] == "2"
      if d["answer"].gsub(/\u00AD/, '') == item["correct_answer"]
        p_sum += 1
        avp_positve += 1
        result = 1
        positive += [d["item"]]
        if avp_correct_items == ""
          avp_correct_items += item["correct_answer"]
        else
          avp_correct_items += ", " +item["correct_answer"]
        end
      elsif d["answer"].gsub(/\u00AD/, '') != "NA"
        avp_negative += 1
        n_sum += 1
        negative += [d["item"]]
        if avp_false_items == ""
          avp_false_items += item["correct_answer"]
        else
          avp_false_items += ", " + item["correct_answer"]
        end
      else
        result = "NA"
      end
    elsif d["answer"].gsub(/\u00AD/, '') != "NA"
      if d["answer"].gsub(/\u00AD/, '') == item["correct_answer"]
        p_sum += 1
        avk_positve += 1
        result = 1
        positive += [d["item"]]
        if avk_correct_items == ""
          avk_correct_items += item["correct_answer"]
        else
          avk_correct_items += ", " +item["correct_answer"]
        end
      elsif d["answer"].gsub(/\u00AD/, '') != "NA"
        avk_negative += 1
        n_sum += 1
        negative += [d["item"]]
        if avk_false_items == ""
          avk_false_items += item["correct_answer"]
        else
          avk_false_items += ", " + item["correct_answer"]
        end
      else
        result = "NA"
      end
    else
      result = "NA"
    end
    data += [{"item": d["item"], "result": result, "group": item["group"], "description": item["correct_answer"], "answer": d["answer"].gsub(/\u00AD/, ''), "time": d["time"] }]
  end
  if r.data[0]["time"] != "NA" && r.id > 611 && r.id < 14204 && r.data[0]["time"] > 300000
    data[0] = {"item": data[0][:item], "result": data[0][:result], "group": data[0][:group], "description": data[0][:description], "answer": data[0][:answer], "time": "NA"}
  end
  last_result = Result.where(assessment_id: r.assessment_id, student_id: r.student_id).where.not(id: r.id).where("test_date < ? ", r.test_date).order(:test_week).last
  trend = last_result.nil? ? 0: (last_result.views['V1'] <= p_sum ? 1: -1)

  lg = ((p_sum.to_f/ (p_sum.to_f+n_sum.to_f))* 100).round(2).to_s
  ri = p_sum.to_s + " von 66"
  ada = "\u003cstrong\u003eAnzahl richtig gelöster Items:\u003c/strong\u003e " + ada_positve.to_s + "\u003chr style=\"margin-top:0; margin-bottom:0\"/\u003e" + ada_correct_items + "\u003cbr/\u003e\u003cbr/\u003e\u003cstrong\u003eAnzahl falsch gelöster Items:\u003c/strong\u003e " + ada_negative.to_s + "\u003chr style=\"margin-top:0; margin-bottom:0\"/\u003e"+ ada_false_items
  avp = "\u003cstrong\u003eAnzahl richtig gelöster Items:\u003c/strong\u003e " + avp_positve.to_s+ "\u003chr style=\"margin-top:0; margin-bottom:0\"/\u003e" + avp_correct_items+ "\u003cbr/\u003e\u003cbr/\u003e\u003cstrong\u003eAnzahl falsch gelöster Items:\u003c/strong\u003e " +avp_negative.to_s + "\u003chr style=\"margin-top:0; margin-bottom:0\"/\u003e" + avp_false_items
  avk = "\u003cstrong\u003eAnzahl richtig gelöster Items:\u003c/strong\u003e " + avk_positve.to_s+ "\u003chr style=\"margin-top:0; margin-bottom:0\"/\u003e" + avk_correct_items+ "\u003cbr/\u003e\u003cbr/\u003e\u003cstrong\u003eAnzahl falsch gelöster Items:\u003c/strong\u003e " +avk_negative.to_s + "\u003chr style=\"margin-top:0; margin-bottom:0\"/\u003e" + avk_false_items

  r.report = {
      "trend":trend,
      "negative":negative,
      "positive": positive
  }
  r.data = data
  v1  = p_sum
  v2 = {
      "LG": lg,
      "RI": ri,
      "ADA": ada,
      "AVP": avp,
      "AVK": avk,
      "LGM": r.views["V2"]["LGM"]

  }
  v3 = {
      "LG": lg,
      "RI": ri,
      "ADA": ada,
      "AVP": avp,
      "AVK": avk,
      "LGM": r.views["V2"]["LGM"],
      "SUM": p_sum
  }
  views = {
      "V1": v1,
      "V2": v2,
      "V3": v3
  }
  r.views = views
  r.save
end

#Lösung für SEL6
t = Test.find_by shorthand: "SEL6"
assessments = Assessment.where(test_id: t.id)
results = Result.where(assessment_id: assessments.ids).where('test_date > 2019-09-08').order(:test_date)
items_sel6 = {"I1"=> { "group"=> "2", "correct_answer"=> "streiten"},
              "I2"=> { "group"=> "1", "correct_answer"=> "verschwundenen"},
              "I3"=> { "group"=> "3", "correct_answer"=> "Trick"},
              "I4"=> { "group"=> "1", "correct_answer"=> "gefährliche"},
              "I5"=> { "group"=> "2", "correct_answer"=> "Sie"},
              "I6"=> { "group"=> "3", "correct_answer"=> "Klassenzimmer"},
              "I7"=> { "group"=> "3", "correct_answer"=> "jubeln"},
              "I8"=> { "group"=> "2", "correct_answer"=> "ihr"},
              "I9"=> { "group"=> "1", "correct_answer"=> "nicht"},
              "I10"=> { "group"=> "2", "correct_answer"=> "Ihn"},
              "I11"=> { "group"=> "3", "correct_answer"=> "Wiese"},
              "I12"=> { "group"=> "1", "correct_answer"=> "einladen"},
              "I13"=> { "group"=> "3", "correct_answer"=> "sauer"},
              "I14"=> { "group"=> "2", "correct_answer"=> "Leinwand"},
              "I15"=> { "group"=> "3", "correct_answer"=> "Sekunden"},
              "I16"=> { "group"=> "2", "correct_answer"=> "Gebäude"},
              "I17"=> { "group"=> "1", "correct_answer"=> "nichts"},
              "I18"=> { "group"=> "1", "correct_answer"=> "besucht"},
              "I19"=> { "group"=> "2", "correct_answer"=> "Pflanzen"},
              "I20"=> { "group"=> "3", "correct_answer"=> "Bürotür"},
              "I21"=> { "group"=> "3", "correct_answer"=> "Anlegeplätze"},
              "I22"=> { "group"=> "2", "correct_answer"=> "du"},
              "I23"=> { "group"=> "1", "correct_answer"=> "viel"},
              "I24"=> { "group"=> "1", "correct_answer"=> "läuft"},
              "I25"=> { "group"=> "2", "correct_answer"=> "Lebensmittel"},
              "I26"=> { "group"=> "3", "correct_answer"=> "tanken"},
              "I27"=> { "group"=> "2", "correct_answer"=> "Geld"},
              "I28"=> { "group"=> "1", "correct_answer"=> "nie"},
              "I29"=> { "group"=> "3", "correct_answer"=> "Morgen"},
              "I30"=> { "group"=> "2", "correct_answer"=> "Wir"},
              "I31"=> { "group"=> "3", "correct_answer"=> "fährt"},
              "I32"=> { "group"=> "1", "correct_answer"=> "wenig"},
              "I33"=> { "group"=> "1", "correct_answer"=> "verpassen"},
              "I34"=> { "group"=> "3", "correct_answer"=> "rief"},
              "I35"=> { "group"=> "2", "correct_answer"=> "Bild"},
              "I36"=> { "group"=> "3", "correct_answer"=> "Spielplatz"},
              "I37"=> { "group"=> "2", "correct_answer"=> "Diese"},
              "I38"=> { "group"=> "1", "correct_answer"=> "hochwertig"},
              "I39"=> { "group"=> "1", "correct_answer"=> "sehr"},
              "I40"=> { "group"=> "3", "correct_answer"=> "bezahlt"},
              "I41"=> { "group"=> "2", "correct_answer"=> "sie"},
              "I42"=> { "group"=> "2", "correct_answer"=> "Weg"},
              "I43"=> { "group"=> "1", "correct_answer"=> "spielen"},
              "I44"=> { "group"=> "3", "correct_answer"=> "Schreibtisch"},
              "I45"=> { "group"=> "1", "correct_answer"=> "gute"},
              "I46"=> { "group"=> "2", "correct_answer"=> "Arzt"},
              "I47"=> { "group"=> "3", "correct_answer"=> "Monate"},
              "I48"=> { "group"=> "1", "correct_answer"=> "niemals"},
              "I49"=> { "group"=> "2", "correct_answer"=> "feiern"},
              "I50"=> { "group"=> "3", "correct_answer"=> "bald"},
              "I51"=> { "group"=> "3", "correct_answer"=> "Tagen"},
              "I52"=> { "group"=> "2", "correct_answer"=> "Es"},
              "I53"=> { "group"=> "1", "correct_answer"=> "berühmt"},
              "I54"=> { "group"=> "1", "correct_answer"=> "rutschen"},
              "I55"=> { "group"=> "3", "correct_answer"=> "heutzutage"},
              "I56"=> { "group"=> "2", "correct_answer"=> "sie"},
              "I57"=> { "group"=> "2", "correct_answer"=> "Uns"},
              "I58"=> { "group"=> "1", "correct_answer"=> "reichlich"},
              "I59"=> { "group"=> "3", "correct_answer"=> "Jahr"},
              "I60"=> { "group"=> "2", "correct_answer"=> "ihr"},
              "I61"=> { "group"=> "3", "correct_answer"=> "draußen"},
              "I62"=> { "group"=> "1", "correct_answer"=> "liebt"},
              "I63"=> { "group"=> "2", "correct_answer"=> "dieser"},
              "I64"=> { "group"=> "1", "correct_answer"=> "Sonnenuntergänge"},
              "I65"=> { "group"=> "3", "correct_answer"=> "verpasse"},
              "I66"=> { "group"=> "2", "correct_answer"=> "Es"},
              "I67"=> { "group"=> "1", "correct_answer"=> "nicht"},
              "I68"=> { "group"=> "3", "correct_answer"=> "Ständen"},
              "I69"=> { "group"=> "3", "correct_answer"=> "Damals"},
              "I70"=> { "group"=> "1", "correct_answer"=> "etwas"},
              "I71"=> { "group"=> "2", "correct_answer"=> "Bibliothek"},
              "I72"=> { "group"=> "1", "correct_answer"=> "verbogen"},
              "I73"=> { "group"=> "2", "correct_answer"=> "klatschen"},
              "I74"=> { "group"=> "3", "correct_answer"=> "schließen"},
              "I75"=> { "group"=> "2", "correct_answer"=> "ihnen"},
              "I76"=> { "group"=> "1", "correct_answer"=> "ausleihe"},
              "I77"=> { "group"=> "3", "correct_answer"=> "Winter"},
              "I78"=> { "group"=> "2", "correct_answer"=> "Pflegerinnen"},
              "I79"=> { "group"=> "1", "correct_answer"=> "verdienen"},
              "I80"=> { "group"=> "3", "correct_answer"=> "kaut"},
              "I81"=> { "group"=> "2", "correct_answer"=> "Ordnungshüter"},
              "I82"=> { "group"=> "3", "correct_answer"=> "Minuten"},
              "I83"=> { "group"=> "1", "correct_answer"=> "verbessert"},
              "I84"=> { "group"=> "2", "correct_answer"=> "ihnen"},
              "I85"=> { "group"=> "2", "correct_answer"=> "Auto"},
              "I86"=> { "group"=> "2", "correct_answer"=> "schließen"},
              "I87"=> { "group"=> "2", "correct_answer"=> "verstummen"},
              "I88"=> { "group"=> "2", "correct_answer"=> "Ozean"},
              "I89"=> { "group"=> "2", "correct_answer"=> "heften"},
              "I90"=> { "group"=> "2", "correct_answer"=> "Dame"},
              "I91"=> { "group"=> "2", "correct_answer"=> "Schwimmen"},
              "I92"=> { "group"=> "2", "correct_answer"=> "euch"},
              "I93"=> { "group"=> "2", "correct_answer"=> "Dieser"},
}
results.each do |r|
  negative = []
  positive = []
  data = []
  p_sum = 0
  n_sum = 0
  comp_correct_items = ""
  comp_false_items = ""
  comp_positve = 0
  comp_negative = 0

  inf_correct_items = ""
  inf_false_items = ""
  inf_positve = 0
  inf_negative = 0

  koh_correct_items = ""
  koh_false_items = ""
  koh_positve = 0
  koh_negative = 0

  r.data.each do |d|
    result = 0
    item = items_sel6[d["item"]]
    if item["group"] == "1"
      if d["answer"].gsub(/\u00AD/, '') == item["correct_answer"]
        p_sum += 1
        result = 1
        positive += [d["item"]]
        comp_positve += 1
        if comp_correct_items == ""
          comp_correct_items += item["correct_answer"]
        else
          comp_correct_items += ", " +item["correct_answer"]
        end
      elsif d["answer"].gsub(/\u00AD/, '') != "NA"
        n_sum += 1
        comp_negative += 1
        negative += [d["item"]]
        if comp_false_items == ""
          comp_false_items += item["correct_answer"]
        else
          comp_false_items += ", " + item["correct_answer"]
        end
      else
        result = "NA"
      end
    elsif item["group"] == "2"
      if d["answer"].gsub(/\u00AD/, '') == item["correct_answer"]
        p_sum += 1
        inf_positve += 1
        result = 1
        positive += [d["item"]]
        if inf_correct_items == ""
          inf_correct_items += item["correct_answer"]
        else
          inf_correct_items += ", " +item["correct_answer"]
        end
      elsif d["answer"].gsub(/\u00AD/, '') != "NA"
        inf_negative += 1
        n_sum += 1
        negative += [d["item"]]
        if inf_false_items == ""
          inf_false_items += item["correct_answer"]
        else
          inf_false_items += ", " + item["correct_answer"]
        end
      else
        result = "NA"
      end
    elsif d["answer"].gsub(/\u00AD/, '') != "NA"
      if d["answer"].gsub(/\u00AD/, '') == item["correct_answer"]
        p_sum += 1
        koh_positve += 1
        result = 1
        positive += [d["item"]]
        if koh_correct_items == ""
          koh_correct_items += item["correct_answer"]
        else
          koh_correct_items += ", " +item["correct_answer"]
        end
      elsif d["answer"].gsub(/\u00AD/, '') != "NA"
        koh_negative += 1
        n_sum += 1
        negative += [d["item"]]
        if koh_false_items == ""
          koh_false_items += item["correct_answer"]
        else
          koh_false_items += ", " + item["correct_answer"]
        end
      else
        result = "NA"
      end
    else
      result = "NA"
    end
    data += [{"item": d["item"], "result": result, "group": item["group"], "description": item["correct_answer"], "answer": d["answer"].gsub(/\u00AD/, ''), "time": d["time"] }]
  end
  if  r.data[0]["time"] != "NA" && r.id > 257 && r.id < 14324 && r.data[0]["time"] > 300000
    data[0] = {"item": data[0][:item], "result": data[0][:result], "group": data[0][:group], "description": data[0][:description], "answer": data[0][:answer], "time": "NA"}
  end
  last_result = Result.where(assessment_id: r.assessment_id, student_id: r.student_id).where.not(id: r.id).where("test_date < ? ", r.test_date).order(:test_week).last
  trend = last_result.nil? ? 0: (last_result.views['V1'] <= p_sum ? 1: -1)

  lg = ((p_sum.to_f/ (p_sum.to_f+n_sum.to_f))* 100).round(2).to_s
  ri = p_sum.to_s + " von 93"
  comp = "\u003cstrong\u003eAnzahl richtig gelöster Items:\u003c/strong\u003e " + comp_positve.to_s + "\u003chr style=\"margin-top:0; margin-bottom:0\"/\u003e" + comp_correct_items + "\u003cbr/\u003e\u003cbr/\u003e\u003cstrong\u003eAnzahl falsch gelöster Items:\u003c/strong\u003e " + comp_negative.to_s + "\u003chr style=\"margin-top:0; margin-bottom:0\"/\u003e"+ comp_false_items
  inf = "\u003cstrong\u003eAnzahl richtig gelöster Items:\u003c/strong\u003e " + inf_positve.to_s+ "\u003chr style=\"margin-top:0; margin-bottom:0\"/\u003e" + inf_correct_items+ "\u003cbr/\u003e\u003cbr/\u003e\u003cstrong\u003eAnzahl falsch gelöster Items:\u003c/strong\u003e " + inf_negative.to_s + "\u003chr style=\"margin-top:0; margin-bottom:0\"/\u003e" + inf_false_items
  koh = "\u003cstrong\u003eAnzahl richtig gelöster Items:\u003c/strong\u003e " + koh_positve.to_s+ "\u003chr style=\"margin-top:0; margin-bottom:0\"/\u003e" + koh_correct_items+ "\u003cbr/\u003e\u003cbr/\u003e\u003cstrong\u003eAnzahl falsch gelöster Items:\u003c/strong\u003e " + koh_negative.to_s + "\u003chr style=\"margin-top:0; margin-bottom:0\"/\u003e" + koh_false_items

  r.report = {
      "trend":trend,
      "negative":negative,
      "positive": positive
  }
  r.data = data
  v1  = p_sum
  v2 = {
      "LG": lg,
      "RI": ri,
      "KOMS": comp,
      "INF": inf,
      "KO": koh,
      "LGM": r.views["V2"]["LGM"]

  }
  v3 = {
      "LG": lg,
      "RI": ri,
      "KOMS": comp,
      "INF": inf,
      "KO": koh,
      "LGM": r.views["V2"]["LGM"],
      "SUM": p_sum
  }
  views = {
      "V1": v1,
      "V2": v2,
      "V3": v3
  }
  r.views = views
  r.save
end

#Lösung falsch abgegebene Results, Key TS0, Zeit ARTH, Zeit erstes Item ZR, ZS1/2, ZZ1/2 jetzt ZZ0/1
results_removed = 0
results_to_remove = []
Result.where('test_date > 2019-09-07').each do |r|
  begin
    if r.views["V1"].include?("NA")
      if r.data.size > Test.find(Assessment.find(r.assessment_id).test_id).items.size
        results_to_remove += [r.id]
        results_removed += 1
        return
      end
    end
  rescue
  end
  if r.assessment.test.shorthand == "TS0" && r.views.has_key?("Übersicht")
    r.views = {'V1': r.views['Übersicht']}
  elsif r.assessment.test.shorthand == "ARTH" && r.id > 755 && r.id < 14353
    newData = []
    r.data.each_with_index do |d, i|
      if i == 0
        newData += [{"item": d["item"], "time": 'NA', "group": d["group"], "answer": d["answer"], "result": d["result"], "description": d["description"]}]
      elsif d['time']!= 'NA' && d['time'] > 300000
        newData += [{"item": d["item"], "time": (d["time"] - r.data[i-1]["time"]), "group": d["group"], "answer": d["answer"], "result": d["result"], "description": d["description"]}]
      else
        newData += [d]
      end
    end
    r.data = newData
    r.save
  elsif (r.assessment.test.shorthand == "ZR" && r.id > 2162 && r.id < 14135) || (r.assessment.test.shorthand == "ZS1" && r.id > 13 && r.id < 14113) ||
      (r.assessment.test.shorthand == "ZS2" && r.id > 14 && r.id < 14114) || (r.assessment.test.shorthand == "ZZ0" && r.id > 17 && r.id < 14115) ||
      (r.assessment.test.shorthand == "ZZ1" && r.id > 8172 && r.id < 14116)
    r.data[0] = {"item": r.data[0]["item"], "time": 'NA', "group": r.data[0]["group"], "answer": r.data[0]["answer"], "result": r.data[0]["result"], "description": r.data[0]["description"]}
  end
  r.save
end
p "Anzahl defekter Results " + results_removed.to_s
p "IDs der defekten Results " + results_to_remove.to_s

#Lösung für Lehrerübung
t = Test.where("shorthand= 'BPL3a2' OR shorthand= 'BPL3a1' OR shorthand= 'BPL3b1' OR shorthand= 'BPL3b2'")
assessments = Assessment.where(test_id: t.ids)
results = Result.where(assessment_id: assessments.ids).where('test_date < "2019-11-28"').order(:test_date)
results.each do |r|
  rbc_ml = ""
  rbc_ol = ""
  fbc_ml = ""
  fbc_ol = ""
  r.data.each do |d|
    if d["group"] == 1
      if d["result"] == 1
        if rbc_ol == ""
          rbc_ol = d["description"]
        else
          rbc_ol += ", " + d["description"]
        end
      else
        if fbc_ol == ""
          fbc_ol = d["description"]
        else
          fbc_ol += ", " + d["description"]
        end
      end
    elsif d["group"] == 0
      if d["result"] == 1
        if rbc_ml == ""
          rbc_ml = d["description"]
        else
          rbc_ml += ", " + d["description"]
        end
      else
        if fbc_ml == ""
          fbc_ml = d["description"]
        else
          fbc_ml += ", " + d["description"]
        end
      end
    end
  end

  fbc = "\u003ctable class=\"table table-bordered\" style=\"margin-bottom: 0\"\u003e\u003cthead\u003e\u003ctr style=\"background-color: rgba(0,0,0,0)\"\u003e\u003cth scope=\"col\" style=\"border: 1px solid #dee2e6;text-align: center\"\u003eItems mit Lesefehler\u003c/th\u003e\u003cth scope=\"col\" style=\"border: 1px solid #dee2e6;text-align: center\"\u003eItems ohne Lesefehler\u003c/th\u003e\u003c/tr\u003e\u003c/thead\u003e\u003ctbody\u003e\u003ctd style=\"border: 1px solid #dee2e6;text-align: center\"\u003e" + fbc_ml + "\u003c/td\u003e\u003ctd style=\"border: 1px solid #dee2e6;text-align: center\"\u003e" + fbc_ol + "\u003c/td\u003e\u003c/tbody\u003e\u003c/table\u003e"
  rbc = "\u003ctable class=\"table table-bordered\" style=\"margin-bottom: 0\"\u003e\u003cthead\u003e\u003ctr style=\"background-color: rgba(0,0,0,0)\"\u003e\u003cth scope=\"col\" style=\"border: 1px solid #dee2e6;text-align: center\"\u003eItems mit Lesefehler\u003c/th\u003e\u003cth scope=\"col\" style=\"border: 1px solid #dee2e6;text-align: center\"\u003eItems ohne Lesefehler\u003c/th\u003e\u003c/tr\u003e\u003c/thead\u003e\u003ctbody\u003e\u003ctd style=\"border: 1px solid #dee2e6;text-align: center\"\u003e" + rbc_ml + "\u003c/td\u003e\u003ctd style=\"border: 1px solid #dee2e6;text-align: center\"\u003e" + rbc_ol + "\u003c/td\u003e\u003c/tbody\u003e\u003c/table\u003e"

  v1  = r.views['V1']
  v2 = {
      "PW": r.views['V2']['PW'],
      "FBC": fbc,
      "RBC": rbc

  }
  v3 = {
      "PW": r.views['V3']['PW'],
      "RB": r.views['V3']['RB'],
      "FBC": fbc,
      "FBL": r.views['V3']['FBL'],
      "RBC": rbc,
      "FBOL": r.views['V3']['FBOL']
  }
  views = {
      "V1": v1,
      "V2": v2,
      "V3": v3
  }
  r.views = views
  r.save
end


#Falsch exportierte Results ehemals "Position finden" löschen
t = Test.where("shorthand= 'ZS1' OR shorthand= 'ZS2'")
assessments = Assessment.where(test_id: t.ids)
results = Result.where(assessment_id: assessments.ids).where('test_date < "2019-09-08"')
results.each do |r|
  a = r.assessment
  r.destroy
  if a.results == []
    a.destroy
  end
end



=begin Wenn die defekten Results wirklich gelöscht werden sollen.

results_removed = 0
results_to_remove = []
Result.where('test_date > 2019-09-07').each do |r|
  begin
    if r.views["V1"].include?("NA")
      if r.data.size > Test.find(Assessment.find(r.assessment_id).test_id).items.size
        r.destroy
        results_to_remove += [r.id]
        results_removed += 1
        return
      end
    end
  rescue
  end
end
p "Anzahl defekter Results " + results_removed.to_s
p "IDs der defekten Results " + results_to_remove.to_s
=end