class Test < ApplicationRecord
  has_many :assessments
  belongs_to :competence

end
