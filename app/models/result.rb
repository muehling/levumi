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

  #Returns an array representation of every Result object together with information about tests, users, assessment and measurement. User for exporting everything as one large file.
  def self.to_xls(test, user)
    book = Spreadsheet::Workbook.new
    sheet = book.create_worksheet name: 'Messungen'

    statement = "
      SELECT results.id,results.student_id, birthdate, gender, specific_needs, migration, measurement_id, assessment_id, assessments.group_id, user_id, email, test_id, subject, construct, tests.name, level, items, responses, extra_data, date
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
    sheet.row(0).concat("Item,Itemtext,Ergebnis,Reaktionszeit,Position in Messreihe,Messung_id,Kind_id,Geburtstag,Geschlecht,Foerderbedarf,Migrationshintergrund,Messzeitpunkt_id,Erhebung_id,Klasse_id,Benutzer_id,Benutzermail,Test,Fach,Testname,Konstrukt,Level,Datum".split(','))
    r = 1
    temp.each do |row|
      items = YAML.load(row["items"])
      responses = YAML.load(row["responses"])
      extra = nil
      unless row["extra_data"].nil?
        extra = YAML.load(row["extra_data"])
      end
      i = 0
      items.each do |item|
        sheet.row(r).concat([item, itembank[item], responses[i], (extra.nil? ? nil : extra["times"][i]), i+1, row["results.id"], row["results.student_id"], row["birthdate"], row["gender"], row["specific_needs"], row["migration"], row["measurement_id"], row["assessment_id"], row["assessments.group.id"], row["user_id"], row["email"], row["tests.id"], row["subject"], row["construct"], row["tests.name"], row["level"], row["date"].to_date.strftime("%d.%m.%Y")])
        r = r + 1
        i = i + 1
      end
    end
    temp = Tempfile.new('levumi')
    temp.close
    book.write temp.path
    return temp.path
  end
end
