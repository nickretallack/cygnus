class SetUpAssociations < ActiveRecord::Migration
  def up
    rename_table :attachments, :associations
    remove_column :associations, :parent_id, :integer
    add_column :associations, :parent_ids, :integer, array: true, default: []

    Submission.where.not(file_id: nil).each do |submission|
      Association.new(parent_model: "submission", parent_id: [submission.id], child_model: "image", child_id: submission.file_id).save!
    end
    remove_column :submissions, :file_id, :integer

    Submission.where.not(pool_id: nil).each do |submission|
      Association.new(parent_model: "pool", parent_id: [submission.pool_id], child_model: "submission", child_id: submission.id).save!
    end
    remove_column :submissions, :pool_id, :integer

    Pool.where.not(user_id: nil).each do |pool|
      Association.new(parent_model: "user", parent_id: [pool.user_id], child_model: "pool", child_id: pool.id).save!
    end
    remove_column :pools, :user_id, :integer

    User.where.not(avatar: nil).each do |user|
      Association.new(parent_model: "user", parent_id: [user.id], child_model: "image", child_id: user.avatar).save!
    end
    remove_column :users, :avatar, :integer

    remove_column :users, :default_order_form
    add_column :users, :order_forms, :integer, array: true, default: []

    remove_column :users, :string
    drop_table :comments

    Card.where.not(user_id: nil).each do |card|
      Association.new(parent_model: "user", parent_id: [card.user_id], child_model: "card", child_id: card.id).save!
    end
    remove_column :cards, :user_id

    Card.where.not(file_id: nil).each do |card|
      Association.new(parent_model: "card", parent_id: [card.id], child_model: "image", child_id: card.file_id).save!
    end
    remove_column :cards, :file_id
  end

  def down
    add_column :cards, :file_id, :integer
    Association.where(parent_model: "card", child_model: "image") do |association|
      association.parent_ids.each do |card_id|
        Card.find(card_id).update_attribute(:file_id, association.child_id)
      end
    end

    add_column :cards, :user_id, :integer
    Association.where(parent_model: "user", child_model: "card") do |association|
      Card.find(association.child_id).update_attribute(:user_id, association.parent_id[0])
    end

    remove_column :users, :order_forms
    add_column :users, :default_order_form, :integer

    add_column :users, :avatar, :integer
    Association.where(parent_model: "user", child_model: "image") do |association|
      association.parent_ids.each do |user_id|
        User.find_by(id: user_id).update_attribute(:avatar, association.child_id)
      end
    end

    add_column :pools, :user_id, :integer
    Association.where(parent_model: "user", child_model: "pool") do |association|
      Pool.find(association.child_id).update_attribute(:user_id, association.parent_id[0])
    end

    add_column :submissions, :pool_id, :integer
    Association.where(parent_model: "pool", child_model: "submission").each do |association|
      Submission.find(association.child_id).update_attribute(:pool_id, association.parent_id[0])
    end
    
    add_column :submissions, :file_id, :integer
    Association.where(parent_model: "submission", child_model: "image").each do |association|
      association.parent_ids.each do |submission_id|
        Submission.find(submission_id).update_attribute(:file_id, association.child_id)
      end
    end

    remove_column :associations, :parent_ids, :integer, array: true, default: []
    add_column :associations, :parent_id, :integer
    rename_table :associations, :attachments
  end
end
