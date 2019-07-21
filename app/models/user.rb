class User < ApplicationRecord
  has_many :group_shares
  has_many :groups, through: :group_shares

  has_secure_password
  validates_presence_of :email
  validates_uniqueness_of :email
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  validates_numericality_of :account_type, greater_than_or_equal_to: 0, less_than_or_equal_to: 2
  validates_numericality_of :state, greater_than: 0, less_than_or_equal_to: 16

  # Eigene Gruppen löschen
  before_destroy do |user|
    shares = GroupShare.where(user_id: user.id, owner: true)
    shares.each do |s|
      s.group.destroy
    end
  end

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

  #Liefert Beschreibung zum Account-Typ
  def get_account_type
    case account_type
    when 0
      'Lehrkraft'
    when 1
      'Forscher_in'
    else
      'Privat'
    end
  end

  #Informationen für Userübersicht sammeln: Pro Gruppe alle verwendeten Tests, Familien, Kompetenzen und Bereiche und alle noch verfügbaren sammeln. Vermeidet redundante Anfragen.
  # TODO: Optimmierbar?
  def get_home_info
    all_tests = Test.all.pluck(:id)
    all_families = TestFamily.all.pluck(:id)
    all_competences = Competence.all.pluck(:id)
    all_areas = Area.all.pluck(:id)

    result = []
    groups.each do |group|

      used = group.assessments.map{|a| a.test_id}

      used_tests = Test.where(id: used).order(:level)
      unused_tests = Test.where(id: all_tests - used).order(:level)

      used = used_tests.map{|a| a.test_family_id}
      used_families = TestFamily.where(id: used).order(:name)
      unused_families = TestFamily.where(id: all_families - used).order(:name)

      used = used_families.map{|f| f.competence_id}
      used_competences = Competence.where(id: used).order(:name)
      unused_competences = Competence.where(id: all_competences - used).order(:name)

      used = used_competences.map{|c| c.area_id}
      used_areas = Area.where(id: used).order(:name)
      unused_areas = Area.where(id: all_areas - used).order(:name)

      result += [{
          areas: used_areas.map{|a| {info: a, used: true}} + unused_areas.map{|a| {info: a, used: false}},
          competences: used_competences.map{|c| {info: c, used: true}} + unused_competences.map{|c| {info: c, used: false}},
          families: used_families.map{|f| {info: f, used: true}} + unused_families.map{|f| {info: f, used: false}},
          tests: used_tests.map{|t| {info: t, used: true}} + unused_tests.map{|t| {info: t, used: false}}
                 }]

    end
    return result
  end

  #Informationen für die Klassenbuchansicht sammeln.
  def get_classbook_info
    result = []
    groups.each do |g|
      result += [g.as_hash(self)]
    end
    return result
  end

  def new_shares?
    GroupShare.exists?(user: self, key: nil)
  end

  #Zufälliges Passwort erzeugen
  def generate_password
    pw = Digest::SHA1.hexdigest(rand(36**8).to_s(36))[1..6]
    self.update_attributes({password: pw, password_confirmation: pw})
    return pw
  end

  #Gibt es eine Sicherheitsabfrage für den Account?
  def has_security?
    return !security_digest.nil? && !security_digest.blank?
  end

  #Testklasse anlegen
  def create_demo(key, token)
    g = Group.create(label: 'Beispiel-Klasse', demo: true, auth_token: token)
    GroupShare.create(user: self, group: g, owner: true, key: key)
  end

end
