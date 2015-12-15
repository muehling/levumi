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

  def real_results
    x = results.map{|f| f.score} - [nil]
    return x.count
  end

  def average
    return ((results.map{|f| f.score.nil? ? 0 : f.score}.sum).to_f/real_results).round(1)
  end

  def self.xls_headings
    return %w{Student}
  end

  def to_a
    return [id.to_s, get_gender(true), get_birthdate(true), get_specific_needs(true), get_migration(true)]
  end
end
