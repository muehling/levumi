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
    group_share = group_shares.where(user: user, group_id: id).first #Kombination aus User & Group muss eindeutig sein!

    data = {
      archive: archive,
      auth_token: auth_token,
      demo: demo,
      id: id,
      is_anonymous: group_share.is_anonymous,
      key: group_share.key,
      label: label,
      owner: group_share.owner,
      read_only: group_share.read_only,
      settings: settings || {},
      share_id: group_share.id,
      size: students.size,
      students: students,
      updated_at: updated_at,
      has_demo_students: !Student.where(group_id: self.id, is_demo: true).empty?
    }
    data['belongs_to'] = group_share.group.owner.email
    if group_share.owner
      data['shares'] = []
      group_shares.all.each { |c| data['shares'] += [c.as_hash] if c.user != user }
    end
    return data
  end

  #Liefert Besitzer der Klasse zurück
  def owner
    group_shares.where(owner: true).first.user
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
