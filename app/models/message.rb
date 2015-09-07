class Message < ActiveRecord::Base
  belongs_to :submission
  belongs_to :user
  belongs_to :parents, -> { where("submission_id IS NOT NULL") }, class_name: "Message", foreign_key: :recipient_id
  has_many :replies, -> { where("submission_id IS NOT NULL") }, class_name: "Message", foreign_key: :recipient_id

  validates :content, format: { with: /\S+/, message: "must have some content." }
end
