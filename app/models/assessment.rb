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

end
