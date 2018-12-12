class Student < ApplicationRecord
  belongs_to :group

  #JSON Ouput for Backend, include virtual attribute size
  def as_json(options={})
    json = super(except: [:created_at, :updated_at])
    json
  end

end
