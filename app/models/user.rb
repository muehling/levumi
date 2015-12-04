# -*- encoding : utf-8 -*-
class User < ActiveRecord::Base
  has_many :groups, :dependent => :destroy

  has_secure_password

  validates_presence_of :email
  validates_uniqueness_of :email

  def hasCapability?(cap)
    return !capabilities.nil? && (capabilities.include?(cap) || capabilities.include?("admin"))
  end
end
