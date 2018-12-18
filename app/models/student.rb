class Student < ApplicationRecord
  belongs_to :group

  validates_presence_of :name

  #JSON Export, nur relevante Attribute übernehmen
  def as_json(options = {})
    super(except: [:created_at, :updated_at])
  end

end
