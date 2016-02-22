class AddHiddenToSubmissions < ActiveRecord::Migration
  def change
    add_column :submissions, :hidden, :boolean, default: true
  end
end
