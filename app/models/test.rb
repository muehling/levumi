require 'zip'

class Test < ApplicationRecord
  has_many :assessments, dependent: :destroy
  belongs_to :test_family
  has_many :items, dependent: :destroy

  #Zu einem Test gehörende Dateien => Active_Storage
  has_one_attached :entry_point
  has_many_attached :media_files
  has_many_attached :script_files
  has_many_attached :style_files

  #Dateien beim Löschen ebenfalls löschen
  before_destroy :purge_files

  #Entspricht dem Testnamen
  validates_presence_of :level
  validates_uniqueness_of :shorthand, conditions: -> { where.not(archive: true) }

  #Konfiguration der Views und Beschreibung als Hash
  serialize :configuration, Hash
  serialize :description, Hash

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
    json['label'] = self.archive ? "Bis #{self.updated_at.strftime("%b %y")}" : 'Aktuell'
    json['full_name'] = self.test_family.name + ' - ' + self.level
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
  def self.import file, archive, update, create
    zip = Zip::File.open(file)
    f = zip.glob('test.json').first
    old_test = nil
    unless f.nil?
      vals = ActiveSupport::JSON.decode(f.get_input_stream.read)
      family = TestFamily.find_by_name(vals['family'])
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
          old_test = family.tests.where(level: vals['level']).where.not(archive: true).first
          unless old_test.nil?
            if archive
              old_test.archive = true
              old_test.save
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

      #MaterialSupport Einträge für neue Version kopieren
      if update && !old_test.nil?
        todo = MaterialSupport.where(test_id: old_test.id)
        todo.each do |m|
          MaterialSupport.create(test_id: test.id, item_id: m.item_id, test_family_id: m.test_family_id, competence_id: m.competence_id, area_id: m.area_id, material_id: m.material_id)
        end
      end

      if !test.nil? && test.save
        #Items anlegen
        vals["items"].each do |key, value|
          new_item = test.items.create(shorthand: key, description: value)
          if update && !old_test.nil?
            item = old_test.items.find_by_shorthand(key)
            todo = MaterialSupport.where(item_id: item.id)
            todo.each do |m|
              MaterialSupport.create(test_id: m.test_id, item_id: new_item.id, test_family_id: m.test_family_id, competence_id: m.competence_id, area_id: m.area_id, material_id: m.material_id)
            end
          end
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
