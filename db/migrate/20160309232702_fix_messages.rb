class FixMessages < ActiveRecord::Migration
  def change
    add_column :messages, :attachments, :string, array: true, default: []
  end
end
