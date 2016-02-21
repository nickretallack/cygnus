class RenameUploadsToImages < ActiveRecord::Migration
  def change
    rename_table :uploads, :images
  end
end
