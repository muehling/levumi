# -*- encoding : utf-8 -*-
class Test < ActiveRecord::Base
  has_many :items
  has_many :assessments

  def draw_items(ability)
    itemset = Array.new
    (1..len).each  do
      remaining = items - itemset
      itemset = itemset + [remaining.sample]
    end
    return itemset.map{|i| i.id}
  end

end
