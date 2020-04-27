test_ids = Test.where(shorthand: "FB-PIQ").or(Test.where(shorthand: "FB-PIQ-STU")).ids
results = Result.where(assessment_id: Assessment.where(test_id: test_ids).ids)
results.each do |r|
  tmp_sic = r.views["V2"]["SIC"]
  tmp_si = r.views["V3"]["SI"]

  r.views["V2"]["SIC"] = r.views["V2"]["EIC"].sub! " center\">EI</th></tr>", " center\">SI</th></tr>"
  r.views["V2"]["EIC"] = tmp_sic.sub! " center\">SI</th></tr>", " center\">EI</th></tr>"

  r.views["V3"]["SIC"] = r.views["V2"]["SIC"]
  r.views["V3"]["EIC"] = r.views["V2"]["EIC"]

  r.views["V3"]["SI"] = r.views["V3"]["EI"]
  r.views["V3"]["EI"] = tmp_si

  r.save
end
