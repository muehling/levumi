desc 'Clean "NA" answers from results data'
task 'clean_large_results' => :environment do
  tests = Test.all.select(:id, :shorthand)
  test_count = Test.all.count

  tests.each_with_index do |test, index|
    count = 0
    assessment_ids = Assessment.where(test_id: test.id).pluck(:id)
    results = Result.where(assessment_id: assessment_ids)
    puts "Processing #{test.shorthand} (#{index}/#{test_count}), with #{results.count} results..."

    results.each_with_index do |result, index|
      data = result['data']

      print '.' if index % 100 == 0
      if !result['data'].is_a? Array
        false
      else
        filtered = data.reject { |d| d['answer'] == 'NA' || d['result'] == 'NA' }
        if filtered.length < data.length
          puts "Error updating result #{result.id}" if !result.update(data: filtered)
          count = count + 1
        end
      end
    end
    puts "total count: #{count}"
  end
end
