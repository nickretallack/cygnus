class Request < ActiveRecord::Base
  belongs_to :user
  belongs_to :upload
  
  has_many :slots
  accepts_nested_attributes_for :slots
  
  def end_date
    created_at + auction_length.days
  end
end
