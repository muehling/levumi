# -*- encoding : utf-8 -*-
class Student < ActiveRecord::Base
  belongs_to :group
  has_many :results, :dependent => :destroy

  validates_presence_of :name
  before_save :check_login

  def check_login
    if self.login.nil? | self.login.blank?
      self.login = self.name
    end
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
        when 3 then "Andere"
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

  def get_open_measurements
    t = Test.where(:student_access => true)
    a = Assessment.where(:group => self.group.id, :test => t)
    m = Measurement.where(:assessment => a)
    #...
    return m.nil? ? [] : m
  end
end
