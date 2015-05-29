class AddMd5ToUploads < ActiveRecord::Migration
  def change
    add_column :uploads, :md5, :string
  end
end
