class Message < ActiveRecord::Base
  belongs_to :submission
  belongs_to :user
  
  validates :content, format: { with: /\S+/, message: "must have some content." }

  def replies
    self.class.where("message_id = ?", id)
  end
end
