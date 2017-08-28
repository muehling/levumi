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

  #Count number of assessments for each user by a direct SQL query, to save time. Returns a hash that maps test ids to counts.
  def self.get_assessment_count
    temp = ActiveRecord::Base.connection.exec_query("
      SELECT user_id, COUNT(*) as Anzahl
      FROM users JOIN groups ON user_id = users.id
        JOIN assessments ON group_id = groups.id
      WHERE export = 1
      GROUP BY user_id;")
    ids = temp.map{|x| x["user_id"]}
    count = temp.map{|x| x["Anzahl"]}
    return Hash[ids.zip(count)]
  end

  #Count number of measurements for each user by a direct SQL query, to save time. Returns a hash that maps test ids to counts.
  def self.get_measurement_count
    temp = ActiveRecord::Base.connection.exec_query("
      SELECT user_id, COUNT(*) as Anzahl
      FROM users JOIN groups ON user_id = users.id
        JOIN assessments ON group_id = groups.id
        JOIN measurements ON assessment_id = assessments.id
      WHERE export = 1
      GROUP BY user_id;
     ")
    ids = temp.map{|x| x["user_id"]}
    count = temp.map{|x| x["Anzahl"]}
    return Hash[ids.zip(count)]
  end

  #Count number of results for each user by a direct SQL query, to save time. Returns a hash that maps test ids to counts.
  def self.get_result_count
    temp = ActiveRecord::Base.connection.exec_query("
      SELECT user_id, COUNT(*) as Anzahl
      FROM users JOIN groups ON user_id = users.id
        JOIN assessments ON group_id = groups.id
        JOIN measurements ON assessment_id = assessments.id
        JOIN results ON measurement_id = results.id
        WHERE export = 1
        GROUP BY user_id;
    ")
    ids = temp.map{|x| x["user_id"]}
    count = temp.map{|x| x["Anzahl"]}
    return Hash[ids.zip(count)]
  end
end