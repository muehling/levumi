class Test < ApplicationRecord
  has_many :assessments
  belongs_to :test_family
  has_many :items

  #JSON Export, nur relevante Attribute übernehmen
  def as_json(options = {})
    json = super(except: [:created_at, :updated_at])
    json['area_id'] = self.test_family.competence.area.id
    json
  end


end