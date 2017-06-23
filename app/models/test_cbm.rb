class TestCBM < TestSpeed
#TODO-A: Umbenennen

  def draw_items(first)
    if first
      return super
    end
    itemset = Array.new
    introitems = intro_items
    enditems = outro_items

    pools = items.map{|i| i.difficulty}.uniq
    len.times  do
      remaining = items - (itemset + introitems +  enditems)
      i = remaining.sample
      if ((itemset.size) > 0)
        count = 0
        while (count < 500) & ((i.itemtext.first.downcase == itemset.last.itemtext.first.downcase) |
                               (i.itemtext.first + itemset.last.itemtext.first == 'bd') |
                               (i.itemtext.first + itemset.last.itemtext.first == 'db') |
                               ((pools.size > 1) & (i.difficulty == itemset.last.difficulty)))
          i = remaining.sample
          count = count + 1
        end
      end
      itemset = itemset + [i]
    end
    return [introitems.map{|i| i.id}, itemset.map{|i| i.id}, outroitems.map{|i| i.id}]
  end

end
