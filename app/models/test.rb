class Test < ActiveRecord::Base
  has_many :items
  has_many :assessments

end
