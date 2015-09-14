class Card < ActiveRecord::Base
  belongs_to :user
  belongs_to :card
  has_one :attachment, class_name: "Upload", foreign_key: :id, primary_key: :file_id, dependent: :destroy

  def level
    @level ||= -> {
      if user_id
        :top
      elsif not cards.empty?
        :list
      else
        :card
      end
    }.call
  end
end
