class TestDictation < Test

  def draw_items(first)
    if first
      return super
    end
    itemset = Array.new
    firstthirty = content_items.take(30)
    count = 0
    len.times do
      if(count<30)
        remaining = firstthirty - itemset
        itemset = itemset + [remaining.sample]
        count = count + 1
      else
        remaining = content_items - itemset
        itemset = itemset + [remaining.sample]
      end
    end
    return [intro_items.map{|i| i.id}, itemset.map{|i| i.id}, outro_items.map{|i| i.id}]
  end
end
