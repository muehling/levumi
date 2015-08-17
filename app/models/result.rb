class Result < ActiveRecord::Base
  belongs_to :student
  belongs_to :measurement
  serialize :results, Hash

  def parse_csv(data)
    vals = data.split(',')
    len = measurement.assessment.test.len
    if vals.size == len
      sum = 0.0
      items = results.keys
      v = 0
      items.sort.each do |i|
      if vals[v] == "1"
        sum = sum + 1.0
        results[i] = 1
      else
        results[i] = 0
      end
      v = v + 1
      end
      self.total = sum / len
      save      
    end
  end

  def to_csv()
    res = ""
    results.keys.sort.each do |i|
      res = res + results[i].to_s + ","
    end
    return res.chop
  end

end
