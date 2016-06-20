class News < ActiveRecord::Base

  def self.new_items(u)
    res = News.all.where(["created_at > ?", u.last_login]).map{|x| x.text}
  end
end
