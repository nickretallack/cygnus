class AddSettingsToUsers < ActiveRecord::Migration
  def change
    remove_column :users, :view_adult, :boolean, default: false
    add_column :users, :settings, :json, default: {}
  end
end
