class Item < ApplicationRecord
  belongs_to :test

  has_many_attached :files
end
