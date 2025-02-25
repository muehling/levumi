require 'zip'

class Test < ApplicationRecord
  include Averages

  # Muss vor has_many stehen, da ansonsten die Kindelemente schon vor before_destroy gelöscht werden und ShadowResults angelegt werden.
  before_destroy :cleanup

  has_many :assessments, dependent: :destroy
  has_one :type
  belongs_to :test_family

  #Zu einem Test gehörende Dateien => Active_Storage
  has_one_attached :entry_point
  has_many_attached :media_files
  has_many_attached :script_files
  has_many_attached :style_files
  has_many_attached :info_files

  #Entspricht dem Testnamen
  validates_presence_of :level
  validates_uniqueness_of :shorthand, conditions: -> { where.not(archive: true) }

  attribute :area_name, :string

  #Ggf. "veraltet" zum Namen dazufügen
  def name
    archive ? level + ' (veraltet)' : level
  end

  def full_name
    test_family.competence.area.name + ' - ' + test_family.competence.name + ' - ' +
      test_family.name + ' - ' + name
  end

  #Kurzdarstellung des Tests
  def info
    {
      id: id,
      level: level,
      family: test_family.name,
      competence: test_family.competence.name,
      area: test_family.competence.area.name,
      student_test: student_test
    }
  end

  def self.tests_meta
    tests_meta =
      Rails
        .cache
        .fetch('tests/tests_meta', expires_in: 30.days) do
          all_families =
            TestFamily.all.map do |family|
              tests_for_family = Test.where(test_family_id: family.id)
              {
                test_count: tests_for_family.count,
                test_type_ids:
                  Test
                    .where(test_family_id: family.id)
                    .map { |test| test.test_type_id ? test.test_type_id : TestType.first[:id] }
                    .uniq,
                test_ids: tests_for_family.pluck(:id),
                id: family.id,
                name: family.name,
                competence_id: family.competence_id
              }
            end
          all_competences =
            Competence.all.map do |competence|
              families_for_competence =
                all_families.select { |family| family[:competence_id] == competence.id }
              {
                test_count:
                  families_for_competence.reduce(0) { |sum, family| sum + family[:test_count] },
                name: competence.name,
                test_type_ids:
                  families_for_competence
                    .reduce([]) { |acc, family| acc + family[:test_type_ids] }
                    .uniq,
                test_ids:
                  families_for_competence.reduce([]) { |acc, family| acc + family[:test_ids] },
                test_family_ids: families_for_competence.pluck(:id),
                id: competence.id,
                area_id: competence.area_id
              }
            end
          all_test_types =
            TestType.all.map do |test_type|
              tests_for_test_type = Test.where(test_type_id: test_type.id).pluck(:id)
              competences_for_test_type =
                all_competences.select do |competence|
                  competence[:test_type_ids].include? test_type.id
                end
              if (test_type.id == 1)
                tests_for_test_type = tests_for_test_type + Test.where(test_type_id: nil).pluck(:id)
              end
              {
                test_ids: tests_for_test_type,
                name: test_type.name,
                id: test_type.id,
                competence_ids: competences_for_test_type.pluck(:id)
              }
            end
          all_areas =
            Area.all.map do |area|
              competences_for_area =
                all_competences.select { |competence| competence[:area_id] == area.id }

              {
                test_count:
                  competences_for_area.reduce(0) do |sum, competence|
                    sum + competence[:test_count]
                  end,
                test_type_ids:
                  competences_for_area
                    .reduce([]) { |acc, competence| acc + competence[:test_type_ids] }
                    .uniq,
                test_ids:
                  competences_for_area.reduce([]) { |acc, competence| acc + competence[:test_ids] },
                name: area.name,
                id: area.id
              }
            end

          # safety net in case someone forgot to add a test type
          all_test_types = [
            { id: 1, name: 'NO TEST TYPE FOUND', test_ids: Test.all.pluck(:id) }
          ] if all_test_types.empty?
          {
            areas: all_areas,
            test_families: all_families,
            competences: all_competences,
            tests: Test.all.as_json(exclude_items: true),
            test_types: all_test_types
          }
        end

    tests_meta
  end

  #JSON Export, nur relevante Attribute übernehmen
  def as_json(options = {})
    latest_version = Test.where(shorthand: self.shorthand, archive: false).first
    if latest_version.nil?
      latest_version = Test.where(shorthand: self.shorthand).order(updated_at: :desc).first
    end

    excludes = %i[created_at updated_at]
    if options[:exclude_items].nil?
      excludes = %i[created_at updated_at]
    else
      excludes = %i[items created_at updated_at]
    end
    json = super(except: excludes)
    json['area_id'] = self.test_family.competence.area.id
    json['competence_id'] = self.test_family.competence.id
    json['label'] =
      self.archive ? "Bis #{I18n.localize(self.updated_at, format: '%B %Y')}" : 'Aktuell'
    json['full_name'] = self.test_family.name + ' - ' + self.level
    json['is_latest'] = latest_version[:id] == self.id
    json['test_type_id'] = self.test_type_id || TestType.first.id
    json
  end

  #Ggf. zum Test gehörende Dateien löschen, alle Results vorbereiten, so dass keine Schattenkopien angelegt werden.
  def cleanup
    entry_point.purge
    media_files.purge
    script_files.purge
    style_files.purge
    results = Result.where(assessment_id: Assessment.where(test_id: id).all.pluck(:id)).all
    results.each do |r|
      r.test_date = nil
      r.save
    end
  end

  #Test Objekt als Import aus ZIP-Datei erzeugen
  def self.import(file, archive, update_material, login)
    #Infos aus ZIP lesen
    begin
      zip = Zip::File.open(file)
    rescue StandardError
      return 'Datei konnte nicht geöffnet werden!'
    end
    f = zip.glob('test.json').first

    if f.nil?
      return 'Keine Datei hochgeladen!'
    else
      #Benötigte Strukturen finden / erzeugen
      vals = ActiveSupport::JSON.decode(f.get_input_stream.read)

      #Automatische Archivierung
      old_test = Test.where(shorthand: vals['shorthand']).where.not(archive: true).first
      unless old_test.nil?
        if old_test.version < vals['version']
          #Falls kleiner Version, automatisch archivert.
          old_test.archive = true
          old_test.save
          assessments_for_old_test = Assessment.where(test_id: old_test.id)
        elsif old_test.version > vals['version']
          #Ältere Version darf neuere nicht ersetzen.
          return 'Die hochgeladene Version ist älter als die vorhandene!'
        end
      end

      #Ggf. benötigte Strukturen anlegen
      area = Area.find_by_name(vals['area'])
      area = Area.create(name: vals['area']) if area.nil?
      competence = area.competences.find_by_name(vals['competence'])
      competence = area.competences.build(name: vals['competence']) if competence.nil?
      family = competence.test_families.find_by_name(vals['family'])
      family = competence.test_families.build(name: vals['family']) if family.nil?

      test_type = TestType.find_by_name(vals['test_type']) if (vals['test_type'])
      test_type = TestType.first if test_type.nil?
      vals['test_type_id'] = test_type.id

      #Test anlegen oder updaten
      if old_test.nil? || old_test.archive
        #TODO: Parameter von configuration einschränken? Ggf. auch als setter?
        test =
          family.tests.build(
            vals.slice(
              'description',
              'version',
              'level',
              'shorthand',
              'student_test',
              'configuration',
              'test_type_id',
              'responsible'
            )
          )
      else
        test = old_test
        test.update(
          vals.slice(
            'description',
            'version',
            'level',
            'shorthand',
            'student_test',
            'configuration',
            'test_type_id',
            'responsible'
          )
        )
      end
      test.items = vals['items']
      test.required_services = vals['required_services']

      test.updated_by = login.email

      if !test.nil? && test.save
        # invalidate cache
        Rails.cache.delete('tests/tests_meta')
        Rails.cache.delete('tests/test_app_data')

        # create new assessments in case an old test was archived
        if (!old_test.nil? && old_test.archive && !assessments_for_old_test.nil?)
          assessments_for_old_test.each do |old_assessment|
            new_assessment = old_assessment.dup
            new_assessment.test_id = test.id
            new_assessment.save
          end
        end

        #MaterialSupport-Einträge auf Testebene für neue Version kopieren - Items dürfen sich nicht verändert haben.
        if update_material && !old_test.nil? && old_test != test
          todo = MaterialSupport.where(test_id: old_test.id)
          todo.each do |m|
            MaterialSupport.create(
              test_id: test.id,
              test_family_id: m.test_family_id,
              competence_id: m.competence_id,
              area_id: m.area_id,
              material_id: m.material_id,
              items: m.items
            )
          end
        end

        #Dateien aus ZIP lesen und zu Test dazufügen bzw. updaten

        if old_test == test
          test.entry_point.purge
          test.media_files.purge
          test.info_files.purge
          test.script_files.purge
          test.style_files.purge
        end

        f = zip.glob('test.html').first
        if !f.nil?
          test.entry_point.attach(
            io: StringIO.new(f.get_input_stream.read),
            filename: 'test.html',
            content_type: 'text/html'
          )
        end

        zip
          .glob('media/*')
          .each do |f|
            test.media_files.attach(
              io: StringIO.new(f.get_input_stream.read),
              filename: f.name.split('/').last
            )
          end

        zip
          .glob('info/*')
          .each do |f|
            test.info_files.attach(
              io: StringIO.new(f.get_input_stream.read),
              filename: f.name.split('/').last
            )
          end

        zip
          .glob('scripts/*')
          .each do |f|
            test.script_files.attach(
              io: StringIO.new(f.get_input_stream.read),
              filename: f.name.split('/').last
            )
          end

        zip
          .glob('styles/*')
          .each do |f|
            test.style_files.attach(
              io: StringIO.new(f.get_input_stream.read),
              filename: f.name.split('/').last,
              content_type: 'text/css'
            )
          end

        pattern = /test(?=_upload\b)/
        if (!!(login.capabilities =~ pattern))
          UserMailer.with(shorthand: test.shorthand, updater: login.email).test_update.deliver_later
        end
        return '' # no error message -> everything cool
      end
    end
  end

  #Gibt es (exportierbare) Ergebnisse?
  def has_results
    assessment_ids = Assessment.where(test_id: self.id).pluck('id')
    Result.where(assessment_id: assessment_ids, test_date: '2019-09-09'..).exists?
  end

  def quartiles
    #duration = self.archive ? 2.years : 7.days
    duration = self.archive ? 2.years : 1.minute
    Rails
      .cache
      .fetch("#{self.shorthand}/#{self.version}_quartiles", expires_in: duration) do
        Averages.calculate_quartiles(self.id)
      end
  end

  #Alle Ergebnisse eines Tests als CSV-Export
  def as_csv
    duration = Rails.env.production? ? 24.hours : 2.seconds
    student_ids =
      Rails
        .cache
        .fetch('all_not_demo_students', expires_in: duration) do
          Student.where(group_id: Group.where.not(demo: true)).pluck(:id)
        end
    assessment_ids =
      Rails
        .cache
        .fetch("assessments_for_test_#{cache_key_with_version}", expires_in: duration) do
          Assessment.where(test_id: self.id).pluck('id')
        end

    #Keine alten Messungen exportieren
    res =
      Result.where(
        student_id: student_ids,
        assessment_id: assessment_ids,
        test_date: '2019-09-09'..
      ).all
    csv = ''
    csv = res[0].csv_header(false) + "\n" if res.size > 0
    res.each { |r| csv = csv + r.as_csv(false) }
    return csv
  end

  #Infos über Messungen von Lehrkräften
  def self.get_statistics
    users = User.where(account_type: 0).pluck(:id)
    groups =
      Group
        .where(id: GroupShare.where(user_id: users, owner: true).pluck('group_id'))
        .where.not(demo: true)
        .pluck(:id)
    students = Student.where(group_id: groups).pluck(:id)

    tests =
      Test
        .where(id: Assessment.where(group_id: groups).pluck(:test_id))
        .order(test_family_id: :asc)
        .all
    res = []
    areas_by_month = {}
    tests.each do |t|
      assessment_ids = Assessment.where(group_id: groups, test_id: t.id).pluck('id')
      results =
        Result.where(student_id: students, assessment_id: assessment_ids, test_date: '2019-09-09'..)
      res << {
        label: t.full_name,
        count: results.count,
        groups: results.group(:assessment_id).count.keys.size,
        progressions: results.group(:student_id).having('COUNT(*) > 1').count.keys.size
      }
    end
    return res
  end

  def as_csv_file
    csv_file_path = Rails.root.join('tmp', "#{self.shorthand}.csv")
    csv_data = self.as_csv
    File.open(csv_file_path, 'w') { |file| file.write(csv_data) }
  end
end
