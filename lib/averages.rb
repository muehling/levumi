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

  def self.calculate_quartiles(test_id)
    test = Test.find(test_id)
    assessment_ids = test.assessments.pluck(:id)
    results = Result.where(assessment_id: assessment_ids)
    data = []
    results.each do |result|
      d = result['views']
      key, value = d.find { |k, v| v.is_a?(Numeric) } # get first view with a single numeric value
      data += [value] if !value.nil? # might be the case for some tests
    end

    sorted_data = data.sort

    n = sorted_data.size
    mid = n / 2

    lower_half = sorted_data[0...mid]
    upper_half = n.odd? ? sorted_data[mid + 1..] : sorted_data[mid..]

    q1 = self.median(lower_half)
    q3 = self.median(upper_half)

    { q1: q1, q3: q3, count: results.count }
  end
end
