class User < ApplicationRecord
  has_secure_password
  has_many :groups

  #Alle Schüler des Nutzers zurückliefern.
  def students
    Student.where(group_id: self.groups).all
  end

  #Überprüft ob die Berechtigung "cap" in den Capabilities des Benutzers vorhanden ist oder dieser Admin ist.
  #Liste aktuell verwendeter Capabilities:
  #admin -> darf/sieht alles
  #test -> darf Tests verwalten
  def has_capability?(cap)
    return !is_regular_user? && (capabilities.include?(cap) || capabilities.include?("admin"))
  end

  #Keine speziellen Capabilities als shortcut
  def is_regular_user?
    return capabilities.nil? || capabilities.blank?
  end
end
