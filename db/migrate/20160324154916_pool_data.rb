class PoolData < ActiveRecord::Migration
  def up
    Pool.where.not(user_id: nil).each do |pool|
      user = User.find_by(id: pool.attributes["user_id"])
      user.update_attribute(:attachments, user.attachments << "pool-#{pool.attributes["id"]}")
    end
    Pool.where(title: "Gallery").each do |pool|
      pool.update_attribute(:title, "gallery")
    end
    remove_column :pools, :user_id, :integer
  end
end
