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
        data += [value] if !value.nil? # might be the case for some tests
      end
    end
    data
  end

  def self.calculate_quartiles(test_id)
    test = Test.find(test_id)
    assessment_ids = test.assessments.pluck(:id)

    start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    Rails.logger.info "Get quartiles for #{test.shorthand}/#{test.version}"
    previous_results =
      Rails
        .cache
        .fetch("#{test.shorthand}/#{test.version}_numeric_results", expires_in: 2.years) do
          results = Result.where(assessment_id: assessment_ids)
          data = self.get_numeric_view_data(results)
          { values: data, timestamp: Time.now }
        end

    after_cache = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    Rails
      .logger.info "Read from cache #{after_cache - start_time}, number of read results #{previous_results[:values].count}"

    results =
      Result
        .where(assessment_id: assessment_ids)
        .where('created_at > ?', previous_results[:timestamp])

    after_db = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    Rails
      .logger.info "Read from DB #{after_db - after_cache}, number of read results #{results.count}"

    data = self.get_numeric_view_data(results) + previous_results[:values]

    return { q1: 0, q3: 0, count: 0 } if data.count < 100

    after_view = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    Rails.logger.info "Get numeric view #{after_view - after_db}"

    sorted_data = data.sort

    after_sort = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    Rails.logger.info "Sort #{after_sort - after_view}"

    Rails.cache.write(
      "#{test.shorthand}/#{test.version}_numeric_results",
      { values: data, timestamp: Time.now },
      expires_in: 2.years
    )
    return { q1: 0, q3: 0, count: 0 } if data.count == 0

    sorted_data = data.sort

    n = sorted_data.size
    mid = n / 2

    lower_half = sorted_data[0...mid]
    upper_half = n.odd? ? sorted_data[mid + 1..] : sorted_data[mid..]

    # Rails.logger.info sorted_data
    # Rails.logger.info lower_half
    # Rails.logger.info upper_half

    q1 = self.median(lower_half)
    q3 = self.median(upper_half)

    end_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    Rails.logger.info "All in all #{end_time - start_time}"

    { q1: q1, q3: q3, count: data.count }
  end
end
