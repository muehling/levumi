require 'zip'

class Test < ApplicationRecord
  has_many :assessments
  belongs_to :test_family
  has_many :items

  has_one_attached :entry_point
  has_many_attached :media_files
  has_many_attached :script_files
  has_many_attached :style_files

  before_destroy :purge_files

  validates_presence_of :level

  #Ggf. "veraltet" zum Namen dazufügen
  def name
    if archive then level + " (veraltet)" else level end
  end

  #JSON Export, nur relevante Attribute übernehmen
  def as_json(options = {})
    json = super(except: [:created_at, :updated_at])
    json['area_id'] = self.test_family.competence.area.id
    json
  end

  #Remove all attached files before destroying test
  def purge_files
    entry_point.purge
    media_files.purge
    script_files.purge
    style_files.purge
  end

  #Create Test object from ZIP file
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
        family = competence.test_families.build(vals['family'])
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

      test = family.tests.build(vals.slice('description', 'level', 'shorthand', 'student_test'))
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
