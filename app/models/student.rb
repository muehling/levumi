class Student < ApplicationRecord
  belongs_to :group
  has_many :results

  validates_presence_of :name
  validates_uniqueness_of :login

  #Login code erzeugen. Kollisionen sind selten, daher keine vorherige Datenbankabfrage des Codes.
  after_create do |student|
    if student.login.nil? || student.login.blank?
      loop do
        student.login = (('0'..'9').to_a + ('a'..'z').to_a).shuffle.first(6).join
        break if student.save
      end
    end
  end

  #JSON Export, nur relevante Attribute übernehmen. Falls zusätzliche Daten vorhanden sind, diese auch exportieren.
  def as_json(options = {})
    json = super(except: [:created_at, :updated_at, :gender, :birthmonth, :sen, :migration])
    json['gender'] = self.gender unless self.gender.nil?
    json['birthmonth'] = I18n.l(self.birthmonth.to_date, format: '%b %Y') unless self.birthmonth.nil?
    json['sen'] = self.sen unless self.sen.nil?
    json['migration'] = (self.migration ? 1 : 0) unless self.migration.nil?
    json
  end

  #Setter für "birthmonth" - Damit Format "YYYY-MM" akzeptiert wird
  def birthmonth=(value)
    val = Date.strptime(value, '%Y-%m')
    super(val)
  end

  #Finde alle aktuell verfügbaren Tests für die Schüleransicht
  def available_tests
    res = Result.where("student_id = ? AND expires_on >= ? AND test_date IS NULL", self.id, Date.today).order(expires_on: :asc)
    res = res.select {|r| r.assessment.test.student_test}
    return res
  end
end
