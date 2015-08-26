# -*- encoding : utf-8 -*-
class Measurement < ActiveRecord::Base
  belongs_to :assessment
  has_many :results, :dependent => :destroy
  has_many :students, through: :results

  validates_presence_of :date

  default_scope {order('date DESC')}

  def prepare_test
    assessment.group.students.each do |s|
      r = results.build(student: s)
      r.initialize_results()
    end
  end

  def update_students(hash)
    hash.each do  |name, id|
      s = Student.find(id.to_i)
      if (not s.nil?) && s.name == name && s.group == assessment.group && results.where(:student_id => s.id).blank?
        r = results.build(student: s)
        r.initialize_results()
      end
    end
    students.each do |s|
      unless hash.has_key?(s.name)
        r = results.find_by_student_id(s.id)
        unless r.nil?
          r.destroy
        end
      end
    end
  end

end
