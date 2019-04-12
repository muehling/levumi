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
    end
  end

  #JSON Export, nur relevante Attribute übernehmen.
  def as_json(options = {})
    json = super(except: [:created_at, :updated_at])
  end

end
