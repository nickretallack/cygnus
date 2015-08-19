class AddAvatarAdultToUsers < ActiveRecord::Migration
  def change
    add_column :users, :avatar_adult, :boolean
  end
end
