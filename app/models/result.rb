# -*- encoding : utf-8 -*-
class Result < ActiveRecord::Base
  belongs_to :student
  belongs_to :measurement

  serialize :items, Array
  serialize :responses, Array

  def update_total
    self.total = responses.map{|x| x == nil ? 0:x}.sum.to_f/responses.size
    save
  end

  def initialize_results()
    self.responses = Array.new
    self.items = measurement.assessment.test.draw_items(0)
    self.responses[self.items.size-1] = nil
    update_total
  end

  def parse_csv(data)
    if data.nil?
      self.responses[self.items.size-1] = nil
      return
    else
      vals = data.split(',')
      vals.length.times do |i|
          self.responses[i] =  vals[i] == "1" ? 1 : (vals[i] == "0" ? 0 : nil)
      end
    end
    update_total
  end

  def parse_Hash(hash)
    hash.each do |i, r|
      p = items.index(i.to_i)
      responses[p] = (r == "1" ? 1 : (r == "0" ? 0 : nil)) unless p.nil?
    end
    update_total
  end

  def to_csv(includeNA)
    responses.map{|x| (x == nil && includeNA)  ? 'NA': (x == nil ? 0 : x.to_s) }.join(",")
  end

end
