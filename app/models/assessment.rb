class Assessment < ApplicationRecord
  belongs_to :test
  belongs_to :group
  has_many :results, dependent: :destroy
  has_many :annotations, dependent: :destroy

  #Startwert für Student-Test setzen - standardmäßig inaktiv
  after_create do |assessment|
    if assessment.test.student_test
      assessment.active = false
    end
  end
  #Result-Objekte nach Wochennummer gruppieren und Test-Konfiguration zurückliefern
  #Rückgabe: Hash
  def get_data
    res = {}
    res['active'] = self.active
    res['test'] = self.test
    res['student_test'] = self.test.student_test
    res['configuration'] = self.test.configuration
    res['series'] = self.results.where.not(test_date: nil).order(:test_date)
    res['annotations'] = self.annotations.order(end: :desc)
    res
  end

end
