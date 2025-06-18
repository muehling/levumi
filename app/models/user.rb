class User < ApplicationRecord
  has_many :group_shares
  has_many :groups, -> { where.not(group_shares: { key: nil }) }, through: :group_shares

  has_secure_password

  #TODO: Ggf. Kommentar entfernen und Fehler-Validierung in _password anpassen, falls gewünscht.
  #validates :password, length: { minimum: 5 }

  validates_presence_of :email, message: 'Die E-Mail-Adresse darf nicht leer sein!'
  validates_uniqueness_of :email,
                          case_sensitive: false,
                          message: 'Diese E-Mail-Adresse ist bereits registriert!'

  #validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, message: 'Bitte eine gültige E-Mail Adresse eingeben'

  validates_numericality_of :account_type,
                            greater_than_or_equal_to: 0,
                            less_than_or_equal_to: 3,
                            message: 'Bitte wählen Sie einen Account-Typen aus!'
  validates_numericality_of :state,
                            greater_than: 0,
                            less_than_or_equal_to: 19,
                            message: 'Bitte wählen Sie ein Bundesland aus!'

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
    SupportMessage.where(user_id: id).update_all(user_id: nil)
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
      'Forscher*in'
    else
      'Privat'
    end
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
  def as_zip(shorthands = nil)
    groups =
      Group
        .where(id: GroupShare.where(user_id: self.id).select('group_id'))
        .where.not(demo: true)
        .pluck(:id) #Keine Beispielklassen exportieren
    students = Student.where(group_id: groups).select('id').pluck(:id)

    if shorthands.kind_of?(Array)
      tests = Test.where(shorthand: shorthands)
    else
      tests = Test.find(Assessment.where(group_id: groups).select('test_id').pluck(:test_id))
    end
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

  #############################################
  ## registrations by type and month
  #############################################
  def self.get_all_registrations_by_type_and_month
    cached = Rails.cache.fetch('all_regs_by_type_and_month')

    if cached.nil?
      all_users = User.all
      all_users_by_type =
        (
          {
            users: all_users.group_by { |user| user.created_at.beginning_of_month },
            teachers:
              all_users
                .select { |user| user.account_type == 0 }
                .group_by { |user| user.created_at.beginning_of_month },
            scientists:
              all_users
                .select { |user| user.account_type == 1 }
                .group_by { |user| user.created_at.beginning_of_month },
            others:
              all_users
                .select { |user| user.account_type == 2 }
                .group_by { |user| user.created_at.beginning_of_month }
          }
        )
      Rails.cache.write(
        'all_regs_by_type_and_month',
        { all_users_by_type: all_users_by_type },
        expires_in: 4.weeks
      )
    else
      all_users_by_type = cached[:all_users_by_type]
    end
    all_users_by_type
  end

  #############################################
  ## active users by month
  #############################################
  def self.get_active_users_by_month
    #done
    users = User.all
    groups = Group.all
    group_shares = GroupShare.where(owner: true)
    active_by_month = {}
    active_users_by_month = {}
    (2020..2023).each do |year|
      (1..12).each do |month|
        puts "active users: #{month}/#{year}"
        start_date = Date.new(year, month, 1)
        end_date = start_date.end_of_month
        assessment_ids = Result.where(created_at: start_date..end_date).pluck(:assessment_id).uniq

        # das holt die aktiven Assessments, wahrscheinlich nicht so interessant
        #active_by_month[year.to_s + '/' + month.to_s] = assessment_ids.size

        assessments = Assessment.where(id: assessment_ids).select(:group_id)
        group_ids = assessments.pluck(:group_id)
        user_ids = group_shares.where(group_id: group_ids).pluck(:user_id).uniq

        active_by_month[year.to_s + '/' + month.to_s] = user_ids.size
      end
    end
    puts 'active users by month done'
    active_by_month
  end

  #############################################
  ## registrations by time and state
  #############################################
  def self.get_registrations_by_time_and_state(time)
    ##### done
    all_users = User.where('intro_state > ?', 3).select(:created_at, :state)
    all_regs_by_state_and_time =
      (
        grouped_by_time =
          all_users
            .group_by { |user| user.state }
            .transform_values do |u1|
              if time == 'quarter'
                u1
                  .group_by { |u2| u2.created_at.beginning_of_quarter }
                  .transform_values { |u3| u3.count }
              else
                u1
                  .group_by { |u2| u2.created_at.beginning_of_month }
                  .transform_values { |u3| u3.count }
              end
            end
      )
    puts 'Completed registrations by time and state'
    all_regs_by_state_and_time
  end

  def self.get_monthly_resultsTRIAL
    # funktioniert, ist aber mistig für die Results by Area
    results_by_month =
      Result
        .all
        .group_by { |result| result.created_at.beginning_of_quarter }
        .transform_values { |r| r.count }

    return { results_by_month: results_by_month }
  end

  def self.get_monthly_results
    cached = Rails.cache.fetch('monthly_results_by_area')
    if cached.nil?
      results_by_month = {}
      results_by_area_and_month = {}

      areas = Area.all.select(:id, :name)
      competences = Competence.all.select(:id, :area_id)
      test_families = TestFamily.all.select(:id, :competence_id)
      tests = Test.all.select(:id, :test_family_id)
      assessments = Assessment.all.select(:id, :test_id, :group_id)

      tests =
        tests.map do |test|
          test[:area_name] = test.test_family.competence.area.name
          test
        end

      all_results = Result.all

      (2020..2023).each do |year|
        (1..12).each do |month|
          first_day = Date.new(year, month, 1)
          last_day = first_day.end_of_month

          #   areas.each do |area|
          #     results_by_area_and_month[year.to_s + '/' + month.to_s + '/' + area[:name]] =
          #       all_results.select do |i|
          #         i.area_name === area.name && (first_day..last_day).cover?(i.created_at)
          #       end.count
          #   end

          results_for_month =
            Result
              .all
              .select(:created_at, :id, :assessment_id)
              .select { |i| (first_day..last_day).cover?(i.created_at) }
          results_by_month[year.to_s + '/' + month.to_s] = results_for_month.count

          results_for_month.each_with_index do |r, index|
            puts "Processed #{index + 1} elements..." if (index + 1) % 5000 == 0
            a = assessments.find { |c| c.id == r.assessment_id }
            t = tests.find { |x| x.id == a.test_id }

            results_by_area_and_month[year.to_s + '/' + month.to_s + '/' + t[:area_name]] =
              if results_by_area_and_month[year.to_s + '/' + month.to_s + '/' + t[:area_name]]
                results_by_area_and_month[year.to_s + '/' + month.to_s + '/' + t[:area_name]] + 1
              else
                1
              end
          end

          puts "completed #{year} #{month}"
        end
        puts "Completed results for #{year}"
      end

      Rails.cache.write(
        'monthly_results_by_area',
        {
          results_by_month: results_by_month,
          results_by_area_and_month: results_by_area_and_month
        },
        expires_in: 4.weeks
      )
    else
      results_by_month = cached[:results_by_month]
      results_by_area_and_month = cached[:results_by_area_and_month]
      active_users_by_month = cached[:active_users_by_month]
    end
    puts 'Completed results by month'
    return(
      { results_by_month: results_by_month, results_by_area_and_month: results_by_area_and_month }
    )
  end

  #Infos über alle Nutzer ermitteln
  def self.get_statistics
    users = User.all
    count = [0, 0, 0]
    active = [0, 0, 0]
    productive = [0, 0, 0]
    state = {}

    # Create an array to store the monthly user counts

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

      return { count: count, active: active, productive: productive, state: state }
    end
  end
end
