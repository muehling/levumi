desc 'Checks the name of the first view with a numeric value'
task 'check_numeric_views' => :environment do
  results = Result.all.select(:id, :views, :assessment_id)

  data = {}
  prev_key = ''

  results.each_with_index do |result, index|
    d = result['views']
    key, value = d.find { |k, v| v.is_a?(Numeric) } # get first view with a single numeric value

    # puts key if prev_key != key
    prev_key = key

    prev = data[key]
    data[key] = (prev || 0) + 1
    if key.nil?
      temp = result['views']
      view_names = []
      temp.each { |k, v| view_names = view_names + [k] }

      a = Assessment.find(result[:assessment_id])
      t = Test.find (a.test_id)
    end
  end
end
