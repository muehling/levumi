class Measurement < ActiveRecord::Base
  belongs_to :assessment
  has_many :results
  has_many :students, through: :results
end
