class User < ActiveRecord::Base
  has_many :groups, :dependent => :destroy

  has_secure_password

  validates_presence_of :email
  validates_uniqueness_of :email

  def isAdmin?
    return id == 1
  end
end
