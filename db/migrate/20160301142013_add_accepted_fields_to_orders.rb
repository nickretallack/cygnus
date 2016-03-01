class AddAcceptedFieldsToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :decided, :boolean, default: false
    add_column :orders, :accepted, :boolean, default: false
  end
end
