class Student < ApplicationRecord
  belongs_to :group

  validates_presence_of :name

  #JSON Ouput for Backend, include virtual attribute size
  def as_json(options={})
    json = super(except: [:created_at, :updated_at])
    json
  end

end
