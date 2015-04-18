class CreateSubmissions < ActiveRecord::Migration
  def change
    create_table :submissions do |t|
      t.string :title
      t.boolean :adult
      t.integer :file_id
      t.integer :pool_id

      t.timestamps null: false
    end
  end
end
