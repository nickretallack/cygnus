class Card < ActiveRecord::Base
  belongs_to :user
  belongs_to :card
  has_one :attachment, class_name: "Upload", foreign_key: :id, primary_key: :file_id, dependent: :destroy
end
