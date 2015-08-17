class Group < ActiveRecord::Base
  belongs_to :user
  has_many :students
  has_many :assessments, :dependent => :destroy

  validates_presence_of :name

  def after_initialize
      @archive ||= false
  end

end
