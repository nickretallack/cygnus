class ChangeDefaultValueOnOrderFormsContent < ActiveRecord::Migration
  def change
    remove_column :order_forms, :content, :json, null: false
    add_column :order_forms, :content, :json, default: []
  end
end
