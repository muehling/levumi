require 'zip'

class Test < ApplicationRecord
  has_many :assessments
  belongs_to :test_family
  has_many :items

  #Zu einem Test gehörende Dateien => Active_Storage
  has_one_attached :entry_point
  has_many_attached :media_files
  has_many_attached :script_files
  has_many_attached :style_files

  #Dateien beim Löschen ebenfalls löschen
  before_destroy :purge_files

  #Entspricht dem Testnamen
  validates_presence_of :level

  #Konfiguration der Views als Hash
  serialize :configuration, Hash

  #Ggf. "veraltet" zum Namen dazufügen
  def name
    if archive then level + " (veraltet)" else level end
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
    json = super(except: [:created_at, :updated_at])
    json['area_id'] = self.test_family.competence.area.id
    json
  end

  #Ggf. zum Test gehörende Dateien löschen
  def purge_files
    entry_point.purge
    media_files.purge
    script_files.purge
    style_files.purge
  end

  #Test Objekt als Import aus ZIP-Datei erzeugen
  def self.import file, archive, create
    zip = Zip::File.open(file)
    f = zip.glob('test.json').first
    unless f.nil?
      vals = ActiveSupport::JSON.decode(f.get_input_stream.read)
      family = TestFamily.find_by_name(vals['family'])  #TODO: So müssten Familien eindeutig bennant sein. Falls ok, dann als constraint einführen
      if (family.nil? && create)
        #Benötigte Strukturen anlegen
        area = Area.find_by_name(vals['area'])
        area = Area.create(name: vals['area']) if area.nil?
        competence = Competence.find_by_name(vals['competence'])
        competence = area.competences.build(name: vals['competence']) if competence.nil?
        family = competence.test_families.build(name: vals['family'])
        family.save
      else
        unless family.nil?
          test = family.tests.find_by_level(vals['level'])
          unless test.nil?
            if archive
              test.archive = true
              test.save
            else
              return false #Test existiert bereits und soll nicht archiviert werden
            end
          end
        else
          return false  #Test kann nicht eingeordnet werden und Strukturen sollen nicht erzeugt werden
        end
      end

      #TODO: Parameter von configuration einschränken? Ggf. auch als setter?
      test = family.tests.build(vals.slice('description', 'level', 'shorthand', 'student_test', 'configuration'))

      if !test.nil? && test.save
        #Items anlegen
        vals["items"].each do |key, value|
          test.items.create(shorthand: key, description: value)
        end

        #Dateien aus ZIP lesen und zu Test dazufügen
        f = zip.glob('test.html').first

        test.entry_point.attach(io: StringIO.new(f.get_input_stream.read), filename: 'test.html', content_type: 'text/html')

        zip.glob('media/*').each do |f|
          test.media_files.attach(io: StringIO.new(f.get_input_stream.read), filename: f.name.split('/').last)
        end

        zip.glob('scripts/*').each do |f|
          test.script_files.attach(io: StringIO.new(f.get_input_stream.read), filename: f.name.split('/').last, content_type: 'text/javascript')
        end

        zip.glob('styles/*').each do |f|
          test.style_files.attach(io: StringIO.new(f.get_input_stream.read), filename: f.name.split('/').last, content_type: 'text/css')
        end

        return test

      end
    end
    return nil
  end

end
