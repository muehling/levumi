class Result < ApplicationRecord
  belongs_to :student
  belongs_to :assessment
  has_one :prior_result, class_name: 'Result', foreign_key: 'prior_result'

  #Wochennummer-Format des Testungsdatum zur Zusammenfassung von Ergebnissen einer Woche generieren und speichern
  before_save do |result|
    unless result.updated_at.nil?
      result.test_week = Date.commercial(result.updated_at.to_date.year, result.updated_at.to_date.cweek)
    end
  end

  #Datum der Testung - eigene Spalte?
  def get_date
    self.updated_at.to_date
  end

end
