class User < ApplicationRecord
  has_many :group_shares
  has_many :groups, -> { where.not(group_shares: {key: nil}) }, through: :group_shares

  has_secure_password
  #TODO: Kommentar entfernen und Fehler-Validierung in _password anpassen.
  #validates :password, length: { minimum: 5 }

  validates_presence_of :email, message: 'E-Mail darf nicht leer sein!'
  validates_uniqueness_of :email, message: 'E-Mail Adresse ist bereits registriert!'
  #validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, message: 'Bitte eine gültige E-Mail Adresse eingeben'
  
  validates_numericality_of :account_type, greater_than_or_equal_to: 0, less_than_or_equal_to: 2
  validates_numericality_of :state, greater_than: 0, less_than_or_equal_to: 19

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
      'Forscher*in'
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

      used_tests = Test.where(id: used)
      unused_tests = Test.where(id: all_tests - used)

      used = used_tests.map{|a| a.test_family_id}
      used_families = TestFamily.where(id: used)
      unused_families = TestFamily.where(id: all_families - used)

      used = used_families.map{|f| f.competence_id}
      used_competences = Competence.where(id: used)
      unused_competences = Competence.where(id: all_competences - used)

      used = used_competences.map{|c| c.area_id}
      used_areas = Area.where(id: used)
      unused_areas = Area.where(id: all_areas - used)

      result += [{
          areas: (used_areas.map{|a| {info: a, used: true}} + unused_areas.map{|a| {info: a, used: false}}).sort!{|a,b| a[:info].name <=> b[:info].name},
          competences: (used_competences.map{|c| {info: c, used: true}} + unused_competences.map{|c| {info: c, used: false}}).sort!{|a,b| a[:info].name <=> b[:info].name},
          families: (used_families.map{|f| {info: f, used: true}} + unused_families.map{|f| {info: f, used: false}}).sort!{|a,b| a[:info].name <=> b[:info].name},
          tests: (used_tests.map{|t| {info: t, used: true}} + unused_tests.map{|t| {info: t, used: false}}).sort!{|a,b| a[:info].level <=> b[:info].level},
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
    #Gruppen dazunehmen für die ein Share-Angebot vorliegt, das aber noch nicht angenommen wurde. Diese fehlen in groups.
    Group.find(GroupShare.where(user_id: self.id, key: nil).pluck(:group_id)).each do |g|
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
    g = Group.create(label: 'Testklasse', demo: true, auth_token: token)
    GroupShare.create(user: self, group: g, owner: true, key: key)
  end

  #Hat der Nutzer bereits alle Intro-Phasen durchlaufen?
  def is_registered
    return intro_state == 4
  end
end
