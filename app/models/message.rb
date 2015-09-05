class Message < ActiveRecord::Base
  belongs_to :submission
  belongs_to :user
  belongs_to :message
  has_many :messages

  validates :content, format: { with: /\S+/, message: "must have some content." }
end
