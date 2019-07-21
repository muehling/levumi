class MaterialSupport < ApplicationRecord
  belongs_to :material
  belongs_to :area, optional: true
  belongs_to :competence, optional: true
  belongs_to :test_family, optional: true
  belongs_to :test, optional: true
  belongs_to :item, optional: true

  def as_json(options = {})
    json = super(except: [:created_at, :updated_at])
    #Fiktive "test_id" exportieren, um Bezug zu Item zu haben
    unless self.item_id.nil?
      json[:test_id] = self.item.test.id
    end
    json
  end

end