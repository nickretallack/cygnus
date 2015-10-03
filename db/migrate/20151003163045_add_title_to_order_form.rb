class AddTitleToOrderForm < ActiveRecord::Migration
  def change
    add_column :order_forms, :title, :string
  end
end
