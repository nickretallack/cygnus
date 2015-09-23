class RemoveAdultFromSubmissions < ActiveRecord::Migration
  def change
    remove_column :submissions, :adult
  end
end
