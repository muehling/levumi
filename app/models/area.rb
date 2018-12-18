class Area < ApplicationRecord
  has_many :competences

  #JSON Export, nur relevante Attribute übernehmen
  def as_json(options = {})
    super(except: [:created_at, :updated_at])
  end
end
