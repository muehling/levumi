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
    group_share = group_shares.where(user: user).first #Kombination aus User & Group muss eindeutig sein!

    data = {
      id: id,
      label: label,
      size: students.size,
      students: students,
      demo: demo,
      auth_token: auth_token,
      read_only: group_share.read_only,
      is_anonymous: group_share.is_anonymous,
      archive: archive,
      updated_at: updated_at,
      key: group_share.key,
      owner: group_share.owner,
      share_id: group_share.id
    }
    data['belongs_to'] = group_share.group.owner.email
    data['shares'] = []
    group_shares.all.each { |c| data['shares'] += [c.as_hash] if c.user != user }
    return data
  end

  #Liefert Besitzer der Klasse zurück
  def owner
    group_shares.where(owner: true).first.user
  end

  def read_only(user)
    group_shares.where(user: user).pluck(:read_only).first
  end
end
