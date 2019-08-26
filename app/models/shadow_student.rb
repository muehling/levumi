class ShadowStudent < ApplicationRecord
  has_many :shadow_results, dependent: :destroy

  serialize :tags, Array
  serialize :settings, Hash
end
