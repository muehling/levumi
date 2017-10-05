# -*- encoding : utf-8 -*-
class Result < ActiveRecord::Base

  belongs_to :student
  belongs_to :measurement

  serialize :items, Array         #Speichert die IDs der content_items die für diese Messung verwendet werden
  serialize :responses, Array     #Speichert die 1/0 Ergebnisse zu den Items aus items
  serialize :extra_data, Hash     #Speichert zusätzlicher Infos als Key/Value Paare. Feste Keys:
                                  #-times: Reaktionszeiten
                                  #-intro: Intro Items für den Test
                                  #-outro: Outro Items für den Test

  #Calculate new running total of the fraction of correct items. Must be called everytime the responses change.
  #Not used from outside
  def update_total
    if count_NA == responses.size
      self.total = 0
    else
      self.total = responses.map{|x| x == nil ? 0:x}.sum.to_f/(responses - [nil]).size
    end
    save
  end

  #Create an empty set of results, but already draw the items that will be used.
  #Used to initialize a result when first starting a measurement.
  def initialize_results()
    self.responses = Array.new
    self.extra_data = Hash.new
    drawed_items = measurement.assessment.test.draw_items(self.getPriorResult == -1)
    self.extra_data["intro"] = drawed_items[0]
    self.items = drawed_items[1]
    self.extra_data["outro"] = drawed_items[2]
    self.responses[self.items.size-1] = nil
    update_total
  end

  #Parses a String or additional data in the form "a,b,c" where each entry denotes the data for an item. The data is stored under the labels given in "labels" also in the form "x,y,z".
  def parse_data(labels, data)
    labels.length.times do |i|
      vals = data[i].split(',')
      if (labels[i] == "times")
        self.extra_data["times"] = vals.map{|x| x.to_i}
      else
        self.extra_data[labels[i]] = vals   # Problem: Leere Eingaben am Ende führen zu zu kurzem Feld.
      end
    end
    save
  end

  #Parses a string of results in the form "1,0,1,1,..." where each 0/1 denotes the result of an item.
  #Used to crate an update results
  def parse_csv(data)
    if data.nil?
      self.responses[self.items.size-1] = nil
      return
    else
      vals = data.split(',')
      vals.length.times do |i|
          self.responses[i] =  vals[i] == "1" ? 1 : (vals[i] == "0" ? 0 : nil)
      end
    end
    update_total
  end

  #Sets the result from a hash of (k, v) pairs where k denotes an item_id and v the 0/1 result for this item.
  #Used to update results
  def parse_Hash(hash)
    hash.each do |i, r|
      p = items.index(i.to_i)
      responses[p] = (r == "1" ? 1 : (r == "0" ? 0 : nil)) unless p.nil?
    end
    update_total
  end

  #Create a string in the form of "0,1,0,1,..." that denotes the result for each item in the respective order. If includeNA is false, every NA response will be transformed to 0 in the result.
  #Used for exporting the results.
  def to_csv(includeNA)
    responses.map{|x| (x == nil && includeNA)  ? 'NA': (x == nil ? 0 : x.to_s) }.join(",")
  end

  #Create an array representation of the results.
  #TIf extra_data contain "times" then export the times instead of the 1/0 values.
  #Used for exporting to XLS
  def to_a(itemset)
    res = []
    itemset.each do |i|
      val = responses[items.index(i)]
      if extra_data.has_key?('times')
        time = extra_data['times'][items.index(i)].nil? ? nil : extra_data['times'][items.index(i)].to_i
        res = res + [time.nil? ? '' : (val == 1 ? time : -1*time)]
      else
        res = res + [val.nil? ? '' :val]
      end
    end
    return res
  end

  #Calculate the number of correct items.
  #Used for displaying the results
  def score
    if responses.include?(1) | responses.include?(0)
      return responses.map{|x| x == nil ? 0:x}.sum
    else
      return nil
    end
  end

  #Calculate ethe number of all items with a "1" response
  #Used for displaying the results
  def count_1
    return (responses - [nil, 0]).size
  end

  #Calculate ethe number of all items with a "0" response
  #Used for displaying the results
  def count_0
    return (responses - [nil, 1]).size
  end

  #Calculate ethe number of all items with a "NA" response
  #Used for displaying the results
  def count_NA
    return (responses - [0, 1]).size
  end

  #Get the results of the most recent prior measurement of the same assessment.
  #Used for generating student feedback after a measurement.
  def getPriorResult()
    measurements = Measurement.where("assessment_id = ? AND created_at < ?", measurement.assessment, measurement.created_at)
    res = Result.where(:measurement => measurements, :student => student).order(created_at: :desc).first
    if res.nil?
      return -1
    else
      t = res.score
      return t.nil? ? 0 : t
    end
  end

  #Creates a csv file containing a "Big table" representation of a set of results objects. Additional information about test, student, group, and user is also included.
  #To restrict the export to a single test or a single user pass either a test id or user id as parameter. Use nil to indicate every test/every user.
  def self.to_csv(test, user)
    file = Tempfile.new('levumi')

    statement = "
      SELECT results.id,results.student_id, birthdate, gender, specific_needs, migration, measurement_id, assessment_id, assessments.group_id, users.name, test_id, items, responses, extra_data, date
      FROM results JOIN measurements ON measurements.id = measurement_id
        JOIN students ON students.id = student_id
        JOIN assessments ON assessments.id = assessment_id
        JOIN tests ON tests.id = test_id
        JOIN groups ON groups.id = assessments.group_id
        JOIN users ON users.id = user_id
      WHERE export = 1
    "

    unless test.nil?
      statement = statement + " AND tests.id = #{test}"
    end
    unless user.nil?
      statement = statement + " AND users.id = #{user}"
    end
    statement = statement + ";"
    temp = ActiveRecord::Base.connection.exec_query(statement)

    itembank = Hash[Item.all.pluck(:id, :shorthand)]
    testbank = Hash[Test.all.pluck(:id), Test.all.map{|t| t.long_name}]
    file.write("Item;Itemtext;Ergebnis;Reaktionszeit;Position in Messreihe;Messung_id;Kind_id;Geburtstag;Geschlecht;Foerderbedarf;Migrationshintergrund;Messzeitpunkt_id;Erhebung_id;Klasse_id;Benutzer;Testname;Datum\n")

    r = 1
    temp.each do |row|
      items = YAML.load(row["items"])
      responses = YAML.load(row["responses"])
      if responses[0].nil?
        next
      end
      extra = nil
      unless row["extra_data"].nil?
        extra = YAML.load(row["extra_data"])
      end
      i = 0
      items.each do |item|
        file.write([item, itembank[item], responses[i], ((extra.nil? || extra["times"].nil?) ? nil : extra["times"][i]), i+1, row["id"], row["student_id"], row["birthdate"], row["gender"], row["specific_needs"], row["migration"], row["measurement_id"], row["assessment_id"], row["group_id"], row["name"], testbank[row["tests_id"]], row["date"].to_date.strftime("%d.%m.%Y")].join(";"))
        file.write("\n")
        r = r + 1
        i = i + 1
      end
    end

    file.close
    return file.path
  end

  #TODO: Aus Klasse Export übernommen und angepasst. Geht teilweise vielleicht auch noch kürzer.
  #Creates an XLS file containing a SPSS-friendly spreadsheet representation of a set of results objects. Information about students is also included.
  #To restrict the export to a single test or a single user pass either a test id or user id as parameter. Use nil to indicate every test/every user.
  def self.to_xls(test, user)
    book = Spreadsheet::Workbook.new
    sheet1 = book.create_worksheet name: 'Items'
    sheetAlle = book.create_worksheet name: 'Alle Messungen - RZ'         #Without Reaktionszeiten
    sheetAlleRZ = book.create_worksheet name: 'Alle Messungen + RZ'  #With Reaktionszeiten

    sheetAlle.row(0).concat Student.table_headings
    sheetAlle.row(0).push "Messzeitpunkt"
    sheetAlleRZ.row(0).concat Student.table_headings
    sheetAlleRZ.row(0).push "Messzeitpunkt"
    sheet1.row(0).concat Item.table_headings

    sheets = {} # contains all sheets, e.g. "Lesetest", "Mathetest" and so on.
    allItems = {} # save item-groups one time to avoid redundancy
    itemSets = {} # contains test names as keys and 2d-array as a value. Each array contains the items of a level
    row = 1
    rowAlle = 1

    # Get items of each test without redundancy. Needed to put many assessments in one sheet
    tests = test.nil? ? Test.all : [Test.find(test)]

    tests.each do |t|
      name = t.name
      sheet = nil
      unless sheets.key? name
        sheet = book.create_worksheet name: t.name
        itemSets[t.name] = []
      else
        sheet = sheets[name]
      end

      ids = t.items.where(itemtype: 0).pluck(:id)

      #To avoid the redundancy the items of each test will be saved. The level or test can't help us, because
      # one level in the same test could have different items-group
      if allItems.key?(t.short_name)
        unless allItems[t.short_name].include?([ids])
          allItems[t.short_name]  << ids
          t.items.where(itemtype: 0).each do |it| # print items in items-sheet
            sheet1.row(row).concat it.to_a
            row = row + 1
          end
        end
      else
        allItems[t.short_name] =  [ids]
        t.items.where(itemtype: 0).each do |it| # print items in items-sheet
          sheet1.row(row).concat it.to_a
          row = row + 1
        end
      end

      # get items(from each level) of each test in a specific order to print the measurements in the right way
      unless itemSets[t.name].include? [ids]
        itemSets[t.name]  << [ids]
      end
      sheets[name] = sheet
    end

    # Print all items at the top of each sheet
    row = sheet1.last_row_index + 1
    itemSets.each do |key, value|
      name = key
      sheets[name].row(0).concat Student.table_headings
      sheets[name].row(0).push "Messzeitpunkt"
      sheets[name].row(0).push " "
      value.each do |a|
        testname = ''
        arr = a.flatten
        allItems.each do |k,v|
          if v.include? arr
            testname = k;
          end
        end
        arr = arr.map{|x| x.to_s.prepend(testname)} #Evtl. anders?
        sheets[key].row(0).concat arr
        sheets[key].row(0).push " "
        sheetAlle.row(0).concat arr
        sheetAlle.row(0).push " "
        sheetAlleRZ.row(0).concat arr
        sheetAlleRZ.row(0).push " "
      end
      row = row + 1
    end

    statement = "
      SELECT results.id, test_id, tests.name, date, student_id
      FROM results JOIN measurements ON measurements.id = measurement_id
        JOIN assessments ON assessments.id = assessment_id
        JOIN students ON students.id = student_id
        JOIN tests ON tests.id = test_id
        JOIN groups ON groups.id = assessments.group_id
        JOIN users ON users.id = user_id
      WHERE export = 1
    "

    unless test.nil?
      statement = statement + " AND tests.id = #{test}"
    end
    unless user.nil?
      statement = statement + " AND users.id = #{user}"
    end
    statement = statement + ";"
    temp = ActiveRecord::Base.connection.exec_query(statement)

    temp.each do |r|
      test = r["name"]
      sheet = sheets[test]
      row = sheet.last_row_index + 1
      itemset = Test.find(r["test_id"]).items.where(itemtype: 0).pluck(:id)

      # Needed just for the sheet 'Alle Messungen'
      indexOfArrayAll = itemSets.values.flatten(1).index([itemset])
      rightColumnAll = indexOfArrayAll + itemSets.values.flatten(1).first(indexOfArrayAll).flatten.size + Student.table_headings.length

      # get the right index to put values under the corresponding column
      indexOfArray = itemSets[test].index([itemset])  # get index of the corresponding items array
      rightColumn = indexOfArray + itemSets[test].first(indexOfArray).flatten.size  # length of all preceeded arrays plus number of blanks between each two sets

      s = Student.find(r["student_id"]).to_a
      d = r["date"].to_date.strftime("%d.%m.%Y")
      res = Result.find(r["id"])

      sheet.row(row).concat s
      sheet.row(row).push d
      sheet.row(row).push "  "
      sheet.row(row)[rightColumn] = " "
      sheet.row(row).concat res.to_a(itemset)
      row = row +1
      # Print results in the first sheet 'Alle Messungen'
      sheetAlle.row(rowAlle).concat s
      sheetAlle.row(rowAlle).push d
      sheetAlle.row(rowAlle)[rightColumnAll] = " "
      sheetAlle.row(rowAlle).concat res.to_a(itemset).map! { |x| x == '' ? "" : (x.to_i > 0 ? x = 1 : x = 0)}
      sheetAlleRZ.row(rowAlle).concat s
      sheetAlleRZ.row(rowAlle).push d
      sheetAlleRZ.row(rowAlle)[rightColumnAll] = " "
      sheetAlleRZ.row(rowAlle).concat res.to_a(itemset)
      rowAlle = rowAlle + 1
    end

    temp = Tempfile.new('levumi')
    temp.close
    book.write temp.path
    return temp.path
  end
end
