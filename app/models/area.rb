class Area < ApplicationRecord
  has_many :competences, dependent: :destroy

  #JSON Export, nur relevante Attribute übernehmen
  def as_json(options = {})
    super(except: [:created_at, :updated_at])
  end
end
