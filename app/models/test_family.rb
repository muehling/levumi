class TestFamily < ApplicationRecord
  belongs_to :competence
  has_many :tests, dependent: :destroy

  #JSON Export, nur relevante Attribute übernehmen
  def as_json(options = {})
    super(except: %i[created_at updated_at])
  end
end
