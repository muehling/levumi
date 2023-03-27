require 'zip'

class Test < ApplicationRecord
  # Muss vor has_many stehen, da ansonsten die Kindelemente schon vor before_destroy gelöscht werden und ShadowResults angelegt werden.
  before_destroy :cleanup

  has_many :assessments, dependent: :destroy
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

  #JSON Export, nur relevante Attribute übernehmen
  def as_json(options = {})
    json = super(except: %i[created_at updated_at])
    json['area_id'] = self.test_family.competence.area.id
    json['competence_id'] = self.test_family.competence.id
    json['label'] =
      self.archive ? "Bis #{I18n.localize(self.updated_at, format: '%B %Y')}" : 'Aktuell'
    json['full_name'] = self.test_family.name + ' - ' + self.level
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
  def self.import(file, archive, update_material)
    #Infos aus ZIP lesen
    begin
      zip = Zip::File.open(file)
    rescue StandardError
      return nil
    end
    f = zip.glob('test.json').first
    unless f.nil?
      #Benötigte Strukturen finden / erzeugen
      vals = ActiveSupport::JSON.decode(f.get_input_stream.read)

      #Automatische Archivierung
      old_test = Test.where(shorthand: vals['shorthand']).where.not(archive: true).first
      unless old_test.nil?
        if old_test.version < vals['version']
          #Falls kleiner Version, automatisch archivert.
          old_test.archive = true
          old_test.save
        elsif old_test.version > vals['version']
          #Ältere Version darf neuere nicht ersetzen.
          return nil
        end
      end

      #Ggf. benötigte Strukturen anlegen
      area = Area.find_by_name(vals['area'])
      area = Area.create(name: vals['area']) if area.nil?
      competence = area.competences.find_by_name(vals['competence'])
      competence = area.competences.build(name: vals['competence']) if competence.nil?
      family = competence.test_families.find_by_name(vals['family'])
      family = competence.test_families.build(name: vals['family']) if family.nil?

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
              'configuration'
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
            'configuration'
          )
        )
      end
      test.items = vals['items']

      if !test.nil? && test.save
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
        test.entry_point.attach(
          io: StringIO.new(f.get_input_stream.read),
          filename: 'test.html',
          content_type: 'text/html'
        )

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
              filename: f.name.split('/').last,
              content_type: 'text/javascript'
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

        return test
      end
    end
    return nil
  end

  #Gibt es (exportierbare) Ergebnisse?
  def has_results
    student_ids =
      Rails
        .cache
        .fetch('all_not_demo_students', expires_in: 24.hours) do
          Student.where(group_id: Group.where.not(demo: true)).pluck(:id)
        end
    assessment_ids = Assessment.where(test_id: self.id).pluck('id')
    Rails
      .cache
      .fetch("has_results_#{cache_key_with_version}", expires_in: 24.hours) do
        Result.where(
          student_id: student_ids,
          assessment_id: assessment_ids,
          test_date: '2019-09-09'..
        ).exists?
      end
  end

  #Alle Ergebnisse eines Tests als CSV-Export
  def as_csv
    student_ids =
      Rails
        .cache
        .fetch('all_not_demo_students', expires_in: 24.hours) do
          Student.where(group_id: Group.where.not(demo: true)).pluck(:id)
        end
    assessment_ids =
      Rails
        .cache
        .fetch("assessments_for_test_#{cache_key_with_version}", expires_in: 24.hours) do
          Assessment.where(test_id: self.id).pluck('id')
        end

    #Keine alten Messungen exportieren
    res =
      Result
        #.where("test_date > '2019-09-09'")
        .where(student_id: student_ids, assessment_id: assessment_ids, test_date: '2019-09-09'..)
        .all
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
end
