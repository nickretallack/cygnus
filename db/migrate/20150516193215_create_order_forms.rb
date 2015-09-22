class CreateOrderForms < ActiveRecord::Migration
  def change
    create_table :order_forms do |t|
      t.json :content, null: false
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
