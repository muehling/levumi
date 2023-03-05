class Competence < ApplicationRecord
  has_many :test_families, dependent: :destroy
  belongs_to :area
  has_many :tests, through: :test_families

  #JSON Export, nur relevante Attribute übernehmen
  def as_json(options = {})
    super(except: %i[created_at updated_at])
  end
end
