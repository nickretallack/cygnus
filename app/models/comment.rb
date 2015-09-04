class Comment < ActiveRecord::Base
  belongs_to :submission
  belongs_to :user
  belongs_to :comment
  has_many :comments

  validates :content, format: { with: /\S+/, message: "must have some content." }
end
