module UsersHelper

  def federal_states
    [["", 0], ['Baden-Württemberg', 1], ['Bayern', 2], ['Berlin', 3], ['Brandenburg', 4], ['Bremen', 5], ['Hamburg', 6], ['Hessen', 7], ['Mecklenburg-Vorpommern', 8], ['Niedersachsen', 9], ['Nordrhein-Westfalen', 10], ['Rheinland-Pfalz', 11], ['Saarland', 12], ['Sachsen', 13], ['Sachsen-Anhalt', 14], ['Schleswig-Holstein', 15], ['Thüringen', 16], ['Österreich', 17], ['Schweiz', 18], ['Anderes', 19]]
  end

  def school_types
    [['', nil], ['Grundschule', 1], ['Gesamtschule', 2], ['Hauptschule', 3], ['Realschule', 4], ['Gymnasium', 5], ['Förderschule Primarsstufe', 6], ['Förderschule Sekundarstufe', 7], ['Berufliche Schule', 8], ['Andere Schulart', 9]]
  end

  def focus_types
    [['', nil], ['Förderlehrkraft - Inklusion', 1], ['Förderlehrkraft - Förderschule', 2],  ['Regelschullehrkraft', 3]]
  end

  def state_to_s(state)
    federal_states.each do |s|
      if s[1] == state
        return s[0]
      end
    end
    return ""
  end

end
