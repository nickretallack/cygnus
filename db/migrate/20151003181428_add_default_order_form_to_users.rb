class AddDefaultOrderFormToUsers < ActiveRecord::Migration
  def change
    add_column :users, :default_order_form, :integer
  end
end
