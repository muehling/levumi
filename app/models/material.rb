class Material < ActiveRecord::Base

  has_and_belongs_to_many :tests

  validates_presence_of :block
  validates_presence_of :subject
  validates_presence_of :construct
  validates_presence_of :exercisetype

  serialize :data, Array


end
