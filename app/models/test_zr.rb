class TestZR < Test
	# Für Zahlenreihen-Test
	def draw_items(first)
		itemset = Array.new
		if(first)  # Choose between A and H, also categories 3-10
			categories = content_items.map{|i| i.difficulty}.uniq
			categories = categories - [1]
			categories = categories - [2] # we need just the items of 3-10 categories at the first draw
			random_cat = categories.sample	# Start with a random cat
			categories.length.times do 
				print "first draw items ---------------------------"
				print firstdraw_items.length
				items_of_rand_cat = firstdraw_items.where(difficulty: random_cat)
				itemset = itemset + items_of_rand_cat
				if(random_cat < 7)
					random_cat += 1
				else
					random_cat = 3 # Start with cat 3, also group A
				end
			end
		else # second draw
			categories = [1,2]
			pool = [1,2]
			all_items = seconddraw_items # all items from first and second categories
			remaining = all_items - itemset
			all_items.length.times do
				if (pool.length == 0)
					pool = categories
				end
				i = remaining.sample
				count = 0
				while ( count < 100) & (!pool.include? i.difficulty)
					i = remaining.sample
					count = count + 1 
				end
				pool = pool - [i.difficulty]
				itemset = itemset + [i]
			end

		end		
		return [intro_items.map{|i| i.id}, itemset.map{|i| i.id}, outro_items.map{|i| i.id}]
	end

    def firstdraw_items
      self.items.where("difficulty > ?", 2).order(:id)
    end

    def seconddraw_items 
    	return self.items.where("difficulty <= ?", 2).order(:id)
    end
end