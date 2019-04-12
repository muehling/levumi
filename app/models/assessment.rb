class Assessment < ApplicationRecord
  belongs_to :test
  belongs_to :group
  has_many :results

  #Result-Objekte nach Wochennummer gruppieren und Test-Konfiguration zurückliefern
  #Rückgabe: Hash
  def get_data
    res = {}
    res['student_test'] = self.test.student_test
    res['configuration'] = self.test.configuration
    res['series'] = self.results.all.order(:test_date)
    res
  end

  #"Leere" Result-Objekte für Schülertest anlegen
  def prepare_results
    end_of_week = (Date.commercial(Date.today.to_date.year, Date.today.to_date.cweek) + 6).end_of_day
    group.students.each do |s|
      results.create(student: s, expires_on: end_of_week)
    end
  end

end
