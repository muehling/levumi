# -*- encoding : utf-8 -*-

#TODO-A: Teststruktur überdenken?

require 'spreadsheet'

class Test < ActiveRecord::Base
  has_many :items, :dependent => :destroy
  has_many :assessments, :dependent => :destroy
  has_and_belongs_to_many :materials

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
    if first                          #Erste Ziehung: Feste Reihenfolge (nach ID in Datenbank)
      itemset = content_items
    else
      content_items.length.times do   # Folgende Ziehungen: Zufällig permutieren
        remaining = content_items - itemset
        itemset = itemset + [remaining.sample]
      end
    end
    return [intro_items.map{|i| i.id}, itemset.map{|i| i.id}, outro_items.map{|i| i.id}]
  end

  def len_info
    if time.nil?
      return "#{len} Items"
    else
      return "#{time} Sekunden, max. #{len} Items"
    end
  end


  def view_info
    return 'Generisch'
  end

  def long_name
    return name + ' - ' + level + ' (' + subject + ' - ' + construct + ')' + (archive ? ' - veraltet':'')
  end

  def short_name
    return name + ' - ' + level + (archive ? ' (veraltet)':'')
  end

  def code
    name.split(' ').map{|w| w.slice(0, 2)}.join + level.last
  end

  #Count number of assessments for each test by a direct SQL query, to save time. Returns a hash that maps test ids to counts.
  def self.get_assessment_count
    temp = ActiveRecord::Base.connection.exec_query("
      SELECT test_id, COUNT(*) as Anzahl
      FROM tests JOIN assessments ON tests.id = test_id
        JOIN groups ON groups.id = group_id
        JOIN users ON users.id = user_id
      WHERE export = 1
      GROUP BY test_id;
    ")
    ids = temp.map{|x| x["test_id"]}
    count = temp.map{|x| x["Anzahl"]}
    return Hash[ids.zip(count)]
  end

  #Count number of measurements for each test by a direct SQL query, to save time. Returns a hash that maps test ids to counts.
  def self.get_measurement_count
    temp = ActiveRecord::Base.connection.exec_query("
      SELECT test_id, COUNT(*) as Anzahl
      FROM measurements JOIN assessments ON assessments.id = assessment_id
        JOIN groups ON groups.id = group_id
        JOIN users ON users.id = user_id
      WHERE export = 1
      GROUP BY test_id;
    ")
    ids = temp.map{|x| x["test_id"]}
    count = temp.map{|x| x["Anzahl"]}
    return Hash[ids.zip(count)]
  end

  #Count number of results for each test by a direct SQL query, to save time. Returns a hash that maps test ids to counts.
  def self.get_result_count
    temp = ActiveRecord::Base.connection.exec_query("
      SELECT test_id, COUNT(*) as Anzahl
      FROM results JOIN measurements ON measurements.id = measurement_id
        JOIN assessments ON assessments.id = assessment_id
        JOIN groups ON groups.id = group_id
        JOIN users ON users.id = user_id
      WHERE export = 1
      GROUP BY test_id;
    ")
    ids = temp.map{|x| x["test_id"]}
    count = temp.map{|x| x["Anzahl"]}
    return Hash[ids.zip(count)]
  end
end