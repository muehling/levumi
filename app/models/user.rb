class User < ApplicationRecord
  has_many :group_shares
  has_many :groups, -> { where.not(group_shares: { key: nil }) }, through: :group_shares

  has_secure_password

  #TODO: Ggf. Kommentar entfernen und Fehler-Validierung in _password anpassen, falls gewünscht.
  #validates :password, length: { minimum: 5 }

  validates_presence_of :email, message: 'E-Mail darf nicht leer sein!'
  validates_uniqueness_of :email,
                          case_sensitive: false,
                          message: 'E-Mail Adresse ist bereits registriert!'

  #validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, message: 'Bitte eine gültige E-Mail Adresse eingeben'

  validates_numericality_of :account_type, greater_than_or_equal_to: 0, less_than_or_equal_to: 2
  validates_numericality_of :state, greater_than: 0, less_than_or_equal_to: 19

  # Eigene Gruppen und Shares löschen
  before_destroy do |user|
    shares = GroupShare.where(user_id: user.id).all
    shares.each do |share|
      if share.owner
        # delete students before the group is deleted, as the shadow data needs information from the group
        # which can't be accessed if the deletion is cascaded from the group to the students
        share.group.students.each { |student| student.destroy }
        share.group.destroy
      end
      share.destroy
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
    return !is_regular_user? && (capabilities.include?(cap) || capabilities.include?('admin'))
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
      'Forscher:in'
    else
      'Privat'
    end
  end

  # get all used tests per group
  def get_home_info
    all_tests = Test.pluck(:id)
    all_families = TestFamily.pluck(:id)
    all_competences = Competence.pluck(:id)
    all_areas = Area.pluck(:id)

    result = []
    groups
      .where(archive: false)
      .order(id: :desc)
      .each do |group|
        used = group.assessments.map { |a| a.test_id }
        used_tests = Test.where(id: used).pluck(:id)
        result += [{ group_id: group.id, used_test_ids: used_tests }]
      end
    return result
  end

  #Informationen für die Klassenbuchansicht sammeln.
  def get_classbook_info
    result = []
    groups.each { |g| result += [g.as_hash(self)] }

    #Gruppen dazunehmen für die ein Share-Angebot vorliegt, das aber noch nicht angenommen wurde. Diese fehlen in groups.
    Group
      .find(GroupShare.where(user_id: self.id, key: nil).pluck(:group_id))
      .each { |g| result += [g.as_hash(self)] }
    return result
  end

  def new_shares?
    GroupShare.exists?(user: self, key: nil)
  end

  #Zufälliges Passwort erzeugen
  def generate_password
    pw = Digest::SHA1.hexdigest(rand(36**8).to_s(36))[1..6]
    return pw
  end

  #Gibt es eine Sicherheitsabfrage für den Account?
  def has_security?
    return !security_digest.nil? && !security_digest.blank?
  end

  #Beispielklasse anlegen
  def create_demo(key, token)
    g = Group.create(label: 'Beispielklasse', demo: true, auth_token: token)
    GroupShare.create(user: self, group: g, owner: true, key: key)
  end

  #Hat der Nutzer bereits alle (wichtigen) Intro-Phasen durchlaufen?
  def is_registered
    return intro_state > 2
  end

  def has_tested_students
    groups =
      Group
        .where(id: GroupShare.where(user_id: self.id).select('group_id'))
        .where.not(demo: true)
        .pluck(:id) #Keine Beispielklassen exportieren
    students = Student.where(group_id: groups).pluck(:id)
    return(
      Result.where("test_date > '2019-09-09'").where(student_id: students).size > 0 ? true : false
    )
  end

  #Alle Testungen eines Users als Zip-Archiv, eine Datei pro verwendetem Test
  def as_zip
    groups =
      Group
        .where(id: GroupShare.where(user_id: self.id).select('group_id'))
        .where.not(demo: true)
        .pluck(:id) #Keine Beispielklassen exportieren
    students = Student.where(group_id: groups).select('id').pluck(:id)
    tests = Test.find(Assessment.where(group_id: groups).select('test_id').pluck(:test_id))
    temp = Tempfile.new('Levumi')
    Zip::OutputStream.open(temp.path) do |zip|
      tests.each do |t|
        #Keine alten Messungen exportieren
        res =
          Result
            .where("test_date > '2019-09-09'")
            .where(
              student_id: students,
              assessment_id:
                Assessment.where(group_id: self.groups.pluck(:id), test_id: t.id).select('id')
            )
            .all
        if (res.size > 0)
          zip.put_next_entry(
            (t.shorthand + '_' + DateTime.now.strftime('%Y_%m_%d') + '.csv').encode!(
              'CP437',
              undefined: :replace,
              replace: '_'
            )
          )
          csv = res[0].csv_header(true) + "\n"
          res.each { |r| csv = csv + r.as_csv(true) }
          zip.print csv
        end
      end
    end
    temp.close
    return temp.path
  end

  #Infos über alle Nutzer ermitteln
  def self.get_statistics
    users = User.all
    count = [0, 0, 0]
    active = [0, 0, 0]
    productive = [0, 0, 0]
    state = {}
    users.each do |u|
      count[u.account_type] += 1
      active[u.account_type] += 1 if !u.last_login.nil? && u.last_login > (DateTime.now - 30)
      groups =
        Group
          .where(id: GroupShare.where(user_id: u.id).select('group_id'))
          .where.not(demo: true)
          .pluck(:id)
      students = Student.where(group_id: groups).pluck(:id)
      if Result.where(student_id: students).exists?
        productive[u.account_type] += 1
        state[u.state] = [0, 0, 0] if state[u.state].nil?
        state[u.state][u.account_type] += 1
      end
    end
    return { count: count, active: active, productive: productive, state: state }
  end
end
