class Assessment < ApplicationRecord
  belongs_to :test
  belongs_to :group
  has_many :results, dependent: :destroy
  has_many :annotations, dependent: :destroy

  #Result-Objekte nach Wochennummer gruppieren und Test-Konfiguration zurückliefern
  #Rückgabe: Hash
  def get_data
    res = {}
    res['test'] = self.test
    res['student_test'] = self.test.student_test
    res['configuration'] = self.test.configuration
    res['series'] = self.results.where.not(test_date: nil).order(:test_date)
    res['annotations'] = self.annotations.order(end: :desc)
    res
  end

end
