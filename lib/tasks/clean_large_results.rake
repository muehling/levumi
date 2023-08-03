desc 'Remove users that registered but never became active in the platform.'
task 'clean_large_results' => :environment do
  shorthands = %w[ZL4 ADD3 SUB3 ARTH]

  test_ids = Test.where(shorthand: shorthands).pluck(:id) #Feld answer
  puts 'Tests:'
  puts test_ids.count

  assessment_ids = Assessment.where(test_id: test_ids).pluck(:id)

  puts 'Assessments:'
  puts assessment_ids.count

  results = Result.where(assessment_id: assessment_ids)
  puts 'Results: '
  puts results.count
  counter = 0

  results.each do |result|
    data = result['data']

    if !result['data'].is_a? Array
      false
    else
      filtered = data.reject { |d| d['answer'] == 'NA' }
      if filtered.length < data.length
        #puts "#{result['id']} / #{data.length} / #{filtered.length}"
        if !result.update(data: filtered)
          puts "Result mit ID #{result.id} konnte nicht geändert werden"
        end
      end
    end
  end
end
