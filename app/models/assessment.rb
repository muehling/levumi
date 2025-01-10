class Assessment < ApplicationRecord
  belongs_to :test
  belongs_to :group
  has_many :results, dependent: :destroy
  has_many :annotations, dependent: :destroy
  has_many :targets, dependent: :destroy

  after_create do |assessment|
    assessment.active = true
    assessment.excludes = []
    assessment.save
  end

  def exclude(ids)
    new_excludes = JSON.parse(ids)
    if new_excludes.kind_of?(Array)
      self.excludes = (self.excludes + new_excludes).uniq
    else
      self.excludes = (self.excludes + [new_excludes.to_i]).uniq
    end
    self.save
  end

  def include(ids)
    new_includes = JSON.parse(ids)
    if new_includes.kind_of?(Array)
      new_includes.each { |include| self.excludes.delete(include.to_i) }
    else
      self.excludes.delete(ids.to_i)
    end
    self.save
  end

  #Result-Objekte nach Wochennummer gruppieren und Test-Konfiguration zurückliefern
  #Rückgabe: Hash
  def get_data
    res = {}
    res['id'] = self.id
    res['active'] = self.active
    res['excludes'] = self.excludes
    res['test'] = self.test
    res['student_test'] = self.test.student_test
    res['configuration'] = self.test.configuration
    res['series'] = self.results.where.not(test_date: nil).order(:test_date)
    res['annotations'] = self.annotations.order(end: :desc)
    res['targets'] = self.targets
    res['settings'] = self.settings
    res['test_average'] = {
      mean: self.test.average[:mean],
      count: self.test.average[:count],
      std_dev: Math.sqrt(self.test.average[:m2] / self.test.average[:count])
    }

    res
  end

  #Eigene Funktion, da Schülerziele einzeln geladen können werden sollten, wenn sie dynamisch geändert werden, bzw. überhaupt erst abgefragt werden.
  def get_targets
    res = {}
    res['targets'] = self.targets
    res
  end
end
