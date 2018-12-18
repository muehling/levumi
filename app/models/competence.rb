class Competence < ApplicationRecord
  has_many :tests
  belongs_to :area

  #JSON Export, nur relevante Attribute übernehmen
  def as_json(options = {})
    super(except: [:created_at, :updated_at])
  end

end
