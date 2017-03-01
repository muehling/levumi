class TestDictation < Test

  def len_info
    return "#{time} Sekunden, max. #{len} Items"
  end

  def type_info
    return "Diktat"
  end

  def view_info
    return "TestDiktatNormal"
  end

  def draw_items(ability)
    itemset = Array.new
    if(len<10)
      (1..len).each  do
        remaining = items - itemset
        itemset = itemset + [remaining.sample]
      end
      return itemset.map{|i| i.id}
    else
      (1..10).each  do
        remaining = items - itemset
        itemset = itemset + [remaining.sample]
      end
      return itemset.map{|i| i.id}
    end
  end
end
