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
    introitems = intro_items
    outroitems = outro_items
    if first
      itemset = itemset + content_items
    else
      len.times do
        remaining = items - (itemset + introitems + outroitems)
        itemset = itemset + [remaining.sample]
      end
    end
    return [introitems.map{|i| i.id}, itemset.map{|i| i.id}, outroitems.map{|i| i.id}]
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

  def export
    measurements = Measurement.where(:assessment => Assessment.where(:test => self))
    results = Result.where(:measurement => measurements)
    students = Student.where(:id => results.uniq.pluck(:student_id))

    book = Spreadsheet::Workbook.new

    sheet = book.create_worksheet :name => 'Items'
    sheet.row(0).concat Item.xls_headings
    i = 1
    content_items.each do |it|
      sheet.row(i).concat it.to_a
      i = i+1
    end

    sheet = book.create_worksheet :name => 'SuS'
    sheet.row(0).concat Student.xls_headings
    i = 1
    students.find_each do |s|
      if (s.group.export)
        sheet.row(i).concat s.to_a
        i = i+1
      end
    end

    sheet = book.create_worksheet :name => 'Alle Messungen'
    sheet.row(0).concat %w(Schüler/in Messzeitpunkt Klassen-Id Benutzer-Id)
    itemset = content_items.pluck(:id)
    sheet.row(0).concat itemset
    i = 1
    results.find_each do |r|
      if (r.measurement.assessment.group.export)
        sheet.row(i).push r.student.id
        sheet.row(i).push r.measurement.date.to_date.strftime("%d.%m.%Y")
        sheet.row(i).push r.measurement.assessment.group.id
        sheet.row(i).push r.measurement.assessment.group.user.id
        sheet.row(i).concat r.to_a(itemset)
        i = i+1
      end
    end

    measurements.sort_by { |a| a.date}.each do |m|
      if (m.assessment.group.export)
        sheet = book.create_worksheet :name => "Messung #{m.id}"
        sheet.row(0).push 'Datum'
        sheet.row(0).push m.date.to_date.strftime("%d.%m.%Y")
        sheet.row(1).push 'Benutzer-Id'
        sheet.row(1).push m.assessment.group.user.id
        sheet.row(2).push 'Klassen-Id'
        sheet.row(2).push m.assessment.group.id

        sheet.row(3).concat %w(Student)
        itemset = content_items.pluck(:id)
        sheet.row(3).concat itemset
        i = 4
        m.results.each do |r|
          sheet.row(i).push r.student.id
          sheet.row(i).concat r.to_a(itemset)
          i = i+1
        end
      end
    end

    temp = Tempfile.new('levumi')
    temp.close
    book.write temp.path
    return temp.path
  end
end
