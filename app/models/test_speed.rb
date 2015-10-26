# -*- encoding : utf-8 -*-
class TestSpeed < Test

  def draw_items(ability)
    itemset = Array.new
    (1..len).each  do
      remaining = items - itemset
      i = remaining.sample
      if (itemset.size > 0)
        count = 0
        while (i.itemtext.first.downcase == itemset.last.itemtext.first.downcase) & (count < 100)
          i = remaining.sample
          count = count + 1
        end
      end
      itemset = itemset + [i]
    end
    return itemset.map{|i| i.id}
  end

  def len_info
    return "#{time} Sekunden, max. #{len} Items"
  end

  def type_info
    return "Speed-Test"
  end
end
