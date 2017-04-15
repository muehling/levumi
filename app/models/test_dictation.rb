class TestDictation < Test
#Return lenghth and lead time
  def len_info
    return "#{time} Sekunden, max. #{len} Items"
  end
#Return type info
  def type_info
    return "Diktat"
  end
#Return which view should be chosen
  def view_info
    return "GenerischNormal"
  end
#draw item from itempool
  def draw_items(ability)
    itemset = Array.new
    x=0
    while x<4
      x +=1
      remaining = items - itemset
      itemset = itemset + [remaining.first]
    end
    (5..len).each  do
      remaining = items - itemset
      itemset = itemset + [remaining.sample]
    end
    return itemset.map{|i| i.id}
  end

end
