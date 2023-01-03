class Assessment < ApplicationRecord
  belongs_to :test
  belongs_to :group
  has_many :results, dependent: :destroy
  has_many :annotations, dependent: :destroy

  #Startwert für Student-Test setzen - standardmäßig inaktiv
  after_create do |assessment|
    assessment.active = false if assessment.test.student_test
    assessment.excludes = []
    assessment.save
  end

  def exclude(id)
    self.excludes = (self.excludes + [id.to_i]).uniq
    self.save
  end

  def include(id)
    self.excludes.delete(id.to_i)
    self.save
  end

  #Result-Objekte nach Wochennummer gruppieren und Test-Konfiguration zurückliefern
  #Rückgabe: Hash
  def get_data
    res = {}
    res['active'] = self.active
    res['excludes'] = self.excludes
    res['test'] = self.test
    res['student_test'] = self.test.student_test
    res['configuration'] = self.test.configuration
    res['series'] = self.results.where.not(test_date: nil).order(:test_date)
    res['annotations'] = self.annotations.order(end: :desc)
    res
  end
end
