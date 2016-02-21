class SetUpAttachments < ActiveRecord::Migration

  def up
    add_column :users, :attachments, :string, array: true, default: []

    User.where.not(avatar: nil).each do |user|
      user.update_attribute(:attachments, user.attachments << "image-#{avatar}")
    end

    remove_column :users, :avatar
    rename_column :users, :gallery, :offsite_gallery
    remove_column :users, :string
    remove_column :users, :default_order_form
    remove_column :order_forms, :user_id

    add_column :pools, :attachments, :string, array: true, default: []

    Pool.where.not(user_id: nil) do |pool|
      User.find_by(id: pool.user_id).each do |user|
        user.update_attribute(:attachments, user.attachments << "pool-#{pool.id}")
      end
    end

    remove_column :pools, :user_id, :integer

    add_column :submissions, :attachments, :string, array: true, default: []

    Submission.all.each do |submission|
      submission.update_attribute(:attachments, submission.attachments << "image-#{submission.file_id}") if submission.file_id
      Pool.find(submission.pool_id).each do |pool|
        pool.update_attribute(:attachments, pool.attachments << "submission-#{submission.id}")
      end
    end

    remove_column :submissions, :file_id, :integer
    remove_column :submissions, :pool_id, :integer

    add_column :cards, :attachments, :string, array: true, default: []

    Card.all.each do |card|
      if card.user_id
        user = User.find_by(id: card.user_id)
        user.update_attribute(:attachments, user.attachments << "card-#{card.id}")
      end
      if card.file_id
        card.update_attribute(:attachments, card.attachments << "image-#{}")
      end
      unless card.cards.empty?
      end
    end

    remove_column :cards, :user_id
    remove_column :cards, :file_id
    remove_column :cards, :cards
  end

end
