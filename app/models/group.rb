class Group < ActiveRecord::Base
  belongs_to :user
  has_many :students

  validates_presence_of :name
end
