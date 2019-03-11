class Assessment < ApplicationRecord
  belongs_to :test
  belongs_to :group
  has_many :results

  #Result-Objekte nach Wochennummer gruppieren und Test-Konfiguration zurückliefern
  #Rückgabe: Hash mit zwei Einträgen für Ergebnisse und Konfiguration
  def get_data
    results = self.results.all
    res = {}
    res['configuration'] = self.test.configuration
    res['series'] = results
    res
  end

end
