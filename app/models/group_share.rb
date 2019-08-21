class GroupShare < ApplicationRecord
  belongs_to :user
  belongs_to :group

  #Hash Repräsentation für Frontend / Classbook
  def as_hash
    {id: id, user: user.email, read_only: read_only, accepted: !key.nil?}
  end
end