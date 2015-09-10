class CreateUploads < ActiveRecord::Migration
  def change
    create_table :uploads do |t|
      t.string :file
      t.boolean :enabled, default: true
      t.boolean :explicit, :default => false
      t.string :md5
      t.string :original_filename

      t.timestamps null: false
    end
  end
end
