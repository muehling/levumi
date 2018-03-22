# -*- encoding : utf-8 -*-
module UsersHelper

  def federal_states
    return [["", nil], ["Baden-Württemberg", 1], ["Bayern", 2], ["Berlin", 3], ["Brandenburg", 4], ["Bremen", 5], ["Hamburg", 6], ["Hessen", 7], ["Mecklenburg-Vorpommern", 8],
            ["Niedersachsen", 9], ["Nordrhein-Westfalen", 10], ["Rheinland-Pfalz", 11], ["Saarland", 12], ["Sachsen", 13], ["Sachsen-Anhalt", 14], ["Schleswig-Holstein", 15], ["Thüringen", 16]]
  end

  def occupation
    return [["", nil], ["Förderschullehrkraft - überwiegend Inklusion", 1], ["Förderschullehrkraft - überwiegend Förderschule", 2], ["Regelschullehrkraft", 3]]
  end
end
