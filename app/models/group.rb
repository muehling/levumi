class Group < ApplicationRecord
  has_many :group_shares, dependent: :destroy
  has_many :users, through: :group_shares
  has_many :students, dependent: :destroy
  has_many :assessments, dependent: :destroy

  validates_presence_of :label

  #Alle "Fremd-Shares" löschen, wenn Klasse archiviert wird
  after_save { |g| GroupShare.where(group: g, owner: false).destroy_all if g.archive }

  #Liefere Objekt für Frontend, das Group und GroupShare vereint
  def as_hash(user)
    group_share = group_shares.where(user: user, group_id: id).where.not(key: nil).first #Kombination aus User & Group muss eindeutig sein!
    transfer_share = GroupShare.where(user: user, key: nil, group_id: id).first
    if !transfer_share.nil?
      has_transfer_request_to = transfer_share.user.email
    else
      has_transfer_request_to = ''
    end

    gs = has_transfer_request_to == '' ? group_share : transfer_share
    #todo nee, das geht so nicht. das frontend kriegt groupshares und tut so, als seien es groups, das kann man nicht über group.as_hash abbilden X-(
    data = {
      archive: archive,
      auth_token: auth_token,
      demo: demo,
      has_transfer_request_to: has_transfer_request_to,
      id: id,
      is_anonymous: gs.is_anonymous,
      key: gs.key,
      label: label,
      #owner: group_share.owner,
      owner: gs.user_id == user.id,
      read_only: gs.read_only,
      settings: settings || {},
      share_id: gs.id,
      size: students.size,
      students: students,
      updated_at: updated_at
    }

    # only add shares info if the user owns the group
    data['belongs_to'] = group_share.group.owner.email
    if group_share.owner
      data['shares'] = []

      group_shares.all.each { |c| data['shares'] += [c.as_hash] if c.user != user && !c.owner }
    end
    return data
  end

  #Liefert Besitzer der Klasse zurück
  def owner
    shares = group_shares.where(owner: true)
    shares.first.user
  end

  def owned_by_login(login)
    return self.owner.email == login.email
  end

  def owned_by_login(user)
    return user == owner
  end

  def read_only(user)
    group_shares.where(user: user).pluck(:read_only).first
  end

  def test_data
    return(
      {
        used_test_ids:
          Assessment
            .joins(:test)
            .where(group_id: id)
            .where.not(tests: { archive: true })
            .pluck(:test_id)
      }
    )
  end
end
