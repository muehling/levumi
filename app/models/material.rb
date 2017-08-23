class Material < ActiveRecord::Base

  validates_presence_of :block
  validates_presence_of :subject
  validates_presence_of :construct
  validates_presence_of :exercisetype

  serialize :data, Array


end
