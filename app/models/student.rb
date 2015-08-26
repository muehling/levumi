# -*- encoding : utf-8 -*-
class Student < ActiveRecord::Base
  belongs_to :group
  has_many :results, :dependent => :destroy

  validates_presence_of :name

  def self.import(file, group)
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    header.each{|h| h.downcase!}
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      student = group.students.build(name: row["name"], firstname: row["vorname"])
      student.save!
    end
  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
      when ".csv" then Roo::CSV.new(file.path)
      when ".xls" then Roo::Excel.new(file.path, file_warning: :ignore)
      else raise "Unknown file type: #{file.original_filename}"
    end
  end

  def getResults
    tests = Hash.new()
    items = Hash.new()
    results.each do |r|
      test = r.measurement.assessment.test.id
      if tests.has_key?(test)
        tests[test] = tests[test] + [r]
      else
        tests[test] = [r]
      end
      r.results.each do |item, val|
        if items.has_key?(item)
          items[item]["freq"] = items[item]["freq"] + 1
          items[item]["cor"] = items[item]["cor"] + (val == "0" ? 0 : 1)
          items[item]["prob"] = items[item]["cor"].to_f / items[item]["freq"]
          items[item]["dates"] = items[item]["dates"] + [r.measurement.date]
        else
          items[item] = {"freq" => 1,"cor" => val.to_i, "prob" => val.to_i, "dates" => [r.measurement.date]}
        end
      end
    end
    return tests
  end

  def getTestResults(test_id)
    items = Hash.new()
    results.each do |r|
      if test_id == r.measurement.assessment.test.id
        r.results.each do |item, val|
          if items.has_key?(item)
            items[item]["freq"] = items[item]["freq"] + 1
            items[item]["cor"] = items[item]["cor"] + (val == "0" ? 0 : 1)
            items[item]["prob"] = items[item]["cor"].to_f / items[item]["freq"]
            items[item]["dates"] = items[item]["dates"] + [r.measurement.date]
          else
            items[item] = {"freq" => 1,"cor" => val.to_i, "prob" => val.to_i, "dates" => [r.measurement.date]}
          end
        end
      end
    end
    probs = []
    items.each do |key, val|
      probs = probs + [val["prob"]]
    end
    probs.sort!
    return {"1st" => probs[probs.size/4], "4th" => probs[3*probs.size/4], "data" => items}
  end

  def fullName
    if firstname.blank?
      return name
    else
      return name + ", " + firstname
    end
  end

end
