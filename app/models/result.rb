class Result < ApplicationRecord
  belongs_to :student
  belongs_to :assessment
  has_one :prior_result, class_name: 'Result', foreign_key: 'prior_result_id'

  serialize :results, Hash
  serialize :data, Array

  #Nach dem Anlegen das letzte Ergebnis desselben Assessment finden und verlinken (ggf. nil)
  after_create do |result|
    result.prior_result = Result.where(["student_id = ? and assessment_id = ?", result.student_id, result.assessment_id]).order(:test_date).last
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

  # Schattenkopie anlegen. falls Result-Objekt nicht leer und länger als 24h in der Datenbank (sonst vermutlich Fehlerhaft)
  before_destroy do |result|
    if (!result.test_data.nil? && result.test_date < Date.today)
      student = ShadowStudent.find_by_original_id(result.student_id)
      student = result.student.create_shadow if student.nil?
      student.shadow_results.create(test: result.assessment.test.id, test_date: result.test_date, test_week: result.test_week, results: result.results, data: result.data)
    end
  end

  #JSON Export, nur relevante Attribute übernehmen.
  def as_json(options = {})
    json = super(except: [:created_at, :updated_at])
  end

  #Markiert ein Objekt als gelöscht durch Löschen des Testdatums, aktualisiert prior_result Verweise
  def delete
    self.test_date = nil
    r = Result.where(prior_result_id: self.id).first
    unless r.nil?
      r.prior_result = self.prior_result
      r.save
    end
    save
  end

end
