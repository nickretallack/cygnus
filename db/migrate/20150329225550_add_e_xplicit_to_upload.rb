class AddEXplicitToUpload < ActiveRecord::Migration
  def change
    add_column :uploads, :explicit, :boolean, :default => false
    add_column :users, :view_adult, :boolean, :default => false
  end
end
