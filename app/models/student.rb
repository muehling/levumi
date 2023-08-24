class Student < ApplicationRecord
  belongs_to :group
  has_many :results, dependent: :destroy

  validates_presence_of :name
  validates_uniqueness_of :login

  #Login code erzeugen. Kollisionen sind selten, daher keine vorherige Datenbankabfrage des Codes.
  after_create do |student|
    if student.login.nil? || student.login.blank?
      loop do
        student.login = (('0'..'9').to_a + ('A'..'Z').to_a).shuffle.first(6).join
        break if student.save
      end
    end
  end

  #Schattenkopie anlegen, wird im Zuge des Löschen von Results aufgerufen.
  def create_shadow
    return if ShadowStudent.find_by_original_id(self.id)

    ShadowStudent.create(
      original_id: self.id,
      account_type: self.group.owner.account_type,
      state: self.group.owner.state,
      group: self.group_id,
      gender: self.gender,
      birthmonth: self.birthmonth,
      sen: self.sen,
      tags: self.tags
    )
  end

  #JSON Export, nur relevante Attribute übernehmen. Falls zusätzliche Daten vorhanden sind, diese auch exportieren.
  def as_json(options = {})
    json = super(except: %i[created_at updated_at gender birthmonth sen tags settings])
    json['gender'] = self.gender unless self.gender.nil?
    json['birthmonth'] = I18n.l(self.birthmonth.to_date, format: '%Y-%m') unless self.birthmonth
      .nil?
    json['sen'] = self.sen unless self.sen.nil?
    json['tags'] = self.tags.nil? ? [] : self.tags
    json['settings'] = self.settings unless self.settings.nil?
    json
  end

  def tag_list
    if tags.nil?
      return ''
    else
      tags.join(',')
    end
  end

  #Setter für "birthmonth" - Damit Format "YYYY-MM" akzeptiert wird
  def birthmonth=(value)
    unless value.nil?
      val = Date.strptime(value, '%Y-%m')
      super(val)
    end
  end

  #Setter für Tags als Serialisiertes Array, das als JSON-Format geschickt wird
  def tags=(value)
    unless value.nil?
      val = JSON.parse(value)
      val.sort!
      super(val)
    end
  end

  #Liefert die aktuellen Assessments eines Schülers zurück. Archivierte Tests werden ignoriert.
  def get_assessments
    tests = Test.where(archive: false)
    all_assessments = Assessment.where(group_id: self.group_id, test_id: tests, active: true)
    week = Date.commercial(Date.today.year, Date.today.cweek)
    result = []
    puts '##################################################'
    puts all_assessments.count
    puts self.group_id
    all_assessments.each do |a|
      unless a.excludes.include?(self.id)
        result += [
          {
            id: a.id,
            test_info: a.test.info,
            open: !Result.exists?(assessment_id: a.id, student_id: self.id, test_week: week)
          }
        ]
      end
    end
    result
  end

  #Liefert den Wert einer der möglichen Einstellungen falls er existiert oder einen Defaultwert
  def get_setting(key)
    if !settings.nil? && settings.has_key?(key)
      return settings[key]
    else
      defs = {
        #Achtung: Evtl. nicht der einzige Ort an dem dieser Werte definiert werden! TODO: Lässt sich das lösen?
        'font_family' => 'Fibel Nord',
        'font_size' => 1
      }
      return defs[key]
    end
  end
end
