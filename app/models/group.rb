class Group < ApplicationRecord
  belongs_to :user
  has_many :students
  has_many :assessments

  validates_presence_of :label

  #JSON Export, nur relevante Attribute übernehmen
  def as_json(options = {})
    json = super(except: [:created_at, :user_id])
  end

  def get_home_info

    #
    # TODO: Ggf. Attribute einschränken oder nach user verschieben um Redundnaz zu vermeiden...?
    #

    all_tests = Test.all.pluck(:id)
    used_tests = Test.where(id: self.assessments.map{|a| a.test.id})
    unused_tests = Test.where(id: all_tests - self.assessments.map{|a| a.test.id})

    all_competences = Competence.all.pluck(:id)
    used_competences = Competence.where(id: used_tests.map{|t| t.competence.id})
    unused_competences = Competence.where(id: all_competences - used_tests.map{|t| t.competence.id})

    all_areas = Area.all.pluck(:id)
    used_areas = Area.where(id: used_competences.map{|c| c.area.id})
    unused_areas = Area.where(id: all_areas - used_competences.map{|c| c.area.id})

    return {
        areas: used_areas.map{|a| {info: a, used: true}} + unused_areas.map{|a| {info: a, used: false}},
        competences: used_competences.map{|c| {info: c, used: true}} + unused_competences.map{|c| {info: c, used: false}},
        tests: used_tests.map{|t| {info: t, used: true}} + unused_tests.map{|t| {info: t, used: false}}
    }
  end
end
