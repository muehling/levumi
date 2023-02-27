class Context < ApplicationRecord
  has_many :areas, dependent: :destroy
  has_many :competences, through: :areas
  has_many :test_families, through: :competences
  has_many :tests, through: :test_families
end
