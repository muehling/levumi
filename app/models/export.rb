class Export 
	def exportData(assessments, measurements)
		book = Spreadsheet::Workbook.new  
		sheet1 = book.create_worksheet name: 'Items'
	    sheetAlle = book.create_worksheet name: 'Alle Messungen - RZ'         #Without Reaktionszeiten
	    sheetAlleRZ = book.create_worksheet name: 'Alle Messungen + RZ'  #With Reaktionszeiten

	    sheetAlle.row(0).concat Student.xls_headings
	    sheetAlle.row(0).push "Messzeitpunkt"
	    sheetAlleRZ.row(0).concat Student.xls_headings
	    sheetAlleRZ.row(0).push "Messzeitpunkt"
	    sheet1.row(0).concat Item.xls_headings

	    sheets = {} # contains all sheets, e.g. "Lesetest", "Mathetest" and so on.
	    allItems = {} # save item-groups one time to avoid redundancy
	    itemSets = {} # contains test names as keys and 2d-array as a value. Each array contains the items of a level
	    row = 1
	    rowAlle = 1
	    # Get items of each test without redundancy. Needed to put many assessments in one sheet
	    assessments.sort_by { |a| a.created_at}.each do |ass|
	    	test = ass.test
	    	nam = test.name
	    	sheet = nil
	    	if !sheets.key? nam
	    		sheet = book.create_worksheet :name => "#{test.name}"
	    		itemSets[test.name] = []
	    	else 
	    		sheet = sheets[nam]
	    	end

	      	#To avoid the redundancy the items of each test will be saved. The level or test cann't help us, because 
	      	# one level in the same test could have different items-group
	      	if allItems.key?(test.name+" "+test.level)
	      		if !allItems[test.name+" "+test.level].include? [test.items.pluck(:id)]
	      			allItems[test.name+" "+test.level] = allItems[test.name+" "+test.level] << test.items.pluck(:id)
	          		test.items.each do |it| # print items in items-sheet
	          			sheet1.row(row).concat it.to_a
	          			row = row + 1
	          		end
	          	end
	          else
	          	allItems[test.name+" "+test.level] =  [test.items.pluck(:id)]
			        test.items.each do |it| # print items in items-sheet
			        	sheet1.row(row).concat it.to_a
			        	row = row + 1
			        end
			    end

		    # get items(from each level) of each test in a specific order to print the measurements in the right way
		    if !itemSets[test.name].include? [test.items.pluck(:id)]
		    	itemSets[test.name] = itemSets[test.name] << [test.items.pluck(:id)]
		    end
		    sheets[nam] = sheet
		end
		
	    # Print all items at the top of each sheet
	    row = sheet1.last_row_index + 1
	    itemSets.each do |key, value|
	    	sheets[key].row(0).concat Student.xls_headings
	    	sheets[key].row(0).push "Messzeitpunkt"
	    	sheets[key].row(0).push " "
	    	value.each do |arr1|
	    		testname = ""
	    		arr = arr1.flatten
	    		allItems.each do |k,v|
	    			if v.include? arr
	    				testname = k;
	    			end
	    		end 
	    		arr = arr.map{|x| x.to_s.prepend(testToCode(testname))}
	    		sheets[key].row(0).concat arr
	    		sheets[key].row(0).push " "
	    		sheetAlle.row(0).concat arr
	    		sheetAlle.row(0).push " "
	    		sheetAlleRZ.row(0).concat arr
	    		sheetAlleRZ.row(0).push " "
	    	end
	    	row = row + 1
	    end

	    # Print the measurements
	    measurements.sort_by{|a| a.date}.each do |m|
	    	if (m.assessment.group.export and Result.where(:measurement =>m).size > 0)
	    		test = m.assessment.test
	    		sheet = sheets[test.name]
	    		row = sheet.last_row_index + 1
	    		itemset = test.items.pluck(:id)

	        	# Needed just for the sheet 'Alle Messungen'
	        	indexOfArrayAll = itemSets.values.flatten(1).index([itemset])
	        	rightColumnAll = indexOfArrayAll + itemSets.values.flatten(1).first(indexOfArrayAll).flatten.size + Student.xls_headings.length

		        # get the right index to put values under the corresponding column
		        indexOfArray = itemSets[test.name].index([itemset])  # get index of the corresponding items array
		        rightColumn = indexOfArray + itemSets[test.name].first(indexOfArray).flatten.size  # length of all preceeded arrays plus number of blanks between each two sets 
		        m.results.each do |r|
		        	sheet.row(row).concat r.student.to_a
		        	sheet.row(row).push r.measurement.date.to_date.strftime("%d.%m.%Y")
		        	sheet.row(row).push "  "
		        	sheet.row(row)[rightColumn] = " "
		        	sheet.row(row).concat r.to_a(itemset)
		        	row = row +1
		            # Print results in the first sheet 'Alle Messungen'
		            sheetAlle.row(rowAlle).concat r.student.to_a
		            sheetAlle.row(rowAlle).push r.measurement.date.to_date.strftime("%d.%m.%Y")
		            sheetAlle.row(rowAlle)[rightColumnAll] = " "
		            sheetAlle.row(rowAlle).concat r.to_a(itemset).map! { |x| x == '' ? "" : (x.to_i > 0 ? x = 1 : x = 0)}
		            sheetAlleRZ.row(rowAlle).concat r.student.to_a
		            sheetAlleRZ.row(rowAlle).push r.measurement.date.to_date.strftime("%d.%m.%Y")
		            sheetAlleRZ.row(rowAlle)[rightColumnAll] = " "
		            sheetAlleRZ.row(rowAlle).concat r.to_a(itemset)
		            rowAlle = rowAlle + 1
		        end
		    end
		end
		temp = Tempfile.new('levumi')
		temp.close
		book.write temp.path
		return temp.path
	end

  #Get the code of a specific test
  def testToCode (t)
  	testcodes = {
  		"Silben lesen Niveastufe 0" => "SL0_",
  		"Silben lesen Niveastufe 1" => "SL1_",
  		"Silben lesen Niveastufe 2" => "SL2_",
  		"Silben lesen Niveastufe 2a" => "SL2a_",
  		"Silben lesen Niveastufe 2b" => "SL2b_",
  		"Silben lesen Niveastufe 3" => "SL3_",
  		"Silben lesen Niveastufe 4" => "SL4_",
  		"Pseudowörder Lesen Niveaustufe 0" => "PL0_",
  		"Pseudowörder Lesen Niveaustufe 1" => "PL1_",
  		"Pseudowörder Lesen Niveaustufe 2" => "PL2_",
  		"Pseudowörder Lesen Niveaustufe 2a" => "PL2a_",
  		"Pseudowörder Lesen Niveaustufe 2b" => "PL2b_",
  		"Pseudowörder Lesen Niveaustufe 3" => "PL3_",
  		"Pseudowörder Lesen Niveaustufe 3a" => "PL3a_",
  		"Pseudowörder Lesen Niveaustufe 3b" => "PL3b_",
  		"Pseudowörder Lesen Niveaustufe 4" => "PL4_",
  		"Wörter lesen Niveaustufe 1" => "WL1_",
  		"Wörter lesen Niveaustufe 2" => "WL2_",
  		"Wörter lesen Niveaustufe 2a" => "WL2a_",
  		"Wörter lesen Niveaustufe 2b" => "WL2b_",
  		"Wörter lesen Niveaustufe 3" => "WL3_",
  		"Wörter lesen Niveaustufe 4" => "WL4_",
  		"Buchstaben erkennen Niveaustufe 1" => "BE1_",
  		"Buchstaben erkennen Niveaustufe 2" => "BE2_",
  		"Wörter schreiben Kurztest" =>"WSK_",
  		"Wörter schreiben Level 0" =>"WS0_",
  		"Wörter schreiben Level 1" =>"WS1_",
  		"Tastaturschulung Level 0" =>"TS0_",
  		"Sichtwortschatz Niveausstufe 2" => "SW2_",
  		"Sichtwortschatz Niveausstufe 4" => "SW4_",
  		"Zahlenlesen Niveaustufe 1" => "ZL1_",
  		"Zahlenlesen Niveaustufe 2" => "ZL2_",
  		"Zahlenlesen Niveaustufe 3" => "ZL3_",
  		"Zahlenlesen Niveaustufe 4" => "ZL4_",
  		"Lesetest Level 0" => "LT0_",
  		"Lesetest Level 1" => "LT1_",
  		"Mathetest Level 0" => "MT0_",
  		"Sinnentnehmendes Lesen Level 1" => "SEL1_"
  	}
  	return testcodes[t].nil? ? " " : testcodes[t]
  end
end