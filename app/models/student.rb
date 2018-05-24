# -*- encoding : utf-8 -*-
class Student < ActiveRecord::Base
  #Connections with other model classes:
  belongs_to :group
  has_many :results, :dependent => :destroy

  #Validations:
  validates_presence_of :name
  after_create :set_login


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

  def get_account_type(val)
    if val.nil?
      return "nicht erfasst"
    else
      return case val
        when 0 then "Lehrkraft"
        when 1 then "Forscher"
        when 2 then "Privat/System"
      end
    end
  end


  #####################

  #Generate random login code
  def set_login
    while self.login.nil? | self.login.blank?
      cur = (('0'..'9').to_a + ('a'..'z').to_a).shuffle.first(6).join
      if(Student.where(:login => cur).empty?)
        self.login = cur
        self.save
      end
    end
  end

  def self.table_headings
    return %w{Kind-ID Code Klassen-Id Klassen-Name Benutzer-Id Benutzertyp Geschlecht Geburtsdatum Förderbedarf Migrationshintergrund}
  end

  def to_a
    return [id.to_s, name, group.id, group.name, group.user.id, get_account_type(group.user.account_type), get_gender(true), get_birthdate(true), get_specific_needs(true), get_migration(true)]
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

  #Only get measurement which are available
  def get_open_measurements
    t = Test.where(:student_access => true)
    a = Assessment.where(:group => self.group.id).
                   where(:test => t)
    #only return measurements which are not worked and out of date
    m = Measurement.
        where(:assessment => a).
        where("date > ?", Date.yesterday)
    r = Result.
        where(:measurement => m).
        where(:student_id => self.id).
        where('responses LIKE ? OR responses LIKE ?', '%1%', '%0%')
    r.each do |temp|
     m = m.where.not(:id => temp.measurement_id)
    end
    #TODO-Morten ist gerade nur die schnelle Lösung. Ändere ich bei zeiten wieder zur schöneren + wahrscheinlich .select{}, da Array kein .where hat
    # der Datenbankabruf muss nicht zweimal passieren
    #return only Measurements, which has a resultobjekt
    r = Result.
        where(:measurement => m).
        where(:student_id => self.id)
    result = []
    r.each do |temp|
      result = result + m.where(:id => temp.measurement_id)
    end
	return result.nil? ? [] : result
  end

  #get current result objekt of student
  def getCurrentResult(measurement_id)
    r = Result.where(:student_id => self.id, :measurement_id => measurement_id).first
    return r.nil? ? [] : r
  end

end
