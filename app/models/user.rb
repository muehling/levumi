# -*- encoding : utf-8 -*-
class User < ActiveRecord::Base
  has_many :groups, :dependent => :destroy

  has_secure_password

  validates_presence_of :email
  validates_uniqueness_of :email

  after_create :create_test_group

  def hasCapability?(cap)
    return !isRegularUser? && (capabilities.include?(cap) || capabilities.include?("admin"))
  end

  def isRegularUser?
    return capabilities.nil? || capabilities.blank?
  end

  def create_test_group
    self.groups.create(:name => "Testklasse", :export => false, :archive => false, :demo => true)
  end

  def export
    groups = Group.where(:user => self, :export => true)
    students = Student.where(:group => groups)
    assessments = Assessment.where(:group => groups)
    measurements = Measurement.where(:assessment => assessments)
    @export = Export.new
    @export.exportData(assessments, measurements)
  end
end