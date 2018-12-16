class Group < ApplicationRecord
  belongs_to :user
  has_many :students

  validates_presence_of :label

  #JSON Ouput for Backend, include virtual attribute size
  def as_json(options={})
    json = super(except: [:created_at, :user_id])
    json["size"] = size
    json
  end

  #Return number of students as virtual attribute
  def size
    self.students.count
  end
end
