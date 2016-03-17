class AddNameAndEmailToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :name, :string
    add_column :orders, :email, :string
  end
end
