# -*- encoding : utf-8 -*-
class Item < ActiveRecord::Base
  belongs_to :test

  validates_presence_of :itemtext

  before_save :check_shorthand

  private

  def check_shorthand
    if shorthand.nil? || shorthand.blank?
      self.shorthand = itemtext
    end
  end

end
