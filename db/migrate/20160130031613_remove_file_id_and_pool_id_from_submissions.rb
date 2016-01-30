class RemoveFileIdAndPoolIdFromSubmissions < ActiveRecord::Migration
  def change
    remove_column :submissions, :file_id, :integer
    remove_column :submissions, :pool_id, :integer
  end
end
