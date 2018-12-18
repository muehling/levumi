class Group < ApplicationRecord
  belongs_to :user
  has_many :students

  validates_presence_of :label

  #JSON Export, nur relevante Attribute übernehmen
  def as_json(options = {})
    json = super(except: [:created_at, :user_id])
  end

end
