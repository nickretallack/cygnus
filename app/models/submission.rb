class Submission < ActiveRecord::Base
  #has_and_belongs_to_many :users
  belongs_to :upload, foreign_key: :file_id
  belongs_to :pool
  has_many :comments, -> { where("recipient_id IS NULL") }, class_name: "Message"
  validate do |submission|
    errors.add(:pool_id, "does not exist") if submission.pool.nil? || submission.pool.user.nil?
  end
  validates_presence_of :file_id

  def faved_by
    @faved_by ||= User.where("? = ANY (favs)", id)
  end
end
