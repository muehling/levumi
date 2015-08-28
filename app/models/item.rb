# -*- encoding : utf-8 -*-
class Item < ActiveRecord::Base
  belongs_to :test

  validates_presence_of :itemtext

  before_save :check_shorthand

  private

  def check_shorthand
    if shorthand.nil? || shorthand.blank?
      if itemtext.length > 5
        self.shorthand = itemtext[0..4]
      else
        self.shorthand = itemtext
      end
    end
  end

end
