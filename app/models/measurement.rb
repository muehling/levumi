class Measurement < ActiveRecord::Base
  belongs_to :assessment
  has_many :results, :dependent => :destroy
  has_many :students, through: :results

  validates_presence_of :date
end
