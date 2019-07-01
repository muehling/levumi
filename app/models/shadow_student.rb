class ShadowStudent < ApplicationRecord
  has_many :shadow_results, dependent: :destroy

  serialize :settings, Hash
end
