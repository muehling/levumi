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
    infos = []
    assessment = Assessment.where(group: self.group)
    assessment.each do |a|
      if a.test.student_test
        results = Result.where(assessment: a, student: self)
        create = true
        results.each do |r|
          if r.test_date.nil?
            infos += [{'id': r.id, 'student': r.student_id, 'assessment': r.assessment.id, 'area': r.assessment.test.test_family.competence.area.name, 'competence': r.assessment.test.test_family.competence.name, 'family': r.assessment.test.test_family.name, 'level': r.assessment.test.level}]
            create = false
          else
            if r.test_week == Date.commercial(Date.today.year, Date.today.cweek)
              create = false
            end
          end
        end
        if create
          r = Result.create(assessment: a, student: self)
          infos += [{'id': r.id, 'student': r.student_id, 'assessment': r.assessment.id, 'area': r.assessment.test.test_family.competence.area.name, 'competence': r.assessment.test.test_family.competence.name, 'family': r.assessment.test.test_family.name, 'level': r.assessment.test.level}]
        end
      end
     end
    return infos
  end
end
