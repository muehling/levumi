class Result < ApplicationRecord
  belongs_to :student
  belongs_to :assessment

  #Wochennummer-Format des Testungsdatum zur Zusammenfassung von Ergebnissen einer Woche generieren und speichern
  before_save do |result|
    unless result.test_date.nil?
      result.test_week = Date.commercial(result.test_date.to_date.year, result.test_date.to_date.cweek)
    else
      result.test_week = nil
    end
  end

  # Schattenkopie anlegen. falls Result-Objekt nicht zur Beispielklasse gehört, nicht leer ist und länger als 24h in der Datenbank (sonst vermutlich einfach fehlerhafte Messung).
  before_destroy do |result|
    if (!result.test_date.nil? && result.test_date < Date.today && !result.assessment.group.demo)
      student = ShadowStudent.find_by_original_id(result.student_id)
      student = result.student.create_shadow if student.nil?
      student.shadow_results.create(shorthand: result.assessment.test.shorthand, version: result.assessment.test.version, group: result.assessment.group.id, test_date: result.test_date, test_week: result.test_week, views: result.views, report: result.report, data: result.data)
    end
  end

  #JSON Export, nur relevante Attribute übernehmen.
  def as_json(options = {})
    json = super(except: [:created_at, :updated_at])
  end

  #TODO: Schülermerkmale exportieren!

  #Textdarstellung für CSV Export
  def as_csv
    start = "\"#{self.id}\",\"#{self.student_id}\",\"#{self.assessment.group_id}\",\"#{self.assessment.test_id}\",\"#{self.test_date}\",\"#{self.test_week}\","
    res = ''
    self.data.each do |d|
      res = res + start
      d.each do |k, v|
        res = res + '"' + v.to_s + '",'
      end
      res = res.slice(0, res.length-1) + "\n"
    end
    return res
  end

  #Spaltenbezeichner für CSV-Export, nimmt an, dass alle Result-Objekte eines Tests ein einheitliches Format haben!
  def csv_header
    res = '"Ergebnis_ID","Kind_ID","Klassen_ID","Test_ID","Testdatum","Testwoche"'
    if self.data.size > 0
      self.data[0].each do |k,v|
        res = res + ',"' + k + '"'
      end
    end
    return res
  end

  #Eintrag 'trend' aus 'support' zurückliefern, falls vorhanden => Security-Check für fehlerhafte Result-Objekte
  def get_trend
    unless report.nil? || report['trend'].nil?
      report['trend']
    else
      0
    end
  end

  #Eintrag 'items' aus 'support' zurückliefern, falls vorhanden => Security-Check für fehlerhafte Result-Objekte
  def get_support_items
    unless report.nil? || report['negative'].nil?
      report['negative']
    else
      []
    end
  end
end
