module Averages
  def self.create_test_average(test_id)
    test = Test.find(test_id)
    assessment_ids = test.assessments.pluck(:id)
    results = Result.where(assessment_id: assessment_ids)

    count = 0.0
    mean = 0.0
    m2 = 0.0
    delta = 0.0
    delta2 = 0.0

    results.each do |result|
      count += 1
      data = result['views']
      key, new_value = data.find { |k, v| v.is_a?(Numeric) } # get first view with a single numeric value

      if new_value.is_a? Numeric
        delta = new_value - mean
        mean += delta / count
        delta2 = new_value - mean
        m2 += delta * delta2
      end
    end

    { m2: m2, count: count, mean: mean }
  end

  def self.median(array)
    n = array.size
    mid = n / 2
    n.odd? ? array[mid] : (array[mid - 1] + array[mid]) / 2.0
  end

  def self.get_numeric_view_data(results)
    data = []
    if !results.empty?
      r = results[0]
      key, value = r['views'].find { |k, v| v.is_a?(Numeric) }
      results.each do |result|
        v = result['views'][key]
        data += [v] if v.is_a?(Numeric) # might be the case for some tests, e. g. 0 and "NA"
      end
    end
    data
  end

  def self.calculate_quartiles(test_id)
    test = Test.find(test_id)
    assessment_ids = test.assessments.pluck(:id)

    previous_results =
      Rails
        .cache
        .fetch("#{test.shorthand}/#{test.version}_numeric_results", expires_in: 15.years) do
          results = Result.where(assessment_id: assessment_ids)
          data = self.get_numeric_view_data(results)
          { values: data, timestamp: Time.now }
        end

    results =
      Result
        .where(assessment_id: assessment_ids)
        .where('created_at > ?', previous_results[:timestamp])

    data = self.get_numeric_view_data(results) + previous_results[:values]

    return { q1: 0, q3: 0, count: 0 } if data.count < 100

    sorted_data = data.sort

    Rails.cache.write(
      "#{test.shorthand}/#{test.version}_numeric_results",
      { values: data, timestamp: Time.now },
      expires_in: 15.years
    )
    return { q1: 0, q3: 0, count: 0 } if data.count == 0

    sorted_data = data.sort

    n = sorted_data.size
    mid = n / 2

    lower_half = sorted_data[0...mid]
    upper_half = n.odd? ? sorted_data[mid + 1..] : sorted_data[mid..]

    q1 = self.median(lower_half)
    q3 = self.median(upper_half)

    { q1: q1, q3: q3, count: data.count }
  end
end
