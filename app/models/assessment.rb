class Assessment < ActiveRecord::Base
  has_many :measurements, :dependent => :destroy
  belongs_to :test
  belongs_to :group
end
