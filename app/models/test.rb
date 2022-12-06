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
        if old_test.version < vals['version'] || archive
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
        f = zip.glob('test.html').first
        test.entry_point.purge if old_test == test
        test.entry_point.attach(
          io: StringIO.new(f.get_input_stream.read),
          filename: 'test.html',
          content_type: 'text/html'
        )

        test.media_files.purge if old_test == test
        zip
          .glob('media/*')
          .each do |f|
            test.media_files.attach(
              io: StringIO.new(f.get_input_stream.read),
              filename: f.name.split('/').last
            )
          end

        test.info_files.purge if old_test == test
        zip
          .glob('info/*')
          .each do |f|
            test.info_files.attach(
              io: StringIO.new(f.get_input_stream.read),
              filename: f.name.split('/').last
            )
          end

        test.script_files.purge if old_test == test
        zip
          .glob('scripts/*')
          .each do |f|
            test.script_files.attach(
              io: StringIO.new(f.get_input_stream.read),
              filename: f.name.split('/').last,
              content_type: 'text/javascript'
            )
          end

        test.style_files.purge if old_test == test
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
    s = Student.where(group_id: Group.where.not(demo: true)).select('id').pluck(:id) #Keine Demoklassen exportieren

    #Keine alten Messungen exportieren
    Result
      .where("test_date > '2019-09-09'")
      .where(student_id: s, assessment_id: Assessment.where(test_id: self.id).select('id'))
      .count > 0
  end

  #Alle Ergebnisse eines Tests als CSV-Export
  def as_csv
    s = Student.where(group_id: Group.where.not(demo: true)).select('id').pluck(:id) #Keine Demoklassen exportieren

    #Keine alten Messungen exportieren
    res =
      Result
        .where("test_date > '2019-09-09'")
        .where(student_id: s, assessment_id: Assessment.where(test_id: self.id).select('id'))
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
        .where(id: GroupShare.where(user_id: users, owner: true).select('group_id'))
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
      results =
        Result
          .where("test_date > '2019-09-09'")
          .where(
            student_id: students,
            assessment_id: Assessment.where(group_id: groups, test_id: t.id).pluck('id')
          )
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
