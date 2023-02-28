class Annotation < ApplicationRecord
  belongs_to :assessment
  belongs_to :annotation_category
end
