class ShadowResult < ApplicationRecord
  belongs_to :shadow_student

  serialize :results, Hash
  serialize :data, Array
end
