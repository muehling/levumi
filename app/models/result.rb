# -*- encoding : utf-8 -*-
class Result < ActiveRecord::Base
  belongs_to :student
  belongs_to :measurement

  serialize :items, Array
  serialize :responses, Array

  def update_total
    if count_NA == responses.size
      self.total = 0
    else
      self.total = responses.map{|x| x == nil ? 0:x}.sum.to_f/(responses - [nil]).size
    end
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

  def score
    if responses.include?(1) | responses.include?(0)
      return responses.map{|x| x == nil ? 0:x}.sum
    else
      return nil
    end
  end

  def count_1
    return (responses - [nil, 0]).size
  end

  def count_0
    return (responses - [nil, 1]).size
  end

  def count_NA
    return (responses - [0, 1]).size
  end

  def to_a(itemset)
    res = []
    itemset.each do |i|
      res = res + [responses[items.index(i)].nil? ? '' : responses[items.index(i)]]
    end
    return res
  end

  def getPriorResult()
    measurements = Measurement.where("assessment_id = ? AND created_at < ?", measurement.assessment, measurement.created_at)
    res = Result.where(:measurement => measurements, :student => student).order(created_at: :desc).first
    if res.nil?
      return 0
    else
      t = res.score
      return t.nil? ? 0 : t
    end

  end
end
