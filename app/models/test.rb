# -*- encoding : utf-8 -*-
class Test < ActiveRecord::Base
  has_many :items
  has_many :assessments

  def draw_items(ability)
    return items[0..(len-1)].map{|i| i.id}
  end
end
