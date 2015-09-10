# -*- encoding : utf-8 -*-
class Test < ActiveRecord::Base
  has_many :items
  has_many :assessments

  def draw_items(ability)
    itemset = Array.new
    (1..len).each  do
      puts itemset
      puts"---------------------------"
      remaining = items - itemset
      itemset = itemset + [remaining.sample]
    end
    return itemset.map{|i| i.id}
  end

  def len_info
    return "#{len} Items"
  end

  def type_info
    return "Test"
  end

end
