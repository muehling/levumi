class Group < ApplicationRecord
  has_many :group_shares
  has_many :users, through: :group_shares
  has_many :students
  has_many :assessments

  validates_presence_of :label

  #Liefere Objekt für Frontend, das Group und GroupShare vereint
  def as_hash(user)
    c = group_shares.where(user: user).first  #Kombination aus User & Group muss eindeutig sein!
    data = {
        id: id,
        label: label,
        size: students.size,
        students: students,
        demo: demo,
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
