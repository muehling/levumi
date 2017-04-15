# -*- encoding : utf-8 -*-
class TestKeyboard < Test
#Return length of test
  def len_info
    return "#{len} Items"
  end
#Return type info
  def type_info
    return "Tastaturschulung"
  end
#Return which view should be chosen
  def view_info
    return "GenerischNormal"
  end

#draw item from itempool
  def draw_items(ability)
    itemset = Array.new
    (1..len).each  do
      remaining = items - itemset
      itemset = itemset + [remaining.first]
    end
    return itemset.map{|i| i.id}
  end

end
