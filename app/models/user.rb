class User < ActiveRecord::Base
  has_many :groups

  has_secure_password

end
