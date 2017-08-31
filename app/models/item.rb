# -*- encoding : utf-8 -*-
class Item < ActiveRecord::Base
  belongs_to :test

  validates_presence_of :itemtext

  before_save :check_shorthand
  serialize :mediapath, Hash

  def self.xls_headings
    return %w{ID Kurztext}
  end

  def to_a
    return [id.to_s, shorthand]
  end

  private

  def check_shorthand
    if shorthand.nil? || shorthand.blank?
      self.shorthand = itemtext
    end
  end

end
