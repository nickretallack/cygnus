class CreatePools < ActiveRecord::Migration
  def change
    create_table :pools do |t|
      t.string :title
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
