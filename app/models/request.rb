class Request < ActiveRecord::Base
  belongs_to :user
  
  def end_date
    created_at + auction_length.days
  end
end
