class AddDetailsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :gallery, :string
    add_column :users, :price, :string
    add_column :users, :details, :text
    add_column :users, :commissions, :boolean
    add_column :users, :trades, :boolean
    add_column :users, :requests, :boolean
  end
end
