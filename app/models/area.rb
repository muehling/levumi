class Area < ApplicationRecord
  has_many :competences, dependent: :destroy
  has_many :test_families, through: :competences
  has_many :tests, through: :test_families

  #JSON Export, nur relevante Attribute übernehmen
  def as_json(options = {})
    super(except: %i[created_at updated_at])
  end
end
