results = Result.all
results.each do |r|
	if(r.assessment.test.shorthand != 'WS1' && r.assessment.test.shorthand != 'TS0' && r.assessment.test.shorthand != 'FB-PIQ-STU' &&
			r.assessment.test.shorthand != 'FB-PIQ' && r.assessment.test.shorthand != 'FB' && r.assessment.test.shorthand != 'FB2' && r.assessment.test.shorthand != 'BPL3b2' &&
			r.assessment.test.shorthand != 'BPL3b1' && r.assessment.test.shorthand != 'BPL3a2' && r.assessment.test.shorthand != 'BPL3a1')
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
		r.save
	end
end