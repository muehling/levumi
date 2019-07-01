class TestFamily < ApplicationRecord
  belongs_to :competence
  has_many :tests, dependent: :destroy

  #Damit Auto-Archivierung funktioniert
  validates_uniqueness_of :name

  #JSON Export, nur relevante Attribute übernehmen
  def as_json(options = {})
    super(except: [:created_at, :updated_at])
  end
end
