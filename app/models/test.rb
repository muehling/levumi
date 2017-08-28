# -*- encoding : utf-8 -*-

#TODO-A: Teststruktur überdenken?

require 'spreadsheet'

class Test < ActiveRecord::Base
  has_many :items, :dependent => :destroy
  has_many :assessments, :dependent => :destroy

  validates_presence_of :name
  validates_presence_of :subject
  validates_presence_of :construct
  validates_presence_of :level
  after_create :set_defaults

  def set_defaults
    self.archive ||= false
  end

  def content_items
    self.items.where(itemtype: 0).order(:id)
  end

  def intro_items
    self.items.where("itemtype < ?", 0).order(:itemtype)
  end

  def outro_items
    self.items.where("itemtype > ?", 0).order(:itemtype)
  end

  def draw_items(first)
    itemset = Array.new
    if first
      itemset = content_items
    else
      len.times do
        remaining = content_items - itemset
        itemset = itemset + [remaining.sample]
      end
    end
    return [intro_items.map{|i| i.id}, itemset.map{|i| i.id}, outro_items.map{|i| i.id}]
  end

  def len_info
    return "#{len} Items"
  end

  def type_info
    return 'Test'
  end

  def view_info
    return 'Test'
  end

  def long_name
    return name + ' - ' + level + ' (' + subject + ' - ' + construct + ')' + (archive ? ' - veraltet':'')
  end

  def short_name
    return name + ' - ' + level + (archive ? ' (veraltet)':'')
  end

  def toCode
    name.split(' ').map{|w| w.slice(0, 2)}.join + level.last
  end

  #Count number of assessments for each test by a direct SQL query, to save time. Returns a hash that maps test ids to counts.
  def self.get_assessment_count
    temp = ActiveRecord::Base.connection.execute("
      SELECT test_id, COUNT(*) as Anzahl
      FROM Tests JOIN Assessments ON Tests.id = test_id
        JOIN Groups ON Groups.id = group_id
      WHERE export = 't'
      GROUP BY test_id;
    ")
    ids = temp.map{|x| x["test_id"]}
    count = temp.map{|x| x["Anzahl"]}
    return Hash[ids.zip(count)]
  end

  #Count number of measurements for each test by a direct SQL query, to save time. Returns a hash that maps test ids to counts.
  def self.get_measurement_count
    temp = ActiveRecord::Base.connection.execute("
      SELECT test_id, COUNT(*) as Anzahl
      FROM Measurements JOIN Assessments ON Assessments.id = assessment_id
        JOIN Groups ON Groups.id = group_id
      WHERE export = 't'
      GROUP BY test_id;
    ")
    ids = temp.map{|x| x["test_id"]}
    count = temp.map{|x| x["Anzahl"]}
    return Hash[ids.zip(count)]
  end

  #Count number of results for each test by a direct SQL query, to save time. Returns a hash that maps test ids to counts.
  def self.get_result_count
    temp = ActiveRecord::Base.connection.execute("
      SELECT test_id, COUNT(*) as Anzahl
      FROM Results JOIN Measurements ON Measurements.id = measurement_id
        JOIN Assessments ON Assessments.id = assessment_id
        JOIN Groups ON Groups.id = group_id
      WHERE export = 't'
      GROUP BY test_id;
    ")
    ids = temp.map{|x| x["test_id"]}
    count = temp.map{|x| x["Anzahl"]}
    return Hash[ids.zip(count)]
  end
end