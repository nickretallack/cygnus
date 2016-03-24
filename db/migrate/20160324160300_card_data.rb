class CardData < ActiveRecord::Migration
  def up
    Card.all.each do |card|
      if card.attributes["user_id"]
        user = User.find_by(id: card.attributes["user_id"])
        user.update_attribute(:attachments, user.attachments << "card-#{card.attributes["id"]}")
      end
      if card.attributes["file_id"]
        card.update_attribute(:attachments, card.attachments << "image-#{card.attributes["file_id"]}")
      end
      unless card.attributes["cards"].empty?
        card.attributes["cards"].each do |id|
          card.update_attribute(:attachments, card.attachments << "card-#{id}")
        end
      end
    end

    remove_column :cards, :user_id
    remove_column :cards, :file_id
    remove_column :cards, :cards
  end
end
