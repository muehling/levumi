require 'zip'

class Material < ApplicationRecord
  has_many :material_supports, dependent: :destroy
  has_many :areas, through: :material_supports
  has_many :competences, through: :material_supports
  has_many :test_families, through: :material_supports
  has_many :tests, through: :material_supports
  has_many :items, through: :material_supports

  has_many_attached :files

  validates_uniqueness_of :name

  #JSON Export, nur relevante Attribute übernehmen
  def as_json(options = {})
    json = super(except: %i[created_at updated_at])
    json['files'] =
      self.files.map do |f|
        {
          name: f.filename,
          path: Rails.application.routes.url_helpers.rails_blob_path(f, only_path: true)
        }
      end
    json
  end

  #Legt neue Eintrag in material_supports an. Übergegeben werden außer für items Felder von Bezeichnern (name bzw. shorthand).
  # Für items wird ein Feld von Hashes erwartet, die jeweils item (shorthand) und test (shorthand) als keys beinhalten.
  def attach_to(areas: [], competences: [], test_families: [], tests: [], groups: [], items: [])
    areas.each do |a|
      area = Area.find_by_name(a)
      MaterialSupport.create(material_id: self.id, area_id: area.id) unless area.nil?
    end
    competences.each do |c|
      competence = Competence.find_by_name(c)
      unless competence.nil?
        MaterialSupport.create(material_id: self.id, competence_id: competence.id)
      end
    end
    test_families.each do |tf|
      test_family = TestFamily.find_by_name(tf)
      unless test_family.nil?
        MaterialSupport.create(material_id: self.id, test_family_id: test_family.id)
      end
    end
    tests.each do |t|
      test = Test.where(shorthand: t, archive: false).first
      MaterialSupport.create(material_id: self.id, test_id: test.id) unless test.nil?
    end
    items.each do |i|
      test = Test.find_by_shorthand(i['test'])
      unless test.nil?
        MaterialSupport.create(material_id: self.id, test_id: test.id, items: i['items'])
      end
    end
    groups.each do |g|
      test = Test.find_by_shorthand(g['test'])
      unless test.nil?
        MaterialSupport.create(material_id: self.id, test_id: test.id, group: g['group'])
      end
    end
  end

  #Material Objekt als Import aus ZIP-Datei erzeugen und passende Verknüpfungen anlegen, vorhandenes Material ggf. vorher löschen
  def self.import(file, replace)
    begin
      zip = Zip::File.open(file)
    rescue StandardError
      return nil
    end

    f = zip.glob('material.json').first
    unless f.nil?
      vals = ActiveSupport::JSON.decode(f.get_input_stream.read)
      vals['elements'].each do |val|
        material = Material.where(name: val['name']).first
        material.destroy unless (material.nil? || !replace)
        material = Material.create(val.slice('name', 'description'))
        zip
          .glob("#{val['path']}/*")
          .each do |f|
            material.files.attach(
              io: StringIO.new(f.get_input_stream.read),
              filename: f.name.split('/').last
            )
          end
        material.attach_to(
          areas: val['areas'],
          competences: val['competences'],
          test_families: val['test_families'],
          tests: val['tests'],
          groups: val['groups'],
          items: val['items']
        )
      end
    end
  end

  #Liefert die Informationen für die Material-App SPA
  def self.get_material_info
    materials = Material.all
    tests = Test.where(id: MaterialSupport.all.pluck(:test_id)).where.not(archive: true)
    test_families =
      (
        TestFamily.where(id: MaterialSupport.all.pluck(:test_family_id)) +
          TestFamily.where(id: tests.pluck(:test_family_id))
      ).uniq
    competences =
      (
        Competence.where(id: MaterialSupport.all.pluck(:competence_id)) +
          Competence.where(id: test_families.pluck(:competence_id))
      ).uniq
    areas =
      (
        Area.where(id: MaterialSupport.all.pluck(:area_id)) +
          Area.where(id: competences.pluck(:area_id))
      ).uniq
    {
      'materials': materials,
      'tests': tests,
      'test_families': test_families,
      'competences': competences,
      'areas': areas,
      'supports': MaterialSupport.all
    }
  end

  #Vorschläge für Fördermateiral generieren
  def self.get_suggestions(test, group)
    students = Student.where(group_id: group)
    assessment = Assessment.where(test_id: test, group_id: group).first
    test = Test.find(test)

    generic_supports =
      MaterialSupport.where(area_id: test.test_family.competence.area.id) +
        MaterialSupport.where(competence_id: test.test_family.competence.id) +
        MaterialSupport.where(test_family_id: test.test_family.id) +
        MaterialSupport.where(test_id: test.id)

    result = []
    students.each do |s|
      generic = []
      last_results =
        Result
          .where(student_id: s.id, assessment_id: assessment.id)
          .order(test_week: :desc)
          .limit(6)
          .all
      if last_results.size > 1 && last_results[0].get_trend < 0
        #Fall 1: Letzte Testung war schlechter => Förderung vorschlagen
        generic = Material.find(generic_supports.map { |sup| sup.material_id })
      elsif last_results.size > 2 && last_results[0].get_trend == 0 &&
            last_results[1].get_trend == 0
        #Fall 2: Letzte beide Testungen ohne Zuwachs => Förderung vorschlagen
        generic = Material.find(generic_supports.map { |sup| sup.material_id })
      end

      #Zusätzlich: Items aus den letzten Testungen identifizieren
      item_map = {}
      last_results.each do |r|
        r.get_support_items.each do |i|
          if item_map.has_key?(i)
            item_map[i] += 1
          else
            item_map[i] = 1
          end
        end
      end
      specific = []

      #Zusätzlich: Alle Items, die mindestens 3 Mal in supports auftauchen
      item_map.each do |k, v|
        if v > 2
          todo = MaterialSupport.where(test_id: test.id).where.not(items: nil)
          todo.each do |m|
            specific = specific + [Material.find(m.material_id)] unless m.items.index(k).nil?
          end
        end
      end
      specific = specific.uniq
      generic = generic.uniq - specific
      result += [
        {
          student: s.id,
          materials:
            specific.uniq.map { |entry| { specific: true, material: entry } } +
              generic.uniq.map { |entry| { specific: false, material: entry } }
        }
      ] if (specific + generic).size > 0
    end
    result
  end
end
