class Assessment < ApplicationRecord
  belongs_to :test
  belongs_to :group
  has_many :results

  #Result-Objekte nach Wochennummer gruppieren
  #Rückgabe: Hash mit allen vorkommenden Wochennummern
  def get_grouped_results
    results = self.results.all
    weeks = results.map{|r| r.get_week_date}
    group = {}
    weeks.uniq do |w|
      group[w] = results.select{|r| r.get_week_date == w}
    end
    group
  end

end
