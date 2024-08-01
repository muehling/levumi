class GroupShare < ApplicationRecord
  belongs_to :user
  belongs_to :group

  #Hash Repräsentation für Frontend / Classbook
  def as_hash
    {
      id: id,
      user: user.email,
      read_only: read_only,
      is_anonymous: is_anonymous,
      owner: owner,
      accepted: !key.nil?
    }
  end
end
