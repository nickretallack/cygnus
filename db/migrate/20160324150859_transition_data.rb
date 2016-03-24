class TransitionData < ActiveRecord::Migration
  def up
    User.where.not(avatar: nil).each do |user|
      user.update_attribute(:attachments, user.attachments << "avatar-#{user.attributes["avatar"]}")
    end
    remove_column :users, :avatar
    remove_column :users, :string
    remove_column :users, :default_order_form
    remove_column :order_forms, :user_id
  end
end
