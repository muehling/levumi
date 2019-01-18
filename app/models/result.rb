class Result < ApplicationRecord
  belongs_to :student
  belongs_to :assessment
  has_one :prior_result, class_name: 'Result', foreign_key: 'prior_result'

  #Datum der Testung
  def get_date
    self.created_at.to_date
  end

  #Wochennummer-Format des Testungsdatum zur Zusammenfassung von Ergebnissen einer Woche
  def get_week_date
    Date.commercial(self.created_at.to_date.year, self.created_at.to_date.cweek)
  end
end
