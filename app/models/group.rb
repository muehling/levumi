class Group < ApplicationRecord
  has_many :group_shares, dependent: :destroy
  has_many :users, through: :group_shares
  has_many :students, dependent: :destroy
  has_many :assessments, dependent: :destroy

  validates_presence_of :label


  #Alle "Fremd-Shares" löschen, wenn Klasse archiviert wird
  after_save do |g|
    if g.archive
      GroupShare.where(group: g, owner: false).destroy_all
    end
  end

  #Alle Einträge aus Share löschen, bevor Klasse gelöscht wird
  before_destroy do |g|
    GroupShare.where(group: g).destroy_all
  end

  #Liefere Objekt für Frontend, das Group und GroupShare vereint
  def as_hash(user)
    c = group_shares.where(user: user).first  #Kombination aus User & Group muss eindeutig sein!
    data = {
        id: id,
        label: label,
        size: students.size,
        students: students,
        demo: demo,
        auth_token: auth_token,
        read_only: c.read_only,
        archive: archive,
        updated_at: updated_at,
        key: c.key,
        owner: c.owner,
        share_id: c.id
    }
    data['belongs_to'] = c.group.owner.email
    data['shares'] = []
    group_shares.all.each do |c|
      if c.user != user
        data['shares'] += [c.as_hash]
      end
    end
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
