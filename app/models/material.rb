require 'zip'

class Material < ApplicationRecord
  has_many :material_supports
  has_many :areas, through: :material_supports
  has_many :competences, through: :material_supports
  has_many :test_families, through: :material_supports
  has_many :tests, through: :material_supports
  has_many :items, through: :material_supports

  has_many_attached :files

  #JSON Export, nur relevante Attribute übernehmen
  def as_json(options = {})
    json = super(except: [:created_at, :updated_at])
    json['files'] = self.files.map{|f| {name: f.filename, path: Rails.application.routes.url_helpers.rails_blob_path(f, only_path: true)}}
    json
  end

  #Legt neue Eintrag in material_supports an. Übergegeben werden außer für items Felder von Bezeichnern (name bzw. shorthand).
  # Für items wird ein Feld von Hashes erwartet, die jeweils item (shorthand) und test (shorthand) als keys beinhalten.
  def attach_to(areas: [], competences: [], test_families: [], tests: [], items: [])
    areas.each do |a|
      area = Area.find_by_name(a)
      MaterialSupport.create(material_id: self.id, area_id: area.id) unless area.nil?
    end
    competences.each do |c|
      competence = Competence.find_by_name(c)
      MaterialSupport.create(material_id: self.id, competence_id: competence.id) unless competence.nil?
    end
    test_families.each do |tf|
      test_family = TestFamily.find_by_name(tf)
      MaterialSupport.create(material_id: self.id, test_family_id: test_family.id) unless test_family.nil?
    end
    tests.each do |t|
      test = Test.find(shorthand: t, archive: false)
      MaterialSupport.create(material_id: self.id, test_id: test.id) unless test.nil?
    end
    items.each do |i|
      item = Item.where(shorthand: i['item'], test_id: Test.find_by_shorthand(i['test']).id)
      MaterialSupport.create(material_id: self.id, item_id: item.first.id) unless item.nil?
    end
  end

  #Material Objekt als Import aus ZIP-Datei erzeugen und passende Verknüpfungen anlegen
  def self.import file
    zip = Zip::File.open(file)
    f = zip.glob('material.json').first
    unless f.nil?
      vals = ActiveSupport::JSON.decode(f.get_input_stream.read)
      vals['elements'].each do |val|
        material = Material.create(name: val['name'], description: val['description'])
        zip.glob("files/#{val['path']}/*").each do |f|
          material.files.attach(io: StringIO.new(f.get_input_stream.read), filename: f.name.split('/').last)
        end
        material.attach_to(areas: val['areas'], competences: val['competences'], test_families: val['test_families'], tests: val['tests'], items: val['items'])
      end
     end
  end

  #Liefert die Informationen für die Material-App SPA
  def self.get_material_info
    materials = Material.all
    items = Item.where(id: MaterialSupport.all.pluck(:item_id))
    tests = (Test.where(id: MaterialSupport.all.pluck(:test_id)) + Test.where(id: items.pluck(:test_id))).uniq
    test_families = (TestFamily.where(id: MaterialSupport.all.pluck(:test_family_id)) + TestFamily.where(id: tests.pluck(:test_family_id))).uniq
    competences = (Competence.where(id: MaterialSupport.all.pluck(:competence_id)) + Competence.where(id: test_families.pluck(:competence_id))).uniq
    areas = (Area.where(id: MaterialSupport.all.pluck(:area_id)) + Area.where(id: competences.pluck(:area_id))).uniq
    {
        'materials': materials,
        'items': items,
        'tests': tests,
        'test_families': test_families,
        'competences': competences,
        'areas': areas,
        'supports': MaterialSupport.all
    }
  end
end
