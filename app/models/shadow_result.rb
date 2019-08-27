class ShadowResult < ApplicationRecord
  belongs_to :shadow_student

  serialize :views, Hash
  serialize :report, Hash
  serialize :data, Array
end
