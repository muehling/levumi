class Target < ApplicationRecord
  belongs_to :assessment
  belongs_to :student, optional: true
end
