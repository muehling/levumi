class Group < ApplicationRecord
  belongs_to :user
  has_many :students
  has_many :assessments

  validates_presence_of :label

  #JSON Export, nur relevante Attribute übernehmen, size als zusätzliches Attribut einfügen
  def as_json(options = {})
    json = super(except: [:created_at, :user_id])
    json['size'] = self.students.size
    json
  end

end
