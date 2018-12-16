class User < ApplicationRecord
  has_secure_password
  has_many :groups

  def students
    Student.where(group_id: self.groups).all
  end
end
