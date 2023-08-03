class TestType < ApplicationRecord
  validates_uniqueness_of :name
end
