class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :passwod_digest
      t.string :email
      t.integer :level, default: 0, value: 0
      t.inet :ip_Address

      t.timestamps null: false
    end
  end
end
