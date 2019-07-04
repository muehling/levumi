class MaterialSupport < ApplicationRecord
  belongs_to :material
  belongs_to :area, optional: true
  belongs_to :competence, optional: true
  belongs_to :test_family, optional: true
  belongs_to :test, optional: true
  belongs_to :item, optional: true
end