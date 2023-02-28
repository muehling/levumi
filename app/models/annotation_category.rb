class AnnotationCategory < ApplicationRecord
  validates_uniqueness_of :name
end
