# -*- encoding : utf-8 -*-
class Group < ActiveRecord::Base
  belongs_to :user
  has_many :students, :dependent => :destroy
  has_many :assessments, :dependent => :destroy

  validates_presence_of :name

  after_create :set_defaults

  def set_defaults
      self.archive ||= false
  end

end
