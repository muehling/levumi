# -*- encoding : utf-8 -*-
class Student < ActiveRecord::Base
  belongs_to :group
  has_many :results, :dependent => :destroy
 # has_secure_password

  validates_presence_of :name
  before_create :set_password
  after_create :set_login

  #Generieren von eindeutigen Login
  def set_login
    self.login = "stu" + self.id.to_s
    self.save
  end

  #TODO vllt secure_password einfügen/Setzen des passwortes für den Schüler
  def set_password
=begin has_secure_password schwer bis nicht möglich als Klartext wieder anzuzeigen
    #self.password = (('0'..'9').to_a+('a'..'z').to_a+('A'..'Z').to_a).shuffle.first(12).join
    #self.password_confirmation = self.password
=end
    self.password_digest = (('0'..'9').to_a+('a'..'z').to_a+('A'..'Z').to_a).shuffle.first(12).join
  end
  #Getter für Merkmale:

  def get_gender(raw = false)
    return self[:gender].nil? ? (raw ? "nicht erfasst" : "<i>nicht erfasst</i>") : (self[:gender] ? "männlich" : "weiblich")
  end

  def get_birthdate(raw = false)
    if self[:birthdate].nil?
      return raw ? "nicht erfasst" : "<i>nicht erfasst</i>"
    else
      return I18n.l(self[:birthdate].to_date, format: "%b %Y")
    end
  end

  def get_specific_needs(raw = false)
    if self[:specific_needs].nil?
      return raw ? "nicht erfasst" : "<i>nicht erfasst</i>"
    else
      return case self[:specific_needs]
        when 0 then "Keinen"
        when 1 then "Lernen"
        when 2 then "Geistige Entwicklung"
        when 3 then "Anderer Förderbedarf"
        when 4 then "Deutsch"
      end
    end
  end

  def get_migration(raw = false)
    return self[:migration].nil? ? (raw ? "nicht erfasst" : "<i>nicht erfasst</i>") : (self[:migration] ? "Ja" : "Nein")
  end

  def self.xls_headings
    return %w{ID Code Klassen-Id Klassen-Name Benutzer-Id Geschlecht Geburtsdatum Förderbedarf Migrationshintergrund}
  end

  def to_a
    return [id.to_s, name, group.id, group.name, group.user.id, get_gender(true), get_birthdate(true), get_specific_needs(true), get_migration(true)]
  end

  #####################



  def self.import(file, group)
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    header.each{|h| h.downcase!}
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      student = group.students.build(name: row["name"])
      student.save!
    end
  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
      when ".csv" then Roo::CSV.new(file.path)
      when ".xls" then Roo::Excel.new(file.path, file_warning: :ignore)
      else raise "Unknown file type: #{file.original_filename}"
    end
  end

  def getResults
    tests = Hash.new()
    items = Hash.new()
    results.each do |r|
      if r.score == nil
        next
      end
      test = r.measurement.assessment.test.id
      if tests.has_key?(test)
        tests[test] = tests[test] + [r]
      else
        tests[test] = [r]
      end
      for i in 0..r.responses.size-1 do
        item = r.items[i].to_s
        val = r.responses[i]
        if items.has_key?(item)
          items[item]["freq"] = items[item]["freq"] + 1
          items[item]["cor"] = items[item]["cor"] + (val == nil ? 0 : val)
          items[item]["prob"] = items[item]["cor"].to_f / items[item]["freq"]
          items[item]["dates"] = items[item]["dates"] + [r.measurement.date]
        else
          items[item] = {"freq" => 1,"cor" => (val == nil ? 0 : val), "prob" => (r.responses[i] == nil ? 0 : r.responses[i]), "dates" => [r.measurement.date]}
        end
        i = i + 1
      end
    end
    return tests
  end

  def getTestResults(test_id)
    items = Hash.new()
    results.each do |r|
      if test_id == r.measurement.assessment.test.id
        for i in 0..r.responses.size-1 do
          item = r.items[i].to_s
          val = r.responses[i]
          if items.has_key?(item)
            items[item]["freq"] = items[item]["freq"] + 1
            items[item]["cor"] = items[item]["cor"] + (val == nil ? 0 : val)
            items[item]["prob"] = items[item]["cor"].to_f / items[item]["freq"]
            items[item]["dates"] = items[item]["dates"] + [r.measurement.date]
          else
            items[item] = {"freq" => 1,"cor" => (val == nil ? 0 : val), "prob" => (r.responses[i] == nil ? 0 : r.responses[i]), "dates" => [r.measurement.date]}
          end
          i = i + 1
        end
      end
    end
    probs = []
    items.each do |key, val|
      probs = probs + [val["prob"]]
    end
    probs.sort!
    return {"1st" => probs[probs.size/4], "4th" => probs[3*probs.size/4], "data" => items}
  end

  #TODO Nur measurements anzeigen ,welche noch nicht bearbeitet wurden(in welche schon einmal reingespeichert wurde)
  def get_open_measurements
    t = Test.where(:student_access => true)
    a = Assessment.where(:group => self.group.id).
                   where(:test => t)
    #nur zurückgeben der Measurments welche noch nicht abgelaufen sind
    m = Measurement.
        where(:assessment => a).
        where("date >?", Date.today)
    r = Result.
        where(:measurement => m).
        where(:student_id => self.id).
        where('responses LIKE ? OR responses LIKE ?', '%1%', '%0%')
    r.each do |temp|
     m = m.where.not(:id => temp.measurement_id)
    end
    return m.nil? ? [] : m
  end

  #Aktuelles Resultobjekt des Schülers holen
  def getCurrentResult(measurement_id)
    rCreate = Result.where(:measurement_id => measurement_id, :student_id => self.id)
    if(rCreate.empty?)
      s = rCreate.build(student: self)
      s.initialize_results()
    end
    r = Result.where(:student_id => self.id, :measurement_id => measurement_id).first
    @result=r
    return r.nil? ? [] : r
  end
end
