class Result < ApplicationRecord
  belongs_to :student
  belongs_to :assessment
  has_one :prior_result, class_name: 'Result', foreign_key: 'prior_result_id'

  #Nach dem Anlegen das letzte Ergebnis desselben Assessment finden und verlinken (ggf. nil)
  after_create do |result|
    result.prior_result = Result.where(["id != ? and student_id = ? and assessment_id = ?",result.id, result.student_id, result.assessment_id]).order(:test_date).last
    result.save
  end

  #Wochennummer-Format des Testungsdatum zur Zusammenfassung von Ergebnissen einer Woche generieren und speichern
  before_save do |result|
    unless result.test_date.nil?
      result.test_week = Date.commercial(result.test_date.to_date.year, result.test_date.to_date.cweek)
    else
      result.test_week = nil
    end
  end

  # Schattenkopie anlegen. falls Result-Objekt nicht leer und länger als 24h in der Datenbank (sonst vermutlich fehlerhaft). Prior Verweis aktualisieren
  before_destroy do |result|
    if (!result.test_date.nil? && result.test_date < Date.today)
      student = ShadowStudent.find_by_original_id(result.student_id)
      student = result.student.create_shadow if student.nil?
      student.shadow_results.create(shorthand: result.assessment.test.shorthand, version: result.assessment.test.version, group: result.assessment.group.id, test_date: result.test_date, test_week: result.test_week, views: result.views, report: result.report, data: result.data)
    end
    r = Result.where(prior_result_id: result.id).first
    unless r.nil?
      r.prior_result = result.prior_result
      r.save
    end
  end

  #JSON Export, nur relevante Attribute übernehmen.
  def as_json(options = {})
    json = super(except: [:created_at, :updated_at])
  end

  #Textdarstellung für CSV Export
  def as_csv
    start = "#{self.id},#{self.student_id},#{self.assessment.group_id},#{self.assessment.test_id},#{self.assessment.test_date},#{self.assessment.test_week},"
    res = ''
    #TODO: Alles Keys exportieren!
    self.data.each do |d|
      res = res + start + "'#{d['item']}','#{d['result']}'" + (d.has_key?('time') ? ",#{d['time']}\n" : "\n")
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
