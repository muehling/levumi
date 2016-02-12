# -*- encoding : utf-8 -*-
class User < ActiveRecord::Base
  has_many :groups, :dependent => :destroy

  has_secure_password

  validates_presence_of :email
  validates_uniqueness_of :email

  def hasCapability?(cap)
    return !isRegularUser? && (capabilities.include?(cap) || capabilities.include?("admin"))
  end

  def isRegularUser?
    return capabilities.nil? || capabilities.blank?
  end

  def export
    groups = Group.where(:user => self)
    students = Student.where(:group => groups)
    assessments = Assessment.where(:group => groups)
    tests = Test.where(:id => assessments.uniq.pluck(:test_id))
    items = Item.where(:test => tests)

    book = Spreadsheet::Workbook.new

    sheet = book.create_worksheet :name => 'Items'
    sheet.row(0).concat Item.xls_headings
    i = 1
    items.each do |it|
      sheet.row(i).concat it.to_a
      i = i+1
    end

    sheet = book.create_worksheet :name => 'SuS'
    sheet.row(0).concat Student.xls_headings
    i = 1
    students.find_each do |s|
      sheet.row(i).concat s.to_a
      i = i+1
    end

    assessments.each do |a|
      sheet = book.create_worksheet :name => "Assessment #{a.id}"
      sheet.row(0).push "Test"
      sheet.row(0).push a.test.long_name
      sheet.row(1).push "Klassen-Id"
      sheet.row(1).push a.group.id

      sheet.row(2).concat %w(Student)
      itemset = Item.where(:test => a.test).pluck(:id)
      sheet.row(2).concat itemset
      i = 3
      Measurement.where(:assessment => a).sort_by {|x| x.date}.each do |m|
        date = m.date.to_date.strftime("%d.%m.%Y")
        m.results.each do |r|
          sheet.row(i).push r.student.id
          sheet.row(i).concat r.to_a(itemset)
          i = i+1
        end
      end
    end

    temp = Tempfile.new("LeVuMi")
    temp.close
    book.write temp.path
    return temp.path
  end

end
