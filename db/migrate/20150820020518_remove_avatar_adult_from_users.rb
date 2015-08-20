class RemoveAvatarAdultFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :avatar_adult, :boolean
  end
end
